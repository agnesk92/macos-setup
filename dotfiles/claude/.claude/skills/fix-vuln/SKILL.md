---
name: fix-vuln
description: List a GitHub repo's open Dependabot security alerts, ask which one to fix, then apply and verify the fix. Use when the user says "fix a vuln", "security alerts", "dependabot", "fix vulnerability", or invokes /fix-vuln.
---

# Fix a repo security vulnerability

Guide the user from "show me the alerts" to a verified fix. Requires `gh` CLI authenticated.

## 1. Detect the repo

Get `owner/repo` from the git remote:

```bash
gh repo view --json nameWithOwner --jq .nameWithOwner
```

If it fails (not a repo / no `gh`), tell the user and stop.

## 2. List open alerts

```bash
gh api "/repos/{owner}/{repo}/dependabot/alerts?state=open&per_page=100" \
  --jq '.[] | {number, severity: .security_vulnerability.severity, pkg: .dependency.package.name, scope: .dependency.scope, created_at, summary: .security_advisory.summary, fixed_in: .security_vulnerability.first_patched_version.identifier}'
```

Show as a compact table ranked by severity (critical → high → medium → low). Columns: `#`, severity, package, scope (runtime/dev), **age**, summary, fixed-in version.

**Age** = today minus `created_at`, shown human-readable (e.g. "3d", "5w", "4mo"). Old high-severity alerts are the priority.

If zero open alerts, say so and stop.

## 3. Ask which to fix

Ask the user which alert number(s) to fix. **Wait for their answer** — do not pick for them. They may say one number, several, or "all criticals".

## 4. Identify the stack

Do NOT assume npm. Find how this repo manages dependencies, in this order:

1. **Repo instructions first** — check `CLAUDE.md`, `AGENTS.md`, `CONTRIBUTING.md`, `README.md`, `.github/` for a documented dependency/security-update process. If the repo says how to update deps, follow that.
2. **Manifest / lockfiles present** — infer the ecosystem:
   - Node: `package.json`, `package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`
   - Go: `go.mod`, `go.sum`
   - Python: `requirements*.txt`, `pyproject.toml`, `poetry.lock`, `Pipfile.lock`, `uv.lock`
   - Others: `Gemfile.lock`, `Cargo.lock`, `composer.lock`, `pom.xml`, `build.gradle` — handle analogously.
3. **Still unclear** — read the README / official project setup docs to learn the toolchain, then proceed.

The Dependabot alert's `.dependency.package.ecosystem` field also names the ecosystem — cross-check it.

## 5. Fix the chosen alert(s)

For each chosen alert, pull full detail:

```bash
gh api "/repos/{owner}/{repo}/dependabot/alerts/{number}"
```

Then, per the stack from step 4:

1. Find the vulnerable version(s) installed and compare against the alert's `vulnerable_version_range`. Only versions inside the range need fixing.
   - Node: inspect `package-lock.json` / lockfile for every copy of the package.
   - Go: `go list -m all | grep PKG`.
   - Python: check the lockfile / `pip show PKG`.
2. Apply the minimal fix to reach `first_patched_version`. **Prefer genuinely updating the dependency (and its parents) to a newer version over pinning/overriding** — pulling packages forward is usually the healthier fix than freezing a lone transitive version.
   - Node: try `npm update PKG` first (moves within allowed semver, updates the lockfile). If the vulnerable copy is pinned by an old parent, update the parent, or bump the direct dep in `package.json` and reinstall. Fall back to `overrides` only when a real update isn't possible.
   - Go: `go get PKG@FIXED && go mod tidy` (updates the module graph, not a pin).
   - Python: bump the fixed version in the manifest and regenerate the lockfile (`poetry lock`, `uv lock`, `pip-compile`, …).
   - Prefer targeted updates over blanket auto-fixes, but favor real version bumps over overrides.
3. Rebuild only if the dep ships in a built/bundled artifact (e.g. `dist/`). Dev-only deps (`scope: development`) usually don't need a rebuild.

## 6. Verify

- Confirm the vulnerable version is gone: re-run the version check from step 5.
- Run the project's install + build + tests to confirm nothing broke.
- Report: what changed, which files (lockfile, manifest, built artifacts), and whether a rebuild was needed.

## Guardrails

- Never auto-commit or push unless the user asks.
- Don't blanket-force upgrades (`npm audit fix --force` and similar) — they can bump majors and break things.
- Flag runtime vs dev scope clearly; runtime vulns matter more.
- If a fix requires a breaking major bump, surface that and ask before proceeding.
