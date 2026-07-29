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
rg -q 'USD 29' "$ROOT/README.md"
rg -q 'GitHub does not process or escrow payment' "$ROOT/DELIVERY.md"
rg -q 'spreadsheet-audit.yml' "$ROOT/samples/spreadsheet-preflight-checklist.md"
rg -q 'ci-triage.yml' "$ROOT/samples/ci-first-15-minutes.md"
rg -q 'agent-skill.yml' "$ROOT/samples/agent-skill-acceptance-checklist.md"
rg -q 'digital-kit.yml' "$ROOT/SAMPLES.md"
rg -q 'go test ./...' "$ROOT/samples/go-cross-architecture.yml"

print "service catalog verification: 24 checks passed"
