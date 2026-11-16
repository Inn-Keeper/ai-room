<p align="center">
  <img src="assets/logo.svg" width="96" alt="ai-room logo: an open door with warm light behind it">
</p>

<h1 align="center">ai-room</h1>

<p align="center">
  Skills, agents, and instructions for Claude Code and Codex.<br>
  Set up once, reused in every project.
</p>

<p align="center">
  <a href="https://github.com/Inn-Keeper/ai-room/actions/workflows/ci.yml"><img src="https://github.com/Inn-Keeper/ai-room/actions/workflows/ci.yml/badge.svg" alt="CI status"></a>
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="MIT license"></a>
</p>

My base kit of AI workflows: review, audit, and planning skills, UI-testing and
product agents, global instructions, and the plugins I rely on. Every skill and
agent ships in both **Claude Code** and **Codex** form.

## Requirements

- Claude Code, Codex, or both.
- macOS or Linux with `git` and `bash`, for `install.sh`.
- For the `real-user` and `acceptance-tester` agents: the Playwright plugin on Claude;
  Node (`npx`) on Codex, which runs the Playwright MCP server.
- For the `web-vitals` skill: Chrome and Node 22.19 or newer.
- [rtk](https://github.com/rtk-ai/rtk), only if you merge the shell hook from `claude/settings.json`.

## Usage

Once installed, call a skill by name or just describe the task; agents are called by name.

```text
/x-ray
    Review the current diff for correctness. In Codex: $x-ray

Run a11y on http://localhost:3000
    Audit the running site against WCAG 2.2 AA.

Use the real-user agent on http://localhost:3000 as a novice: sign up and create a first project.
    Walk the journey in a browser and report friction.

Ask product-manager for acceptance criteria for the invite flow, then have
acceptance-tester check them on http://localhost:3000.
    Criteria come from docs/, then get checked against the running app.

Run real-user on <url> with goal <goal>, then run web-vitals and get-styled on the same target.
    Chain a journey with performance and CSS audits.
```

## Layout

```text
skills/      one folder per skill: SKILL.md (Claude and Codex) + agents/openai.yaml (Codex app metadata)
agents/      custom subagents, each as <name>.md (Claude) and <name>.toml (Codex)
claude/      global CLAUDE.md, RTK.md, and a portable settings.json (hooks + plugins)
codex/       global AGENTS.md, RTK.md, and a portable config.toml (plugins + Playwright MCP)
install.sh   puts the above where each tool looks for it
test.sh      checks every skill and agent and both install modes; CI runs it
```

## Install (machine-wide, recommended)

```bash
git clone https://github.com/Inn-Keeper/ai-room ~/projects/ai-room
~/projects/ai-room/install.sh
```

This symlinks every skill and agent into `~/.claude` (Claude) and into
`~/.agents/skills` and `~/.codex/agents` (Codex), so editing a file in the repo
updates both tools.

It also replaces your global `~/.claude/CLAUDE.md` and `~/.codex/AGENTS.md` with
the ones in this repo. Any file the installer would replace is moved to
`~/.ai-room-backups/<timestamp>/`, so your own instructions are kept there, not
deleted. Use the per-project install if you want to keep your own.

`settings.json` and `config.toml` are merged by hand, because the tools rewrite
those files themselves. Install [rtk](https://github.com/rtk-ai/rtk) before merging
`claude/settings.json`, or leave its `hooks` block out: the hook runs `rtk` before
every Bash call and fails each one if `rtk` is missing.

## Use in a single project

To keep the kit inside one repository instead, copy it in:

```bash
# everything
~/projects/ai-room/install.sh --project .

# or only what the project needs
~/projects/ai-room/install.sh --project . there-we-go x-ray real-user
```

Skills are copied to `.claude/skills/` and `.agents/skills/`, and agents to
`.claude/agents/` and `.codex/agents/`. Commit them with the project so
collaborators and CI get them too. To update, `git pull` in `~/projects/ai-room` and rerun.

## Update and uninstall

- **Update, machine-wide:** `git -C ~/projects/ai-room pull`. The symlinks pick up
  edits immediately; rerun `install.sh` only when a skill or agent was added.
- **Update, single project:** pull, then rerun `install.sh --project .` and commit the result.
- **Uninstall, machine-wide:** remove the symlinks that point into the clone, then
  copy back anything you want from `~/.ai-room-backups/<timestamp>/`, which mirrors
  the original paths.

  ```bash
  find ~/.claude ~/.agents ~/.codex -maxdepth 3 -type l -lname "$HOME/projects/ai-room/*" -delete
  ```

- **Uninstall, single project:** delete the copied folders under `.claude/`, `.agents/`, and `.codex/`.

## Copy by hand

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

Agents work the same way, one file per tool:

```bash
# Claude Code
curl -fsSL --create-dirs -o .claude/agents/real-user.md \
  https://raw.githubusercontent.com/Inn-Keeper/ai-room/main/agents/real-user/real-user.md

# Codex
curl -fsSL --create-dirs -o .codex/agents/real-user.toml \
  https://raw.githubusercontent.com/Inn-Keeper/ai-room/main/agents/real-user/real-user.toml
```

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
| `a11y` | Accessibility audit against WCAG 2.2 AA: alternatives, structure, contrast, keyboard, forms, ARIA |

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
| `acceptance-tester` | Checks your running app against a list of acceptance criteria through the UI and returns pass/fail per criterion with evidence. It only reports and never edits code. |

`real-user` and `acceptance-tester` need a browser tool. On Claude, that is the Playwright plugin. On Codex,
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

## License

[MIT](LICENSE). The third-party plugins and tools above keep their own licenses.
