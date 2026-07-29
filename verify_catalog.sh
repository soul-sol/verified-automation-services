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
  agents-md-audit-kit.html \
  github-actions-ci-triage-ebook.html \
  go-cross-architecture-ci-kit.html \
  spreadsheet-preflight-ebook.html \
  downloads/github-actions-ci-triage-preview-ko.pdf \
  downloads/spreadsheet-preflight-preview-ko.pdf \
  assets/ci-triage-ebook-spread.webp \
  assets/spreadsheet-preflight-ebook-spread.webp \
  samples/spreadsheet-preflight-checklist.md \
  samples/ci-first-15-minutes.md \
  samples/agent-skill-acceptance-checklist.md \
  samples/go-cross-architecture.yml; do
  [[ -s "$ROOT/$required" ]]
done

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
rg -q 'digital-kit.yml' "$ROOT/go-cross-architecture-ci-kit.html"
rg -q 'digital-kit.yml' "$ROOT/spreadsheet-preflight-ebook.html"
rg -q 'github-actions-ci-triage-ebook.html' "$ROOT/index.html"
rg -q 'go-cross-architecture-ci-kit.html' "$ROOT/index.html"
rg -q 'spreadsheet-preflight-ebook.html' "$ROOT/index.html"
rg -q 'agents-md-audit-kit.html' "$ROOT/index.html"
rg -q 'USD 19' "$ROOT/github-actions-ci-triage-ebook.html"
rg -q 'downloads/github-actions-ci-triage-preview-ko.pdf' \
  "$ROOT/github-actions-ci-triage-ebook.html"
rg -Fq 'GitHub Actions CI Triage Ebook + templates' \
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
rg -q 'agents-md-audit-kit.html' "$ROOT/SAMPLES.md"
rg -q 'go test ./...' "$ROOT/samples/go-cross-architecture.yml"

print "service catalog verification: all checks passed"
