# Verified Automation Services Design System

## 0. Research Log

- Embedded refs: shortlisted Wise, Stripe, and Linear; selected `taste-skill` +
  Wise because fixed pricing needs confident clarity, approachable contrast,
  and physical CTA feedback rather than decorative software aesthetics.
- UI/UX database: the trust-and-authority pattern recommended transparent
  pricing, one accent, a low-friction CTA, Korean-first Noto Sans KR, visible
  focus, 44px touch targets, and a 3-step conversion path.
- Lazyweb: 3 queries and 6 desktop screens viewed (Cutover, Precoro,
  WooCommerce Agencies, Ocado Intelligent Automation, Wix Studio, Cortex);
  retained large problem-first copy, transparent price bands, real work
  imagery, and direct quote paths. Rejected long forms, fake proof, repeated
  equal cards, and dark developer-only presentation.
- Imagen drafts: `design-reference/concept-a-split.webp`,
  `design-reference/concept-b-dark.webp`, and
  `design-reference/selected-concept.webp`; selected the third draft because
  it makes the free sample the first decision and places prices, scope, and
  privacy in one short path.
- Final hero asset: `assets/deliverables-wall.webp`, generated for this page
  and containing no people, logos, customer claims, or private data.

## 1. Atmosphere & Identity

A calm inspection desk for buying technical work. The visitor sees the kind
of deliverable before seeing a sales claim. The signature moment is the
physical wall of four technical outputs paired with a single lime action
color. The page feels direct, evidence-led, and safe for a buyer who may not
understand GitHub.

Design read: trust-first service landing for nontechnical business owners and
engineering leads, using a bold, clear fintech information hierarchy.

Design dials: `DESIGN_VARIANCE 4`, `MOTION_INTENSITY 3`,
`VISUAL_DENSITY 4`.

## 2. Color

### Palette

| Role | Token | Light | Dark | Usage |
|---|---|---|---|---|
| Surface/primary | `--surface-primary` | `#fbfcf8` | `#11130f` | Page background |
| Surface/secondary | `--surface-secondary` | `#f0f4eb` | `#1b1f18` | Tinted sections |
| Surface/elevated | `--surface-elevated` | `#ffffff` | `#232820` | Media and scope panels |
| Surface/inverse | `--surface-inverse` | `#11130f` | `#f4f7f0` | Final conversion panel |
| Text/primary | `--text-primary` | `#11130f` | `#f4f7f0` | Headlines and body |
| Text/secondary | `--text-secondary` | `#4b5148` | `#c4cbc0` | Supporting copy |
| Text/inverse | `--text-inverse` | `#f4f7f0` | `#11130f` | Inverse panel copy |
| Border/default | `--border-default` | `#c9d0c4` | `#41483e` | Dividers and cards |
| Border/strong | `--border-strong` | `#7f8879` | `#90998a` | Emphasized structure |
| Accent/primary | `--accent-primary` | `#9fe870` | `#a8ef7c` | Primary actions only |
| Accent/hover | `--accent-hover` | `#b7f58f` | `#c0f69d` | Hover feedback |
| Accent/ink | `--accent-ink` | `#163300` | `#163300` | Text on accent |
| Code/accent | `--code-accent` | `#316b12` | `#a8ef7c` | Verified command and PASS signal |
| Focus | `--focus-ring` | `#163300` | `#d3ffb8` | Keyboard focus |
| Status/warning | `--status-warning` | `#735c00` | `#ffe169` | Privacy notice text |
| Status/error | `--status-error` | `#9f2525` | `#ffb4ab` | Error showcase only |

### Rules

- Accent is reserved for links, primary buttons, and small document details.
- Information is never communicated by color alone.
- All component code uses semantic variables. Raw colors live only here and
  in the root token declarations.

## 3. Typography

### Scale

| Level | Size | Weight | Line Height | Tracking | Usage |
|---|---|---|---|---|---|
| Display | `clamp(3rem, 7vw, 6.5rem)` | 900 | 0.98 | -0.045em | Hero |
| H1 | `clamp(2.5rem, 5vw, 4.5rem)` | 900 | 1.02 | -0.035em | Major conversion heading |
| H2 | `clamp(2rem, 4vw, 3.5rem)` | 800 | 1.08 | -0.025em | Section headings |
| H3 | `1.5rem` | 750 | 1.25 | -0.015em | Offer and sample titles |
| Body/lg | `1.125rem` | 500 | 1.65 | 0 | Lead paragraphs |
| Body | `1rem` | 450 | 1.65 | 0 | Default text |
| Body/sm | `0.875rem` | 500 | 1.55 | 0 | Supporting details |
| Caption | `0.75rem` | 650 | 1.45 | 0.02em | Metadata |

### Font Stack

- Primary: `"Noto Sans KR", "Apple SD Gothic Neo", "Malgun Gothic",
  system-ui, sans-serif`
- Mono: `"SFMono-Regular", Consolas, "Liberation Mono", monospace`
- No serif font is used.

### Rules

- Korean is primary; English product names stay in the same family.
- Body copy is never below 14px and is limited to 68 characters per line.
- Prices use tabular figures.

## 4. Spacing & Layout

### Base Unit

All spacing derives from 4px.

| Token | Value | Usage |
|---|---|---|
| `--space-1` | `4px` | Tight inline gap |
| `--space-2` | `8px` | Icon and label |
| `--space-3` | `12px` | Compact controls |
| `--space-4` | `16px` | Mobile gutter |
| `--space-5` | `20px` | Text grouping |
| `--space-6` | `24px` | Card inner spacing |
| `--space-8` | `32px` | Component groups |
| `--space-10` | `40px` | Compact section |
| `--space-12` | `48px` | Major grouping |
| `--space-16` | `64px` | Section spacing |
| `--space-20` | `80px` | Desktop section spacing |
| `--space-24` | `96px` | Maximum separation |

### Grid

- Max content width: 1200px.
- Desktop: 12 columns with 24px gutters.
- Tablet: 8 columns with 24px gutters.
- Mobile: one column with 16px gutters.
- Breakpoints: 640px, 768px, 1024px, 1280px.
- Hero uses `min-height: calc(100dvh - 72px)`.

## 5. Components

### Action Link

- **Structure**: semantic anchor with label and optional inline arrow.
- **Variants**: primary accent, secondary outline, text link.
- **Spacing**: minimum 48px height, `--space-4` horizontal minimum.
- **States**: default, hover, active, focus-visible, visited, disabled
  showcase.
- **Accessibility**: descriptive text, 44px minimum target, 3px focus ring.
- **Motion**: 160ms transform and color only; active scales to 0.98.

### Service Row

- **Structure**: service name, one-sentence scope, starting price, inquiry
  action.
- **Variants**: standard and kit.
- **Spacing**: `--space-6` mobile, `--space-8` desktop.
- **States**: default, hover/focus-within, unavailable showcase.
- **Accessibility**: price is text, action intent is unique per service.
- **Motion**: no automatic motion; link feedback only.

### Sample Tile

- **Structure**: visual document surface, title, useful outcome, sample link.
- **Variants**: spreadsheet, CI, agent skill, Go workflow.
- **Spacing**: `--space-5` with 16px media radius.
- **States**: default, hover/focus-within, empty and error showcase.
- **Accessibility**: decorative preview is hidden from assistive technology;
  the title and outcome carry meaning.
- **Motion**: tile rises 2px on hover; disabled under reduced motion.

### Scope Split

- **Structure**: two columns labeled “포함” and “제외”, each with concise
  grouped statements.
- **Variants**: normal only.
- **Spacing**: `--space-8`; collapses to one column below 768px.
- **States**: static.
- **Accessibility**: headings and lists communicate the distinction without
  relying on green.
- **Motion**: none.

### Journey Item

- **Structure**: verb heading, explanation, direct action where relevant.
- **Variants**: check, choose, inquire.
- **Spacing**: `--space-6`.
- **States**: static, link focus where present.
- **Accessibility**: DOM order is the journey order; no decorative step
  numbers.
- **Motion**: none.

### Notice

- **Structure**: heading and plain-language warning.
- **Variants**: privacy, empty, error.
- **Spacing**: `--space-5`.
- **States**: static.
- **Accessibility**: does not depend on iconography or color.
- **Motion**: none.

### Top Navigation

- **Structure**: text wordmark, in-page links, primary inquiry action.
- **Variants**: desktop and wrapped mobile.
- **Spacing**: 72px desktop height; 64px mobile.
- **States**: anchor default, hover, active, focus-visible.
- **Accessibility**: skip link precedes it; single-line desktop navigation.
- **Motion**: sticky surface uses no scroll listener.

### Code Artifact Display

- **Structure**: inverse hero tray containing two actual code-output windows,
  each with a filename label and preformatted content.
- **Variants**: workflow source and compile report.
- **Spacing**: `--space-4` tray, `--space-5` code body.
- **States**: static; horizontal code overflow remains locally scrollable.
- **Accessibility**: source remains selectable text, has a descriptive figure
  caption, and does not encode PASS only through color.
- **Motion**: none.

### Assessment Question

- **Structure**: numbered fieldset with one plain-language reliability check
  and mutually exclusive `예` / `아니요` radio choices.
- **Variants**: unanswered, answered yes, answered no, disabled showcase.
- **Spacing**: `--space-6` panel padding, `--space-3` between choices.
- **States**: default, hover, checked, focus-visible, disabled.
- **Accessibility**: the question is a `legend`; native radio inputs remain in
  the accessibility tree; each target is at least 48px high.
- **Motion**: checked state changes color only; no animated layout.

### Score Summary

- **Structure**: answered progress, numeric score, named risk band, short
  interpretation, privacy statement, and one primary next action.
- **Variants**: incomplete, urgent 0–3, build 4–7, ready 8–10.
- **Spacing**: `--space-8` panel padding; collapses actions to one column on
  mobile.
- **States**: incomplete is non-actionable; complete results expose a
  score-specific link.
- **Accessibility**: score and band are both text; the updating result uses a
  polite live region; progress exposes `aria-valuemin`, `aria-valuemax`, and
  `aria-valuenow`.
- **Motion**: none.

## 6. Motion & Interaction

| Type | Duration | Easing | Usage |
|---|---|---|---|
| Micro | 120ms | ease-out | Active press |
| Standard | 160ms | cubic-bezier(0.16, 1, 0.3, 1) | Hover and focus |
| Emphasis | none | n/a | No page-load animation |

- Only `transform`, `opacity`, and color change.
- There is no scroll-driven animation or automatic carousel.
- `prefers-reduced-motion: reduce` removes all transforms and transitions.

## 7. Depth & Surface

Strategy: ring borders plus tonal shift.

- Cards use a one-pixel semantic border, never a generic drop shadow.
- Hero media uses an inset ring and slight tonal separation.
- Buttons are pill-shaped. Media and panels use 16px radius. This is the
  documented mixed-radius rule.
- No backdrop blur or glass material is used.

## 8. Accessibility Constraints & Accepted Debt

### Constraints

- WCAG 2.2 AA minimum; body contrast target is 7:1 where practical.
- Every interactive element has a visible focus indicator and 44px target.
- Heading order is sequential and the main content has a skip target.
- Korean and English remain readable at 200% zoom.
- The page respects reduced motion, system color scheme, and browser zoom.
- Assessment controls collect only local yes/no answers. No name, email,
  repository, file, secret, or personal data is requested, stored, or sent.

### Inclusive Personas

- **Minji, small-business owner**: reads Korean first and needs a concrete
  price and deliverable without understanding GitHub.
- **Alex, engineering lead**: scans in English, checks technical evidence,
  exclusions, and verification approach.
- **Jisoo, low-vision keyboard user**: zooms to 200%, uses visible focus, and
  must reach every sample and inquiry link without horizontal scrolling.
- **Hyun, attention-limited mobile user**: needs one decision per section and
  plain-language privacy boundaries.

### Accepted Debt

None. Accessibility debt requires explicit owner acknowledgement and is not
accepted by default.
