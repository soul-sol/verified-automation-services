# Primitive showcase QA

## Evidence

- Page: `showcase.html`
- Captures: `output/playwright/showcase/mobile.png`, `tablet.png`, `desktop.png`
- Viewports: 375×900, 768×1000, 1280×900
- Browser: Chrome through Playwright CLI
- Console: 0 errors, 0 warnings
- Geometry: `scrollWidth === clientWidth` at all three widths
- Keyboard: first Tab focuses the skip link
- Disabled state: native disabled button exposed by `:disabled`

## Review response

- Added Korean-aware `word-break: keep-all` with emergency overflow wrapping.
- Added standard, kit, and unavailable service variants.
- Added spreadsheet, CI, Agent Skill, and Go sample variants plus empty/error states.
- Added privacy, empty, and error notice variants.
- Removed the backdrop blur so the shared CSS matches `DESIGN.md`.
