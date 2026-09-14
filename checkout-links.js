(() => {
  "use strict";

  const checkoutLinks = Object.freeze({
    "adversarial-review-prompt-pack": "https://lifestep1.gumroad.com/l/adversarial-review-prompt-pack",
    "claude-md-pattern-library": "https://lifestep1.gumroad.com/l/claude-md-pattern-library",
    "agents-md-audit-kit": "https://lifestep1.gumroad.com/l/agents-md-audit-kit",
    "codex-agents-operations-handbook": null,
    "developer-reliability-bundle": null,
    "github-actions-ci-triage-ebook": "https://lifestep1.gumroad.com/l/github-actions-ci-failure-triage-kit",
    "go-cross-architecture-ci-kit": "https://lifestep1.gumroad.com/l/go-linux-cross-architecture-ci-starter-kit",
    "solo-team-claude-code-orchestration": "https://lifestep1.gumroad.com/l/solo-team-claude-code-orchestration",
    "spreadsheet-preflight-ebook": "https://lifestep1.gumroad.com/l/spreadsheet-structural-preflight-guide",
  });

  const approvedHosts = Object.freeze([
    "gumroad.com",
    "ko-fi.com",
    "payhip.com",
    "paypal.com",
    "www.paypal.com",
  ]);

  // ⛔ 2026-09-15: 이 링크들엔 UTM 이 없어서, 이 카탈로그 36개 페이지에서 스토어로 간 클릭이
  // Gumroad UTM 대시보드에 **한 건도 잡히지 않았다.** 채널이 작동하는지 아닌지를 구별할 수 없었다는
  // 뜻이고, 그건 "클릭 0" 과 "측정 안 됨" 을 같은 모양으로 만든다.
  // 태그는 여기 한 곳에서만 붙인다 — 페이지마다 손으로 붙이면 반드시 빠지는 페이지가 생긴다.
  function taggedCheckoutUrl(value, product) {
    if (typeof value !== "string" || value.trim() === "" || !product) {
      return value;
    }
    try {
      const url = new URL(value);
      if (url.searchParams.has("utm_source")) {
        return url.href;
      }
      url.searchParams.set("utm_source", "catalog");
      url.searchParams.set("utm_medium", "page");
      url.searchParams.set("utm_campaign", product);
      return url.href;
    } catch {
      return value;
    }
  }

  function approvedCheckoutUrl(value) {
    if (typeof value !== "string" || value.trim() === "") {
      return null;
    }

    try {
      const url = new URL(value);
      const hostname = url.hostname.toLowerCase();
      const approved = approvedHosts.some(
        (host) => hostname === host || hostname.endsWith(`.${host}`),
      );

      return url.protocol === "https:" && approved ? url.href : null;
    } catch {
      return null;
    }
  }

  function activateCheckoutLink(action, value) {
    const checkoutUrl = approvedCheckoutUrl(value);
    if (!checkoutUrl) {
      return false;
    }

    action.href = checkoutUrl;
    action.dataset.checkoutActive = "true";

    if (action.dataset.checkoutLabel) {
      action.textContent = action.dataset.checkoutLabel;
    }

    return true;
  }

  function activateCheckoutLinks(root = document) {
    root.querySelectorAll("[data-checkout-product]").forEach((action) => {
      const product = action.dataset.checkoutProduct;
      activateCheckoutLink(action, taggedCheckoutUrl(checkoutLinks[product], product));
    });
  }

  if (typeof module !== "undefined" && module.exports) {
    module.exports = {
      activateCheckoutLink,
      activateCheckoutLinks,
      approvedCheckoutUrl,
      taggedCheckoutUrl,
      checkoutLinks,
    };
  }

  if (typeof document !== "undefined") {
    if (document.readyState === "loading") {
      document.addEventListener(
        "DOMContentLoaded",
        () => activateCheckoutLinks(),
        {once: true},
      );
    } else {
      activateCheckoutLinks();
    }
  }
})();
