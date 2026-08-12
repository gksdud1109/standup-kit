# standup

여러 레포의 오늘 커밋을 모아 오늘 한 일을 정리한다.

## 설치
```bash
git clone <repo> ~/src/standup && ~/src/standup/install.sh
```
설치 후 `~/.standup/config` 에서 **저자와 스캔 경로**를 확인한다.
git 신원이 여러 개면 `STANDUP_AUTHORS` 에 콤마로 모두 적는다.

## 사용
```bash
standup                 # 수집만 (마크다운)
standup "1 day ago"     # 기간 지정
```

- **Claude Code**: `/standup` — 어제 보고서와 대조해 초안까지 생성, `~/.standup/log/` 에 저장
- **GPT 등**: `standup | pbcopy` 후 붙여넣기

## 한계
커밋이 안 남는 일은 안 잡힌다 — 조사·디버깅·회의·리뷰·배포 관측, 그리고 "안 하기로 한 결정".
**보고서 생성기가 아니라 기억 보조다.** 초안을 5초에 만들고 빠진 걸 채우는 용도.
