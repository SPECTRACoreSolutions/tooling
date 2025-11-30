# SPECTRA Workflow Guide

**Last Updated:** 2025-11-29  
**Status:** Standard templates available  
**Owner:** Infrastructure team

---

## Overview

This directory contains standardised GitHub Actions workflows for all SPECTRA repositories. These templates provide consistent CI/CD patterns, security scanning, and dependency management across the organisation.

### Philosophy

> **Alana does the heavy lifting. Workflows are the guardrails.**

Workflows should:

- ✅ Verify code quality (lint, test, security)
- ✅ Enforce standards (coverage thresholds, no secrets)
- ✅ Deploy to known-good environments
- ❌ NOT generate content (that's Alana's job)
- ❌ NOT perform complex business logic

---

## Available Templates

### 1. Python CI (`ci-python.yml`)

**Purpose:** Comprehensive CI for Python projects

**Features:**

- Linting with Ruff (check + format)
- Testing with pytest (Python 3.11 and 3.12 matrix)
- Code coverage reporting (Codecov + artifacts)
- CodeQL security scanning
- Dependency caching
- Summary job (all checks must pass)

**When to use:**

- Any Python project with tests
- Libraries, services, scripts
- Data engineering projects

**Customization:**

- Adjust Python versions in matrix
- Modify coverage thresholds
- Add/remove optional type checking
- Configure test commands

**Example `package.json` scripts needed:**

```json
{
  "scripts": {
    "lint": "ruff check .",
    "format": "ruff format .",
    "test": "pytest",
    "test:cov": "pytest --cov"
  }
}
```

---

### 2. Node.js/TypeScript CI (`ci-node.yml`)

**Purpose:** Comprehensive CI for JavaScript/TypeScript projects

**Features:**

- Linting with ESLint
- Type checking with TypeScript
- Testing with Jest/Vitest
- Build verification
- Code coverage reporting
- CodeQL security scanning
- NPM audit
- Dependency caching

**When to use:**

- Frontend applications (React, Astro, Vue, etc.)
- Node.js services
- TypeScript libraries

**Customization:**

- Adjust Node version
- Change package manager (npm/yarn/pnpm)
- Modify build commands
- Configure test framework

**Example `package.json` scripts needed:**

```json
{
  "scripts": {
    "lint": "eslint . --ext .ts,.tsx,.js,.jsx",
    "format:check": "prettier --check .",
    "typecheck": "tsc --noEmit",
    "test": "jest",
    "build": "vite build" // or whatever your builder is
  }
}
```

---

### 3. Security Scanning (`security.yml`)

**Purpose:** Standalone comprehensive security scanning

**Features:**

- CodeQL analysis (configurable languages)
- Dependency review (on PRs)
- NPM audit (if Node.js project)
- Pip audit (if Python project)
- Secret scanning (Gitleaks)
- Weekly scheduled scans
- Security summary report

**When to use:**

- Standalone security scanning (separate from CI)
- Weekly security audits
- High-security repositories
- Can complement basic CI workflows

**Customization:**

- Adjust CodeQL languages
- Set severity thresholds
- Configure licence deny-list
- Enable/disable specific scans

---

### 4. Dependabot (`dependabot.yml`)

**Purpose:** Automated dependency updates

**Features:**

- Weekly update checks (Monday 09:00 GMT)
- Grouped updates by type (production/development)
- Framework-specific grouping
- Auto-assignment and labeling
- Conventional commit messages

**When to use:**

- ALL repositories (mandatory)
- Any project with dependencies

**Customization:**

- Adjust update frequency
- Modify grouping strategy
- Change reviewers/assignees
- Add ignore rules

**Supported ecosystems:**

- Python (pip)
- Node.js (npm)
- GitHub Actions
- Docker (optional)
- Terraform (optional)

---

## Quick Start

### For New Repositories

1. **Copy the appropriate CI template:**

```bash
# For Python projects:
cp Core/infrastructure/tooling/workflows/templates/ci-python.yml .github/workflows/ci.yml

# For Node.js projects:
cp Core/infrastructure/tooling/workflows/templates/ci-node.yml .github/workflows/ci.yml
```

2. **Copy the Dependabot config:**

```bash
cp Core/infrastructure/tooling/workflows/templates/dependabot.yml .github/dependabot.yml
```

3. **Optional: Add standalone security scanning:**

```bash
cp Core/infrastructure/tooling/workflows/templates/security.yml .github/workflows/security.yml
```

4. **Customize for your project:**

   - Review Python versions or Node versions
   - Adjust test commands if needed
   - Configure coverage thresholds
   - Update reviewer assignments

5. **Commit and push:**

```bash
git add .github/
git commit -m "chore: add standard CI workflows"
git push
```

---

### For Existing Repositories

1. **Review current workflows:**

```bash
ls -la .github/workflows/
cat .github/workflows/ci.yml  # See what you have
```

2. **Compare with standard templates:**

   - Check for missing features (caching, coverage, matrix testing)
   - Identify broken patterns (continue-on-error, old actions)
   - Note customizations you want to keep

3. **Migrate incrementally:**

   - Option A: Replace entirely (if current workflow is basic)
   - Option B: Merge features (if you have custom requirements)

4. **Test in a branch:**

```bash
git checkout -b chore/standardise-workflows
# Copy templates
# Customize
git commit -m "chore: standardise workflows"
git push origin chore/standardise-workflows
# Open PR and verify CI passes
```

---

## Workflow Architecture

### Standard Pattern

```
.github/
├── workflows/
│   ├── ci.yml           # Main CI (lint, test, build)
│   ├── security.yml     # Optional standalone security
│   └── deploy.yml       # Optional deployment (see Phase 3)
└── dependabot.yml       # Dependency updates
```

### Job Dependencies

```
CI Workflow (ci-python.yml):
  lint
    ↓
  test (matrix)
    ↓
  security (CodeQL)
    ↓
  ci-success (summary)

CI Workflow (ci-node.yml):
  lint
    ↓
  ├─→ typecheck
  └─→ test
       ↓
     build
       ↓
     security (CodeQL)
       ↓
     ci-success (summary)
```

### When Jobs Run

| Trigger                   | Runs                            |
| ------------------------- | ------------------------------- |
| `push` to main/dev        | All jobs (lint, test, security) |
| `pull_request`            | All jobs                        |
| `workflow_dispatch`       | Manual trigger (all jobs)       |
| `schedule` (security.yml) | Weekly Monday 09:00 UTC         |

---

## Configuration

### Required Secrets

**Repository Secrets:**

- `CODECOV_TOKEN` - For coverage reporting (optional but recommended)
- `RAILWAY_TOKEN` - For deployments (Phase 3)

**organisation Secrets (already configured):**

- `SPECTRA_GITHUB_APP_ID`
- `SPECTRA_GITHUB_APP_PRIVATE_KEY`
- `SPECTRA_FABRIC_CLIENT_ID`
- (See Vault for full list)

### Required Permissions

**Workflow permissions** (Settings → Actions → General):

- Read repository contents: ✅
- Read and write permissions: ✅ (for coverage/artifacts)

**Security permissions:**

- Code scanning alerts: ✅
- Dependabot alerts: ✅
- Secret scanning: ✅

### Branch Protection

**Recommended settings for `main` branch:**

- Require PR before merging: ✅
- Require status checks: ✅
  - `CI Success` or `ci-success`
  - `lint`
  - `test`
- Require branches to be up to date: ✅
- Require conversation resolution: ✅
- No force pushes: ✅
- No deletions: ✅

---

## Best Practices

### DO:

✅ **Use semantic versioning for reusable workflows**

```yaml
uses: SPECTRACoreSolutions/infrastructure/.github/workflows/ci.yml@v1
```

✅ **Pin actions to major versions**

```yaml
- uses: actions/checkout@v4 # Pin to v4, auto-update to v4.x
```

✅ **Use caching for dependencies**

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
```

✅ **Fail fast on security issues**

```yaml
- name: Perform CodeQL Analysis
  uses: github/codeql-action/analyse@v3
  # No continue-on-error!
```

✅ **Use matrix testing for libraries**

```yaml
strategy:
  matrix:
    python-version: ["3.11", "3.12"]
```

✅ **Document workflow requirements in README**

```markdown
## CI/CD

This project uses standard SPECTRA workflows:

- Linting: Ruff
- Testing: pytest with coverage
- Security: CodeQL
- Dependencies: Dependabot (weekly)
```

---

### DON'T:

❌ **Generate content in workflows**

```yaml
# BAD: Workflows shouldn't generate docs/context
- name: Generate docs
  run: python scripts/generate_docs.py
```

_Use Alana for content generation instead_

❌ **Store secrets in workflow files**

```yaml
# BAD:
env:
  API_KEY: abc123
```

_Use GitHub Secrets instead_

❌ **Use continue-on-error to hide problems**

```yaml
# BAD:
- name: Security scan
  run: security-tool scan
  continue-on-error: true
```

_Fix the issue or adjust thresholds_

❌ **Run workflows on every commit**

```yaml
# BAD: Wasteful
on: [push]
```

_Use branch filters and path filters_

❌ **Copy-paste workflows**
_Use templates and reusable workflows instead_

❌ **Mix CI and CD in one file**
_Separate concerns: ci.yml, deploy.yml_

❌ **Ignore workflow failures**
_If it's failing, either fix it or remove it_

---

## Troubleshooting

### Common Issues

#### 1. CodeQL Fails with "No Code to analyse"

**Cause:** Language not detected or empty project

**Fix:**

```yaml
- name: Initialize CodeQL
  uses: github/codeql-action/init@v3
  with:
    languages: python # Explicitly specify language
```

#### 2. Coverage Upload Fails

**Cause:** Missing CODECOV_TOKEN or wrong file path

**Fix:**

```yaml
- uses: codecov/codecov-action@v4
  with:
    files: ./coverage.xml # Check path is correct
    fail_ci_if_error: false # Don't block PR on upload failure
```

#### 3. Cache Not Working

**Cause:** Cache key doesn't match or path is wrong

**Fix:**

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip # Verify path for your OS
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
    # Must include hashFiles for auto-invalidation
```

#### 4. Matrix Jobs All Fail

**Cause:** Dependency installation failing

**Fix:**

```yaml
- name: Install dependencies
  run: |
    # Try multiple patterns
    pip install -r requirements.txt || true
    pip install -e . || pip install .
```

#### 5. Dependabot PRs Not Created

**Cause:** Permissions or configuration issue

**Check:**

- Dependabot alerts enabled in repo settings
- No conflicting ignore rules
- Reviewer teams exist and have access
- `open-pull-requests-limit` not reached

---

## Migration Checklist

Use this checklist when migrating a repository to standard workflows:

### Pre-Migration

- [ ] Review existing `.github/workflows/` files
- [ ] Document any custom requirements or integrations
- [ ] Check for hardcoded secrets (move to GitHub Secrets)
- [ ] Note any special build/test commands

### Migration

- [ ] Create branch: `git checkout -b chore/standardise-workflows`
- [ ] Copy appropriate CI template (`ci-python.yml` or `ci-node.yml`)
- [ ] Copy `dependabot.yml` template
- [ ] Optional: Copy `security.yml` if needed
- [ ] Customize for project-specific needs
- [ ] Update README with CI badge and documentation
- [ ] Delete obsolete workflow files
- [ ] Commit: `git commit -m "chore: standardise workflows"`

### Testing

- [ ] Push branch and open PR
- [ ] Verify all CI jobs run and pass
- [ ] Check artifacts are uploaded correctly
- [ ] Verify coverage reports display properly
- [ ] Test Dependabot by manually triggering (Settings → Dependabot → Check for updates)

### Post-Migration

- [ ] Merge PR
- [ ] Update branch protection rules to require new status checks
- [ ] Monitor first few workflow runs
- [ ] Document any custom changes in repo's README
- [ ] Update team documentation

---

## Performance optimisation

### Reduce CI Time

**1. Use caching:**

```yaml
- uses: actions/cache@v4
  with:
    path: ~/.cache/pip
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements.txt') }}
```

_Saves 30-60 seconds per run_

**2. Run jobs in parallel:**

```yaml
jobs:
  lint:
  test:
    needs: lint # Run after lint, but parallel to others
  typecheck:
    needs: lint # Also runs parallel to test
```

**3. Use path filters:**

```yaml
on:
  push:
    branches: [main]
    paths:
      - "src/**"
      - "tests/**"
      - "requirements.txt"
```

_Skips CI when only docs change_

**4. Skip redundant steps:**

```yaml
- name: Run tests
  if: github.event_name != 'schedule' # Skip in scheduled runs
```

**5. Use GitHub Actions cache service:**

```yaml
- uses: actions/setup-python@v5
  with:
    python-version: "3.12"
    cache: "pip" # Built-in caching
```

---

## Cost Monitoring

### GitHub Actions Minutes

**Free tier (per month):**

- Public repos: Unlimited
- Private repos: 2,000 minutes

**Current usage:**

- Check: Settings → Billing → Actions minutes
- Estimate: ~15-30 minutes per workflow run
- Target: <300 minutes/month per repo

**optimisation tips:**

1. Use `if` conditions to skip unnecessary jobs
2. Cache dependencies aggressively
3. Run expensive jobs (security) weekly, not on every commit
4. Use `pull_request` triggers instead of `push` where possible

---

## Examples

### Example: Python Data Project

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
    paths:
      - "**.py"
      - "requirements*.txt"
      - "pyproject.toml"
  pull_request:

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
          cache: "pip"
      - run: pip install ruff
      - run: ruff check .

  test:
    needs: lint
    runs-on: ubuntu-latest
    strategy:
      matrix:
        python-version: ["3.11", "3.12"]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: "pip"
      - run: pip install -e .[dev]
      - run: pytest --cov
      - uses: codecov/codecov-action@v4
        if: matrix.python-version == '3.12'
```

### Example: Astro Frontend

```yaml
# .github/workflows/ci.yml
name: CI

on:
  push:
    branches: [main]
  pull_request:

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"
      - run: npm ci
      - run: npm run lint

  build:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"
      - run: npm ci
      - run: npm run build
      - uses: actions/upload-artifact@v4
        with:
          name: dist
          path: dist/
```

---

## Next Steps

### Phase 3: CD Workflows (Week 2)

- Railway deployment templates
- Deployment verification
- Rollback strategies

### Phase 4: Enhanced Security (Week 3)

- Advanced CodeQL queries
- Custom security policies
- Compliance reporting

---

## Support

**Questions?**

- Check this guide first
- Review template comments
- Ask in #engineering Slack channel
- Ping @infrastructure team

**Issues?**

- Open issue in infrastructure repo
- Include workflow run logs
- Tag as `workflow` or `ci`

**Improvements?**

- Suggest via PR to infrastructure repo
- Update this guide with learnings
- Share patterns that work well

---

## Changelog

### 2025-11-29 - Initial Release

- Created standard Python CI template
- Created standard Node.js CI template
- Created security scanning template
- Created Dependabot configuration
- Published workflow guide

---

_This guide is part of the workflow standardisation initiative documented in `WORKFLOWS-ASSESSMENT-2025-11-29.md`_

