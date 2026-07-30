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
  checkoutLinks,
} = require(path.join(root, "checkout-links.js"));

assert.equal(approvedCheckoutUrl(null), null);
assert.equal(approvedCheckoutUrl("http://payhip.com/example"), null);
assert.equal(approvedCheckoutUrl("https://payhip.com.evil.example/item"), null);
assert.equal(
  approvedCheckoutUrl("https://payhip.com/b/example"),
  "https://payhip.com/b/example",
);
assert.ok(Object.values(checkoutLinks).every((value) => value === null));

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
