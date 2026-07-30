(() => {
  "use strict";

  const checkoutLinks = Object.freeze({
    "agents-md-audit-kit": null,
    "codex-agents-operations-handbook": null,
    "developer-reliability-bundle": null,
    "github-actions-ci-triage-ebook": null,
    "go-cross-architecture-ci-kit": null,
    "spreadsheet-preflight-ebook": null,
  });

  const approvedHosts = Object.freeze([
    "gumroad.com",
    "ko-fi.com",
    "payhip.com",
    "paypal.com",
    "www.paypal.com",
  ]);

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
      activateCheckoutLink(action, checkoutLinks[product]);
    });
  }

  if (typeof module !== "undefined" && module.exports) {
    module.exports = {
      activateCheckoutLink,
      activateCheckoutLinks,
      approvedCheckoutUrl,
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
