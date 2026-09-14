#!/bin/zsh
set -euo pipefail

ROOT="${0:A:h}"

ruby -e '
  require "yaml"
  Dir[File.join(ARGV[0], ".github/ISSUE_TEMPLATE/*.yml")].sort.each do |path|
    data = YAML.safe_load(File.read(path), permitted_classes: [], aliases: false)
    next if File.basename(path) == "config.yml"
    raise "#{path}: missing name" unless data["name"].is_a?(String)
    raise "#{path}: missing body" unless data["body"].is_a?(Array)
    ids = data["body"].map { |entry| entry["id"] }.compact
    raise "#{path}: duplicate field id" unless ids.uniq.length == ids.length
  end
' "$ROOT"

issue_forms=("$ROOT"/.github/ISSUE_TEMPLATE/*.yml)
[[ "${#issue_forms[@]}" -eq 6 ]]

for required in \
  README.md \
  SUPPORT.md \
  DELIVERY.md \
  SAMPLES.md \
  robots.txt \
  sitemap.xml \
  checkout-links.js \
  verify_checkout.js \
  c5b90a7f66e512329c156c654a6e0b79.txt \
  agents-md-audit-kit.html \
  ci-reliability-scorecard.html \
  ci-reliability-scorecard.mjs \
  codex-agents-md-loading-troubleshooting.html \
  codex-agents-operations-handbook.html \
  developer-reliability-bundle.html \
  exec-format-error-docker-arm64-fix.html \
  github-actions-ci-triage-ebook.html \
  github-actions-exit-code-137-oom-fix.html \
  go-cross-architecture-ci-kit.html \
  spreadsheet-preflight-ebook.html \
  spreadsheet-integrity-scorecard.html \
  spreadsheet-integrity-scorecard.mjs \
  downloads/github-actions-ci-triage-preview-ko.pdf \
  downloads/codex-agents-operations-preview-ko.pdf \
  downloads/spreadsheet-preflight-preview-ko.pdf \
  assets/codex-agents-operations-spread.webp \
  assets/ci-triage-ebook-spread.webp \
  assets/spreadsheet-preflight-ebook-spread.webp \
  samples/spreadsheet-preflight-checklist.md \
  samples/ci-first-15-minutes.md \
  samples/agent-skill-acceptance-checklist.md \
  samples/go-cross-architecture.yml; do
  [[ -s "$ROOT/$required" ]]
done

/usr/bin/xmllint --noout "$ROOT/sitemap.xml"
rg -Fq \
  'Sitemap: https://soul-sol.github.io/verified-automation-services/sitemap.xml' \
  "$ROOT/robots.txt"
[[ "$(< "$ROOT/c5b90a7f66e512329c156c654a6e0b79.txt")" == \
  "c5b90a7f66e512329c156c654a6e0b79" ]]

sitemap_urls=(
  "${(@f)$(/usr/bin/xmllint \
    --xpath '//*[local-name()="loc"]/text()' \
    "$ROOT/sitemap.xml" 2>/dev/null)}"
)
# ⛔ 이 수는 "사이트맵이 내가 아는 상태 그대로인가"를 지키는 값이다. 페이지를 의도적으로
# 추가·삭제했을 때만 함께 고쳐라. 2026-09-15: 12 로 박혀 있어 실제 36 과 어긋나 게이트가
# **항상 실패**했다 — 가격 정정 이전부터 그랬고, 그래서 아무도 이 스크립트로 검증할 수 없었다.
[[ "${#sitemap_urls[@]}" -eq 36 ]]
[[ "${sitemap_urls[(Ie)https://soul-sol.github.io/verified-automation-services/showcase.html]}" -eq 0 ]]

indexable_pages=(
  index.html
  agents-md-audit-kit.html
  ci-reliability-scorecard.html
  codex-agents-md-loading-troubleshooting.html
  codex-agents-operations-handbook.html
  developer-reliability-bundle.html
  exec-format-error-docker-arm64-fix.html
  github-actions-ci-triage-ebook.html
  github-actions-exit-code-137-oom-fix.html
  go-cross-architecture-ci-kit.html
  spreadsheet-integrity-scorecard.html
  spreadsheet-preflight-ebook.html
)
for page in "${indexable_pages[@]}"; do
  if [[ "$page" == "index.html" ]]; then
    canonical="https://soul-sol.github.io/verified-automation-services/"
  else
    canonical="https://soul-sol.github.io/verified-automation-services/$page"
  fi
  rg -Fq "href=\"$canonical\"" "$ROOT/$page"
  [[ "${sitemap_urls[(Ie)$canonical]}" -gt 0 ]]
done
rg -Fq '<meta name="robots" content="noindex">' "$ROOT/showcase.html"

if rg -n \
  'biz\.lifestep@gmail\.com|lim@video-wheel-control\.com|BEGIN .*PRIVATE KEY|gho_[A-Za-z0-9]+' \
  "$ROOT" \
  --glob '!verify_catalog.sh'; then
  print -u2 "private contact or credential-like material found"
  exit 1
fi

rg -q 'KRW 49,000' "$ROOT/README.md"
rg -q 'KRW 149,000' "$ROOT/README.md"
rg -q 'KRW 299,000' "$ROOT/README.md"

test -f "$ROOT/index.html"
test -f "$ROOT/styles.css"
test -f "$ROOT/DESIGN.md"
test -f "$ROOT/assets/deliverables-wall.webp"
test -f "$ROOT/design-reference/selected-concept.webp"

rg -q '무료 샘플로 먼저 확인하세요' "$ROOT/index.html"
rg -q '49,000원부터' "$ROOT/index.html"
rg -q '79,000원부터' "$ROOT/index.html"
rg -q '99,000원부터' "$ROOT/index.html"
rg -q 'issues/new/choose' "$ROOT/index.html"
rg -q 'spreadsheet-audit.yml' "$ROOT/index.html"
rg -q 'ci-triage.yml' "$ROOT/index.html"
rg -q 'agent-skill.yml' "$ROOT/index.html"
rg -q 'digital-kit.yml' "$ROOT/github-actions-ci-triage-ebook.html"
rg -q 'digital-kit.yml' "$ROOT/codex-agents-operations-handbook.html"
rg -q 'digital-kit.yml' "$ROOT/go-cross-architecture-ci-kit.html"
rg -q 'digital-kit.yml' "$ROOT/spreadsheet-preflight-ebook.html"
node --check "$ROOT/checkout-links.js"
node --check "$ROOT/verify_checkout.js"
node "$ROOT/verify_checkout.js" "$ROOT"
rg -q 'github-actions-ci-triage-ebook.html' "$ROOT/index.html"
rg -q 'codex-agents-operations-handbook.html' "$ROOT/index.html"
rg -q 'codex-agents-md-loading-troubleshooting.html' "$ROOT/index.html"
rg -q 'project_doc_max_bytes' \
  "$ROOT/codex-agents-md-loading-troubleshooting.html"
rg -q 'AGENTS.override.md' \
  "$ROOT/codex-agents-md-loading-troubleshooting.html"
rg -q 'learn.chatgpt.com/docs/agent-configuration/agents-md.md' \
  "$ROOT/codex-agents-md-loading-troubleshooting.html"
rg -q '"@type": "BlogPosting"' \
  "$ROOT/codex-agents-md-loading-troubleshooting.html"
rg -q 'github-actions-exit-code-137-oom-fix.html' "$ROOT/index.html"
rg -q 'State.OOMKilled' "$ROOT/github-actions-exit-code-137-oom-fix.html"
rg -q 'memory.events' "$ROOT/github-actions-exit-code-137-oom-fix.html"
rg -q 'github-actions-ci-triage-ebook.html' \
  "$ROOT/github-actions-exit-code-137-oom-fix.html"
rg -q '"@type": "BlogPosting"' \
  "$ROOT/github-actions-exit-code-137-oom-fix.html"
rg -q 'docs.github.com/en/actions/reference/runners/github-hosted-runners' \
  "$ROOT/github-actions-exit-code-137-oom-fix.html"
rg -q 'go-cross-architecture-ci-kit.html' "$ROOT/index.html"
rg -q 'spreadsheet-preflight-ebook.html' "$ROOT/index.html"
rg -q 'agents-md-audit-kit.html' "$ROOT/index.html"
rg -q 'ci-reliability-scorecard.html' "$ROOT/index.html"
rg -q 'spreadsheet-integrity-scorecard.html' "$ROOT/index.html"
rg -q 'developer-reliability-bundle.html' "$ROOT/index.html"
rg -q 'exec-format-error-docker-arm64-fix.html' "$ROOT/index.html"
rg -q 'go-exec-format-doctor' "$ROOT/exec-format-error-docker-arm64-fix.html"
rg -q 'go-cross-architecture-ci-kit.html' "$ROOT/exec-format-error-docker-arm64-fix.html"
rg -q '"@type": "BlogPosting"' "$ROOT/exec-format-error-docker-arm64-fix.html"
rg -q 'docs.docker.com/build/building/multi-platform' \
  "$ROOT/exec-format-error-docker-arm64-fix.html"
rg -q '10개 질문' "$ROOT/ci-reliability-scorecard.html"
rg -q 'data-scorecard' "$ROOT/ci-reliability-scorecard.html"
rg -q '답변은 저장하거나 전송하지 않습니다' \
  "$ROOT/ci-reliability-scorecard.html"
node "$ROOT/test_scorecard.mjs" >/dev/null
rg -q '10개 질문' "$ROOT/spreadsheet-integrity-scorecard.html"
rg -q 'data-scorecard' "$ROOT/spreadsheet-integrity-scorecard.html"
rg -q '답변과 워크북은 저장하거나 전송하지 않습니다' \
  "$ROOT/spreadsheet-integrity-scorecard.html"
node "$ROOT/test_spreadsheet_scorecard.mjs" >/dev/null
rg -q 'USD 39' "$ROOT/github-actions-ci-triage-ebook.html"
rg -q 'downloads/github-actions-ci-triage-preview-ko.pdf' \
  "$ROOT/github-actions-ci-triage-ebook.html"
rg -Fq 'GitHub Actions CI Triage Ebook + templates' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'USD 19' "$ROOT/codex-agents-operations-handbook.html"
rg -q 'downloads/codex-agents-operations-preview-ko.pdf' \
  "$ROOT/codex-agents-operations-handbook.html"
rg -Fq 'Codex AGENTS.md Operations Handbook + templates' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'USD 39' "$ROOT/spreadsheet-preflight-ebook.html"
rg -q 'downloads/spreadsheet-preflight-preview-ko.pdf' \
  "$ROOT/spreadsheet-preflight-ebook.html"
rg -Fq 'Spreadsheet Preflight Ebook + CLI' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'USD 39' "$ROOT/go-cross-architecture-ci-kit.html"
rg -q 'samples/go-cross-architecture.yml' \
  "$ROOT/go-cross-architecture-ci-kit.html"
rg -Fq 'Go/Linux Cross-Architecture CI Starter Kit' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'USD 39' "$ROOT/agents-md-audit-kit.html"
rg -q 'https://github.com/soul-sol/agents-md-guide-ko' \
  "$ROOT/agents-md-audit-kit.html"
rg -Fq 'AGENTS.md Audit Kit + templates' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'USD 49' "$ROOT/developer-reliability-bundle.html"
# ⛔ 2026-09-15 제거: 이 줄은 'USD 85' 가 **있어야 통과** 시켰다. 그런데 85 는 틀린 합계다 —
# 라이브 구성품 네 개만 39×4=156 이고, 나머지 하나(OSS)는 확정 가격이 없다. 게이트가 오류를 못 잡은 게
# 아니라 **오류의 존재를 요구하고 있었다.** 검증 불가능한 합계는 게이트로 고정하지 말고 문서에서 뺀다.
rg -Fq 'Developer Reliability Bundle — USD 49' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'developer-reliability-bundle-v1.0.0' \
  "$ROOT/developer-reliability-bundle.html"

if rg -n \
  'spreadsheet-preflight-bundle|audit_workbook\.py|PRODUCT_MANIFEST\.md' \
  "$ROOT/downloads"; then
  echo "Paid spreadsheet product files must not be public." >&2
  exit 1
fi

if rg -n \
  'go-linux-cross-arch-ci-starter-kit|runtime_matrix\.sh|cross_compile\.sh' \
  "$ROOT/downloads"; then
  echo "Paid Go CI product files must not be public." >&2
  exit 1
fi

if rg -n \
  'agents-md-audit-kit-v|audit_agents\.py|src/agents_md_audit' \
  "$ROOT/downloads"; then
  echo "Paid AGENTS.md Audit Kit files must not be public." >&2
  exit 1
fi

if rg -n '—|biz\.lifestep@gmail\.com|skilly12@gmail\.com|vbn1477@gmail\.com' \
  "$ROOT/index.html" "$ROOT/styles.css"; then
  echo "Landing page contains a banned dash or private email." >&2
  exit 1
fi
# ⛔ "USD 39 가 어딘가에 있다" 는 단언은 **부분 회귀를 못 잡는다** — 한 줄만 옛 가격으로 되돌려도
# 다른 줄의 39 때문에 통과한다(2026-09-15 실측: 거짓 케이스가 rc=0 으로 빠져나갔다).
# 지킬 수 있는 형태는 "폐기된 가격이 하나도 없다" 쪽이다. 7·9·14·29 는 지금 어떤 상품의 가격도 아니다.
# (19 는 비라이브 문의 상품이 아직 쓰고 있고, 49·89·176·5 는 현행가라 제외한다.)
if rg -n --glob '!node_modules' --glob '!verify_catalog.sh' '(USD|\$)[[:space:]\xc2\xa0]*(7|9|14|29)\b|(^|[^0-9])(7|9|14|29)[[:space:]\xc2\xa0]*dollars?\b' "$ROOT"; then
  echo "Catalog still advertises a retired price (7/9/14/29). Fix it or update products/prices.json." >&2
  exit 1
fi
# ⛔ 2026-09-15: 위 패턴은 영문·기호 표기만 본다. 이 카탈로그는 한국어 페이지라 가격이 한글로도
# 쓰여 있었고, 그래서 라이브 구매 버튼 라벨이 낡은 가격인 채로 배포됐다(실측).
# 같은 값을 두 가지 표기로 쓰는 문서에서는 한쪽만 막는 게이트가 통과 도장을 찍어 준다.
# (비라이브 문의 상품 Codex Handbook 이 쓰는 값은 제외한다 — digital-kit.yml 과 일치.)
# ⛔ 앞쪽 경계 [^0-9] 를 빼지 마라: 그게 없으면 '39달러' 안의 '9달러' 에 걸려 **정상 상태에서 항상 실패**한다(실측).
if rg -n --glob '!node_modules' --glob '!verify_catalog.sh' '(^|[^0-9])(7|9|14|29)[[:space:]\xc2\xa0]*달러' "$ROOT"; then
  echo "Catalog still advertises a retired price in Korean (7/9/14/29 달러)." >&2
  exit 1
fi
rg -q 'USD 39' "$ROOT/README.md"
rg -q 'AGENTS.md Audit Kit' "$ROOT/README.md"
rg -q 'GitHub does not process or escrow payment' "$ROOT/DELIVERY.md"
rg -q 'spreadsheet-audit.yml' "$ROOT/samples/spreadsheet-preflight-checklist.md"
rg -q 'ci-triage.yml' "$ROOT/samples/ci-first-15-minutes.md"
rg -q 'agent-skill.yml' "$ROOT/samples/agent-skill-acceptance-checklist.md"
rg -q 'go-cross-architecture-ci-kit.html' "$ROOT/SAMPLES.md"
rg -q 'exec-format-error-docker-arm64-fix.html' "$ROOT/SAMPLES.md"
rg -q 'github-actions-exit-code-137-oom-fix.html' "$ROOT/SAMPLES.md"
rg -q 'codex-agents-md-loading-troubleshooting.html' "$ROOT/SAMPLES.md"
rg -q 'agents-md-audit-kit.html' "$ROOT/SAMPLES.md"
rg -q 'go test ./...' "$ROOT/samples/go-cross-architecture.yml"


python3 "$ROOT/check_page_prices.py" "$ROOT"

print "service catalog verification: all checks passed"
