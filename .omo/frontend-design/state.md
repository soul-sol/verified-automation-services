# Frontend Design State

## Current Objective

Publish a Korean-first, bilingual static service landing page that moves a
visitor from a real free sample to the matching fixed-scope GitHub inquiry.

## Locked Decisions

- Static HTML and CSS only; no React, analytics, forms, cookies, or third-party
  runtime scripts.
- GitHub Pages is the intended public host.
- Korean first, English summaries second.
- One lime accent, ring-border depth, Noto Sans KR/system font stack.
- No invented customer proof, revenue, awards, results, or urgency.
- No email, payment, private-data upload, legal acceptance, or account setup.

## Source Inputs

- `DESIGN.md`
- `README.md`
- `SAMPLES.md`
- `DELIVERY.md`
- `design-reference/selected-concept.webp`
- `assets/deliverables-wall.webp`

## Design Brief

Primary journey: identify the problem, inspect a free sample, compare the
fixed scope and exclusions, then open the corresponding public inquiry form.
The page must work for nontechnical Korean buyers and technical English
readers without assuming GitHub fluency.

## Inclusive Personas

- Minji: Korean-first small-business owner seeking clear price and output.
- Alex: engineering lead seeking evidence and explicit exclusions.
- Jisoo: low-vision keyboard user at 200% zoom.
- Hyun: attention-limited mobile user who needs short, direct sections.

## Adaptive Preferences

- Full keyboard access and a skip link.
- Visible focus in both color schemes.
- Reduced-motion disables transforms and transitions.
- 200% zoom and 375px layouts must not scroll horizontally.
- No content is available only on hover or only by color.

## Verification Matrix

- Primitive showcase at 375, 768, and 1280 widths before page composition.
- Final page at the same widths in light and dark preferences.
- Keyboard order and focus visibility.
- External and internal link checks.
- Production-host HTTP and deployed Lighthouse mobile/desktop.
- Final visual QA and design review use the same captured surface.

## Design Debt Register

No debt accepted.

## Evidence Index

- Research screens: `/tmp/lazyweb-services.sqYbLX/images/` (temporary,
  reference-only, not shipped).
- Imagen concepts: `design-reference/`.
- Selected project hero: `assets/deliverables-wall.webp`.
- Primitive evidence: `.omo/frontend-design/qa-showcase.md`.
- Landing evidence: `.omo/frontend-design/qa-landing.md`.
- Local captures: `output/playwright/landing/` (verification-only, not shipped).

## Handoff Notes

The local implementation follows `DESIGN.md`. Public issues are inquiries
only, not orders or payments. Independent visual QA passed after correcting
dark contrast, Korean wrapping, illustration labeling, and mobile sample
painting. Production URL and Lighthouse evidence remain pending until the
exact committed source is published.
