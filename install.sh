#!/usr/bin/env bash
set -euo pipefail
HOME_DIR="${STANDUP_HOME:-$HOME/.standup}"
SRC="$(cd "$(dirname "$0")" && pwd)"

mkdir -p "$HOME_DIR/log" "$HOME/.local/bin"
install -m 755 "$SRC/bin/standup" "$HOME/.local/bin/standup"
echo "CLI 설치: ~/.local/bin/standup"

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

# 주간보고 양식 — 사람이 고치는 파일이므로 덮어쓰지 않는다
if [ ! -f "$HOME_DIR/weekly-template.md" ]; then
  install -m 644 "$SRC/templates/weekly.md" "$HOME_DIR/weekly-template.md"
  echo "양식 생성: $HOME_DIR/weekly-template.md  ← 대분류를 팀에 맞게 고치세요"
fi

# Claude Code — 슬래시 커맨드
if [ -d "$HOME/.claude" ]; then
  mkdir -p "$HOME/.claude/commands"
  install -m 644 "$SRC/commands/standup.md" "$HOME/.claude/commands/standup.md"
  install -m 644 "$SRC/commands/weekly.md"  "$HOME/.claude/commands/weekly.md"
  echo "Claude Code 설치: /standup, /weekly"
fi

# Codex — 스킬
if [ -d "$HOME/.codex" ]; then
  mkdir -p "$HOME/.codex/skills/standup" "$HOME/.codex/skills/weekly"
  install -m 644 "$SRC/skills/standup/SKILL.md" "$HOME/.codex/skills/standup/SKILL.md"
  install -m 644 "$SRC/skills/weekly/SKILL.md"  "$HOME/.codex/skills/weekly/SKILL.md"
  echo "Codex 설치: skills/standup, skills/weekly"
fi

case ":$PATH:" in *":$HOME/.local/bin:"*) ;; *)
  echo "⚠️  PATH 에 \$HOME/.local/bin 를 추가하세요" ;;
esac

echo
"$HOME/.local/bin/standup" --whoami
echo
echo "완료. 확인: standup"
