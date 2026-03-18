# Version Control Skill

Use this skill when the user is:
- Starting a new project that needs version control set up
- Working on a project that will be shared on GitHub
- Asking about branching, commits, PRs, or git workflows
- Wanting to enforce good version control practices on an existing project

---

## 1. Initializing a Project

When setting up version control on a new or existing project:

1. Run `git init` if not already a repo
2. Create a `.gitignore` appropriate for the project's language/framework (use `gh` or a template)
3. Create an initial commit with the baseline code
4. Create the GitHub repo: `gh repo create <name> --public|--private --source=. --remote=origin --push`
5. Protect the `main` branch (see Section 4)

---

## 2. Branching Strategy

Always enforce this model for shared repos:

- `main` — production-ready, protected. Never commit directly.
- `dev` (optional) — integration branch for ongoing work
- `feature/<short-description>` — one branch per feature or task
- `fix/<short-description>` — bug fixes
- `chore/<short-description>` — non-functional changes (deps, config, docs)

**Creating a branch:**
```bash
git checkout -b feature/my-feature
```

**Rules:**
- Branch off `main` (or `dev` if present) — never off another feature branch
- Delete branches after merging: `git branch -d feature/my-feature`
- Keep branches short-lived (days, not weeks)

---

## 3. Commit Hygiene

Every commit must be:

- **Atomic** — one logical change per commit
- **Descriptive** — follow Conventional Commits format:

```
<type>(<scope>): <short summary>

[optional body — what changed and why]
```

Types: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`, `style`, `ci`

Examples:
```
feat(auth): add JWT refresh token support
fix(api): handle null response from /users endpoint
chore(deps): upgrade axios to 1.6.0
```

**Never commit:**
- Secrets, API keys, `.env` files
- Build artifacts, `node_modules/`, compiled binaries
- Large binary files (use Git LFS or storage services instead)

---

## 4. Branch Protection (Shared Repos)

After creating a GitHub repo, set up branch protection on `main`:

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --field required_status_checks='{"strict":true,"contexts":[]}' \
  --field enforce_admins=false \
  --field required_pull_request_reviews='{"required_approving_review_count":1}' \
  --field restrictions=null
```

This enforces:
- PRs required to merge into `main`
- At least 1 approving review
- No direct pushes to `main`

---

## 5. Pull Request Workflow

For every feature/fix:

1. Push branch: `git push -u origin feature/my-feature`
2. Open PR: `gh pr create --title "..." --body "..."`
3. PR body must include:
   - **What changed** (bullet points)
   - **Why** (motivation or linked issue)
   - **Test plan** (how to verify it works)
   - **Screenshots** (if UI changes)
4. Request review from collaborators
5. Merge only after approval — prefer **Squash and Merge** for clean history
6. Delete the branch after merge

**PR title format:** same as commit format — `feat(scope): summary`

---

## 6. Tagging & Releases

For versioned projects:

- Use semantic versioning: `MAJOR.MINOR.PATCH`
- Tag releases: `git tag -a v1.0.0 -m "Release v1.0.0"`
- Push tags: `git push origin --tags`
- Create GitHub releases: `gh release create v1.0.0 --notes "..."`

---

## 7. Collaborator Setup

When adding collaborators to a shared repo:

```bash
gh api repos/{owner}/{repo}/collaborators/{username} --method PUT --field permission=push
```

Permissions: `pull` (read), `push` (write), `maintain`, `admin`

Recommend setting up:
- A `CONTRIBUTING.md` explaining the branching/PR workflow
- Issue and PR templates in `.github/`

---

## 8. Keeping Forks & Branches in Sync

```bash
# Sync local main with remote
git checkout main && git pull origin main

# Rebase feature branch onto latest main
git checkout feature/my-feature
git rebase main

# If conflicts arise, resolve then:
git rebase --continue
```

Prefer **rebase over merge** for feature branches to keep history linear.

---

## 9. Recovering from Mistakes

| Situation | Fix |
|-----------|-----|
| Committed to wrong branch | `git cherry-pick <hash>` onto correct branch, then `git reset HEAD~1` on wrong one |
| Committed a secret | Remove with `git filter-repo`, rotate the secret immediately |
| Need to undo last commit (not pushed) | `git reset --soft HEAD~1` |
| Need to undo last commit (pushed) | `git revert HEAD` and push the revert |
| Merge conflict | Resolve files, `git add`, then `git merge --continue` or `git rebase --continue` |

**Never force-push to `main`.** For other branches, force-push is acceptable after a rebase: `git push --force-with-lease`.

---

## 10. Checklist Before Merging

- [ ] Branch is up to date with `main` (rebased or merged)
- [ ] All tests pass
- [ ] No secrets or large files committed
- [ ] PR has a clear description
- [ ] At least 1 reviewer approved
- [ ] CI checks are green
