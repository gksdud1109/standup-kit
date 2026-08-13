# standup

여러 레포에 흩어진 커밋을 모아 일일·주간 업무보고 초안을 만든다. 서버 없이 노트북에서만 돈다.

## 설치

```bash
git clone <personal repo> ~/src/standup
~/src/standup/install.sh
```

`~/.local/bin` 이 PATH에 없으면 설치할 때 알려준다.

```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

커밋 저자는 따로 설정하지 않는다. `standup --whoami` 로 확인만 하고 넘어간다.

## 명령

```bash
standup                  # 오늘 05:00 이후
standup today            # 오늘 00:00 이후
standup yesterday        # 어제 00:00 이후
standup weekly           # 이번 주 월요일부터
standup last-week        # 지난주 월~일
standup "3 days ago"     # 기간 지정
standup --logs weekly    # 그 주에 저장된 일일 보고 모아보기
standup --whoami         # 잡히는 git 신원 확인
```

## 보고서 만들기

### Claude Code

```
/standup                 오늘 일일보고
/standup "3 days ago"
/weekly                  이번 주 주간보고
/weekly last-week        지난주
```

`/standup` 은 어제 보고서를 같이 읽어 이어지는 작업을 한 흐름으로 묶고, 결과를
`~/.standup/log/<날짜>.md` 에 저장한다. 같은 날 다시 돌리면 기존 내용에 합친다.

`/weekly` 는 커밋에 그 주의 일일 보고까지 합쳐서 만든다. CS 대응이나 문서 작성처럼
커밋이 안 남는 일이 일일 보고에만 있기 때문이다. 주간보고는 저장하지 않고 화면에만 낸다.

### Codex

슬래시로 부르지 않는다. 스킬 설명을 보고 잡는다.

```
오늘 업무보고 정리해줘
주간보고 만들어줘
```

확실히 부르려면 스킬 이름을 문장에 넣는다. Claude와 달리 셸 실행을 모델이 직접 하므로
`standup` 을 실행했는지 한 번 보고 넘어간다.

### 그 외

```bash
standup | pbcopy
```

요약 지시문은 `commands/standup.md` 아래쪽에 있다. 그대로 붙여 쓰면 된다.

## 한계

커밋이 안 남는 일은 잡히지 않는다. 조사, 디버깅, 회의, 코드리뷰, 배포 확인, 그리고 안 하기로 한 결정.
커밋 하나에 반나절이 들어간 경우도 한 줄로만 보인다.

보고서를 대신 써주는 도구가 아니라 빠뜨린 걸 떠올리게 하는 도구다. 초안을 몇 초에 만들고
나머지는 직접 채운다.

커밋 메시지가 곧 보고서 품질이 된다. `update` 같은 제목만 쌓이면 그 레포는 요약에서 통째로 빠진다.

---

## 설치되는 파일

| 위치 | 내용 |
| --- | --- |
| `~/.local/bin/standup` | 커밋 수집 CLI |
| `~/.standup/config` | 스캔 경로·하루 시작 시각 |
| `~/.standup/weekly-template.md` | 주간보고 양식 |
| `~/.standup/log/<날짜>.md` | 일일보고 저장본 |
| `~/.claude/commands/{standup,weekly}.md` | 슬래시 커맨드 (Claude Code 있을 때) |
| `~/.codex/skills/{standup,weekly}/SKILL.md` | 스킬 (Codex 있을 때) |

`config` 와 `weekly-template.md` 는 사람이 고치는 파일이라 재설치해도 덮어쓰지 않는다.

## 설정

`~/.standup/config`

```bash
STANDUP_ROOTS="$HOME/development:$HOME/IdeaProjects"   # 스캔할 상위 디렉터리 (콜론 구분, 3단계까지)
STANDUP_SINCE="05:00"                                  # 하루의 시작
#STANDUP_AUTHORS="a@x.com,b@y.com"                     # 자동 탐지를 대신할 값
```

새벽까지 일한 게 전날로 넘어가면 `STANDUP_SINCE` 를 `04:00` 쯤으로 내린다.

## 커밋 저자

`git config --global user.email` 과 각 레포의 `--local user.email` 을 모아 쓴다.
회사 레포와 개인 레포에 다른 이메일을 쓰고 있어도 둘 다 잡는다.

빠진 게 있을 때만 `config` 에서 고정한다.

```bash
STANDUP_AUTHORS="a@x.com,b@y.com"
```

고정하면 자동 탐지를 쓰지 않으므로 신원을 전부 적어야 한다. 하나라도 빠지면 그 레포 커밋이
조용히 사라진다.

## 주간보고 양식

`~/.standup/weekly-template.md` 에 형식과 대분류 매핑이 들어 있다. 회사 양식이 바뀌면 여기만 고친다.

대분류(`1. OCB 운영`, `2. 사내 서비스` 같은)는 커밋에서 유추할 수 없어서 매핑표로 둔다.
레포 이름과 분류를 표에 적어두면 그대로 따라간다.

## 동작

- 미머지 브랜치 커밋도 잡는다(`--all`). feature 브랜치에서 하루 종일 작업해도 빠지지 않는다.
- 머지 커밋은 뺀다.
- 조회 범위가 하루를 넘으면 날짜까지 찍고, 하루면 시각만 찍는다.
- 레포별로 미커밋 파일 목록을 같이 보여준다. 어느 작업이 진행 중인지 판단하는 근거가 된다.
- `today` `yesterday` `weekly` 는 자정 기준으로 바꿔서 넘긴다. git 은 이 표현들을 "지금 이 시각"으로
  읽어서, `--since=today` 는 0건을 내고 `--since=yesterday` 는 어제 오전을 빠뜨린다.
