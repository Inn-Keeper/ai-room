# Skill pattern

Every skill follows this structure, so they read and behave alike in Claude and Codex.

```
skills/<name>/
  SKILL.md
  agents/openai.yaml   # Codex: display_name, short_description, default_prompt
```

`SKILL.md`:

```markdown
---
name: <name>
description: >
  <What it does, one sentence>. Trigger on "<phrase>", "<phrase>".
  <Not for X; use <other-skill> instead>. <Report only | Edits code>.
---

# <Title>

<One or two lines: the goal and the stance.>

## Scope
Inputs, what to read, what is out of scope. Ask when something is missing.

## Steps        (process skills)   or   ## Checks   (review skills)
Numbered or grouped work.

## Report
A fenced template of the exact output.

## Rules
Hard limits: evidence, no invention, what never to touch.
```

`agents/openai.yaml`:

```yaml
interface:
  display_name: "<Title>"
  short_description: "<under ~60 chars>"
  default_prompt: "Use $<name> to <task>."
```
