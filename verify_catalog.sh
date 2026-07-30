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
[[ "${#issue_forms[@]}" -eq 5 ]]

for required in \
  README.md \
  DELIVERY.md \
  SAMPLES.md \
  robots.txt \
  sitemap.xml \
  c5b90a7f66e512329c156c654a6e0b79.txt \
  agents-md-audit-kit.html \
  ci-reliability-scorecard.html \
  ci-reliability-scorecard.mjs \
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
[[ "${#sitemap_urls[@]}" -eq 11 ]]
[[ "${sitemap_urls[(Ie)https://soul-sol.github.io/verified-automation-services/showcase.html]}" -eq 0 ]]

indexable_pages=(
  index.html
  agents-md-audit-kit.html
  ci-reliability-scorecard.html
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
rg -q 'github-actions-ci-triage-ebook.html' "$ROOT/index.html"
rg -q 'codex-agents-operations-handbook.html' "$ROOT/index.html"
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
rg -q 'USD 19' "$ROOT/github-actions-ci-triage-ebook.html"
rg -q 'downloads/github-actions-ci-triage-preview-ko.pdf' \
  "$ROOT/github-actions-ci-triage-ebook.html"
rg -Fq 'GitHub Actions CI Triage Ebook + templates' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'USD 19' "$ROOT/codex-agents-operations-handbook.html"
rg -q 'downloads/codex-agents-operations-preview-ko.pdf' \
  "$ROOT/codex-agents-operations-handbook.html"
rg -Fq 'Codex AGENTS.md Operations Handbook + templates' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'USD 9' "$ROOT/spreadsheet-preflight-ebook.html"
rg -q 'downloads/spreadsheet-preflight-preview-ko.pdf' \
  "$ROOT/spreadsheet-preflight-ebook.html"
rg -Fq 'Spreadsheet Preflight Ebook + CLI' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'USD 29' "$ROOT/go-cross-architecture-ci-kit.html"
rg -q 'samples/go-cross-architecture.yml' \
  "$ROOT/go-cross-architecture-ci-kit.html"
rg -Fq 'Go/Linux Cross-Architecture CI Starter Kit' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'USD 9' "$ROOT/agents-md-audit-kit.html"
rg -q 'https://github.com/soul-sol/agents-md-guide-ko' \
  "$ROOT/agents-md-audit-kit.html"
rg -Fq 'AGENTS.md Audit Kit + templates' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"
rg -q 'USD 49' "$ROOT/developer-reliability-bundle.html"
rg -q 'USD 85' "$ROOT/developer-reliability-bundle.html"
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
rg -q 'USD 29' "$ROOT/README.md"
rg -q 'AGENTS.md Audit Kit' "$ROOT/README.md"
rg -q 'GitHub does not process or escrow payment' "$ROOT/DELIVERY.md"
rg -q 'spreadsheet-audit.yml' "$ROOT/samples/spreadsheet-preflight-checklist.md"
rg -q 'ci-triage.yml' "$ROOT/samples/ci-first-15-minutes.md"
rg -q 'agent-skill.yml' "$ROOT/samples/agent-skill-acceptance-checklist.md"
rg -q 'go-cross-architecture-ci-kit.html' "$ROOT/SAMPLES.md"
rg -q 'exec-format-error-docker-arm64-fix.html' "$ROOT/SAMPLES.md"
rg -q 'github-actions-exit-code-137-oom-fix.html' "$ROOT/SAMPLES.md"
rg -q 'agents-md-audit-kit.html' "$ROOT/SAMPLES.md"
rg -q 'go test ./...' "$ROOT/samples/go-cross-architecture.yml"

print "service catalog verification: all checks passed"
