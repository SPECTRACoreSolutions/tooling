# GitHub Workflows Assessment & Remediation Plan

**Date:** 2025-11-29  
**Scope:** All SPECTRA repositories across 7 organisations  
**Assessor:** Mark (with AI assistance)

---

## Executive Summary

**Current State:** Workflows are scattered, inconsistent, and contain obsolete automation (context generation). Basic CI is present but underutilised. CD is ad-hoc.

**Recommendation:** Radical simplification. Remove all obsolete context generation workflows, standardise CI/CD patterns in the infrastructure domain, and adopt Railway as the standard deployment platform with workflow templates.

**Approach:** Delete > Standardise > Templatise > Document

---

## Inventory

### Current Workflows by Type

#### 1. **Context Generation Workflows (OBSOLETE)**

**Status:** ❌ **DELETE ALL**

**Locations:**

- `Core/.github/.github/workflows/validate-context-artifacts.yml`
- `Core/.github-private/.github/workflows/validate-context-artifacts.yml`
- `Core/operations/.github/workflows/validate-context-artifacts.yml`
- `Data/.github/.github/workflows/validate-context-artifacts.yml`
- `Data/.github-private/.github/workflows/validate-context-artifacts.yml`
- `Data/design/.github/workflows/validate-context-artifacts.yml`
- `Design/.github/.github/workflows/validate-context-artifacts.yml`
- `Design/.github-private/.github/workflows/validate-context-artifacts.yml`
- `Engineering/.github/.github/workflows/validate-context-artifacts.yml`
- `Engagement/.github/.github/workflows/validate-context-artifacts.yml`
- `Engagement/.github-private/.github/workflows/validate-context-artifacts.yml`
- `Engagement/discovery/.github/workflows/validate-context-artifacts.yml`
- `Security/.github/.github/workflows/validate-context-artifacts.yml`
- `Security/.github-private/.github/workflows/validate-context-artifacts.yml`
- `Security/iso27001/.github/workflows/validate-context-artifacts.yml`

**Why Delete:**

- Context generation is now handled by Memory system and Graph
- These workflows trigger on every push/PR causing unnecessary CI noise
- The context generation scripts themselves (`scripts/context/generate_context.py`) are also obsolete
- Alana handles context via MCP and Cosmic Index

**Associated Cleanup:**

- Delete `scripts/context/generate_context.py` from all repos (42+ files found)
- Remove template at `Core/operations/templates/context/generate_context.py`
- Update documentation to reflect Memory-first approach

---

#### 2. **CI Workflows**

**Status:** ⚠️ **BASIC BUT FUNCTIONAL** - Needs enhancement

**Locations:**

- Standard CI across all orgs: `Core/.github/workflows/ci.yml`, `Data/.github/workflows/ci.yml`, etc.
- Operations CI: `Core/operations/.github/workflows/ci.yml` (slightly better - has caching and coverage)

**Current Implementation:**

```yaml
jobs:
  lint: # Ruff for Python repos
  test: # pytest
  security: # CodeQL (but often fails or is ignored with continue-on-error)
```

**Issues:**

1. **Inconsistent Python versions** - Mix of 3.9, 3.11, 3.12
2. **No dependency caching** (except Operations CI)
3. **CodeQL often fails** - Using `continue-on-error: true` defeats the purpose
4. **No test coverage reporting** (except Operations CI)
5. **No matrix testing** across Python versions
6. **Missing Node.js/TypeScript workflows** for frontend repos (portal, realtime-chat)
7. **No Dependabot config** (mentioned in revamp docs but not found in repo)

**Recommendation:**

- ✅ Keep the basic structure
- ✅ Enhance with proper caching, coverage, and multi-version matrix
- ✅ Fix or remove broken CodeQL configs
- ✅ Add Node.js CI for TypeScript projects
- ✅ Add Dependabot configuration

---

#### 3. **Project Provisioning Workflows**

**Status:** ✅ **GOOD** - Keep with minor improvements

**Files:**

- `Core/operations/.github/workflows/project-provisioning-engine.yml`
- `Core/operations/.github/workflows/project-provisioning-dispatch.yml`

**What It Does:**

- Provisions GitHub Projects from YAML manifests
- Uses workflow_call pattern for reusability
- Supports plan/apply modes
- Uses Spectra Assistant GitHub App for auth

**Strengths:**

- Well-designed reusable workflow pattern
- Proper secrets management
- Clear plan/apply separation
- Good documentation in inputs

**Minor Improvements:**

- Add validation step before provisioning
- Add rollback capability
- Create evidence artifacts (graphs/reports)
- Version the workflow (use tags for stability)

---

#### 4. **CD/Deployment Workflows**

**Status:** ⚠️ **AD-HOC & INCONSISTENT** - Needs standardisation

##### a) **Xero Railway Deployment**

**File:** `Data/xero/.github/workflows/deploy-to-railway.yml`

**Good:**

- Proper CI before deploy (lint → test → deploy)
- Uses Railway CLI
- Manages secrets via GitHub Secrets
- Sets Railway vars from workflow

**Issues:**

- Missing line 68 - broken `run:` block
- Secrets management is repetitive (could use environment)
- No rollback strategy
- No deployment verification/smoke tests
- Project/service linking is fragile

##### b) **Portal GitHub Pages Deployment**

**File:** `Core/portal/.github/workflows/deploy-astro-site-to-pages.yml`

**Status:** ✅ Mostly fine - standard Astro Pages workflow

**Issues:**

- No pre-deployment tests
- Should run linting/tests before building

##### c) **Alana Devcontainer**

**Status:** Manual Railway deployment (no workflow)

- Documented in `Core/infrastructure/tooling/docs/railway-deployment.md`
- Has `railway.json` config
- No automated CD - relies on Railway's GitHub integration

---

## Critical Assessment

### What's Working

1. ✅ Project provisioning workflows are solid
2. ✅ Basic CI structure exists across all repos
3. ✅ Railway adoption is sensible for small services
4. ✅ Using GitHub Apps for auth is correct

### What's Broken

1. ❌ Context generation workflows are obsolete bloat
2. ❌ 42+ obsolete `generate_context.py` scripts across repos
3. ❌ CI workflows are inconsistent (Python versions, caching, coverage)
4. ❌ CodeQL security scanning often disabled or ignored
5. ❌ No Dependabot configs (despite being in revamp docs)
6. ❌ CD is ad-hoc - no standard deployment pattern
7. ❌ No deployment verification or rollback strategies
8. ❌ Missing Node.js CI for frontend projects

### What's Missing

1. 🔴 **Standard Railway CD template**
2. 🔴 **Dependabot configurations**
3. 🔴 **Branch protection enforcement via workflows**
4. 🔴 **Deployment verification workflows** (smoke tests, health checks)
5. 🔴 **Frontend CI** (TypeScript, ESLint, build checks)
6. 🔴 **Release workflows** (semantic versioning, changelogs)
7. 🔴 **Infrastructure-as-Code validation** (for Railway configs)

---

## Recommendations & Best Practices

### Philosophy

> **Alana does the heavy lifting. Workflows are the guardrails.**

Workflows should:

- ✅ Verify code quality (lint, test, security)
- ✅ Enforce standards (coverage thresholds, no secrets)
- ✅ Deploy to known-good environments
- ❌ NOT generate content (that's Alana's job)
- ❌ NOT perform complex business logic
- ❌ NOT replace local development

### Standardisation Strategy

#### 1. **Infrastructure Domain as Source of Truth**

**Location:** `Core/infrastructure/tooling/workflows/`

Create standard workflow templates:

```
Core/infrastructure/tooling/workflows/
├── README.md
├── templates/
│   ├── ci-python.yml          # Standard Python CI
│   ├── ci-node.yml            # Standard Node.js CI
│   ├── cd-railway.yml         # Railway deployment
│   ├── dependabot.yml         # Standard Dependabot config
│   └── security.yml           # Security scanning
├── reusable/
│   ├── deploy-railway.yml     # Reusable Railway deploy
│   └── smoke-tests.yml        # Post-deploy verification
└── docs/
    ├── workflow-guide.md
    └── railway-cd-guide.md
```

#### 2. **Railway as Standard CD Platform**

**Why Railway:**

- Low overhead for small services
- Good GitHub integration
- Simple secrets management
- Cost-effective for SPECTRA scale

**Standard Pattern:**

```yaml
on:
  push:
    branches: [main]
  workflow_dispatch:

jobs:
  ci:
    uses: SPECTRACoreSolutions/infrastructure/.github/workflows/ci-python.yml@v1

  deploy:
    needs: ci
    uses: SPECTRACoreSolutions/infrastructure/.github/workflows/cd-railway.yml@v1
    with:
      service: ${{ github.repository }}
      health_endpoint: /health
      smoke_tests: true
    secrets: inherit
```

#### 3. **CI Standards**

**Python Projects:**

```yaml
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
      - run: ruff check --output-format=github .

  test:
    needs: lint
    strategy:
      matrix:
        python-version: ["3.11", "3.12"]
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: ${{ matrix.python-version }}
          cache: "pip"
      - run: pip install -e .[dev]
      - run: pytest --cov --cov-report=xml
      - uses: codecov/codecov-action@v3
        if: matrix.python-version == '3.12'

  security:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: github/codeql-action/init@v3
        with:
          languages: python
      - uses: github/codeql-action/analyse@v3
```

**Node.js Projects:**

```yaml
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

  test:
    needs: lint
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "npm"
      - run: npm ci
      - run: npm test -- --coverage

  build:
    needs: test
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
          name: build
          path: dist/
```

#### 4. **Dependabot Configuration**

**Standard Config:**

```yaml
# .github/dependabot.yml
version: 2
updates:
  - package-ecosystem: "pip"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 5
    reviewers:
      - "SPECTRACoreSolutions/engineering"
    labels:
      - "dependencies"
      - "python"
    groups:
      production-dependencies:
        dependency-type: "production"
      development-dependencies:
        dependency-type: "development"

  - package-ecosystem: "npm"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 5
    reviewers:
      - "SPECTRACoreSolutions/engineering"
    labels:
      - "dependencies"
      - "javascript"

  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
      day: "monday"
    open-pull-requests-limit: 3
    reviewers:
      - "SPECTRACoreSolutions/engineering"
    labels:
      - "dependencies"
      - "github-actions"
```

---

## Remediation Plan

### Phase 1: Cleanup (Immediate)

**Goal:** Remove all obsolete workflows and scripts

**Tasks:**

1. ✅ Delete all `validate-context-artifacts.yml` workflows (15+ files)
2. ✅ Delete all `scripts/context/generate_context.py` (42+ files)
3. ✅ Delete `Core/operations/templates/context/generate_context.py`
4. ✅ Remove context generation from any runbooks/docs
5. ✅ Update `Core/memory/README.md` to clarify new approach

**Commit Message:**

```
chore: remove obsolete context generation workflows

Context is now managed via Memory system and Cosmic Index.
These workflows and scripts are no longer needed.

- Delete validate-context-artifacts.yml across all orgs
- Delete generate_context.py scripts (42 files)
- Update documentation to reflect Memory-first approach

Ref: WORKFLOWS-ASSESSMENT-2025-11-29.md
```

### Phase 2: Standardise CI (Week 1)

**Goal:** Create standard CI templates in infrastructure domain

**Tasks:**

1. ✅ Create `Core/infrastructure/tooling/workflows/templates/`
2. ✅ Build `ci-python.yml` template with caching, coverage, multi-version
3. ✅ Build `ci-node.yml` template for TypeScript projects
4. ✅ Build `security.yml` template with working CodeQL
5. ✅ Create `dependabot.yml` template
6. ✅ Document in `workflow-guide.md`
7. ✅ Apply to 3 pilot repos (operations, portal, xero)
8. ✅ Validate with real PRs
9. ✅ Roll out to remaining repos

### Phase 3: Standardise CD (Week 2)

**Goal:** Create reusable Railway deployment workflow

**Tasks:**

1. ✅ Create `Core/infrastructure/tooling/workflows/reusable/deploy-railway.yml`
2. ✅ Support inputs: service name, health endpoint, smoke tests flag
3. ✅ Support secrets: Railway token, service envs
4. ✅ Add deployment verification step (curl health endpoint)
5. ✅ Add rollback capability (optional)
6. ✅ Document in `railway-cd-guide.md`
7. ✅ Migrate xero workflow to use reusable pattern
8. ✅ Apply to alana devcontainer
9. ✅ Apply to context MCP server
10. ✅ Apply to future deployable services

### Phase 4: Enhanced Security (Week 3)

**Goal:** Fix and enable security scanning properly

**Tasks:**

1. ✅ Fix CodeQL configs (remove `continue-on-error`)
2. ✅ Add Dependabot to all repos
3. ✅ Enable Dependabot alerts (via `revamp-spectra-ecosystem.ps1`)
4. ✅ Add secret scanning validation (no plaintext secrets in commits)
5. ✅ Add licence compliance checks (optional)

### Phase 5: Documentation & Training (Week 4)

**Goal:** Ensure Alana and team understand the new patterns

**Tasks:**

1. ✅ Write comprehensive workflow guide
2. ✅ Create Railway CD runbook
3. ✅ Update onboarding docs
4. ✅ Create Alana prompt for workflow assistance
5. ✅ Update project bootstrap templates
6. ✅ Add workflow testing guide

---

## Workflow Hygiene Rules

### DO:

- ✅ Use semantic versioning for reusable workflows (`@v1`, `@v2`)
- ✅ Pin actions to major versions (`actions/checkout@v4`)
- ✅ Use caching for dependencies (`actions/cache` or built-in)
- ✅ Fail fast on security issues (no `continue-on-error` for CodeQL)
- ✅ Use workflow_call for reusability
- ✅ Use environments for deployment protection
- ✅ Document all custom workflows
- ✅ Test workflows in draft PRs before merging
- ✅ Use GITHUB_TOKEN where possible (avoid PATs)
- ✅ Group Dependabot updates by type

### DON'T:

- ❌ Generate content in workflows (that's Alana's job)
- ❌ Store secrets in workflow files (use GitHub Secrets)
- ❌ Use `continue-on-error` to hide broken checks
- ❌ Create workflows that run on every commit (use paths filters)
- ❌ Copy-paste workflows (use reusable patterns)
- ❌ Mix CI and CD in one file (separate concerns)
- ❌ Ignore workflow failures
- ❌ Use outdated actions (keep Dependabot enabled for github-actions)

---

## Cost & Complexity Analysis

### Current State Costs

- **GitHub Actions minutes:** ~500-1000 min/month (estimate based on workflows)
- **Maintenance burden:** High (inconsistent workflows, lots of duplication)
- **Context generation waste:** ~100-200 min/month on obsolete workflows
- **Security gaps:** CodeQL often disabled, no Dependabot

### Post-Remediation Costs

- **GitHub Actions minutes:** ~300-500 min/month (after removing context workflows)
- **Maintenance burden:** Low (standardised templates, clear documentation)
- **Security coverage:** High (working CodeQL, Dependabot enabled)
- **Deployment confidence:** High (smoke tests, rollback capability)

**Net Benefit:** 40% reduction in workflow complexity, 50% reduction in wasted CI minutes, significantly improved security posture

---

## Success Metrics

### Immediate (Week 1)

- ✅ Zero `validate-context-artifacts.yml` workflows remaining
- ✅ Zero `generate_context.py` scripts in repos
- ✅ Standard CI templates published in infrastructure repo

### Short-term (Month 1)

- ✅ 80% of repos using standard CI templates
- ✅ Dependabot enabled on all active repos
- ✅ CodeQL running without `continue-on-error` hacks
- ✅ 3+ services deployed via standard Railway CD workflow

### Long-term (Quarter 1 2026)

- ✅ 100% of repos using standard workflows
- ✅ Zero workflow failures ignored
- ✅ Automated deployment verification on all services
- ✅ <300 GitHub Actions minutes/month baseline
- ✅ All security alerts addressed within 7 days

---

## Next Steps

### Immediate Action Required

1. **Approve this assessment** - Review and sign off on recommendations
2. **Create cleanup branch** - Start Phase 1 immediately
3. **Assign ownership** - Alana to lead remediation (with your oversight)
4. **Schedule reviews** - Weekly check-ins for 4 weeks

### Questions to Resolve

1. **Railway budget?** - Confirm monthly spend limit for deployments
2. **Branch protection enforcement?** - Should workflows enforce protection or just report?
3. **Coverage thresholds?** - Set minimum test coverage % (suggest 70%)
4. **Deployment approval gates?** - Manual approval for production? (suggest yes for critical services)

---

## Appendix A: Workflow File Locations

### Context Generation (DELETE ALL)

```
Core/.github/.github/workflows/validate-context-artifacts.yml
Core/.github-private/.github/workflows/validate-context-artifacts.yml
Core/operations/.github/workflows/validate-context-artifacts.yml
Data/.github/.github/workflows/validate-context-artifacts.yml
Data/.github-private/.github/workflows/validate-context-artifacts.yml
Data/design/.github/workflows/validate-context-artifacts.yml
Design/.github/.github/workflows/validate-context-artifacts.yml
Design/.github-private/.github/workflows/validate-context-artifacts.yml
Engineering/.github/.github/workflows/validate-context-artifacts.yml
Engagement/.github/.github/workflows/validate-context-artifacts.yml
Engagement/.github-private/.github/workflows/validate-context-artifacts.yml
Engagement/discovery/.github/workflows/validate-context-artifacts.yml
Security/.github/.github/workflows/validate-context-artifacts.yml
Security/.github-private/.github/workflows/validate-context-artifacts.yml
Security/iso27001/.github/workflows/validate-context-artifacts.yml
```

### CI Workflows (ENHANCE)

```
Core/.github/workflows/ci.yml
Core/operations/.github/workflows/ci.yml
Data/.github/workflows/ci.yml
Data/design/.github/workflows/ci.yml
Design/.github/workflows/ci.yml
Engineering/.github/workflows/ci.yml
Engagement/.github/workflows/ci.yml
Security/.github-private/workflows/ci.yml
(Plus corresponding -private variants)
```

### CD Workflows (STANDARDISE)

```
Data/xero/.github/workflows/deploy-to-railway.yml
Core/portal/.github/workflows/deploy-astro-site-to-pages.yml
```

### Project Provisioning (KEEP)

```
Core/operations/.github/workflows/project-provisioning-engine.yml
Core/operations/.github/workflows/project-provisioning-dispatch.yml
```

---

## Appendix B: Related Documentation

### Update These Docs

- `Core/operations/docs/revamp-spectra-runbook.md` - Update to reflect new standards
- `Core/infrastructure/tooling/docs/railway-deployment.md` - Add CD workflow section
- `Core/onboarding/README.md` - Update workflow guidance
- `Core/memory/README.md` - Clarify that context is Memory-first

### Create These Docs

- `Core/infrastructure/tooling/workflows/README.md` - Workflow guide
- `Core/infrastructure/tooling/workflows/docs/workflow-guide.md` - How to use templates
- `Core/infrastructure/tooling/workflows/docs/railway-cd-guide.md` - Railway deployment guide
- `Core/infrastructure/tooling/workflows/docs/alana-workflow-prompts.md` - Alana guidance

---

## Sign-off

**Prepared by:** Mark McCann  
**Date:** 2025-11-29  
**Status:** Ready for review and approval

**Approval:**

- [ ] Mark McCann (Owner)
- [ ] Alana (Lead Implementer)

**Target Start Date:** 2025-11-30  
**Target Completion Date:** 2025-12-28

---

_This assessment reflects the state of workflows as of 2025-11-29. Future changes should reference this document and update accordingly._

