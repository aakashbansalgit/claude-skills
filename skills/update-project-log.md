# Update Project Log Skill

Use this skill:
- **Automatically** after making ANY change to a project (editing files, running commands, setting up tools, fixing bugs, adding features)
- When the user asks to update or review the project log
- When starting work on a project for the first time (to create the log)
- At the end of every session to summarize what was done

This skill maintains a `CLAUDE_aakash.md` file at the root of every project. This file is Aakash's personal project log — a living document that keeps track of everything that has happened, the current state, and what to pick up next time.

---

## What is CLAUDE_aakash.md?

A single markdown file at the project root that serves as:
- A **project briefing** — what the project is, stack, how to run it
- A **decision log** — why things were built the way they were
- A **change history** — what changed and when
- A **handoff document** — so any future Claude session can pick up exactly where things left off without needing re-explanation

---

## Step 1: Check if CLAUDE_aakash.md exists

- If it **does not exist** → create it from scratch using the template in Step 2
- If it **exists** → read it fully, then update only the relevant sections (Step 3)

---

## Step 2: Creating CLAUDE_aakash.md from scratch

Use this template. Fill in every section based on what you know about the project:

```markdown
# CLAUDE_aakash.md — [Project Name]

> Personal project log for Aakash. Updated by Claude after every change.

---

## Project Overview

**What it does:** [1-2 sentence description]
**Status:** [Active / In Progress / Paused / Complete]
**Started:** [date]
**Last updated:** [date]

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Language | |
| Framework | |
| Database | |
| Auth | |
| Hosting | |
| CI/CD | |

---

## Project Structure

```
[top-level directory tree — just 1-2 levels deep]
```

## How to Run Locally

```bash
# Install
[command]

# Run dev server
[command]

# Run tests
[command]
```

---

## Environment Variables

| Variable | Purpose | Where to get it |
|----------|---------|----------------|
| | | |

---

## Key Decisions

<!-- Log architectural and design decisions here. Why things are the way they are. -->

- **[date]** — [Decision made and why]

---

## Change Log

<!-- Most recent changes at the top -->

### [date] — [Short title of session]
- [What was done]
- [What was done]

---

## Current State

**What works:**
- [feature/thing that is complete]

**In progress:**
- [thing being worked on]

**Not started yet:**
- [planned feature]

---

## Known Issues / Tech Debt

- [ ] [issue or debt item]

---

## Next Steps

<!-- What to do in the next session -->

1. [Next task]
2. [Next task]
```

---

## Step 3: Updating an existing CLAUDE_aakash.md

After making changes, update **only the sections that are affected**. Always:

### Always update:
- **Last updated** date at the top
- **Change Log** — add a new entry at the top with today's date and bullet points of what changed
- **Current State** — reflect the new state accurately (move items from "in progress" to "what works", add new items as needed)

### Update if relevant:
- **Tech Stack** — if a new technology was added
- **Project Structure** — if new folders/files were added that change the structure
- **How to Run Locally** — if commands changed or new ones are needed
- **Environment Variables** — if new env vars were added
- **Key Decisions** — if an architectural or design decision was made (always log the *why*)
- **Known Issues / Tech Debt** — if new issues were found or old ones resolved
- **Next Steps** — update to reflect what should be done next

### Change Log format:
```markdown
### 2026-03-18 — Set up CI/CD pipeline
- Added `.github/workflows/ci.yml` for lint, test, build on every PR
- Added `.github/workflows/deploy.yml` for auto-deploy to Vercel on merge to main
- Added Dependabot config for weekly dependency updates
- Updated branch protection to require CI to pass before merging
```

---

## Step 4: Rules for maintaining this file

1. **Never delete history** — the Change Log is append-only. Old entries stay.
2. **Be specific** — don't write "fixed bug", write "fixed null pointer error in /api/users when user has no profile"
3. **Log decisions with reasons** — not just *what* but *why*
4. **Keep Next Steps honest** — if something is blocked or uncertain, say so
5. **Date every entry** — always use the full date (YYYY-MM-DD)
6. **Keep it concise** — this is a reference doc, not an essay. Bullet points over paragraphs.
7. **One file per project** — always at the project root, always named `CLAUDE_aakash.md`

---

## Step 5: Add to .gitignore or commit?

**Commit it.** This file is valuable — it documents the project history and lets any future Claude session or collaborator understand the project instantly. Do not gitignore it.

If the project is private and you don't want it public, keep the repo private.
