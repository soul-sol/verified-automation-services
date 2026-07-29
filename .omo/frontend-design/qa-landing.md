# Landing page QA

Last refreshed: 2026-07-29 15:29 KST, after the GitHub-login disclosure,
rendered sample-link update, dark contrast fix, semantic desktop hero wrap,
and illustration disclosure.

## Scope

- Page: `index.html`
- Browser: Chrome through Playwright CLI
- Viewports: 375×900, 768×1000, 1280×900
- Color preferences: light and dark
- Reduced motion: verified through browser media emulation

## Evidence

- Captures: `output/playwright/landing/mobile.png`, `tablet.png`, `desktop.png`,
  and `mobile-dark.png`
- Console: 0 errors, 0 warnings
- Geometry: `scrollWidth === clientWidth` at all three widths
- Mobile minimum visible link height: 44px
- Images: all five loaded with natural width 1200px
- Keyboard: first Tab focuses the skip link; `#main` is programmatically
  focusable
- Dark tokens: dark media query matched with body colors
  `rgb(17, 19, 15)` and `rgb(244, 247, 240)`
- Dark journey numbers resolve to `rgb(168, 239, 124)`.
- Desktop hero resolves to two lines: 157px measured height with 78.4px line
  height.
- Reduced motion media query matched
- Local HTML, fragment, stylesheet, image, and four sample asset checks passed
- `verify_catalog.sh` and `git diff --check` passed
- Sample cards open GitHub-rendered documents. The first three documents end
  with their matching inquiry CTA; the Go card opens the rendered sample index
  where the matching kit inquiry is adjacent.
- The single static HTML and shared CSS intentionally carry `SIZE_OK` markers:
  splitting them would add navigation or build complexity without reducing the
  public no-JavaScript surface.

## Remaining release gates

- Exact source commit and push
- GitHub Pages HTTP 200
- Production Lighthouse mobile and desktop

## Independent visual QA

- Pass A: PASS, high confidence. Responsive hierarchy, CJK wrapping,
  illustration disclosure, sample rendering, and token-driven DOM verified.
- Pass B: PASS, high confidence. Contrast, 44px targets, dark/reduced motion,
  privacy warning, login disclosure, and buyer journey verified.
- Blocking findings: none.
