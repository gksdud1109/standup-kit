# standup

여러 레포에 흩어진 오늘 커밋을 모아 업무보고 초안을 만든다. 서버 없이 노트북에서만 돈다.

## 설치

```bash
git clone <repo> ~/src/standup
~/src/standup/install.sh
```

설치하면 세 가지가 생긴다.

| 위치 | 내용 |
| --- | --- |
| `~/.local/bin/standup` | 커밋 수집 CLI |
| `~/.standup/config` | 스캔 경로·시작 시각 |
| `~/.claude/commands/standup.md` | `/standup` 슬래시 커맨드 (Claude Code 있을 때만) |
| `~/.codex/skills/standup/SKILL.md` | standup 스킬 (Codex 있을 때만) |

`~/.local/bin` 이 PATH에 없으면 설치할 때 알려준다. 없으면 이렇게 넣는다.

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

## 쓰는 법

```bash
standup                  # 오늘 05:00 이후
standup "3 days ago"     # 기간 지정
standup --whoami         # 내 git 신원 확인
```

Claude Code에서는 슬래시 커맨드로 요약까지 한 번에 한다.

```
/standup
/standup "3 days ago"
```

어제 보고서를 같이 읽어서 이어지는 작업은 한 흐름으로 묶고, 결과를 `~/.standup/log/<날짜>.md` 에 저장한다.

Codex는 슬래시로 부르지 않는다. 스킬 설명을 보고 알아서 잡는다.

```
오늘 업무보고 정리해줘
standup 스킬로 최근 3일치 뽑아줘
```

확실히 부르려면 스킬 이름을 문장에 넣는다. Claude와 달리 셸 실행을 모델이 직접 하므로,
`standup` 을 실행했는지 한 번 보고 넘어간다.

둘 다 안 쓰면 수집 결과를 복사해서 쓰던 도구에 넣는다.

```bash
standup | pbcopy
```

요약 지시문은 `commands/standup.md` 아래쪽에 있다. 그대로 붙여 쓰면 된다.

## 커밋 저자

따로 설정하지 않는다. `git config --global user.email` 과 각 레포의 `--local user.email` 을 모아 쓴다.
회사 레포와 개인 레포에 다른 이메일을 쓰고 있어도 알아서 둘 다 잡는다.

`standup --whoami` 로 확인하고, 빠진 게 있을 때만 `~/.standup/config` 에서 고정한다.

```bash
STANDUP_AUTHORS="a@x.com,b@y.com"
```

고정하면 자동 탐지를 쓰지 않으므로 신원을 전부 적어야 한다. 하나라도 빠지면 그 레포 커밋이
조용히 사라진다.

## 설정

`~/.standup/config`

```bash
STANDUP_ROOTS="$HOME/development:$HOME/IdeaProjects"   # 스캔할 상위 디렉터리 (콜론 구분, 3단계까지)
STANDUP_SINCE="05:00"                                  # 하루의 시작
#STANDUP_AUTHORS="a@x.com,b@y.com"                     # 자동 탐지를 대신할 값
```

새벽까지 일한 게 전날로 넘어가면 `STANDUP_SINCE` 를 `04:00` 쯤으로 내린다.

## 알아둘 것

- 미머지 브랜치 커밋도 잡는다(`--all`). feature 브랜치에서 하루 종일 작업해도 빠지지 않는다.
- 머지 커밋은 뺀다.
- 조회 범위가 하루를 넘으면 날짜까지 찍는다. 하루면 시각만 찍는다.
- 레포별 커밋 수 옆에 미커밋 파일 수를 같이 보여준다.

## 한계

커밋이 안 남는 일은 잡히지 않는다. 조사, 디버깅, 회의, 코드리뷰, 배포 확인, 그리고 안 하기로 한 결정.
커밋 하나에 반나절이 들어간 경우도 한 줄로만 보인다.

보고서를 대신 써주는 도구가 아니라 빠뜨린 걸 떠올리게 하는 도구다. 초안을 몇 초에 만들고
나머지는 직접 채운다.

커밋 메시지가 곧 보고서 품질이 된다. `update` 같은 제목만 쌓이면 그 레포는 요약에서 통째로 빠진다.
