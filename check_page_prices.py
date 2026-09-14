#!/usr/bin/env python3
"""구매 경로 요소가 그 페이지 자신의 가격을 말하는지 검사한다.

⛔ 왜 이게 따로 필요한가 (2026-09-15 실측): '폐기된 가격이 없다' 는 금지식은
   **살아 있는 다른 상품의 정가**를 잘못 붙인 것을 못 잡는다. 그리고 '자기 가격이
   페이지 어딘가에 있다' 는 단언도 못 잡는다 — 한 곳만 바꿔도 다른 곳의 정답이
   단언을 통과시키기 때문이다. 오늘 같은 형태로 두 번 속았다.

   그래서 **산문이 아니라 구매 경로 요소만** 본다: price-value 와 checkout 라벨.
   교차판매 문구($89 키트, 따로 사면 $176 등)는 여기 걸리지 않아야 정상이다.
"""
import re, sys, pathlib

# 페이지 → 그 페이지가 파는 상품의 가격 (products/prices.json 이 정본)
PAGES = {
    "solo-team-claude-code-orchestration.html": 49,
    "adversarial-review-prompt-pack.html": 39,
    "claude-md-pattern-library.html": 39,
    "agents-md-audit-kit.html": 39,
    "github-actions-ci-triage-ebook.html": 39,
    "go-cross-architecture-ci-kit.html": 39,
    "spreadsheet-preflight-ebook.html": 39,
}
AMOUNT = re.compile(r"(?:USD|\$)\s*(\d+)|(\d+)\s*달러")
PRICE_VALUE = re.compile(r'class="price-value"[^>]*>([^<]*)<')
CHECKOUT_LABEL = re.compile(r'data-checkout-label="([^"]*)"')

root = pathlib.Path(sys.argv[1] if len(sys.argv) > 1 else ".")
bad = []
for page, want in PAGES.items():
    f = root / page
    if not f.exists():
        bad.append(f"{page}: page is missing")
        continue
    text = f.read_text(encoding="utf-8")
    spots = [("price-value", m) for m in PRICE_VALUE.findall(text)]
    spots += [("checkout-label", m) for m in CHECKOUT_LABEL.findall(text)]
    seen = 0
    for kind, frag in spots:
        for a, b in AMOUNT.findall(frag):
            got = int(a or b)
            seen += 1
            if got != want:
                bad.append(f"{page}: {kind} says {got}, this product costs {want} — {frag.strip()[:60]}")
    if seen == 0:
        bad.append(f"{page}: no price stated on any buy-path element (price-value / checkout-label)")

if bad:
    print("Buy-path price mismatch:", file=sys.stderr)
    for b in bad:
        print("  " + b, file=sys.stderr)
    raise SystemExit(1)
print(f"buy-path prices ok on {len(PAGES)} pages")
