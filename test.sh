#!/usr/bin/env bash
# Checks that every skill and agent is well formed and that both install modes work.
# Installs only into a temp folder; never touches the real home directory.
set -euo pipefail
cd "$(dirname "$0")"
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
fail() { echo "FAIL: $*" >&2; exit 1; }

for s in skills/*/; do
  n="$(basename "$s")"
  grep -qx "name: $n" "$s/SKILL.md" || fail "$n: SKILL.md is missing or its name is not '$n'"
  [ -f "$s/agents/openai.yaml" ] || fail "$n: agents/openai.yaml is missing"
  grep -qF "\`$n\`" README.md || fail "$n: not listed in README.md"
done

for a in agents/*/; do
  n="$(basename "$a")"
  grep -qx "name: $n" "$a/$n.md" || fail "$n: $n.md is missing or its name is not '$n'"
  python3 - "$a/$n.toml" "$n" <<'EOF' || fail "$n: $n.toml is invalid"
import sys, tomllib
t = tomllib.load(open(sys.argv[1], "rb"))
assert t["name"] == sys.argv[2] and t["description"] and t["developer_instructions"]
EOF
  grep -qF "\`$n\`" README.md || fail "$n: not listed in README.md"
done

# per-project install: real copies
./install.sh --project "$tmp" >/dev/null
for s in skills/*/; do
  n="$(basename "$s")"
  [ -f "$tmp/.claude/skills/$n/SKILL.md" ] && [ -f "$tmp/.agents/skills/$n/SKILL.md" ] || fail "project install: skill $n"
done
for a in agents/*/; do
  n="$(basename "$a")"
  [ -f "$tmp/.claude/agents/$n.md" ] && [ -f "$tmp/.codex/agents/$n.toml" ] || fail "project install: agent $n"
done
if ./install.sh --project "$tmp" no-such-name >/dev/null 2>&1; then fail "unknown name was accepted"; fi

# machine-wide install into a fake home: symlinks, and an existing file is backed up
mkdir -p "$tmp/home/.claude"; echo mine > "$tmp/home/.claude/CLAUDE.md"
HOME="$tmp/home" ./install.sh >/dev/null
for s in skills/*/; do
  n="$(basename "$s")"
  [ -L "$tmp/home/.claude/skills/$n" ] && [ -L "$tmp/home/.agents/skills/$n" ] || fail "global install: skill $n"
done
for a in agents/*/; do
  n="$(basename "$a")"
  [ -L "$tmp/home/.claude/agents/$n.md" ] && [ -L "$tmp/home/.codex/agents/$n.toml" ] || fail "global install: agent $n"
done
[ -L "$tmp/home/.claude/CLAUDE.md" ] || fail "global install: CLAUDE.md not linked"
grep -rqx mine "$tmp/home/.ai-room-backups" || fail "global install: existing CLAUDE.md was not backed up"

echo "OK"
