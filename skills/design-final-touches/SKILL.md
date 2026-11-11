---
name: design-final-touches
description: >
  Final visual and accessibility polish pass on a web project before release:
  typography, spacing, color/contrast, focus states, motion, responsive details.
  Trigger on "final touches", "polish the design", "design pass before release",
  or "design-final-touches". Adapts fixes to the project's existing conventions.
---

# Design Final Touches

A reusable design-polish audit. Run it against any web project — static HTML/CSS, React, Next, Vue, Svelte, or similar — to apply final visual and accessibility polish before release.

## How to use
1. **Discover the project first.** Identify the stack, the CSS approach (Tailwind, CSS Modules, vanilla, CSS-in-JS), where design tokens / CSS variables live, and what the primary accent color is. Adapt every fix below to the project's existing conventions rather than imposing new ones.
2. **Work through each area in order**, applying fixes that fit those conventions.
3. **Spot-check, then finish.** See *Before finishing*. Commit only if the project uses version control and a commit is expected; otherwise summarize what changed.

Items marked *Opinion* are aesthetic defaults — adjust or skip them per project. Items citing WCAG / W3C are standards and should hold across projects.

## Typography
- All small text utilities must have a `max()` min-size guard — never drop below `11px` at any zoom level
  *(Opinion — no formal spec; 11px is a widely-cited practical floor for legibility)*
- Verify web font imports include `display=swap` to prevent blank flash on slow connections
  *(Best practice — improves Largest Contentful Paint; part of Google Core Web Vitals guidance)*

## Color — Signal Discipline
Identify the primary accent color. Reserve it **exclusively** for interactive feedback:
- Active/current nav links
- Focus-visible rings
- CTA links, interactive hover states

All decorative roles (labels, dividers, metadata, section titles) must use a secondary/muted variant of the accent.

Audit every accent usage. Ask: is this element interactive? If not, downgrade it to the secondary variant.

> Opinion — grounded in UI design systems thinking, not a formal standard. Reduces visual noise and preserves the signal value of the interactive color.

## Color Grade / Atmosphere
- Background effects (blobs, gradients, overlays) should be symmetric in intensity — avoid any single element dominating the atmospheric layer
- Avoid directional hotspots that cast over content areas
- Continuously-running visual effects (grain, ambient blobs) should stay subtle enough to not compete with content

> Opinion — purely aesthetic judgment, no formal backing. Adjust to project needs.

## Motion
- Any continuously-running CSS animation must pause via `IntersectionObserver` when scrolled off-screen
  *(Best practice — reduces unnecessary GPU load and battery drain on mobile; no formal spec but aligns with performance budgeting)*
- Confirm `prefers-reduced-motion` is respected in both CSS keyframes and JS animation libraries
  *(W3C media feature — WCAG 2.3.3 "Animation from Interactions" (AAA); broadly expected at AA for vestibular safety)*

## Accessibility
- Alt text fallback chain must never resolve to `''` — use a meaningful generic fallback (e.g. `'Photograph'`, `'Image'`)
  *(WCAG 2.1 — Success Criterion 1.1.1 Non-text Content, Level A)*
- Modal/overlay components must have `role="dialog"`, `aria-modal="true"`, a focus trap (Tab/Shift+Tab cycles within), and focus restored to the trigger on close
  *(ARIA Authoring Practices Guide — Modal Dialog Pattern; WCAG 2.1 SC 2.1.2 No Keyboard Trap, Level A)*
- All interactive elements must have visible `focus-visible` rings
  *(WCAG 2.1 — SC 2.4.7 Focus Visible, Level AA; WCAG 2.2 adds SC 2.4.13 Focus Appearance, Level AAA, with measurable size/contrast minimums)*
- Minimum touch target: 44×44px on all buttons and links
  *(WCAG 2.1 — SC 2.5.5 Target Size, Level AAA; 24×24px is the AA threshold in WCAG 2.2 SC 2.5.8)*

## Before finishing
Spot-check at a representative mobile (~375px) and desktop (~1440px) width — substitute the project's own breakpoint targets if it defines them. Verify no regressions in layout, z-index stacking, or interactive components. Then either commit with a clear message (if the project uses version control) or summarize the changes made.
