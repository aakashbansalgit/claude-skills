# CI/CD & Automation Skill

Use this skill when the user is:
- Setting up a CI/CD pipeline on a new or existing project
- Wanting automated testing, linting, or builds on every PR/push
- Setting up automated deployments to any platform
- Adding automation tasks (dependency updates, PR labeling, scheduled jobs)
- Asking about GitHub Actions, pipelines, or deployment workflows

---

## Step 1: Detect Project Type

Before creating any pipeline, read the project to identify:

1. **Language/runtime** — check for `package.json` (Node), `pyproject.toml`/`requirements.txt` (Python), `go.mod` (Go), `Cargo.toml` (Rust), `Gemfile` (Ruby)
2. **Framework** — Next.js, FastAPI, Django, Express, etc.
3. **Test runner** — Jest, Pytest, Go test, RSpec, etc.
4. **Existing CI** — check `.github/workflows/`, `Jenkinsfile`, `.circleci/`, `.gitlab-ci.yml`
5. **Deployment target** — Vercel, Netlify, AWS, Railway, Fly.io, Docker, VPS

Never overwrite existing CI workflows without asking. Extend them instead.

---

## Step 2: CI Pipeline (runs on every push + PR)

Create `.github/workflows/ci.yml`

### Node.js / TypeScript

```yaml
name: CI

on:
  push:
    branches: [main, dev]
  pull_request:
    branches: [main, dev]

jobs:
  ci:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        node-version: [18, 20]

    steps:
      - uses: actions/checkout@v4

      - name: Set up Node ${{ matrix.node-version }}
        uses: actions/setup-node@v4
        with:
          node-version: ${{ matrix.node-version }}
          cache: npm

      - name: Install dependencies
        run: npm ci

      - name: Lint
        run: npm run lint

      - name: Format check
        run: npm run format:check

      - name: Type check
        run: npm run type-check
        if: hashFiles('tsconfig.json') != ''

      - name: Run tests
        run: npm test -- --coverage

      - name: Build
        run: npm run build
```

### Python

```yaml
name: CI

on:
  push:
    branches: [main, dev]
  pull_request:
    branches: [main, dev]

jobs:
  ci:
    runs-on: ubuntu-latest

    strategy:
      matrix:
        python-version: ["3.11", "3.12"]

    steps:
      - uses: actions/checkout@v4

      - name: Set up Python ${{ matrix.python-version }}
        uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: pip

      - name: Install dependencies
        run: |
          pip install --upgrade pip
          pip install -r requirements.txt
          pip install -r requirements-dev.txt

      - name: Lint (ruff)
        run: ruff check .

      - name: Format check (black)
        run: black --check .

      - name: Type check (mypy)
        run: mypy .
        if: hashFiles('mypy.ini') != '' || hashFiles('pyproject.toml') != ''

      - name: Run tests
        run: pytest --cov --cov-report=xml

      - name: Upload coverage
        uses: codecov/codecov-action@v4
        with:
          file: ./coverage.xml
```

### Go

```yaml
name: CI

on:
  push:
    branches: [main, dev]
  pull_request:
    branches: [main, dev]

jobs:
  ci:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v4

      - name: Set up Go
        uses: actions/setup-go@v5
        with:
          go-version-file: go.mod
          cache: true

      - name: Lint
        uses: golangci/golangci-lint-action@v4

      - name: Run tests
        run: go test ./... -v -race -coverprofile=coverage.out

      - name: Build
        run: go build ./...
```

---

## Step 3: CD Pipeline (deploy on merge to main)

Create `.github/workflows/deploy.yml`

### Vercel

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci
      - run: npm run build
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: --prod
```

### Netlify

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: 20
          cache: npm
      - run: npm ci && npm run build
      - uses: nwtgck/actions-netlify@v3
        with:
          publish-dir: ./dist
          production-branch: main
          github-token: ${{ secrets.GITHUB_TOKEN }}
          deploy-message: "Deploy from GitHub Actions"
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}
```

### Docker + any VPS/cloud

```yaml
name: Deploy

on:
  push:
    branches: [main]

jobs:
  build-and-push:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4

      - name: Log in to Docker Hub
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKER_USERNAME }}
          password: ${{ secrets.DOCKER_PASSWORD }}

      - name: Build and push image
        uses: docker/build-push-action@v5
        with:
          context: .
          push: true
          tags: |
            ${{ secrets.DOCKER_USERNAME }}/${{ github.event.repository.name }}:latest
            ${{ secrets.DOCKER_USERNAME }}/${{ github.event.repository.name }}:${{ github.sha }}

  deploy:
    needs: build-and-push
    runs-on: ubuntu-latest
    steps:
      - name: Deploy via SSH
        uses: appleboy/ssh-action@v1
        with:
          host: ${{ secrets.SERVER_HOST }}
          username: ${{ secrets.SERVER_USER }}
          key: ${{ secrets.SERVER_SSH_KEY }}
          script: |
            docker pull ${{ secrets.DOCKER_USERNAME }}/${{ github.event.repository.name }}:latest
            docker stop app || true
            docker rm app || true
            docker run -d --name app -p 80:3000 \
              --env-file /etc/app/.env \
              ${{ secrets.DOCKER_USERNAME }}/${{ github.event.repository.name }}:latest
```

### Railway / Fly.io

These platforms auto-deploy on push to `main` — no workflow needed. Just connect the GitHub repo in the platform dashboard.

---

## Step 4: Automation Tasks

### Dependabot — automatic dependency updates

Create `.github/dependabot.yml`:

```yaml
version: 2
updates:
  - package-ecosystem: npm          # or pip, gomod, cargo, bundler
    directory: /
    schedule:
      interval: weekly
      day: monday
      time: "09:00"
    open-pull-requests-limit: 5
    labels:
      - dependencies
    commit-message:
      prefix: "chore(deps)"

  - package-ecosystem: github-actions
    directory: /
    schedule:
      interval: monthly
```

### Auto-label PRs

Create `.github/workflows/labeler.yml`:

```yaml
name: Label PRs

on:
  pull_request:
    types: [opened, synchronize]

jobs:
  label:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/labeler@v5
        with:
          repo-token: ${{ secrets.GITHUB_TOKEN }}
```

Create `.github/labeler.yml`:

```yaml
feature:
  - head-branch: ["^feat/", "^feature/"]
bug:
  - head-branch: ["^fix/", "^bugfix/"]
chore:
  - head-branch: ["^chore/"]
documentation:
  - changed-files:
    - any-glob-to-any-file: ["**.md", "docs/**"]
```

### Stale issue/PR closer

```yaml
name: Close stale issues and PRs

on:
  schedule:
    - cron: "0 9 * * 1"   # Every Monday at 9am

jobs:
  stale:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/stale@v9
        with:
          stale-issue-message: "This issue has been inactive for 30 days. It will be closed in 7 days unless there is new activity."
          stale-pr-message: "This PR has been inactive for 30 days. It will be closed in 7 days unless there is new activity."
          days-before-stale: 30
          days-before-close: 7
          stale-issue-label: stale
          stale-pr-label: stale
```

---

## Step 5: Secrets Setup

After creating workflows, tell the user exactly which secrets to add in GitHub:
**Settings → Secrets and variables → Actions → New repository secret**

Common secrets by deployment target:

| Platform | Required secrets |
|----------|-----------------|
| Vercel | `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID` |
| Netlify | `NETLIFY_AUTH_TOKEN`, `NETLIFY_SITE_ID` |
| Docker Hub | `DOCKER_USERNAME`, `DOCKER_PASSWORD` |
| VPS/SSH | `SERVER_HOST`, `SERVER_USER`, `SERVER_SSH_KEY` |
| AWS | `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY` |

Always list the exact secrets needed after generating workflows so the user knows what to add.

---

## Step 6: Branch Protection + Required Status Checks

After CI is set up, enforce it on `main` so no PR can merge unless CI passes:

```bash
gh api repos/{owner}/{repo}/branches/main/protection \
  --method PUT \
  --field 'required_status_checks={"strict":true,"contexts":["ci"]}' \
  --field enforce_admins=false \
  --field 'required_pull_request_reviews={"required_approving_review_count":1}' \
  --field restrictions=null
```

Replace `"ci"` with the exact job name from the workflow file.

---

## Checklist

- [ ] `.github/workflows/ci.yml` created and tested
- [ ] `.github/workflows/deploy.yml` created (if deploying)
- [ ] `.github/dependabot.yml` created
- [ ] All required secrets added to GitHub repo settings
- [ ] Branch protection updated to require CI job to pass
- [ ] CI passes on first run (check Actions tab)
