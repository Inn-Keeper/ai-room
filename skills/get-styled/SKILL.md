---
name: get-styled
description: Use when reviewing or improving CSS architecture, selectors, specificity, responsive and adaptive layouts, cross-browser compatibility, or styling performance. Also use for requests to audit stylesheets, deep selectors, CSS best practices, mobile layouts, or get-styled. Keep reviews read-only unless changes are requested.
---

# Get Styled

Audit or improve CSS against the user’s styling principles, connected markup,
and actual browser behavior. Favor small, evidence-backed repairs and predictable
component styles. Apply this skill to any web project, framework or styling
strategy. Discover its conventions and supported platforms from the current
project; do not carry over names, commands, tools, measurements or constraints
from a previous audit. Preserve the existing product and interaction model.

## Scope

1. Establish whether the request is a review, report/action plan, or implementation.
   Reviews are read-only. A request for a report or skill does not authorize fixes.
2. Inventory all relevant styles, including imported CSS, modules, CSS-in-JS,
   inline styles, dynamic classes, component markup, alternate entry points,
   build configuration and browser tests. A project-wide review covers the whole
   project, not just the diff. Exclude generated caches from source findings.
3. Read local instructions and existing design conventions. Trace the cascade
   and runtime callers before declaring a rule dead, a state broken, or a
   performance problem. Preserve unrelated changes and configuration outside the requested scope.
4. Measure complexity with an available parser: selector depth, specificity,
   ID selectors, important flags, duplicated selectors in the same context,
   custom properties, units and media queries. Counts identify investigation
   areas; they do not establish severity or justify arbitrary thresholds.
5. Verify representative screens and interactions in supported browser engines.
   Inspect rendered screenshots as well as geometry and computed styles.
6. Report observed defects separately from compatibility risks, maintainability
   concerns, preferences and optional improvements. For authorized fixes,
   reproduce first, make the smallest repair, then run appropriate checks.

## Checks

### Architecture and maintainability principles

- **CSS variables:** Use native custom properties for shared semantic colors,
  spacing and fonts so global changes have one source. Keep unique component
  geometry and one-off values local; avoid a speculative token system.
- **BEM naming:** Prefer predictable `block__element--modifier` relationships for
  new plain-CSS components. In an established naming system, preserve consistency
  and scope component classes. Record deviations from the user’s BEM preference
  separately from actual maintainability defects; avoid a mass rename.
- **Utilities versus components:** Balance reusable layout components with small,
  purpose-built global spacing utilities. Introduce shared rules for actual
  repetition. Avoid generic classes that unintentionally style unrelated controls.
- **Logical ordering:** Organize resets, tokens and typography, layouts,
  components, states and responsive rules systematically. Consolidate repeated
  selectors within the same context. Preserve intentional breakpoint differences
  and declarations still inherited from earlier rules.
- **Ownership:** Keep component styles easy to locate. Scope special behavior
  such as visually hidden headings to its intended component. Do not make every
  semantic element undo a global component-specific default.

### Selectors and specificity principles

- Use single component classes where possible; attach state through modifiers,
  attributes or pseudo-classes. Inspect descendant chains, child combinators,
  element selectors and structural assumptions. Depth alone is not a defect.
- **Do not introduce IDs for styling.** Keep IDs for labels, anchors and behavior;
  use classes for presentation. Report existing styling IDs and migrate them
  within an authorized, tested scope.
- **Avoid `!important`.** Repair selector ownership, ordering and specificity.
  Existing flags required by third-party integrations need a real behavior
  check before removal. Do not trade a working integration for cosmetic
  compliance; explain and contain any necessary exception.
- Check specificity inside media queries: a later accessibility override can
  still lose to a stronger base selector. Look for redundant selector branches
  that add specificity without extending coverage.
- Trace dynamic names before deleting selectors. Template-built variants,
  pressed/disabled states, portals, optional screens and previews may not appear
  in an initial DOM snapshot.

### Layout, responsiveness and adaptation principles

- Use **Flexbox** for one-dimensional UI layout and **Grid** for two-dimensional
  interfaces. Absolute positioning remains appropriate for overlays, anchored
  controls and layered content; it is not a replacement for general page layout.
- Prefer **mobile-first base styles** with `min-width` desktop enhancements.
  Retain height, orientation, input and accessibility queries when needed.
  Avoid mixing competing layout modes through appended override patches.
- Prefer **relative units**: rem for readable text and content spacing,
  percentages for fluid structure, and viewport/container units where suitable.
  Keep pixel borders, precise geometry and deliberate minimum hit areas when
  they represent the intended constraint. Do not convert units mechanically.
- Use **`clamp()`, `min()` and `max()`** to express fluid constraints rather than
  accumulating breakpoints. Verify that minimums remain readable and maximums
  fit both axes. Avoid nowrap headings that shrink into illegibility.
- Inspect intrinsic sizing: `1fr` can retain an unwanted minimum; use
  `minmax(0, 1fr)` and shrinking children where the composition requires it.
- Check short-wide viewports as well as narrow-tall ones. Constrain large
  content regions and media by available height and width. Stacking/reflow should
  preserve essential controls without shrinking the whole page.
- Measure actual touch targets. Use project/platform requirements; if absent,
  propose 44 × 44 CSS px as the phone design target and state the assumption.
  Do not label every smaller target an automatic standards violation.
- Test larger text independently from viewport changes. A 200% root font probe,
  browser zoom, text-only zoom, pinch zoom and OS text preferences are different
  checks. Fixed-pixel labels can ignore root-size changes while inherited text
  grows. Do not report one check as evidence for the others.
- Check wrapping, long labels, localization risks, scrollable panels, safe areas,
  dynamic browser chrome, focus outlines and keyboard/focus-driven scrolling.
- Do not mask layout defects using `overflow-x: hidden`, whole-page scaling,
  reduced font size or undersized controls.

### Cross-browser verification

Derive the browser and device matrix from the project’s supported platforms,
audience and available automation. For broad web compatibility, exercise
Chromium, Firefox and WebKit; distinguish engine tests
from branded Chrome/Edge/Safari, mobile emulation and actual devices.

Choose a proportionate matrix rather than imposing fixed device dimensions:

| Dimension         | Checks selected for the current project                                           |
| ----------------- | --------------------------------------------------------------------------------- |
| Viewports         | Supported narrow/wide widths, short/tall heights and representative desktop sizes |
| Breakpoints       | Immediately below, at and above actual layout boundaries                          |
| Containers        | Embedded, sidebar or resizable contexts when applicable                           |
| Preferences/input | Reduced motion, larger text, keyboard, touch and hover as supported               |
| Screens/states    | Relevant routes, menus, dialogs, empty/populated, loading, success and error      |

Phone, tablet and desktop scenarios are examples, not mandatory product targets.
Include rotation, safe areas and native webviews only when the product uses them.

- Record requested viewport dimensions separately from layout/visual viewport
  sizes and document bounds. Mobile browsers can expand the layout viewport
  when content overflows, concealing the intended-width failure.
- Check live resize/rotation, not only reload at each size. Verify essential
  action bounds, focus, hit areas, scroll position and alignment after changes.
- Exercise at least the main state transition through real controls. Trace
  JavaScript guards before attributing a forced CSS state to normal behavior.
- Inspect native selects, summaries and checkboxes: matching CSS declarations
  do not guarantee matching rendered geometry. Normalize appearance deliberately
  while preserving semantics and visible control affordances.
- Compare actual resolved build targets and stated browser support with CSS
  feature requirements. For hybrid/native wrappers, also check declared OS minimums. Verify current compatibility with official documentation
  when needed; do not rely on remembered browser-support dates.
- Inspect fallbacks for modern units, containers, `:has()`, masks, individual
  transforms and zoom when supporting older engines. `CSS.supports` verifies
  syntax acceptance, not full rendering correctness. Build transforms cannot
  supply every missing layout capability.
- If browsers or local servers are blocked, report the environment limitation
  distinctly. Preserve completed checks; never present unavailable engines as
  passing or install new production dependencies to bypass the limitation.

### Performance and quality principles

- **Minification:** Verify the production bundler emits compressed CSS. Measure
  output and gzip sizes. Keep an existing working pipeline; do not add cssnano
  simply to satisfy a checklist.
- **Dead code:** Audit unused/superseded rules regularly. Before using a purge
  tool, protect dynamically assembled classes and exercise non-initial states.
  A single-page coverage sample does not prove a selector is unused. Manual
  consolidation is often safer for a small stylesheet.
- **Animation:** Favor transform (including translate/rotate/scale) and opacity
  for motion. Flag layout/paint-heavy transitions and effects for measurement.
  Profile expensive shadows, filters, masks and fixed backgrounds on target
  hardware before calling them performance defects. Do not add blanket
  `will-change`, `translateZ(0)` or forced GPU layers.
- Preserve reduced-motion behavior, visible focus, disabled and pressed states,
  contrast and accessible labels. Gate mouse-only hover appropriately.
- Distinguish CSS payload from image, JavaScript, rendering and application-work costs.
  Build success, selector counts and screenshots do not establish frame rate.

### Example: specificity defeats reduced motion

```css
/* The three-class animation outranks this two-class disabling rule. */
.notification .notification__message.is-entering {
  animation: enter 500ms both;
}
@media (prefers-reduced-motion: reduce) {
  .notification .notification__message {
    animation: none;
  }
}
```

Reproduce with reduced motion and inspect computed `animation-name` on the real
entry flow. Gate the animation under `no-preference` or match its specificity.
If a different animation is gated in JavaScript, exercise that real transition;
manually adding its class does not prove the user flow ignores reduced motion.

## Report

For a full audit, deliver:

1. **Verdict and scope:** what was inspected, intended platforms and whether any
   files changed. Lead with user impact.
2. **Evidence matrix:** engines/versions, requested viewports, states and actual
   outcomes. Separate measurements from passing automated assertions.
3. **Ranked findings:** stable numbers, priority, file/line references,
   reproduction, observed impact, smallest repair and remaining uncertainty.
4. **Principle checklist:** assess every requested architecture, selector,
   layout and performance item. Mark contextual exceptions explicitly.
5. **Action plan:** ordered tasks with affected files, dependencies, focused
   regression checks, acceptance criteria and manual follow-up. Changes to the
   supported platform policy require an explicit decision.
6. **Verification limits:** commands run, failures, skips, temporary evidence
   lifetime and untested devices/preferences. Correct any earlier invalid claim.

Save a repository Markdown report when requested, using repository conventions.
Keep it self-contained; do not depend on temporary JSON or screenshots remaining
available. Do not automatically modify historical reports or commit changes.

For a small implementation request, scale the report down to what changed, why,
verification and material limitations; do not run a project-wide audit by default.

## Rules

- Reviews are read-only. A request for a report or skill does not authorize fixes.
- Discover conventions and supported platforms from the current project; do not
  carry over names, commands, tools, measurements or constraints from a previous audit.
- Report observed defects separately from compatibility risks, maintainability
  concerns, preferences and optional improvements.
