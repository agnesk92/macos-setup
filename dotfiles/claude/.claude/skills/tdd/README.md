# TDD Skill for Claude Code

Source: https://github.com/mfranzon/tdd

A Claude Code skill that guides you through strict **Test-Driven Development** using Red-Green-Refactor cycles.

## Usage

```
/tdd path/to/plan.md
/tdd "add user authentication with JWT and refresh tokens"
```

Provide either a markdown plan file or an inline description of the feature you want to build. The skill will break it into small, testable increments and walk you through TDD for each one.

## How It Works

### 1. Setup

- Reads your plan/feature file
- Detects your language and test framework (Python/pytest, TypeScript/vitest, Go/testing)
- Decomposes the feature into small increments
- Presents the increment list for your approval

### 2. TDD Loop (per increment)

| Phase        | What happens                                                                                                  |
| ------------ | ------------------------------------------------------------------------------------------------------------- |
| **RED**      | Writes a failing test directly to the real test file, runs it to confirm failure, then pauses for your review |
| **GREEN**    | Writes minimal code directly to the real source file, runs the full suite — continues automatically if green  |
| **REFACTOR** | Applies improvements directly, re-runs tests — continues automatically if green                               |

The skill pauses only when your input is needed: after RED (to review the test) and when something goes wrong. Everything else flows automatically.

### 3. Wrap-up

- Summarizes what was built (increments, tests, final status)
- Suggests remaining work (edge cases, integration tests, docs)

## Supported Languages

| Language   | Test Framework   | Runner                  |
| ---------- | ---------------- | ----------------------- |
| Python     | pytest           | `python -m pytest -xvs` |
| TypeScript | vitest           | `npx vitest run`        |
| Go         | testing (stdlib) | `go test -v ./...`      |

## Key Principles

- **Writes directly to real files** — no temp files, no manual moving. You have git for undo.
- **Pauses only when needed** — after RED confirmation and on errors. No unnecessary interruptions.
- **One behavior per test** — tests stay focused and readable
- **Simplest case first** — degenerate/edge cases before the general case
- **Full suite on green** — all tests run at every green/refactor step

## Installation

Copy this directory to `~/.claude/skills/tdd/` (or wherever your Claude Code skills live). The skill is available as `/tdd` in any Claude Code session.
