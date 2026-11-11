# ai-room

My base kit of AI workflows for **Claude Code** and **Codex**: skills, agents,
instructions, and the plugins I rely on. It is set up once and reused in any project.

## Layout

```text
skills/      one folder per skill: SKILL.md (Claude and Codex) + agents/openai.yaml (Codex app metadata)
agents/      custom subagents, each as <name>.md (Claude) and <name>.toml (Codex)
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

## Copy skills by hand

No clone needed. Each skill is a single `SKILL.md`; download it into the project
(or into `~/.claude/skills/` and `~/.agents/skills/` for every project):

```bash
# Claude Code
curl -fsSL --create-dirs -o .claude/skills/x-ray/SKILL.md \
  https://raw.githubusercontent.com/Inn-Keeper/ai-room/main/skills/x-ray/SKILL.md

# Codex
curl -fsSL --create-dirs -o .agents/skills/x-ray/SKILL.md \
  https://raw.githubusercontent.com/Inn-Keeper/ai-room/main/skills/x-ray/SKILL.md
```

Swap `x-ray` for any skill in the table below. Or copy and paste by hand: open
`skills/<name>/SKILL.md` on GitHub, click **Raw**, and save it as
`.claude/skills/<name>/SKILL.md` (Codex: `.agents/skills/<name>/SKILL.md`).
The skill works from `SKILL.md` alone; `agents/openai.yaml` only adds a display
name and default prompt in the Codex app.

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
| `evaluate-product` | Product review of user journeys, flow, and feel |
| `press-pitch-review` | Review of press releases, EPKs, and band bios as a journalist or booker reads them |
| `get-seo-right` | Technical and on-page SEO audit: crawl, index, metadata, rendering, structured data, links |
| `web-vitals` | Measure Core Web Vitals (LCP, INP, CLS) with Lighthouse lab runs and real-user CrUX data |

`web-vitals` needs Chrome and Node 22.19 or newer. Real-user data comes from the
PageSpeed Insights API; its keyless quota is shared and often exhausted, so export
a free key as `PSI_API_KEY` (never commit it).

### Writing a skill

Every skill follows the pattern in [skills/README.md](skills/README.md):
`Scope`, `Steps` or `Checks`, `Report`, and `Rules`, plus the Codex `agents/openai.yaml`.
Describe behavior, not identity: "judge every change by what it can break" steers
the model; "you are a senior architect" barely does.

## Agents

| Agent | What it does |
|---|---|
| `real-user` | Walks through your running app as a persona and reports usability friction. It only reports and never edits code. |
| `product-manager` | Knows the project's requirements and value from `docs/` (superpowers specs and plans). Decides what to build, checks work against requirements, and writes acceptance criteria. Read-only. |

`real-user` needs a browser tool. On Claude, that is the Playwright plugin. On Codex,
it is the `playwright` MCP server in `codex/config.toml`, which is the official
`@playwright/mcp` with a pinned version, runs locally over stdio, and uses an
isolated browser profile.

`product-manager` reads `docs/`, where superpowers writes its specs and plans. With
no docs it says so and points you to brainstorming instead of inventing requirements.

## Third-party plugins and tools

These are installed from their sources, not vendored here:

| Name | Tool | Install |
|---|---|---|
| superpowers, code-review, commit-commands, playwright, frontend-design | Claude | `/plugin install <name>@claude-plugins-official` |
| [ponytail](https://github.com/DietrichGebert/ponytail) | Claude, Codex | `/plugin marketplace add DietrichGebert/ponytail` |
| [rtk](https://github.com/rtk-ai/rtk) | both (shell hook) | see its README; the hook is in `claude/settings.json` |
| [find-skills](https://github.com/vercel-labs/skills) | any | `npx skills add vercel-labs/skills` |
| [typesafe-ai](https://github.com/typesafe-ai/skills) | any (optional) | `npx skills add typesafe-ai/skills` |
