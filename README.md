# ai-room

My base kit of AI workflows for **Claude Code** and **Codex**: skills, agents,
instructions, and the plugins I rely on. It is set up once and reused in any project.

## Layout

```
skills/      one folder per skill (SKILL.md); the same files serve Claude and Codex
agents/      custom subagents, as real-user.md (Claude) and real-user.toml (Codex)
claude/      global CLAUDE.md, RTK.md, and a portable settings.json (hooks + plugins)
codex/       global AGENTS.md, RTK.md, and a portable config.toml (plugins + Playwright MCP)
install.sh   puts the above where each tool looks for it
```

## Use in a project

```bash
git clone https://github.com/Inn-Keeper/ai-room ~/projects/ai-room

# everything
~/projects/ai-room/install.sh --project .

# or only what the project needs
~/projects/ai-room/install.sh --project . there-we-go x-ray real-user
```

Skills are copied to `.claude/skills/` and `.agents/skills/`, and agents to
`.claude/agents/` and `.codex/agents/`. Commit them with the project so
collaborators and CI get them too. To update, `git pull` in `~/projects/ai-room` and rerun.

## Use machine-wide

```bash
~/projects/ai-room/install.sh
```

This symlinks every skill, agent, and instruction file into `~/.claude` and
`~/.codex`, so editing a file in the repo updates both tools.
`settings.json` and `config.toml` are merged by hand, because the tools rewrite
those files themselves.

Any file the installer would replace is moved to `~/.ai-room-backups/<timestamp>/`.
Nothing is deleted.

## Skills

| Skill | What it does |
|---|---|
| `there-we-go` | Ticket to analysis to agreed plan to scoped implementation to verification |
| `architect` | Design a new system or a large feature before coding: options, recommendation, roadmap |
| `x-ray` | Correctness-focused code review of a diff or PR |
| `scrutinize` | Code quality review: structure, complexity, coupling, testability |
| `get-styled` | CSS architecture, responsive, and cross-browser audit |
| `design-final-touches` | Final visual and accessibility polish before release |
| `evaluate-product` | Senior-PM review of user journeys, flow, and feel |
| `press-pitch-review` | Music publicist review of press releases, EPKs, and band bios |

## Agents

| Agent | What it does |
|---|---|
| `real-user` | Walks through your running app as a persona and reports usability friction. It only reports and never edits code. |

`real-user` needs a browser tool. On Claude, that is the Playwright plugin. On Codex,
it is the `playwright` MCP server in `codex/config.toml`, which is the official
`@playwright/mcp` with a pinned version, runs locally over stdio, and uses an
isolated browser profile.

## Third-party plugins and tools

These are installed from their sources, not vendored here:

| Name | Tool | Install |
|---|---|---|
| superpowers, code-review, commit-commands, playwright, frontend-design | Claude | `/plugin install <name>@claude-plugins-official` |
| [ponytail](https://github.com/DietrichGebert/ponytail) | Claude, Codex | `/plugin marketplace add DietrichGebert/ponytail` |
| [rtk](https://github.com/rtk-ai/rtk) | both (shell hook) | see its README; the hook is in `claude/settings.json` |
| [find-skills](https://github.com/vercel-labs/skills) | any | `npx skills add vercel-labs/skills` |
| [typesafe-ai](https://github.com/typesafe-ai/skills) | any (optional) | `npx skills add typesafe-ai/skills` |
