# Code Review Skill

Use this skill when:
- The user asks to review code, a file, or a PR
- Before any PR is merged
- After writing a new feature or fix
- When the user says "review this", "check this code", "look at my changes"

This is a **strict review**. Every category is enforced. Blockers must be resolved before code can be merged or considered done. There are no exceptions.

---

## Step 1: Get the Code to Review

Determine what is being reviewed:

### PR review
```bash
gh pr diff <number>          # get the diff
gh pr view <number>          # get PR title, description, branch
git log main..<branch> --oneline   # see all commits in the PR
```

### Staged / recent local changes
```bash
git diff                     # unstaged changes
git diff --staged            # staged changes
git diff HEAD~1              # last commit
```

### Specific file
Read the file directly. Also check its git history:
```bash
git log --oneline -10 -- <filepath>
git diff HEAD~1 -- <filepath>
```

Read every changed file in full — not just the diff. Understand the surrounding context.

---

## Step 2: Understand the Intent

Before reviewing, answer these questions:
1. What is this change trying to do?
2. What problem does it solve?
3. Is the approach appropriate for the problem?

If the intent is unclear from the code or PR description, flag it as a blocker — unclear intent means the change should not merge.

---

## Step 3: Run the Strict Review Checklist

Go through every category. Do not skip any. Every item marked with 🔴 is a **blocker** — the code cannot merge until it is resolved. Every item marked with 🟡 is a **required improvement** — must be addressed before the code is considered done, even if not blocking a merge. Every item marked with 🟢 is a **suggestion** — strongly recommended but judgment-based.

---

### Category 1: Correctness

- 🔴 Does the logic actually do what it claims to do?
- 🔴 Are there off-by-one errors, wrong operators, or inverted conditions?
- 🔴 Are all code paths handled? (if/else, switch cases, try/catch)
- 🔴 Can this code panic, crash, or throw an unhandled exception?
- 🔴 Are return values checked where failure is possible?
- 🔴 Is async code handled correctly? (missing await, unhandled promise rejections)
- 🔴 Are there race conditions or concurrency issues?
- 🔴 Does it handle the null/undefined/empty case?
- 🟡 Are error messages meaningful and actionable?
- 🟡 Are magic numbers or strings replaced with named constants?

---

### Category 2: Security

- 🔴 Is any user input used in SQL queries without parameterization? (SQL injection)
- 🔴 Is any user input rendered as HTML without sanitization? (XSS)
- 🔴 Are secrets, API keys, tokens, or passwords hardcoded anywhere?
- 🔴 Are secrets logged or exposed in error messages?
- 🔴 Is authentication checked before accessing protected resources?
- 🔴 Is authorization checked — not just "are you logged in" but "are you allowed to do this"?
- 🔴 Are file paths constructed from user input without validation? (path traversal)
- 🔴 Are shell commands constructed from user input? (command injection)
- 🔴 Are rate limits in place for sensitive endpoints (login, password reset, OTP)?
- 🔴 Is sensitive data (passwords, PII) stored or transmitted in plain text?
- 🔴 Are CORS headers properly configured — not set to `*` on authenticated endpoints?
- 🟡 Are error responses sanitized — not leaking stack traces or internal details to clients?
- 🟡 Are dependency versions pinned and free of known CVEs?

---

### Category 3: Performance

- 🔴 Are there N+1 query problems? (DB query inside a loop)
- 🔴 Are large datasets loaded into memory when they should be streamed or paginated?
- 🔴 Are there infinite loops or recursion without a base case?
- 🟡 Are expensive operations (DB queries, API calls, heavy computation) cached where appropriate?
- 🟡 Are database queries using indexes on filtered/sorted columns?
- 🟡 Are unnecessary re-renders introduced? (React — missing memo, unstable references)
- 🟡 Are large files or blobs processed synchronously when they should be async/background?
- 🟢 Are there opportunities to batch operations instead of running them one at a time?

---

### Category 4: Code Quality & Standards

- 🔴 Does the code match the project's coding standards? (run coding-standards skill to verify)
- 🔴 Are functions doing more than one thing? (violates single responsibility)
- 🔴 Is there duplicated logic that should be extracted into a shared utility?
- 🔴 Are variable and function names clear and descriptive?
- 🔴 Is there dead code, commented-out code, or unused imports/variables?
- 🔴 Are `console.log`, `print`, `debugger`, or other debug statements left in?
- 🟡 Are functions longer than ~50 lines? (if so, should likely be broken up)
- 🟡 Is nesting deeper than 3 levels? (should be flattened or extracted)
- 🟡 Are there TODO comments without a linked issue or owner?
- 🟢 Can complex logic be simplified?

---

### Category 5: Tests

- 🔴 Is new functionality covered by tests?
- 🔴 Is bug fix code accompanied by a regression test that would have caught the bug?
- 🔴 Do tests actually test the behavior, not just the implementation? (testing internals = brittle)
- 🔴 Are tests isolated — do they depend on order or shared mutable state?
- 🔴 Are edge cases tested: null/empty input, maximum values, error conditions?
- 🔴 Do tests pass? (run them if possible)
- 🟡 Is test coverage maintained or improved — not regressed?
- 🟡 Are test descriptions clear enough to understand what they test without reading the body?
- 🟡 Are there tests that mock too much and don't test real behavior?
- 🟢 Are there integration or E2E tests for critical user flows?

---

### Category 6: Breaking Changes

- 🔴 Does this change break any existing API contracts (endpoint removed, response shape changed, param renamed)?
- 🔴 Does this change break database schema compatibility with existing data?
- 🔴 Does this remove or rename a public function/class/module that other code depends on?
- 🔴 Does this change behavior that other parts of the system rely on silently?
- 🟡 If a breaking change is intentional, is it documented and is a migration path provided?
- 🟡 Are dependent services or consumers updated in the same PR?

---

### Category 7: Documentation & Clarity

- 🔴 If a public API endpoint was added or changed, is it documented? (update project-docs skill)
- 🔴 If a data model changed, is it documented?
- 🟡 Is the PR description clear — does it explain what changed and why?
- 🟡 Are non-obvious algorithms or business logic explained with comments?
- 🟡 Are complex regex patterns or bitwise operations commented?
- 🟢 Would a new developer understand this code without asking questions?

---

## Step 4: Output the Review Report

Always output the review in this exact format:

---

```
## Code Review — [filename / PR title / description]
**Date:** YYYY-MM-DD
**Reviewed by:** Claude (strict mode)

---

### Intent
[1-2 sentences: what this change does and whether the approach is sound]

---

### 🔴 Blockers — Must fix before merge
[List every blocker found. For each:]
- **[Category] Line X / File Y:** [What the issue is]
  - **Why it's a blocker:** [Specific risk or consequence]
  - **Fix:** [Concrete suggestion for how to fix it]

None — if no blockers found.

---

### 🟡 Required Improvements — Must address before done
[List every required improvement. For each:]
- **[Category] Line X / File Y:** [What needs to improve]
  - **Fix:** [Suggestion]

None — if none found.

---

### 🟢 Suggestions — Strongly recommended
[List suggestions. Keep brief.]
- [Suggestion]

None — if none found.

---

### What was done well
[Genuine specific praise — not filler. What patterns, decisions, or code quality stood out positively.]

---

### Verdict
🔴 REQUEST CHANGES — X blocker(s) must be resolved before this can merge.
  OR
🟡 IMPROVEMENTS NEEDED — No blockers, but X required improvements before this is considered done.
  OR
✅ APPROVED — No blockers, no required improvements. Good to merge.
```

---

## Step 5: After the Review

### If blockers exist:
- Do not merge
- Fix each blocker
- Re-run the review after fixes

### If approved:
- Follow the version-control skill for the merge process
- After merge, update project-docs skill (git history + change log)
- Update CLAUDE_aakash.md via update-project-log skill

---

## Strict Review Rules

1. **No exceptions for blockers** — "we'll fix it later" is not acceptable for 🔴 items
2. **Every changed file gets reviewed** — not just the lines that changed
3. **Context matters** — read surrounding code before flagging an issue
4. **Be specific** — never say "this could be improved". Say exactly what, where, and how.
5. **Re-review after fixes** — once blockers are fixed, run the review again to confirm
6. **Security is non-negotiable** — any security issue is always a blocker, no matter how small
7. **Tests are non-negotiable** — untested new code is always a blocker
