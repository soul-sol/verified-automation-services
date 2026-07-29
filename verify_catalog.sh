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
  github-actions-ci-triage-ebook.html \
  downloads/github-actions-ci-triage-preview-ko.pdf \
  assets/ci-triage-ebook-spread.webp \
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
rg -q 'digital-kit.yml' "$ROOT/index.html"
rg -q 'github-actions-ci-triage-ebook.html' "$ROOT/index.html"
rg -q 'USD 19' "$ROOT/github-actions-ci-triage-ebook.html"
rg -q 'downloads/github-actions-ci-triage-preview-ko.pdf' \
  "$ROOT/github-actions-ci-triage-ebook.html"
rg -Fq 'GitHub Actions CI Triage Ebook + templates' \
  "$ROOT/.github/ISSUE_TEMPLATE/digital-kit.yml"

if rg -n '—|biz\.lifestep@gmail\.com|skilly12@gmail\.com|vbn1477@gmail\.com' \
  "$ROOT/index.html" "$ROOT/styles.css"; then
  echo "Landing page contains a banned dash or private email." >&2
  exit 1
fi
rg -q 'USD 29' "$ROOT/README.md"
rg -q 'GitHub does not process or escrow payment' "$ROOT/DELIVERY.md"
rg -q 'spreadsheet-audit.yml' "$ROOT/samples/spreadsheet-preflight-checklist.md"
rg -q 'ci-triage.yml' "$ROOT/samples/ci-first-15-minutes.md"
rg -q 'agent-skill.yml' "$ROOT/samples/agent-skill-acceptance-checklist.md"
rg -q 'digital-kit.yml' "$ROOT/SAMPLES.md"
rg -q 'go test ./...' "$ROOT/samples/go-cross-architecture.yml"

print "service catalog verification: all checks passed"
