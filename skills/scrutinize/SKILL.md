---
name: scrutinize
description: >
  Stack-agnostic code quality review of a file, directory, or the current diff:
  structure, complexity, coupling, duplication, type safety, testability and
  delivery risk. Ranked findings with concrete fixes, review only. For
  correctness and regressions of a change, use x-ray instead. Trigger on
  "scrutinize", "code quality review", or "deep review".
---

# Scrutinize: Code Quality Analysis

Review as a principal engineer looking for what will cause bugs, slow the team,
or make the next change harder: not style. No praise, no padding, concrete
findings only.

## Scope

- File or directory given → read everything in scope.
- Nothing given → `git diff HEAD`.
- Diff clean → most recently touched files (`git log --name-only -5`).
- Not a git repo and nothing given → ask for a target.

State the scope in one line. Before analyzing:

1. Read the project's agent/contributor docs (AGENTS.md, CLAUDE.md,
   CONTRIBUTING, README) and respect their conventions and principles over the
   defaults below.
2. Identify the language, frameworks, and idioms in scope; translate every check
   to them (e.g. "component props" → constructor/function parameters, "render"
   → whatever produces output).
3. Run the project's existing linters, type checker, and any complexity tooling
   on the scope, if present. Use their output as evidence; don't install tools.
4. Read every file in scope in full. Track each module's responsibility, data
   flow between them, functions called from multiple sites, and state that's
   shared, cached, or mutated.

## Checks

Run every dimension. Report only what fires.

**Extraction**: functions doing more than one thing at more than one level of
abstraction; long bodies where a block has a nameable purpose; deep nesting
(3+ levels); pure logic buried inside I/O, framework, or UI code that could be
a standalone, testable function. Name what to extract, its signature, and where
it should live.

**Inversion**: three kinds:

- Dependency: high-level policy importing concrete I/O, storage, network, clock,
  randomness, or framework objects instead of receiving them.
- Control: hard-wired calls that make the code untestable without the real
  dependency; prefer passing functions/collaborators in.
- Conditions: nested `if` pyramids that become flat with guard clauses or
  early returns.

Only flag where inversion simplifies or enables testing: not for its own sake.

**SOLID**: flag these, don't define them:

- S: one unit that fetches + transforms + outputs, or owns unrelated state
- L: subtypes or optional fields that break callers expecting the full contract
- I: units receiving large parameter sets or interfaces but using a few

Dependency inversion lives under Inversion; growing type/kind conditionals
under Pattern opportunities. Skip minor violations where the code is still clear.

**Complexity**: cyclomatic: count each branch (`if`/`else if`, ternary, loop,
`case`, `catch`, short-circuit `&&`/`||`/`??`, optional chaining used as a
branch). Also note cognitive load: nesting depth and mixed concerns. Prefer the
project's tool output when available. Report hotspots relative to the codebase
(the top outliers) with name, line range, and score; don't justify refactors by
an arbitrary threshold alone.

**Coupling and cohesion**: modules reaching through other objects' internals
(Law of Demeter), exported mutable state, circular imports, modules whose parts
change for unrelated reasons, and features scattered across many files.

**Magic numbers/strings**: any literal that repeats or has no meaning from
context. Give file, line, value, and the constant name it should get.

**Dead code**: assigned-but-unread variables, unused imports, unreferenced
functions or exports, feature flags fixed to one value, unreachable branches.

**Repeated logic**: near-identical blocks across 2+ sites. Give each location
and the name the shared abstraction should have. Recommend extracting at the
third repetition unless the copies already diverge in bugs.

**Pattern opportunities**: only where a pattern clearly simplifies, never for
its own sake, and never if it adds more lines than it removes: lookup table or
Strategy for growing conditionals, Factory for repeated construction, Observer
or events for callbacks threaded through many layers, Command for undoable or
queued mutations.

**Type safety**: escape hatches (`any`, unchecked casts, non-null assertions,
`unsafe`, `# type: ignore`, unchecked `interface{}`) without a stated invariant;
external data (network, storage, files, env, parsing) not validated at the
boundary; missing guards on realistically-absent values; mutable collections
that should be read-only. Skip this section for untyped languages except
boundary validation.

**Side effects and state**: hidden mutation of arguments or globals, functions
that look pure but aren't, resources (handles, listeners, timers, subscriptions)
acquired without cleanup.

**Performance**: work in hot paths (per-frame, per-request, per-item loops):
repeated allocation, I/O, or recomputation that could be hoisted or cached;
unbounded growth of caches, lists, or retained snapshots.

**Testability and coverage**: risky logic (branches, parsing, money, security,
state machines) with no test; code that can't be tested without its real
dependencies (see Inversion).

**Delivery risk**: implicit coupling with no shared type or contract (a format
built in one place, parsed in another); unhandled errors around async or I/O
that can fail; side effects during output/rendering; hardcoded URLs, timeouts,
or limits that belong in config; leftover debug logging, `TODO`, or `FIXME` in
production paths.

## Report

Group by severity; skip empty groups. Report at most 15 findings, highest
severity first, then state how many lower ones were omitted.

- **High**: will cause bugs, data loss, or a real regression under normal use.
- **Medium**: works today, fragile, will bite the next engineer.
- **Low**: edge-case correctness, or a clarity risk that invites a future misread.

Format each finding:

```
[SEVERITY] Short title
File: path:line

Problem: one or two sentences: what's wrong and why it matters.
Fix: the concrete action (extracted function, injected dependency, guard
clause, renamed constant, type guard, pattern). If two approaches fit, name
both with the tradeoff in a sentence each.
```

## Summary

Close with one sentence each:

1. **Biggest risk**: the finding most likely to cause a production bug or painful refactor if ignored.
2. **Easiest win**: under 10 minutes, highest clarity payoff.
3. **Structural debt**: extraction, inversion, or repeated-conditional issues to fix before the codebase grows.
4. **Ship confidence**: safe as-is, or does a High finding block it?

Then list the commands run and any checks skipped, with the reason.

## Rules

- Read the actual code; never invent findings from names or descriptions.
- Read call sites outside the scope when a finding depends on them.
- SOLID and inversion findings must cite a current cost (a bug, duplication at
  3+ sites, or code that can't be tested). Never recommend an abstraction with a
  single implementation or an extension point for variants that don't exist yet.
- Distinguish measured results (tool output, counted branches) from judgment.
- Skip style and formatting unless they create real ambiguity or a correctness risk.
- Review only; don't edit files.
- Zero findings after full analysis: **"No findings. Code is clean."**
