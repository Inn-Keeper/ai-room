---
name: web-vitals
description: >
  Measure and validate Core Web Vitals (LCP, INP, CLS) for one or more URLs, local
  or live. Trigger on "core web vitals", "web vitals", "check LCP/INP/CLS", "page
  speed", "is my site fast", or "performance check". Combines Lighthouse lab runs
  with real-user CrUX field data and reports pass/fail against Google's thresholds,
  with the elements to fix. Report only; never edits code.
---

# Web Vitals

Validate Core Web Vitals and point at what to fix. Never present lab numbers as a real-user pass.

## Thresholds (75th percentile of page loads)

| Metric | Good | Needs improvement | Poor |
|---|---|---|---|
| LCP | ≤ 2.5 s | ≤ 4.0 s | > 4.0 s |
| INP | ≤ 200 ms | ≤ 500 ms | > 500 ms |
| CLS | ≤ 0.1 | ≤ 0.25 | > 0.25 |

A page passes only when all three are Good in field data.

## Inputs

- One or more URLs. Ask for them if missing; do not crawl a whole site.
- Local URLs (localhost, dev servers) get lab data only. Prefer a production build; say so when the target is a dev server, since dev builds are slower.

## 1. Lab data (any URL)

Run Lighthouse three times per URL with the default mobile profile and use the median:

```bash
npx -y lighthouse@13.6.0 "$URL" --only-categories=performance \
  --output=json --output-path=./lh-1.json --chrome-flags="--headless=new" --quiet
```

Write reports to a temp directory, not the project. From each JSON read:
- `audits["largest-contentful-paint"]` and `audits["largest-contentful-paint-element"]`: LCP time and the element.
- `audits["cumulative-layout-shift"]` and `audits["layout-shifts"]`: CLS and the shifting elements.
- `audits["total-blocking-time"]`: TBT, the lab proxy for INP. Lab runs have no real interactions, so INP itself cannot be measured here.
- Top opportunities by estimated savings (e.g. `render-blocking-resources`, `unused-javascript`, `uses-optimized-images`, `server-response-time`).

If Chrome or npx is unavailable, report Blocked; do not install browsers without asking.

## 2. Field data (public URLs only)

Query the PageSpeed Insights API, which includes CrUX data from real Chrome users over the last 28 days:

```bash
curl -s "https://www.googleapis.com/pagespeedonline/v5/runPagespeed?url=$(python3 -c 'import urllib.parse,sys;print(urllib.parse.quote(sys.argv[1],safe=""))' "$URL")&strategy=mobile&category=performance${PSI_API_KEY:+&key=$PSI_API_KEY}"
```

- Read `loadingExperience.metrics` (this URL) and `originLoadingExperience.metrics` (whole origin): `LARGEST_CONTENTFUL_PAINT_MS`, `INTERACTION_TO_NEXT_PAINT`, `CUMULATIVE_LAYOUT_SHIFT_SCORE` (divide by 100), each with `percentile` and `category`.
- No URL-level data: fall back to origin data and label it. No data at all: say "no field data", never estimate it.
- Works without a key at low volume. On quota errors, ask the user to set `PSI_API_KEY` in their environment. Never print, log, or commit the key.

## Report

```
## Core Web Vitals: <url>
Verdict: Pass | Fail | Lab only (no field data)

| Metric | Field p75 | Lab (median of 3) | Status |
|---|---|---|---|
| LCP | 2.1 s (URL) | 3.4 s | Good |
| INP | 310 ms (origin) | TBT 450 ms | Needs improvement |
| CLS | 0.02 | 0.00 | Good |

Fixes (highest impact first):
1. <metric>: <element or resource> → <concrete fix>. Evidence: <audit id / value>.
```

- Tie each fix to the element or resource Lighthouse named; in a codebase, locate the file that renders it.
- When lab and field disagree, trust field for the verdict and explain the gap (device, cache, real interactions).
- Limits: say which URLs, which device profile, and what was not measured.
