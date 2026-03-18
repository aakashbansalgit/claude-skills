# Coding Standards & Style Skill

Use this skill when the user is:
- Starting a new project and wants coding standards established
- Joining or contributing to an existing project
- Writing code that must match an existing codebase's style
- Setting up linters, formatters, or pre-commit hooks
- Asking about naming conventions, file structure, or code style

---

## Step 1: Detect the Situation

Before writing a single line of code, determine which scenario applies:

### Joining an existing project → go to Section A
Signs: repo already has code, config files exist, team/collaborators present

### Starting fresh → go to Section B
Signs: empty repo, no existing config files, greenfield project

---

## Section A: Joining an Existing Project

**Never assume. Always read the project first.**

### A1. Scan for existing config files

Check for these files in the project root (and subdirectories):

**Formatting / Linting:**
- `.eslintrc`, `.eslintrc.js`, `.eslintrc.json`, `.eslintrc.yml` — JS/TS linting
- `.prettierrc`, `prettier.config.js` — JS/TS formatting
- `pyproject.toml`, `setup.cfg`, `.flake8`, `.pylintrc` — Python linting/formatting
- `.rubocop.yml` — Ruby
- `golangci.yml`, `.golangci.yaml` — Go
- `phpcs.xml`, `.php-cs-fixer.php` — PHP
- `rustfmt.toml`, `.rustfmt.toml` — Rust
- `.stylelintrc` — CSS/SCSS

**Editor / General:**
- `.editorconfig` — universal indent/newline settings
- `tsconfig.json` — TypeScript strictness settings

**Git hooks:**
- `.husky/` — JS pre-commit hooks
- `.pre-commit-config.yaml` — Python/universal pre-commit hooks
- `lefthook.yml` — alternative git hooks

**Read every config file found.** Extract the key rules: indent size, quotes, semicolons, max line length, naming conventions, etc.

### A2. Read existing code to infer unlisted conventions

Config files don't capture everything. Read 3–5 representative files across the codebase and note:

- **Naming:** camelCase vs snake_case vs PascalCase for variables, functions, classes, files, folders
- **File structure:** how are components/modules/services organized?
- **Import order:** external → internal? grouped? sorted alphabetically?
- **Comment style:** JSDoc, docstrings, inline `//`, or minimal?
- **Error handling:** try/catch, Result types, error codes?
- **Test structure:** file co-location or `__tests__`/`tests/` folder? naming pattern?
- **Async style:** async/await, Promises, callbacks?
- **Export style:** named exports, default exports, barrel files (`index.ts`)?

### A3. Check for documented standards

Look for:
- `CONTRIBUTING.md`
- `docs/` folder
- `README.md` — may have a "Development" or "Contributing" section
- `.github/CONTRIBUTING.md`

Read these in full before writing code.

### A4. Apply discovered standards

When writing code for this project:
- Match **exactly** the style of surrounding code — not personal preference
- Use the same patterns already in the codebase, even if not ideal
- Run the project's linter/formatter before committing
- If uncertain about a convention, find an existing example in the codebase and mirror it

### A5. Flag conflicts or gaps

If the codebase has inconsistent style, note it but **match the majority pattern**. Do not silently "fix" style in unrelated files — keep PRs focused. If there are no standards at all, propose establishing them (see Section B).

---

## Section B: New Project — Establishing Standards

### B1. Choose tools based on language/framework

**JavaScript / TypeScript:**
```bash
# ESLint + Prettier
npm install --save-dev eslint prettier eslint-config-prettier
npx eslint --init
```
Recommended ESLint config base: `eslint:recommended` + `plugin:@typescript-eslint/recommended` (for TS)
Always add `eslint-config-prettier` to disable ESLint rules that conflict with Prettier.

**Python:**
```bash
pip install ruff black isort
# ruff handles linting + isort; black handles formatting
```
Add to `pyproject.toml`:
```toml
[tool.black]
line-length = 88

[tool.ruff]
line-length = 88
select = ["E", "F", "I"]

[tool.isort]
profile = "black"
```

**Go:** `gofmt` and `golangci-lint` are standard — no setup needed, just enforce usage.

**Rust:** `rustfmt` (built-in) + `clippy`. Add `rustfmt.toml` for any overrides.

**Ruby:** RuboCop — `gem install rubocop`, generate `.rubocop.yml` with `rubocop --init`.

### B2. Create `.editorconfig` (language-agnostic baseline)

Always create this — it works across all editors and languages:

```ini
root = true

[*]
indent_style = space
indent_size = 2
end_of_line = lf
charset = utf-8
trim_trailing_whitespace = true
insert_final_newline = true

[*.py]
indent_size = 4

[*.md]
trim_trailing_whitespace = false

[Makefile]
indent_style = tab
```

### B3. Set up pre-commit hooks

Hooks enforce standards automatically before every commit — no manual enforcement needed.

**For JS/TS projects (Husky + lint-staged):**
```bash
npm install --save-dev husky lint-staged
npx husky init
```
Add to `package.json`:
```json
"lint-staged": {
  "*.{js,ts,jsx,tsx}": ["eslint --fix", "prettier --write"],
  "*.{css,md,json}": ["prettier --write"]
}
```
Add to `.husky/pre-commit`:
```bash
npx lint-staged
```

**For Python projects (pre-commit):**
```bash
pip install pre-commit
```
Create `.pre-commit-config.yaml`:
```yaml
repos:
  - repo: https://github.com/psf/black
    rev: 24.0.0
    hooks:
      - id: black
  - repo: https://github.com/charliermarsh/ruff-pre-commit
    rev: v0.3.0
    hooks:
      - id: ruff
        args: [--fix]
```
Run: `pre-commit install`

### B4. Define naming conventions explicitly

Document in `CONTRIBUTING.md` or `README.md`:

| Element | Convention | Example |
|---------|-----------|---------|
| Variables | camelCase (JS) / snake_case (Py) | `userProfile` / `user_profile` |
| Functions | camelCase (JS) / snake_case (Py) | `fetchUser()` / `fetch_user()` |
| Classes | PascalCase | `UserService` |
| Constants | UPPER_SNAKE_CASE | `MAX_RETRIES` |
| Files (JS) | kebab-case or PascalCase for components | `user-service.ts`, `UserCard.tsx` |
| Files (Py) | snake_case | `user_service.py` |
| Folders | kebab-case | `user-management/` |
| Branches | `type/short-description` | `feat/add-auth` |

### B5. Add CI enforcement

Add a lint/format check to your CI pipeline so standards are enforced on every PR.

**GitHub Actions example:**
```yaml
# .github/workflows/lint.yml
name: Lint
on: [push, pull_request]
jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
      - run: npm ci
      - run: npm run lint
      - run: npm run format:check
```

### B6. Create `CONTRIBUTING.md`

Every shared project must have one. Template:

```markdown
# Contributing

## Setup
[how to install and run locally]

## Code Style
- We use [ESLint + Prettier / Black + Ruff / etc.]
- Run `npm run lint` before committing
- Pre-commit hooks are set up automatically via Husky

## Naming Conventions
[reference the table from B4]

## Branching
See version-control skill — branch off `main`, use `feat/`, `fix/`, `chore/` prefixes.

## Pull Requests
- One PR per feature/fix
- Fill out the PR template
- Must pass CI before merging
```

---

## Checklist Before Committing Code

- [ ] Linter passes with zero errors
- [ ] Formatter applied (no unformatted files)
- [ ] Naming matches the codebase conventions
- [ ] No commented-out code left in
- [ ] No debug logs / `console.log` / `print` statements left in
- [ ] Imports ordered and cleaned up
- [ ] Pre-commit hook ran successfully
