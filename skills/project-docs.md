# Project Documentation Skill

Use this skill when:
- Starting a new project (create the docs from scratch)
- After any git commit is made (update the changelog section)
- After any significant change to architecture, APIs, data models, or setup
- When the user asks to update or generate project documentation
- At the end of a working session

This skill maintains a comprehensive `PROJECT_DOCS.md` (and optionally `PROJECT_DOCS.docx`) at the project root. The file is **gitignored** — it lives locally only and is never pushed to GitHub. It is the single source of truth for everything about the project.

---

## Step 1: Setup — Add to .gitignore

Before creating the docs file, ensure it is gitignored:

1. Check if `.gitignore` exists in the project root
2. If it does, check if `PROJECT_DOCS.md` and `PROJECT_DOCS.docx` are already listed
3. If not listed, append them:

```
# Local project documentation (not committed)
PROJECT_DOCS.md
PROJECT_DOCS.docx
```

4. Commit the `.gitignore` change with message: `chore: gitignore local project docs`

---

## Step 2: Check if PROJECT_DOCS.md exists

- **Does not exist** → create from scratch using the full template in Step 3
- **Exists** → read it fully, then update only relevant sections (Step 4)

---

## Step 3: Creating PROJECT_DOCS.md from scratch

Read the entire project first: directory structure, package files, config files, existing README, source files, and git log. Then populate every section of this template:

````markdown
# [Project Name] — Project Documentation

> Local documentation for Aakash. Gitignored — not committed to GitHub.
> Last updated: [YYYY-MM-DD]

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Architecture](#2-architecture)
3. [Tech Stack](#3-tech-stack)
4. [Project Structure](#4-project-structure)
5. [Setup & Installation](#5-setup--installation)
6. [Environment Variables](#6-environment-variables)
7. [Running the Project](#7-running-the-project)
8. [API Reference](#8-api-reference)
9. [Data Models](#9-data-models)
10. [Key Components & Modules](#10-key-components--modules)
11. [Authentication & Security](#11-authentication--security)
12. [Database](#12-database)
13. [Testing](#13-testing)
14. [Deployment](#14-deployment)
15. [CI/CD Pipeline](#15-cicd-pipeline)
16. [Known Issues & Tech Debt](#16-known-issues--tech-debt)
17. [Git History & Change Log](#17-git-history--change-log)
18. [Decisions & Reasoning](#18-decisions--reasoning)

---

## 1. Project Overview

**Name:** [project name]
**Description:** [what this project does in 2-3 sentences]
**Status:** [Active / In Progress / Paused / Complete]
**Repository:** [GitHub URL if known]
**Started:** [date]
**Last updated:** [date]

**Goals:**
- [primary goal]
- [secondary goal]

**Out of scope:**
- [what this project does NOT do]

---

## 2. Architecture

[Describe the high-level architecture. How do the main parts connect? Is it monolithic, microservices, serverless, MVC, etc.?]

```
[ASCII diagram if helpful — e.g. Client → API → DB]
```

**Key architectural decisions:**
- [Decision and reason]

---

## 3. Tech Stack

| Layer | Technology | Version | Why chosen |
|-------|-----------|---------|-----------|
| Language | | | |
| Framework | | | |
| Database | | | |
| Auth | | | |
| Caching | | | |
| Queue/Jobs | | | |
| File Storage | | | |
| Email | | | |
| Hosting | | | |
| CI/CD | | | |
| Monitoring | | | |

---

## 4. Project Structure

```
[directory tree — 2-3 levels deep, with comments explaining each folder]
project-root/
├── src/
│   ├── components/     # React components
│   ├── pages/          # Next.js pages / routes
│   ├── lib/            # Shared utilities
│   └── types/          # TypeScript types
├── tests/              # Test files
├── .github/            # CI/CD workflows
└── ...
```

---

## 5. Setup & Installation

### Prerequisites

- [e.g. Node 20+, Python 3.11+, Docker, etc.]

### Install

```bash
[step by step install commands]
```

### First-time setup

```bash
[any one-time setup: DB migrations, seed data, env file creation, etc.]
```

---

## 6. Environment Variables

Copy `.env.example` to `.env` and fill in:

| Variable | Required | Description | Where to get it |
|----------|----------|-------------|----------------|
| `DATABASE_URL` | Yes | PostgreSQL connection string | Local DB or provider |
| `SECRET_KEY` | Yes | App secret for JWT signing | Generate randomly |
| | | | |

**Never commit `.env` to git.**

---

## 7. Running the Project

```bash
# Development
[command]

# Production build
[command]

# Run tests
[command]

# Run linter
[command]

# Database migrations
[command]
```

---

## 8. API Reference

[Document every API endpoint. Add new ones as they are created.]

### Base URL
- Development: `http://localhost:3000`
- Production: `[URL]`

### Authentication
[How to authenticate — Bearer token, API key, session cookie, etc.]

---

### Endpoints

#### `GET /api/example`

**Description:** [what it does]
**Auth required:** Yes / No

**Query params:**
| Param | Type | Required | Description |
|-------|------|----------|-------------|
| | | | |

**Response:**
```json
{
  "status": "ok",
  "data": {}
}
```

**Error responses:**
| Status | Meaning |
|--------|---------|
| 400 | Bad request |
| 401 | Unauthorized |
| 404 | Not found |

---

[Repeat the block above for every endpoint]

---

## 9. Data Models

[Document every database table / collection / schema]

### [ModelName]

| Field | Type | Required | Description |
|-------|------|----------|-------------|
| `id` | UUID | Yes | Primary key |
| `created_at` | Timestamp | Yes | Creation time |
| | | | |

**Relationships:**
- `[ModelName]` has many `[OtherModel]`
- `[ModelName]` belongs to `[OtherModel]`

---

## 10. Key Components & Modules

[For each significant component, service, or module:]

### [ComponentName]

**File:** `src/components/ComponentName.tsx`
**Purpose:** [what it does]
**Props / Inputs:**
| Name | Type | Description |
|------|------|-------------|
| | | |

**Notes:** [anything non-obvious about how it works]

---

## 11. Authentication & Security

**Auth method:** [JWT / Session / OAuth / API Key]
**Token storage:** [httpOnly cookie / localStorage / memory]
**Token expiry:** [duration]
**Refresh strategy:** [how tokens are refreshed]

**Security measures in place:**
- [ ] HTTPS enforced
- [ ] CORS configured
- [ ] Rate limiting
- [ ] Input validation/sanitization
- [ ] SQL injection protection
- [ ] XSS protection
- [ ] CSRF protection
- [ ] Secrets in env vars (never hardcoded)

---

## 12. Database

**Type:** [PostgreSQL / MySQL / MongoDB / SQLite / etc.]
**ORM/ODM:** [Prisma / SQLAlchemy / Mongoose / etc.]

### Migrations

```bash
# Create migration
[command]

# Run migrations
[command]

# Rollback
[command]
```

### Backups
[How and where the DB is backed up]

---

## 13. Testing

**Test runner:** [Jest / Pytest / Go test / etc.]
**Coverage target:** [e.g. 80%]

```bash
# Run all tests
[command]

# Run with coverage
[command]

# Run specific test
[command]
```

**Test structure:**
- Unit tests: `[location]`
- Integration tests: `[location]`
- E2E tests: `[location]`

---

## 14. Deployment

**Platform:** [Vercel / Netlify / AWS / Railway / Fly.io / VPS / etc.]
**Branch → Environment mapping:**
| Branch | Environment | URL |
|--------|-------------|-----|
| `main` | Production | |
| `dev` | Staging | |

### Manual deploy steps (if any)
```bash
[commands]
```

### Rollback procedure
```bash
[commands or steps]
```

---

## 15. CI/CD Pipeline

**Platform:** GitHub Actions

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| `ci.yml` | Every push + PR | Lint, test, build |
| `deploy.yml` | Push to `main` | Deploy to production |
| `dependabot.yml` | Weekly | Dependency updates |

**Required secrets in GitHub:**
| Secret | Purpose |
|--------|---------|
| | |

---

## 16. Known Issues & Tech Debt

| # | Issue | Severity | Notes |
|---|-------|----------|-------|
| 1 | | Low/Med/High | |

---

## 17. Git History & Change Log

[Updated automatically after every commit. Most recent first.]

---

### [YYYY-MM-DD] — [Commit message / session title]

**Commit:** `[hash]`
**Author:** Aakash
**Files changed:** [list key files]

**What changed:**
- [specific change]
- [specific change]

**Why:**
[Explanation of the motivation — what problem this solved, what feature this added, or what decision led to this change]

---

[Repeat block for every commit / session]

---

## 18. Decisions & Reasoning

[Log significant architectural, design, and technical decisions here. Why things are the way they are. This prevents re-litigating past decisions.]

| Date | Decision | Alternatives considered | Why this was chosen |
|------|----------|------------------------|---------------------|
| | | | |

````

---

## Step 4: Updating an existing PROJECT_DOCS.md

### After every git commit — always do this:

1. Run `git log --oneline -10` to see recent commits
2. Run `git show <latest-commit-hash> --stat` to see what files changed
3. Run `git show <latest-commit-hash>` to see the full diff
4. Add a new entry to **Section 17 (Git History & Change Log)**:
   - Date, commit hash, files changed
   - What changed (from the diff)
   - **Why** it changed (infer from the commit message + context of the change)
5. Update **Last updated** date at the top

### After architectural/significant changes — also update:

- **Section 2** if architecture changed
- **Section 3** if new tech was added
- **Section 4** if folder structure changed
- **Section 8** if new API endpoints were added or existing ones changed
- **Section 9** if data models changed
- **Section 10** if new components/modules were added
- **Section 11** if auth/security changed
- **Section 15** if CI/CD changed
- **Section 16** add new issues found; check off resolved ones
- **Section 18** if a significant decision was made

---

## Step 5: Generate .docx (optional)

If pandoc is available, convert to docx after updating the markdown:

```bash
# Check if pandoc is installed
which pandoc

# Convert to docx
pandoc PROJECT_DOCS.md -o PROJECT_DOCS.docx --toc --toc-depth=2
```

If pandoc is not installed, tell the user:
```
PROJECT_DOCS.md is ready. To also generate a .docx, install pandoc:
  brew install pandoc
Then run: pandoc PROJECT_DOCS.md -o PROJECT_DOCS.docx --toc
```

The `.docx` is also gitignored and stays local only.

---

## Rules

1. **Never commit PROJECT_DOCS.md or PROJECT_DOCS.docx** — always gitignored
2. **Git History is append-only** — never delete past entries
3. **Always explain the why** — not just what changed but the reason behind it
4. **Keep the API Reference current** — update it the moment an endpoint is added/changed/removed
5. **Data models must match the code** — if schema changes, update Section 9 immediately
6. **Decisions log prevents revisiting** — if a decision was made and logged, don't second-guess it without a good reason
