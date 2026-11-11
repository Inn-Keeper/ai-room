---
name: evaluate-product
description: Use when the user requests a senior product manager evaluation, product UX audit, or thorough review of user journeys, intuitiveness, navigation, onboarding, flow, friction, and product feel. Applies to live products, prototypes, screenshots, and source-backed reviews; not routine code review or implementation.
---

# Evaluate Product

Evaluate whether the intended user can understand the promise, achieve a valuable outcome, recover from trouble, and return confidently. Connect individual screens to the whole journey. Prioritize user outcomes and product tradeoffs over feature counts or personal taste, and judge interactions by whether users can predict, act, and recover.

## Scope

Read available product, brand, and design guidance. Identify the target user, their situation, job to accomplish, promised value, and meaningful success event. Distinguish documented intent from assumptions. Ask only for missing information that materially changes the evaluation; otherwise state a working assumption and proceed.

Respect the requested scope. For a whole-product evaluation, inventory entry points and connected journeys before choosing representative paths. Include new and returning users and materially different roles. Derive platforms and dimensions from the actual product; do not assume a particular stack, device, or business model.

## Checks

### Walk the journey

Follow the product as a user would, using the available interface before relying on implementation details. Source code can explain behavior but does not establish that the rendered experience works.

Map the relevant path: arrival and promise → orientation → setup → first value → core task → completion → return or continuation. Include branches, handoffs, exits, and recovery. For each stage capture:

| Stage | User intent and expected next action | Actual cue/action | Friction or reassurance | Evidence |
| --- | --- | --- | --- | --- |

Inspect the happy path plus relevant empty, loading, invalid-input, failure, interruption, back-navigation, and saved-state recovery cases. Check whether progress survives refresh or return when the task depends on it. Sample realistic content and volume, not only pristine demos.

For interactive access, inspect supported small and large layouts, keyboard/focus behavior, touch interactions, and feedback timing where relevant. If only screenshots, prototypes, or source are available, evaluate what they establish and identify the missing checks. Do not call static evidence a tested flow.

### Evaluate these dimensions

Cover each dimension; mark it observed, inferred, untested, or not applicable with a reason. A missing observation is not a passing result.

| Dimension | Decision to assess |
| --- | --- |
| Value and first use | Is the benefit understandable, and does setup earn its cost before first value? |
| Intuition and mental model | Do labels, grouping, affordances, defaults, and navigation match how users think? Can they predict the next action and its consequence? |
| Flow and continuity | Are sequence and handoffs coherent? Where do users repeat work, switch context, lose state, hit dead ends, or face premature decisions? |
| Feedback and control | Are progress, waiting, success, failure, undo, and recovery understandable and timely? |
| Feel and trust | What visible behavior creates confidence, hesitation, overload, calm, or frustration? Assess hierarchy, density, copy tone, motion, perceived responsiveness, and honest expectations. |
| Inclusive use | Can relevant users complete the task across supported devices, input methods, and accessibility needs? |
| Completion and return | Is success explicit? Can users find their result, resume work, and recognize a useful reason to return? |

Treat emotional reactions as reviewer judgments until supported by user research. Explain the concrete cue behind each judgment. Separate useful friction, such as informed confirmation, from needless effort. Preserve effective parts of the experience.

### Prioritize with evidence

For every material finding give: journey stage and affected user; evidence location and reproduction context; observed behavior; likely user consequence; severity; confidence; smallest useful improvement; and a way to validate it. Label source-backed inferences, usability hypotheses, and aesthetic preferences separately from reproduced defects.

Severity reflects consequence: **critical** blocks the core outcome or risks serious loss; **high** substantially obstructs a key task; **medium** causes recoverable confusion or unnecessary work; **low** is limited polish. Rank using consequence, likely exposure, and confidence. State when exposure or implementation effort is unknown. Do not invent conversion lifts, prevalence, timing measurements, or user quotes.

Compare meaningful tradeoffs. Fewer steps are not automatically better; added automation can reduce control. Prefer removing, clarifying, reordering, or improving defaults before adding features. Recommend user research or instrumentation when uncertainty drives the decision, with a specific question or success measure.

## Report

Lead with a concise verdict scoped to the evidence. Then provide:

1. Product/user assumptions and coverage: inspected surfaces, scenarios, methods, and limitations.
2. Journey map and dimension coverage, including untested areas.
3. Ranked findings with the fields above; group shared causes instead of repeating symptoms.
4. What works and should be preserved.
5. Priorities for now, next, and later, with rationale and dependencies. Distinguish launch blockers from improvements.
6. Validation plan: observable task success, comprehension, recovery, and relevant behavioral metrics; list remaining manual checks.

Adapt detail to the requested depth without hiding gaps. Avoid an arbitrary aggregate UX score unless requested; any score needs an explained rubric. If a durable report is requested, save it at the requested location. End with the highest-value next decision, not an unsolicited implementation.

## Rules

- Review without changing product files or persistent user data unless requested. Use safe test environments and existing fixtures. Real sends, purchases, deletions, and account changes require appropriate authorization; inspect up to that boundary when unavailable.
