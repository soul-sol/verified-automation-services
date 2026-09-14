"use strict";

const assert = require("node:assert/strict");
const fs = require("node:fs");
const path = require("node:path");

const root = process.argv[2];
assert.ok(root, "catalog root is required");

const checkoutPages = [
  "agents-md-audit-kit.html",
  "codex-agents-operations-handbook.html",
  "developer-reliability-bundle.html",
  "github-actions-ci-triage-ebook.html",
  "go-cross-architecture-ci-kit.html",
  "spreadsheet-preflight-ebook.html",
];

for (const page of checkoutPages) {
  const html = fs.readFileSync(path.join(root, page), "utf8");
  assert.equal(
    (html.match(/data-checkout-product=/g) || []).length,
    3,
    `${page}: expected three checkout markers`,
  );
  assert.equal(
    (html.match(/src="checkout-links\.js"/g) || []).length,
    1,
    `${page}: expected one checkout script`,
  );
  assert.match(
    html,
    /github\.com\/soul-sol\/verified-automation-services\/issues\/new/,
    `${page}: inquiry fallback is required`,
  );
}

const {
  activateCheckoutLink,
  approvedCheckoutUrl,
  taggedCheckoutUrl,
  checkoutLinks,
} = require(path.join(root, "checkout-links.js"));

assert.equal(approvedCheckoutUrl(null), null);
assert.equal(approvedCheckoutUrl("http://payhip.com/example"), null);
assert.equal(approvedCheckoutUrl("https://payhip.com.evil.example/item"), null);
assert.equal(
  approvedCheckoutUrl("https://payhip.com/b/example"),
  "https://payhip.com/b/example",
);
// ⛔ 2026-09-15: 이 단언은 "아직 아무것도 살 수 없다" 던 시점에 쓰였고, 제품이 실제로 올라간 뒤에도
// 그대로 남아 검증 전체를 **항상 실패**시키고 있었다. 게이트가 항상 실패하면 아무도 돌리지 않게 되고,
// 그러면 없는 것과 같다. 지금 지켜야 할 불변식으로 바꾼다.
{
  const live = Object.entries(checkoutLinks).filter(([, v]) => v !== null);
  // ① 살아 있는 링크는 전부 허용 호스트의 https 여야 한다(하나라도 아니면 그 페이지의 구매 버튼이 죽는다).
  for (const [product, url] of live) {
    assert.ok(
      approvedCheckoutUrl(url),
      `${product}: checkout URL is not an approved https host: ${url}`,
    );
  }
  // ② 아직 판매하지 않는 제품은 null 이어야 한다 — 값을 지어내면 없는 상품을 파는 페이지가 된다.
  for (const product of ["codex-agents-operations-handbook", "developer-reliability-bundle"]) {
    assert.strictEqual(
      checkoutLinks[product],
      null,
      `${product}: not on sale, so its checkout link must stay null`,
    );
  }
  // ③ 태깅이 붙고도 허용 판정을 통과해야 한다 — 붙이는 순간 거부되면 클릭이 문의 폼으로 떨어진다.
  for (const [product, url] of live) {
    const tagged = taggedCheckoutUrl(url, product);
    assert.ok(tagged.includes(`utm_campaign=${product}`), `${product}: utm_campaign missing`);
    assert.ok(approvedCheckoutUrl(tagged), `${product}: tagged URL rejected by the allowlist`);
  }
  assert.ok(live.length > 0, "no live checkout links at all — that cannot be right");
}

const fallback = {
  dataset: {checkoutLabel: "전자책 바로 구매"},
  href: "https://github.com/example/inquiry",
  textContent: "구매 문의",
};
assert.equal(activateCheckoutLink(fallback, null), false);
assert.equal(fallback.href, "https://github.com/example/inquiry");
assert.equal(fallback.textContent, "구매 문의");

assert.equal(
  activateCheckoutLink(fallback, "https://payhip.com/b/example"),
  true,
);
assert.equal(fallback.href, "https://payhip.com/b/example");
assert.equal(fallback.textContent, "전자책 바로 구매");
assert.equal(fallback.dataset.checkoutActive, "true");
