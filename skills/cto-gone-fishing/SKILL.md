---
name: cto-gone-fishing
description: >
  Produce a one-page visual briefing on a single module, feature, or scope of a
  project, so an engineer can make a first change there without the person who knows
  it. Trigger on "brief me on", "explain this module", "how does <feature> work",
  "onboard me to", "get me up to speed on", or "cto-gone-fishing". Covers where the
  scope sits in the architecture, its main flow, business rules and constraints with
  sources, data touched, where to start, and traps. Writes one HTML file; never
  edits code. For designing something new, use architect instead.
---

# CTO Gone Fishing

Brief an engineer on one part of a project as if the person who built it were unreachable. Go deep on the named scope and stay shallow on everything else. Every rule cites where it comes from, and what the code cannot answer is listed as a question, never guessed.

## Scope

- **Input:** one module, feature, path, or ticket. If none is given, or the request is the whole project, list five to eight candidate scopes you can see (top-level modules, features, routes) and ask which one. Never brief a whole repository.
- **Read:** the code in scope, its tests, and related docs, ADRs, comments, schemas, and config. Read outside the scope only enough to place it on the architecture map and to find what depends on it.
- **Out of scope:** judging code quality (`scrutinize`), reviewing a change (`x-ray`), and proposing a redesign (`architect`).
- **Output:** one HTML file at `docs/briefings/<scope-slug>.html` in the project, or the path the user gives. Leave it uncommitted.

## Steps

1. **Fix the scope.** State in one line what is in and what is out. If the scope is too big to brief within the limits below, propose a split and ask.
2. **Place it.** Sketch the whole system as layers of boxes, top (entry points, clients) to bottom (storage, external services), with the scope marked. This is orientation only: names and one-line notes.
3. **Trace the main flow.** Pick the one path that best explains the scope, usually the most common request or job, and follow it start to finish through the code. Name it in `flowTitle`.
4. **Collect rules and constraints.** A rule is what the business requires ("an order over the credit limit needs approval"). A constraint is what the system forces ("the job must finish before the nightly export"). For each, record the source and the basis:
   - `documented`: stated in docs, a comment, a test name or assertion, or a validation message.
   - `inferred`: seen only in how the code behaves. Say what the code does, not why, unless a source says why.
5. **List the data it touches:** tables, files, queues, events, caches, and external services, with whether the scope reads or writes each.
6. **Choose where to start:** the entry point, the few files that matter most, and the tests that cover the scope, in reading order, each with one line on why.
7. **Find the traps:** hidden coupling, callers outside the scope, order dependence, feature flags, things with no test. Each needs a source.
8. **Write down what you could not determine** as questions for the person who knows. A gap is a question, not a guess.
9. **Write the page.** Copy `template.html` from this skill's folder to the output path. In the copy, replace the lone `{}` inside `<script type="application/json" id="briefing">` with the data below. Change nothing else in the file.
10. **Check it.** The data must be valid JSON, and every `source` must point at a file and line that exist. Open the page if a browser tool is available; otherwise say it was not opened.

### Data

```json
{
  "project": "<project name>",
  "scope": "<scope name, a few words>",
  "summary": "<one or two sentences: what this part is for>",
  "date": "<YYYY-MM-DD>",
  "commit": "<short commit hash, or omit>",
  "map": [
    { "layer": "<layer name>", "boxes": [
      { "name": "", "note": "<one line>", "talksTo": ["<box name>"], "inScope": true }
    ]}
  ],
  "flowTitle": "<which path this is>",
  "flow": [ { "step": "<what happens>", "detail": "<one sentence>", "source": "path/file.ext:12-30" } ],
  "rules": [ { "rule": "<plain statement>", "kind": "rule | constraint", "basis": "documented | inferred", "source": "path/file.ext:12" } ],
  "data": [ { "name": "", "kind": "<table, queue, API, file...>", "access": "Reads | Writes | Reads and writes", "note": "" } ],
  "start": [ { "path": "path/file.ext:12", "kind": "entry | file | test", "why": "<one line>" } ],
  "traps": [ { "trap": "<what goes wrong and when>", "source": "path/file.ext:12" } ],
  "questions": [ "<what the code and docs do not answer>" ],
  "notCovered": [ "<what was left out, and where to look>" ]
}
```

Limits, so the page stays a ten-minute read: 10 boxes across at most 4 layers, 8 flow steps, 15 rules, 10 data rows, 6 places to start, 6 traps, 6 questions. Past a limit, keep the most important items and name the rest in `notCovered`. Omit a section with nothing in it. `inScope` and `talksTo` are optional; mark `inScope` on the box or boxes that are the scope.

Inside the JSON, write `<\/` for any `</`, so the data cannot close the script tag.

## Report

```
## Briefing: <scope>
File: <path written>
In scope: <what was covered>   Out: <what was left out>
Rules: <n> documented, <n> inferred
Open questions: <n>
Opened in a browser: <yes | no>

Most important thing to know: <one sentence>
```

## Rules

- Every flow step, rule, and trap cites a `file:line` or a doc. No source, no entry.
- Never present an inferred rule as documented, and never invent the reason behind a rule.
- Write for someone new: plain statements, no project jargon without a few words of explanation.
- Leave secrets, credentials, and personal data out of the page, even when they appear in the code.
- Write only the briefing file. Never edit code, tests, or docs, and never commit.
