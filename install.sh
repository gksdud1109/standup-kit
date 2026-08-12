#!/usr/bin/env bash
set -euo pipefail
HOME_DIR="${STANDUP_HOME:-$HOME/.standup}"
SRC="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME_DIR/log" "$HOME/.local/bin"
install -m 755 "$SRC/bin/standup" "$HOME/.local/bin/standup"

if [ ! -f "$HOME_DIR/config" ]; then
  cat > "$HOME_DIR/config" <<CONF
# 커밋 저자 — git 신원이 여러 개면 콤마로 모두 적으세요
STANDUP_AUTHORS="$(git config user.email)"
# 스캔할 최상위 디렉터리 (콜론 구분)
STANDUP_ROOTS="\$HOME/development:\$HOME/IdeaProjects"
# 하루의 시작 (새벽 작업을 전날로 안 넘기려면 04~06시)
STANDUP_SINCE="05:00"
CONF
  echo "설정 생성: $HOME_DIR/config  ← 저자·경로 확인하세요"
fi

if [ -d "$HOME/.claude" ]; then
  mkdir -p "$HOME/.claude/commands"
  install -m 644 "$SRC/commands/standup.md" "$HOME/.claude/commands/standup.md"
  echo "Claude 커맨드 설치: /standup"
fi

case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *)
  echo "⚠️  PATH 에 \$HOME/.local/bin 를 추가하세요" ;;
esac
echo "완료. 확인: standup"
