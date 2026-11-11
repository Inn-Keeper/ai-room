---
name: get-seo-right
description: >
  Technical and on-page SEO audit of a codebase or live URL. Trigger on "SEO audit",
  "check my SEO", "find SEO issues", "is this indexable", "technical SEO", or
  "get-seo-right". Checks crawlability, indexation, metadata, rendering, structured
  data, links, and international setup, with every finding tied to a file or URL.
  Performance is delegated to the web-vitals skill. Report only; never edits code.
---

# Get SEO Right

Find what stops pages from being crawled, indexed, understood, and clicked. Every finding cites a `file:line` or URL plus what was observed. Never guess at rankings or invent search volumes.

## Scope

- **Codebase:** find routes and page files (`page.tsx`, `pages/`, `app/`, `*.html`, templates), the head/metadata layer, the sitemap and robots config, and redirects.
- **URL:** fetch the HTML and headers (`curl -sIL`, `curl -sL`), plus `/robots.txt` and the sitemap. If content depends on JavaScript, compare raw HTML with the rendered page (Playwright, if available); say which one you judged.
- Audit the pages the user names, or a representative set (home, one per template); state the sample. Don't crawl a whole large site.

## Checks

### 1. Crawl and index (blockers first)
- `robots.txt` exists, doesn't block important paths or CSS/JS, and points to the sitemap.
- Sitemap lists only canonical, indexable 200 URLs.
- No stray `noindex` (meta or `X-Robots-Tag`) on pages meant to rank, and `noindex` is present on staging, search results, and thin utility pages.
- Status codes: real 404s for missing pages (no soft 404s), 301 for permanent moves, no redirect chains or loops, and one canonical host and protocol (https, www or not, trailing slash).
- Canonical: absolute, self-referencing on originals, consistent with the sitemap and hreflang.

### 2. Rendering
- Primary content, links, title, and meta are in the server HTML, or are reliably rendered. Content behind client-only fetches or interactions may not be indexed.
- Links are real `<a href>`s, not click handlers.

### 3. Metadata
- `<title>` is unique and descriptive with the main topic first; roughly 60 characters before it truncates.
- Meta description is unique and summarizes the page (around 150 characters). It doesn't affect ranking, only clicks.
- `lang` on `<html>`, a viewport meta tag, and charset.
- Open Graph (`og:title`, `og:description`, `og:image` with absolute URL, `og:url`) and `twitter:card` for share previews.
- Flag duplicates across pages; in a codebase, find the shared default causing them.

### 4. Content structure
- One clear `<h1>` stating the page topic; headings reflect the outline.
- Images have meaningful `alt` text (empty `alt=""` for decorative ones), plus `width` and `height`.
- Descriptive anchor text, not "click here".

### 5. Structured data
- JSON-LD matches visible content and the page type (Organization, Article, Product, BreadcrumbList, FAQPage, and so on).
- Required properties are present; no markup for content that isn't on the page.
- Recommend checking with Google's Rich Results Test, and say you did not run it unless you did.

### 6. Links
- Broken internal links (verify the status, don't assume it).
- Orphan pages: indexable pages that no internal link reaches.
- Important pages are within about three clicks of the home page.

### 7. International (only if multiple locales)
- `hreflang` is reciprocal and uses valid codes, includes `x-default`, and points at canonical URLs.

### 8. Performance and mobile
Don't re-measure here. Note obvious signals (render-blocking scripts, unsized images, huge hero images) and recommend running the `web-vitals` skill for LCP, INP, and CLS.

## Report

```
## SEO Report: <site or project>
Scope: <pages/templates checked, URL or codebase, raw vs rendered>

### Blockers (stop indexing or ranking)
- <finding>: <evidence> at <file:line | URL>. Fix: <concrete change>.

### Should fix
- ...

### Opportunities
- ...

### Working well
- ...

Not checked: <what's out of scope or needs tools/access>
```

- Rank by impact: indexation over metadata over polish.
- No overall score; a single number hides what matters. Counts per section are fine.
- Label anything not verified directly as a hypothesis.
