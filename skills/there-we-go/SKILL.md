---
name: there-we-go
description: >
  Analyze a scoped software ticket, user story, issue, or change request, agree on a
  plan, then implement exactly that. Trigger when the user pastes a ticket or issue
  (with or without images) and says "evaluate this ticket", "implement this ticket",
  "break down this story", "analyze this task", or "there we go". For designing a new
  system or a large multi-component feature, use architect instead.
---

# There We Go

Read the demand carefully, including the description and any attached images.
Understand exactly what is asked. Nothing more.

## Scope

Run the analysis (steps 1–3) by default. Skip straight to step 4 only if the user
explicitly waives the analysis.

## Steps

### Step 1: Understand the demand

In your own words:

- **What is asked:** one or two precise sentences.
- **Acceptance criteria:** explicit if stated; otherwise inferred and marked *(inferred)*.
- **Out of scope:** anything the ticket hints at but does not ask for. List it, then ignore it.

If the ticket is too vague to plan safely, say what is missing and ask. Do not proceed.

### Step 2: Identify what changes

List only what must change to satisfy the demand:

- Files, components, types, or functions to modify
- Interfaces or contracts affected, and who consumes them
- Anything that could break as a side effect

Read the codebase to answer this. If you cannot access it, name what you need and ask.
Never fabricate file names or APIs.

### Step 3: Implementation plan

Ordered, atomic steps, scoped tightly to the demand:

```
Step 1: <title>
  Where: <file or module>
  What:  <specific change>
```

End with: **"Does this look right? I'll start once you confirm."**
Write no code until the user agrees.

### Step 4: Implement

Execute the steps in order.

- **Strict scope:** only what the plan says. No bonus fixes, style changes, or "while we're at it".
- **Clean code:** correct, readable, sufficient. No over-engineering.
- **Surprises:** if something unexpected comes up, stop, describe it, and ask before continuing.
- After each step, briefly state what changed and what is next.

### Step 5: Verify

Run the project's tests, type check, or build, whichever exist. Report the real result.
If nothing can be run, say so.

## Report

Finish with: files changed, verification result, and "All steps complete."

## Rules

- Write no code until the user agrees to the plan (unless the analysis was waived).
- Strict scope: only what the plan says.
- Never fabricate file names or APIs.
- If something unexpected comes up, stop and ask.
