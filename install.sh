#!/usr/bin/env bash
set -euo pipefail
HOME_DIR="${STANDUP_HOME:-$HOME/.standup}"
SRC="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME_DIR/log" "$HOME/.local/bin"
install -m 755 "$SRC/bin/standup" "$HOME/.local/bin/standup"

if [ ! -f "$HOME_DIR/config" ]; then
  cat > "$HOME_DIR/config" <<'CONF'
# 스캔할 최상위 디렉터리 (콜론 구분)
STANDUP_ROOTS="$HOME/development:$HOME/IdeaProjects"

# 하루의 시작 (새벽 작업을 전날로 안 넘기려면 04~06시)
STANDUP_SINCE="05:00"

# 커밋 저자 — 기본은 자동 탐지(global + 각 레포의 local user.email).
# `standup --whoami` 로 확인하고, 자동 탐지가 틀릴 때만 아래 주석을 풀어 고정한다.
# 고정하면 자동 탐지는 무시되므로 신원을 빠짐없이 적어야 한다.
#STANDUP_AUTHORS="a@x.com,b@y.com"
CONF
  echo "설정 생성: $HOME_DIR/config"
fi

if [ -d "$HOME/.claude" ]; then
  mkdir -p "$HOME/.claude/commands"
  install -m 644 "$SRC/commands/standup.md" "$HOME/.claude/commands/standup.md"
  echo "Claude 커맨드 설치: /standup"
fi

case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *)
  echo "⚠️  PATH 에 \$HOME/.local/bin 를 추가하세요" ;;
esac

echo
echo "탐지된 git 신원:"
"$HOME/.local/bin/standup" --whoami | tail -n +2
echo
echo "완료. 확인: standup --whoami / standup"
