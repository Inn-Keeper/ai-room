#!/usr/bin/env bash
# Usage:
#   ./install.sh                         symlink everything into ~/.claude and ~/.codex
#   ./install.sh --project DIR [NAME...] copy skills/agents (all, or only NAMEs) into a project
# Anything already at a target path is moved to ~/.ai-room-backups/<timestamp>/, never deleted.
set -euo pipefail

ROOT="$(cd "$(dirname "$0")" && pwd)"
TS="$(date +%Y%m%d%H%M%S)"

backup() { # move an existing target out of the way
  if [ -L "$1" ]; then rm "$1"
  elif [ -e "$1" ]; then
    # outside skills/ dirs, or the backup would load as a duplicate skill
    b="$HOME/.ai-room-backups/$TS$1"; mkdir -p "$(dirname "$b")"; mv "$1" "$b"; echo "  backed up $1 -> $b"
  fi
}
link() { mkdir -p "$(dirname "$2")"; backup "$2"; ln -s "$1" "$2"; echo "  link $2"; }
copy() { mkdir -p "$(dirname "$2")"; backup "$2"; cp -R "$1" "$2"; echo "  copy $2"; }

all_names() { ls "$ROOT/skills"; ls "$ROOT/agents"; }

install_global() {
  for s in "$ROOT"/skills/*/; do
    n="$(basename "$s")"
    link "$ROOT/skills/$n" "$HOME/.claude/skills/$n"
    link "$ROOT/skills/$n" "$HOME/.codex/skills/$n"
  done
  for a in "$ROOT"/agents/*/; do
    n="$(basename "$a")"
    link "$a$n.md" "$HOME/.claude/agents/$n.md"
    link "$a$n.toml" "$HOME/.codex/agents/$n.toml"
  done
  link "$ROOT/claude/CLAUDE.md" "$HOME/.claude/CLAUDE.md"
  link "$ROOT/claude/RTK.md" "$HOME/.claude/RTK.md"
  link "$ROOT/codex/AGENTS.md" "$HOME/.codex/AGENTS.md"
  link "$ROOT/codex/RTK.md" "$HOME/.codex/RTK.md"
  # ponytail: settings are merged by hand; the tools rewrite these files, so a symlink would churn the repo
  echo "Merge by hand: claude/settings.json -> ~/.claude/settings.json, codex/config.toml -> ~/.codex/config.toml"
}

install_project() {
  dir="$1"; shift
  [ -d "$dir" ] || { echo "No such directory: $dir" >&2; exit 1; }
  dir="$(cd "$dir" && pwd)"
  names=("$@"); [ ${#names[@]} -gt 0 ] || names=($(all_names))
  for n in "${names[@]}"; do
    if [ -d "$ROOT/skills/$n" ]; then
      copy "$ROOT/skills/$n" "$dir/.claude/skills/$n"
      copy "$ROOT/skills/$n" "$dir/.agents/skills/$n"
    elif [ -d "$ROOT/agents/$n" ]; then
      copy "$ROOT/agents/$n/$n.md" "$dir/.claude/agents/$n.md"
      copy "$ROOT/agents/$n/$n.toml" "$dir/.codex/agents/$n.toml"
    else
      echo "Unknown skill or agent: $n (available: $(all_names | tr '\n' ' '))" >&2; exit 1
    fi
  done
}

case "${1:-}" in
  "") install_global ;;
  --project) [ $# -ge 2 ] || { echo "Usage: $0 --project DIR [NAME...]" >&2; exit 1; }; shift; install_project "$@" ;;
  -h|--help) sed -n '2,5p' "$0" ;;
  *) echo "Unknown option: $1 (see --help)" >&2; exit 1 ;;
esac
