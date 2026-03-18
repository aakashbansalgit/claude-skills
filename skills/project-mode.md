# Project Mode Skill

Use this skill when:
- The user says "start project mode", "activate project mode", "set up this project", or "initialise project"
- Beginning work on any new or existing project
- The user wants all project skills active at once

This skill activates and coordinates all 6 core project skills simultaneously and keeps them running for the entire project session. It also learns during the project and updates skills when new patterns or standards are discovered.

---

## What Project Mode Does

Activates these 6 skills in order, keeps them all active, and coordinates between them:

| # | Skill | Role |
|---|-------|------|
| 1 | `version-control` | Git workflow, branching, PRs, branch protection |
| 2 | `coding-standards` | Detect or establish code style and conventions |
| 3 | `cicd-automation` | CI pipeline, CD pipeline, automation tasks |
| 4 | `code-review` | Strict review before every merge |
| 5 | `update-project-log` | Maintain `CLAUDE_aakash.md` after every change |
| 6 | `project-docs` | Maintain `PROJECT_DOCS.md` after every change |

---

## Step 1: Project Scan

Before activating anything, read the project to understand its current state:

```bash
# What kind of project is this?
ls -la

# Is it already a git repo?
git status 2>/dev/null || echo "not a git repo"

# What's the tech stack?
cat package.json 2>/dev/null || cat pyproject.toml 2>/dev/null || cat go.mod 2>/dev/null || cat Cargo.toml 2>/dev/null

# Is there existing CI?
ls .github/workflows/ 2>/dev/null

# Is there existing documentation?
ls *.md 2>/dev/null

# What does the git history look like?
git log --oneline -10 2>/dev/null
```

Based on the scan, determine:
- **New project** → run full setup for all 6 skills
- **Existing project** → detect what's already in place, only set up what's missing

---

## Step 2: Activate All 6 Skills in Sequence

Run each skill in this order. Do not skip any.

### 2.1 — Version Control
Follow the `version-control` skill fully:
- If no git repo: `git init`, create `.gitignore`, initial commit, create GitHub repo
- If already a repo: check remote is connected, check branch protection on `main`
- Establish branching strategy: `main` → protected, work on `feature/`, `fix/`, `chore/` branches
- Set up branch protection rules via GitHub API

### 2.2 — Coding Standards
Follow the `coding-standards` skill fully:
- **New project:** install linter + formatter for the stack, create `.editorconfig`, set up pre-commit hooks, create `CONTRIBUTING.md`
- **Existing project:** scan for existing configs, read codebase to infer conventions, document them

### 2.3 — CI/CD Automation
Follow the `cicd-automation` skill fully:
- Create `.github/workflows/ci.yml` — lint, test, build on every push + PR
- Create `.github/workflows/deploy.yml` — deploy on merge to `main` (ask user for deployment target if unknown)
- Create `.github/dependabot.yml` — weekly dependency updates
- List all required GitHub secrets the user needs to add
- Update branch protection to require CI to pass

### 2.4 — Code Review Setup
The `code-review` skill does not require setup — it is invoked before every merge. Confirm with the user:
> "Strict code review is active. I will run a full review before any branch is merged into main."

### 2.5 — Update Project Log (CLAUDE_aakash.md)
Follow the `update-project-log` skill:
- Create `CLAUDE_aakash.md` at project root if it doesn't exist
- Populate all sections from the project scan
- Add initial entry to the Change Log: "Project Mode activated — all skills initialised"

### 2.6 — Project Docs (PROJECT_DOCS.md)
Follow the `project-docs` skill:
- Ensure `PROJECT_DOCS.md` is in `.gitignore`
- Create `PROJECT_DOCS.md` at project root if it doesn't exist
- Populate all 18 sections from the project scan
- If pandoc is available, generate `PROJECT_DOCS.docx`

---

## Step 3: Project Mode Status Report

After all 6 skills are activated, output this report:

```
## ✅ Project Mode Active — [Project Name]

| Skill | Status | What was set up |
|-------|--------|----------------|
| Version Control | ✅ Active | [e.g. git init, GitHub repo created, main protected] |
| Coding Standards | ✅ Active | [e.g. ESLint + Prettier installed, .editorconfig created] |
| CI/CD Automation | ✅ Active | [e.g. ci.yml + deploy.yml created, Dependabot configured] |
| Code Review | ✅ Active | Strict review runs before every merge |
| Project Log | ✅ Active | CLAUDE_aakash.md created/updated |
| Project Docs | ✅ Active | PROJECT_DOCS.md created/updated |

### Secrets needed in GitHub
[List any secrets the user needs to add manually]

### Next steps
[List 2-3 immediate things to do now that project mode is active]
```

---

## Step 4: Staying Active Throughout the Project

Once Project Mode is active, these triggers apply for the rest of the session and every future session in this project. Claude must follow them automatically:

| Trigger | Skills that run |
|---------|----------------|
| Any file is edited or created | `update-project-log` → update CLAUDE_aakash.md |
| Any git commit is made | `project-docs` → update git history section; `update-project-log` → update change log |
| A PR is opened or ready to merge | `code-review` → run full strict review; block merge if blockers exist |
| A PR is merged | `version-control` → delete branch; `project-docs` → update docs; `update-project-log` → update log |
| A new file/folder structure is added | `coding-standards` → verify it matches conventions; `project-docs` → update structure section |
| A new API endpoint is added or changed | `project-docs` → update API reference section immediately |
| A data model/schema changes | `project-docs` → update data models section immediately |
| A new dependency is added | `coding-standards` → verify it fits the stack; `project-docs` → update tech stack if significant |
| CI/CD pipeline changes | `cicd-automation` → verify correctness; `project-docs` → update CI/CD section |
| A security issue is found | `code-review` → flag as 🔴 blocker; `project-docs` → log in known issues |
| A new convention or pattern is established | `project-mode` → update relevant skill (see Step 5) |

---

## Step 5: Learning & Updating Skills

This is the most important ongoing responsibility. When something new is learned during the project that any skill should know about, update the skill file immediately.

### When to update a skill

Update a skill when:
- A new convention is discovered that isn't in `coding-standards` (e.g. "this team uses barrel exports everywhere")
- A deployment process is discovered that isn't in `cicd-automation` (e.g. a custom deploy script)
- A new type of security risk is encountered specific to this stack
- The code review process catches a recurring issue that should be added as a standing check
- A new workflow pattern is established for version control
- Something in the docs template turns out to be wrong or missing for this project type

### How to update a skill

1. Identify which skill file needs updating: `~/claude-skills/skills/<skill-name>.md`
2. Read the current skill file
3. Add the new learning to the appropriate section — be specific and generalizable (write it so it applies to future projects too, not just this one)
4. Commit and push:

```bash
cd ~/claude-skills
git add skills/<skill-name>.md
git commit -m "chore(skills): update <skill-name> — [what was learned]"
git push
```

5. Confirm to the user: "I've updated the `<skill-name>` skill with [what was learned]. This will apply to all future projects."

### Examples of learnings worth updating

- "This stack uses Vitest not Jest — update cicd-automation to use `vitest run` instead of `jest`"
- "This team requires two approvals on PRs not one — update version-control"
- "Railway deploy requires a `railway.json` file — add to cicd-automation"
- "Aakash prefers named exports over default exports — update coding-standards"
- "This project uses `pnpm` not `npm` — update cicd-automation CI templates to use `pnpm ci`"

### Learnings that are project-specific (do NOT update global skills)
If a learning only applies to this specific project (e.g. a custom internal API, a one-off config), do NOT update the global skill. Instead, log it in `CLAUDE_aakash.md` and `PROJECT_DOCS.md` only.

---

## Step 6: Starting a New Session on an Existing Project

When returning to a project that already has Project Mode active:

1. Read `CLAUDE_aakash.md` — understand current state, last changes, next steps
2. Read `PROJECT_DOCS.md` — refresh context on architecture, APIs, data models
3. Run `git log --oneline -5` — see what's changed since last session
4. Pull latest: `git pull origin main`
5. Confirm Project Mode is still active and all skills are ready
6. Report to user: "Resumed [project name]. Last session: [date]. [X] commits since then. Ready."

---

## Rules for Project Mode

1. **All 6 skills are always on** — never deactivate one without explicit instruction from the user
2. **No merge without code review** — the `code-review` skill runs before every single merge, no exceptions
3. **Docs and log stay current** — never let more than one commit pass without updating both files
4. **Skills get smarter** — every new learning gets pushed to GitHub so future projects benefit
5. **Project-specific vs global** — know the difference: global learnings update the skill, project-specific ones go in the local docs only
6. **Session continuity** — always read `CLAUDE_aakash.md` at the start of every session to resume context
