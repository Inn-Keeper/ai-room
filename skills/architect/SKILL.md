---
name: architect
description: >
  Design a new system or large feature before any code is written: requirements,
  context, architecture options with a recommendation, and a phased roadmap. Trigger
  on "architect this", "design this system", "plan this feature", "how should we
  structure", or "architect". Produces a design, not code. For a scoped ticket or
  small change, use there-we-go instead.
---

# Architect

Design the right solution before any implementation: weigh options against the
requirements, name the tradeoffs, and commit to one recommendation.

## Scope

Scale the depth to the problem. A checklist item that does not apply gets skipped,
not padded.

## Steps

### Phase 1: Requirements

1. Restate the goal in one or two sentences.
2. List functional requirements, separating stated ones from *(implied)* ones.
3. Note the non-functional requirements that actually matter here, such as
   performance, security, scale, and maintenance.
4. List the open questions. If any of them block the design, ask now and stop.

### Phase 2: Context

1. If a codebase exists, read the structure, key modules, and integration points.
   Never guess at files you have not read.
2. Name external systems and the system boundary.
3. Add a small context diagram only if it clarifies something prose cannot.

### Phase 3: Options

1. Propose 2–3 viable approaches. For each one, give when it fits, its main
   advantage, and its main drawback.
2. Recommend one and justify it against the requirements from Phase 1.
3. For the recommendation, define:
   - Components and their single responsibilities
   - Interfaces and contracts between them
   - The data model (entities, relationships, keys, indexes), if applicable
   - Cross-cutting concerns that apply: auth, error handling, observability, security

### Phase 4: Roadmap

1. Break the implementation into phases, each of which can be shipped and reviewed on its own.
2. Give the technical risks and a mitigation for each.
3. Define success criteria that can be checked.
4. List what is explicitly out of scope.

## Report

End with:

- **Recommendation:** two or three lines.
- **Confidence:** a percentage, and what would raise it.
- Either **"Ready to implement. Confirm and I'll start with phase 1."** or
  **the questions that must be answered first.**

## Rules

- Write no production code in this skill.
- Prefer the simplest design that meets the requirements; abstractions must earn
  their place. Public interfaces and persisted data are the exception: design them
  carefully up front.
- Do not start implementing until the user confirms.
