# Workflow Deployment Guide

**Date:** 2025-11-29  
**Status:** Ready to Deploy  
**Action Required:** Execute migration scripts

---

## Current State

✅ **Templates Created:**

- All workflow templates in `Core/infrastructure/tooling/workflows/`
- Comprehensive documentation (30,000+ words)
- Migration scripts ready

❌ **Not Yet Deployed:**

- Templates are local in monorepo workspace
- Individual GitHub repos not yet migrated
- Workflows not running in any repo yet

---

## Deployment Options

### Option 1: Single Repo Migration (Recommended Start)

**Test with one repo first:**

```powershell
# Navigate to workspace
cd C:\Users\markm\OneDrive\SPECTRA

# Migrate Core/operations (Python repo)
.\Core\infrastructure\tooling\scripts\migrate-workflows.ps1 `
    -RepoPath "C:\Users\markm\OneDrive\SPECTRA\Core\operations" `
    -RepoType "python" `
    -Apply

# Review changes
cd Core\operations
git status
git diff

# Commit if looks good
git add .
git commit -m "chore: standardise workflows

- Remove obsolete context generation workflows
- Add standard CI (lint, test, security)
- Add Dependabot configuration

Ref: WORKFLOWS-ASSESSMENT-2025-11-29.md"

# Push to remote
git push
```

**Then verify:**

1. Go to GitHub repo
2. Check Actions tab
3. Open a test PR
4. Verify CI runs and passes

---

### Option 2: Bulk Migration (After Testing)

**Migrate all repos at once:**

```powershell
# DRY RUN first (preview changes)
cd C:\Users\markm\OneDrive\SPECTRA
.\Core\infrastructure\tooling\scripts\bulk-migrate-workflows.ps1 -DryRun

# Review output, then apply
.\Core\infrastructure\tooling\scripts\bulk-migrate-workflows.ps1 -Apply

# With auto-commit (advanced)
.\Core\infrastructure\tooling\scripts\bulk-migrate-workflows.ps1 -Apply -AutoCommit
```

**Then push all repos:**

```powershell
# Script to push all (run manually)
$repos = Get-ChildItem -Directory -Include "Core","Data","Design","Engineering","Engagement","Media","Security"

foreach ($repo in $repos) {
    $subrepos = Get-ChildItem $repo.FullName -Directory | Where-Object {
        Test-Path (Join-Path $_.FullName ".git")
    }

    foreach ($subrepo in $subrepos) {
        Push-Location $subrepo.FullName
        Write-Host "Pushing: $($subrepo.Name)" -ForegroundColor Cyan
        git push
        Pop-Location
    }
}
```

---

### Option 3: Manual Migration (If Scripts Don't Work)

**For each repository:**

1. **Cleanup Phase 1:**

   ```bash
   # Delete obsolete workflows
   rm .github/workflows/validate-context-artifacts.yml

   # Delete context scripts
   rm -rf scripts/context/
   rm -rf .spectra/
   ```

2. **Add Phase 2 (CI):**

   ```bash
   # Copy CI template
   cp ../SPECTRA/Core/infrastructure/tooling/workflows/templates/ci-python.yml .github/workflows/ci.yml

   # Copy Dependabot
   cp ../SPECTRA/Core/infrastructure/tooling/workflows/templates/dependabot.yml .github/dependabot.yml
   ```

3. **Add Phase 3 (CD) if needed:**

   ```bash
   # For Railway services only
   cp ../SPECTRA/Core/infrastructure/tooling/workflows/templates/cd-railway.yml .github/workflows/deploy.yml
   cp ../SPECTRA/Core/infrastructure/tooling/workflows/templates/railway.json railway.json
   ```

4. **Commit and push:**
   ```bash
   git add .github/ railway.json
   git add -u  # Stage deletions
   git commit -m "chore: standardise workflows"
   git push
   ```

---

## Recommended Deployment Strategy

### Week 1: Pilot Phase

**Day 1-2: Single Pilot Repo**

```powershell
# Test with Core/operations
.\migrate-workflows.ps1 -RepoPath "Core\operations" -RepoType "python" -Apply
cd Core\operations
git push
# Monitor CI runs for 24-48 hours
```

**Day 3-4: Three Pilot Repos**

```powershell
# Core/operations (Python)
# Core/portal (Node/Astro)
# Data/xero (Python + Railway CD)

# Migrate each, test CI, verify workflows work
```

**Day 5: Review and Adjust**

- Fix any issues found
- Update templates if needed
- Document edge cases

---

### Week 2: Core & Data Orgs

```powershell
# Migrate Core org
$coreRepos = @("Core\.github", "Core\academy", "Core\assistant", "Core\foundation",
               "Core\onboarding", "Core\opinions", "Core\support", "Core\Vault")

foreach ($repo in $coreRepos) {
    .\migrate-workflows.ps1 -RepoPath $repo -RepoType "python" -Apply
}

# Migrate Data org
$dataRepos = @("Data\.github", "Data\branding", "Data\bridge", "Data\design",
               "Data\framework", "Data\graph", "Data\jira", "Data\media",
               "Data\unifi", "Data\zephyr")

foreach ($repo in $dataRepos) {
    .\migrate-workflows.ps1 -RepoPath $repo -RepoType "python" -Apply
}
```

---

### Week 3: Remaining Orgs

```powershell
# Use bulk migration script
.\bulk-migrate-workflows.ps1 -Apply -AutoCommit

# Or migrate remaining orgs manually
```

---

## Verification Checklist

### Per Repository:

- [ ] Obsolete workflows deleted
- [ ] Context generation scripts deleted
- [ ] `.spectra` directories deleted
- [ ] New CI workflow added
- [ ] Dependabot config added
- [ ] Security workflow added (optional)
- [ ] Railway CD added (if applicable)
- [ ] Changes committed
- [ ] Changes pushed to remote
- [ ] CI runs successfully
- [ ] No workflow errors in GitHub Actions

### organisation-Wide:

- [ ] All Core repos migrated
- [ ] All Data repos migrated
- [ ] All Design repos migrated
- [ ] All Engagement repos migrated
- [ ] All Engineering repos migrated
- [ ] All Media repos migrated
- [ ] All Security repos migrated
- [ ] Total: ~38 repos migrated
- [ ] Zero obsolete workflows remaining
- [ ] 100% Dependabot coverage
- [ ] 100% security scan coverage

---

## Monitoring After Deployment

### Day 1-7:

```powershell
# Check GitHub Actions usage
# Settings → Billing → Actions minutes

# Monitor for failures
# Check each repo's Actions tab

# Review first Dependabot PRs
# Should appear within 1 week
```

### Week 2-4:

- Monitor CI pass rates
- Review security scan findings
- Address any Dependabot alerts
- Fix any edge cases
- Update documentation based on learnings

---

## Rollback Plan

**If a migration breaks a repo:**

```bash
# Revert the commit
git revert HEAD
git push

# Or reset to before migration
git reset --hard HEAD~1
git push --force  # Only if safe to do so

# Or manually restore old workflows
git checkout HEAD~1 -- .github/workflows/
git commit -m "revert: restore old workflows temporarily"
git push
```

---

## Troubleshooting

### Issue: Migration script fails

**Solution:**

```powershell
# Check template base path
Test-Path "C:\Users\markm\OneDrive\SPECTRA\Core\infrastructure\tooling\workflows"

# Run with verbose output
.\migrate-workflows.ps1 -RepoPath "path" -RepoType "python" -Apply -Verbose

# Check PowerShell version
$PSVersionTable.PSVersion  # Should be 5.1 or 7+
```

### Issue: CI workflow fails after migration

**Common causes:**

1. **Missing dependencies** - Update requirements.txt/package.json
2. **Test failures** - Fix tests or adjust CI config
3. **CodeQL timeout** - Increase timeout or use path filters
4. **Wrong Python/Node version** - Update workflow matrix

**Quick fix:**

```bash
# Edit workflow directly
nano .github/workflows/ci.yml

# Or temporarily disable problematic job
# Comment out the failing job in YAML
```

### Issue: Dependabot creates too many PRs

**Solution:**

```yaml
# Edit .github/dependabot.yml
# Reduce open-pull-requests-limit
open-pull-requests-limit: 3 # Down from 5
```

---

## Expected Outcomes

### Immediate (Week 1):

- ✅ 3 pilot repos migrated
- ✅ CI running successfully
- ✅ Zero obsolete workflows in pilots
- ✅ Health checks working (Railway repos)

### Short-term (Month 1):

- ✅ 38 repos migrated
- ✅ 100% Dependabot coverage
- ✅ 100% security scan coverage
- ✅ Average CI time: 3-5 minutes
- ✅ Zero ignored workflow failures

### Long-term (Quarter 1 2026):

- ✅ All new repos use templates
- ✅ <300 GitHub Actions minutes/month baseline
- ✅ Zero security alerts > 7 days old
- ✅ Automated dependency updates working smoothly
- ✅ Deployment confidence high

---

## Success Metrics

**Track these metrics:**

| Metric                        | Before  | Target  | Current |
| ----------------------------- | ------- | ------- | ------- |
| Repos with obsolete workflows | 38      | 0       | ?       |
| Repos with Dependabot         | 0       | 38      | ?       |
| Repos with CodeQL             | ~15     | 38      | ?       |
| Average CI time               | 5-8 min | 3-5 min | ?       |
| Failed deployments            | High    | <5%     | ?       |
| Security alerts               | ?       | <7 days | ?       |

---

## Communication Plan

### Announce to Team:

**Slack message:**

```
🚀 SPECTRA Workflow standardisation

We're rolling out standardised GitHub workflows across all repos:
- Removing obsolete context generation workflows
- Adding consistent CI (lint, test, security)
- Adding Dependabot for automated updates
- standardising Railway deployments

Timeline:
- Week 1: Pilot repos (operations, portal, xero)
- Week 2: Core & Data orgs
- Week 3: Remaining orgs

What you'll see:
- New Dependabot PRs (weekly)
- Faster CI times (caching!)
- Better security scanning
- Consistent workflow patterns

Questions? Check: Core/infrastructure/tooling/workflows/docs/workflow-guide.md
```

---

## Quick Reference

### Files Created:

- `scripts/migrate-workflows.ps1` - Single repo migration
- `scripts/bulk-migrate-workflows.ps1` - Bulk migration
- `workflows/templates/ci-python.yml` - Python CI
- `workflows/templates/ci-node.yml` - Node CI
- `workflows/templates/security.yml` - Security scanning
- `workflows/templates/dependabot.yml` - Dependabot config
- `workflows/templates/cd-railway.yml` - Railway CD
- `workflows/templates/railway.json` - Railway config
- `workflows/reusable/deploy-railway.yml` - Reusable deployer

### Documentation:

- `workflows/docs/workflow-guide.md` - Complete CI guide
- `workflows/docs/railway-cd-guide.md` - Complete CD guide
- `docs/WORKFLOWS-ASSESSMENT-2025-11-29.md` - Original assessment
- `docs/PHASE1-CLEANUP-SUMMARY-2025-11-29.md` - Phase 1 details
- `docs/PHASE2-standardisation-SUMMARY-2025-11-29.md` - Phase 2 details
- `docs/PHASE3-CD-SUMMARY-2025-11-29.md` - Phase 3 details

---

## Ready to Deploy!

**Start with:**

```powershell
cd C:\Users\markm\OneDrive\SPECTRA

# Option 1: Single pilot repo
.\Core\infrastructure\tooling\scripts\migrate-workflows.ps1 `
    -RepoPath "Core\operations" -RepoType "python" -Apply

# Option 2: Preview all changes first
.\Core\infrastructure\tooling\scripts\bulk-migrate-workflows.ps1 -DryRun

# Option 3: Bulk apply (after testing)
.\Core\infrastructure\tooling\scripts\bulk-migrate-workflows.ps1 -Apply
```

---

_All workflows, templates, and documentation are ready. Execute at your discretion._

