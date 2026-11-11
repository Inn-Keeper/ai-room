# CLAUDE.md

## How to work here

- Design before code. For anything non-trivial, state the approach — data flow, failure modes, what's out of scope — and wait for confirmation before implementing.
- Ask when requirements are ambiguous. Don't pick an interpretation and build it.
- YAGNI first, SOLID on the third repetition. Doesn't apply to public interfaces or persisted data — those get designed up front.
- Keep changes small and reviewable. If a task can't be broken into reviewable pieces, say so instead of doing it in one pass.

## My preferences
<!-- Fill these in as they come up — Claude: if a session reveals a stable preference, suggest adding it here. -->
- Commit messages: short imperative subject (e.g. "Add speed challenge"), no type prefix. Each feature or small task gets its own commit, not one blast commit with everything.
- Authorship: commits and PRs attributed only to my GitHub user (InnKeeper). No Claude/Anthropic attribution anywhere — no `Co-Authored-By` trailer, no "Generated with Claude Code" footer.

## Security
- Never expose secrets in the chats and sessions.