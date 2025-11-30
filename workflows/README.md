# SPECTRA Workflows

Standard GitHub Actions workflows, templates, and documentation for all SPECTRA repositories.

## Quick Links

- **[Workflow Guide](docs/workflow-guide.md)** - Complete documentation
- **[Phase 2 Summary](../docs/PHASE2-standardisation-SUMMARY-2025-11-29.md)** - Implementation details
- **[Workflows Assessment](../docs/WORKFLOWS-ASSESSMENT-2025-11-29.md)** - Original assessment

---

## Directory Structure

```
workflows/
├── templates/           # Copy these to your .github/ directory
│   ├── ci-python.yml       # Python CI template
│   ├── ci-node.yml         # Node.js/TypeScript CI template
│   ├── security.yml        # Security scanning template
│   └── dependabot.yml      # Dependabot configuration
├── reusable/            # Reusable workflows (Phase 3)
│   └── deploy-railway.yml  # Coming soon
├── docs/                # Documentation
│   └── workflow-guide.md   # Comprehensive guide
└── README.md            # This file
```

---

## Quick Start

### For Python Projects

```bash
# Copy CI workflow
cp Core/infrastructure/tooling/workflows/templates/ci-python.yml .github/workflows/ci.yml

# Copy Dependabot config
cp Core/infrastructure/tooling/workflows/templates/dependabot.yml .github/dependabot.yml

# Commit and push
git add .github/
git commit -m "chore: add standard CI workflows"
git push
```

### For Node.js/TypeScript Projects

```bash
# Copy CI workflow
cp Core/infrastructure/tooling/workflows/templates/ci-node.yml .github/workflows/ci.yml

# Copy Dependabot config
cp Core/infrastructure/tooling/workflows/templates/dependabot.yml .github/dependabot.yml

# Commit and push
git add .github/
git commit -m "chore: add standard CI workflows"
git push
```

---

## Available Templates

| Template         | Purpose            | Use When                                   |
| ---------------- | ------------------ | ------------------------------------------ |
| `ci-python.yml`  | Python CI/CD       | Python projects, data engineering, scripts |
| `ci-node.yml`    | Node.js CI/CD      | Frontend apps, Node services, TypeScript   |
| `security.yml`   | Security scanning  | All projects (optional standalone)         |
| `dependabot.yml` | Dependency updates | ALL repositories (mandatory)               |

---

## Features

### Python CI (`ci-python.yml`)

- ✅ Ruff linting + formatting
- ✅ Pytest with multi-version matrix (3.11, 3.12)
- ✅ Code coverage (Codecov + artifacts)
- ✅ CodeQL security scanning
- ✅ Dependency caching
- ✅ Summary job (all checks must pass)

### Node.js CI (`ci-node.yml`)

- ✅ ESLint + Prettier
- ✅ TypeScript type checking
- ✅ Jest/Vitest testing
- ✅ Build verification
- ✅ Code coverage (Codecov + artifacts)
- ✅ CodeQL security scanning
- ✅ NPM audit
- ✅ Summary job

### Security (`security.yml`)

- ✅ CodeQL analysis (multi-language)
- ✅ Dependency review (PRs only)
- ✅ NPM audit (Node projects)
- ✅ Pip audit (Python projects)
- ✅ Secret scanning (Gitleaks)
- ✅ Weekly scheduled scans
- ✅ Security summary report

### Dependabot (`dependabot.yml`)

- ✅ Weekly updates (Monday 09:00 GMT)
- ✅ Grouped by type (production/dev/framework)
- ✅ Auto-labeled and assigned
- ✅ Conventional commit messages
- ✅ Supports: Python, Node.js, GitHub Actions, Docker, Terraform

---

## Customization

Each template includes comments explaining customization options:

- **Python versions:** Adjust matrix in `ci-python.yml`
- **Node version:** Change `NODE_VERSION` in `ci-node.yml`
- **Coverage thresholds:** Modify pytest/jest config
- **Security severity:** Adjust in `security.yml`
- **Update frequency:** Change Dependabot schedule

See [workflow-guide.md](docs/workflow-guide.md) for detailed customization instructions.

---

## Migration

### Existing Repositories

1. **Review current workflows:**

   ```bash
   ls -la .github/workflows/
   ```

2. **Compare with templates:**

   - Missing features? (caching, coverage, matrix)
   - Broken patterns? (continue-on-error, old actions)
   - Custom requirements? (keep those)

3. **Migrate in branch:**
   ```bash
   git checkout -b chore/standardise-workflows
   # Copy and customize templates
   git commit -m "chore: standardise workflows"
   git push origin chore/standardise-workflows
   # Open PR and verify
   ```

See [workflow-guide.md](docs/workflow-guide.md) for full migration checklist.

---

## Best Practices

### DO ✅

- Use these templates for new repos
- Pin actions to major versions (`@v4`)
- Cache dependencies aggressively
- Fail fast on security issues
- Document custom changes in README

### DON'T ❌

- Generate content in workflows (use Alana)
- Store secrets in workflow files (use GitHub Secrets)
- Use `continue-on-error` to hide problems
- Run workflows on every file change (use path filters)
- Copy-paste workflows (use templates)

---

## Support

**Questions?**

- Read [workflow-guide.md](docs/workflow-guide.md) first
- Check template comments
- Ask in #engineering Slack

**Issues?**

- Open issue with workflow run logs
- Tag as `workflow` or `ci`

**Improvements?**

- PR to infrastructure repo
- Update docs with learnings

---

## Roadmap

### ✅ Phase 1: Cleanup (Complete)

- Removed obsolete context generation workflows
- Deleted ~100+ obsolete files

### ✅ Phase 2: CI standardisation (Complete)

- Created Python CI template
- Created Node.js CI template
- Created security scanning template
- Created Dependabot configuration
- Published workflow guide

### ⏳ Phase 3: CD standardisation (Next)

- Railway deployment templates
- Deployment verification workflows
- Rollback strategies

### ⏳ Phase 4: Enhanced Security (Future)

- Advanced CodeQL queries
- Custom security policies
- Compliance reporting

---

## Statistics

**As of 2025-11-29:**

- **4 templates** available
- **3 pilot repos** in progress (operations, portal, xero)
- **~38 repos** to migrate
- **Target:** 80% adoption by end of Week 1

---

## Changelog

### 2025-11-29 - Initial Release

- Created template directory structure
- Published Python CI template (`ci-python.yml`)
- Published Node.js CI template (`ci-node.yml`)
- Published security template (`security.yml`)
- Published Dependabot template (`dependabot.yml`)
- Created comprehensive workflow guide
- Started pilot deployment

---

_For complete context, see [WORKFLOWS-ASSESSMENT-2025-11-29.md](../docs/WORKFLOWS-ASSESSMENT-2025-11-29.md)_

