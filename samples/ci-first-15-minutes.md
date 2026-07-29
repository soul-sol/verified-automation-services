# GitHub Actions: The First 15 Minutes

The fastest useful CI diagnosis starts by classifying the failure before
editing YAML.

## Minute 0–5: capture the failing boundary

1. Save the workflow run URL, job name, step name, runner OS, and commit SHA.
2. Find the first meaningful error, not the final `exit code 1`.
3. Determine whether the same command fails locally in a clean checkout.
4. Check whether the failure is code, test, toolchain, dependency, permission,
   secret, quota, runner capacity, or an external service.

## Minute 5–10: compare the environment

- Runtime and package-manager versions
- Lockfile and cache keys
- Working directory and shell
- Matrix values and excluded combinations
- Environment variables by name only; never print secret values
- Changed action versions, runner images, or dependency indexes

## Minute 10–15: choose the smallest proof

- Re-run only the failing command with the same versions.
- If a matrix entry fails, compare it with one passing entry.
- If a cache is suspect, test once without restoring it.
- If permissions are suspect, inspect declared workflow permissions.
- Write a one-sentence hypothesis and the observation that would disprove it.

Do not rotate secrets, change billing, broaden permissions, or disable tests as
a diagnostic shortcut.

If the failure remains reproducible but the code-fixable cause is unclear,
[request CI diagnosis](https://github.com/soul-sol/verified-automation-services/issues/new?template=ci-triage.yml).
