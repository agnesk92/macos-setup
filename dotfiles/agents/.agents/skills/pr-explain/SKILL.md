---
name: pr-explain
description: Read a GitHub PR and explain it so the user understands it, without checking it out or posting anything. Gives a layered brief (why, what, how it flows, what changed in behaviour, what's tested, what to watch), then answers follow-up questions with file:line evidence. Pulls context from linked GitHub and Linear issues. Use when the user says "explain PR", "what does this PR do", "help me understand this PR", "walk me through", "pr-explain", pastes a PR URL asking to understand it, or invokes /pr-explain. For leaving review comments, use pr-review instead.
allowed-tools:
  - Bash(~/.claude/skills/pr-explain/fetch.sh:*)
  - Bash(git rev-parse:*)
  - Bash(git status:*)
  - Bash(git diff:*)
  - Bash(git show:*)
  - Bash(git log:*)
  - mcp__linear-server__get_issue
  - mcp__linear-server__list_comments
---

# PR explain

Goal: the user understands the PR well enough to discuss it, review it, or build on it. Comprehension, not judgement. Read-only end to end.

Argument, one of:

- a PR URL (`https://github.com/owner/repo/pull/123`) or `owner/repo#123`
- a bare number: resolve the repo with `fetch.sh current-repo`
- nothing: the PR for the checked-out branch, via `fetch.sh meta` with no argument

Optional focus after the PR, e.g. `/pr-explain 412 the retry logic`. With a focus, still do steps 1–2, but keep the brief short and spend the depth on the focus.

## Hard rules

- GitHub access only through `~/.claude/skills/pr-explain/fetch.sh` (read-only), by this exact path. Never run `gh` directly.
- Only read-only `git` commands. Never check out, clone, fetch, pull, or switch branches. Ask before building or running anything.
- Never post, comment, approve, or edit anything on GitHub or Linear.
- Every claim about behaviour cites `path:line`. If you inferred it rather than read it, mark it `(inferred)`. Never fill gaps with plausible guesses.

## 1. Gather

`fetch.sh meta [<pr>]` first. Note `headRefOid`, `baseRefName`, `files`.

Local mode if the PR's branch is checked out here. Check all of:

1. `git rev-parse --show-toplevel` succeeds and `fetch.sh current-repo` matches the PR's repo (skip the second call if you already ran it to resolve a bare number)
2. `git rev-parse HEAD` equals `headRefOid`
3. `git diff --name-only origin/<base>...HEAD` lists exactly the paths in `files`. If not, the local base branch is stale; don't fetch, use GitHub.

All pass: local mode.

- Files at the PR head: the Read tool. If `git status --porcelain` shows modified tracked files, use `git show HEAD:<path>` for those, so uncommitted edits don't leak in.
- Old version: `git show origin/<base>:<path>`
- Callers and uses: Grep and Glob

Any check fails: say which one in one line and use GitHub mode: `fetch.sh file <owner/repo> <headRefOid|base> <path>` and `fetch.sh search <owner/repo> "<symbol>"` (search covers the default branch only). Either mode still needs GitHub for `meta`, `comments`, and issues.

Then in parallel:

- diff: `git diff origin/<base>...HEAD` or `fetch.sh diff <pr>`
- commits: `git log --oneline origin/<base>..HEAD` or `fetch.sh commits <pr>`
- discussion: `fetch.sh comments <pr>`
- GitHub issues: `fetch.sh issue <owner/repo> <n>` for `closingIssuesReferences` and any `#n` in the body
- Linear issues: any key like `ABC-123` in the branch name, title, body, or commits (case-insensitive, e.g. `abc-123-foo`). Call `mcp__linear-server__get_issue`, and `list_comments` if the description is thin. If Linear isn't connected, skip silently.

Then read past the diff, before writing anything:

- the full new version of each key file (not just the hunks)
- the old version where behaviour changes
- the callers of every changed exported function or type (Grep / `fetch.sh search`)
- the tests that touch the changed code, new and existing

Skip generated, vendored, lockfile, and formatting-only files; count them as noise.

## 2. Brief

Layered: TL;DR, Problem, Solution, Not this PR alone should be enough. Show this and nothing else:

````
**<title>** · <owner/repo>#<n> · @<author> · N files, +A/−D (<noise note>) · <ABC-123 if any>

🎯 **TL;DR** <one sentence: what changes for whom>

🐛 **Problem**
- <what's broken or missing, from the issue/ticket/body>
- <constraint or acceptance criterion from the ticket, if any>

🔧 **Solution**
- <what changes, 1–4 bullets>
- `path`: <its role in the fix>

🚫 **Not this PR**
- ⚠️ <change that doesn't serve the problem> `path`
- split: yes/no, <why>

🔄 **Before → after**
```diff
- <behaviour before>
+ <behaviour after>
- <edge case before>
+ <edge case after>
```

🧭 **How it works**
```
Reconcile()          resource_controller.go:120
  → applyObjects()   :210   new: tracks applied keys in status
  → pruneOrphans()   :260   new: deletes keys missing from this run
```

📖 **Read in this order**
- ☐ `path:line` <role, why start here>
- ☐ `path:line` <role>
- ☐ `path_test.go` <what it proves>

🧪 **Tests**
- ✅ <behaviour covered> `path_test.go:line`
- ❌ <behaviour not covered>

👀 **Watch**
- ⚠️ <surprising, risky, or unstated thing> `path:line`
- 🤔 <open question from the discussion, or ticket criterion not met>

📚 **Terms**
- `<repo term>`: <5–10 word meaning>
````

Rules:

- Bullets and fragments, about 12 words max each, max 5 bullets per block (more goes behind `deep`). Plain words. No "This PR …", no title restating, no praise, no verdict.
- **Problem**: if nothing states it, `- not stated, guess: …`.
- **Solution**: skip files that are only plumbing.
- **Not this PR**: group the diff hunks by intent, compare each group against Problem. Anything that doesn't serve it gets a ⚠️ bullet (unrelated refactors, renames, drive-by fixes, dependency bumps). All on topic: `- nothing, all on topic`.
- **Before → after** is the core of the brief: observable behaviour (API, status fields, side effects, errors, config), not code structure. Always a ```diff block, one `-`/`+` pair per behaviour, so old shows red and new green. Pure refactor: plain bullet `- no behaviour change (verified: <how>)`.
- **How it works**: the real call chain from the code, 3–8 lines, entry point first, in a plain code block so alignment holds. Mark new/changed nodes. Prefer this sketch over prose.
- **Read in this order**: 3–5 entries, dependency order (what you need to understand first), not diff order. A checklist: ☐ open, ☑ once the user has asked about or gone `deep` on that file.
- **Tests**: map each behaviour from Before → after to a test or ❌.
- **Watch**: only things a careful reader would want flagged: unstated behaviour changes, migrations or upgrade effects, ticket criteria missing from the code, unresolved review threads. Skip if empty.
- **Terms**: only repo or domain terms the diff relies on. Skip if none.
- If the commits tell a story (e.g. refactor, then feature), add `📜 **Commits**` after Solution with one line per meaningful commit. Skip for one-commit or fixup-noise PRs.
- Drop any empty block. Emoji and block order never change, so the brief always looks the same.
- Before showing, run the `humanizer:humanizer` skill over the brief (see Style).

End with one line: **ask anything, `deep <n>` for a section, or `review` to hand over to pr-review.**

## 3. Follow-up

Loop until the user stops:

- **Questions**: answer from the code, read more if needed. Lead with the answer in 1–3 lines, then the `path:line` evidence. If the code can't answer it (intent, product decisions), say so and point to the ticket, the comment thread, or the author.
- **`deep <section or file>`**: walk through it hunk by hunk in reading order, each step: what changed, why (tie to Problem), and what it touches elsewhere.
- **"what if X"**: trace the scenario through the code path step by step with `path:line`, end with the outcome. Mark any step you couldn't verify.
- **`review`**: invoke the `pr-review` skill with the same PR. Everything learned here carries over, so it can skip the fetch and brief. If `pr-review` isn't installed, say so.

Keep answers short. Don't repeat the brief. When a Read-in-order file has been covered, end the answer with the updated 📖 checklist. Run `humanizer:humanizer` over any answer longer than a few lines.

## Style

Everything shown to the user, brief and follow-ups:

- Fragments, not full sentences. Drop articles and filler. `retry moved into transport, every call gets it`, not `The retry logic has been moved into the transport so that every call gets it.`
- Plain, full words. No invented abbreviations (`cfg`, `impl`, `fn`). Exact technical terms, code, and error strings stay verbatim.
- Humanizer strips AI tells (stock phrases, inflated claims, forced triads, not-X-but-Y, em dashes). Where it would expand fragments into sentences, keep the fragments: this section wins.
- Humanizer leaves the layout, `→` in Before → after and the flow sketch, and every `path:line` untouched.
- Compress style, never facts: keep the scenario, the condition, the `path:line`. If dropping a word makes the meaning ambiguous, keep the word.

Readability (dyslexia-friendly):

- One idea per line. Blank line between blocks.
- Key word first, so the left edge scans: `retry: moved into transport`, not `the transport now owns the retry`. Where a file is the subject (Solution, Read in this order), the `path` is the key word.
- `path:line` at the end of a bullet, never mid-sentence.
- Bold only for block headings. No italics, no ALL CAPS, no long parentheticals.
- Same block order every time, even in follow-ups that reuse brief blocks.
- Digits, not number words. Common words over rare ones.
