# Xero Deployment Migration Notes

**Current Status:** Broken workflow (missing `run:` on line 68)  
**Recommended Action:** Migrate to standard Railway CD template  
**Priority:** High

---

## Current Issues

1. **Line 68 missing `run:`** - Syntax error in workflow
2. **No health checks** - Deployment succeeds even if service fails
3. **No smoke tests** - No verification after deployment
4. **Manual variable setting** - Should be configured in Railway UI
5. **No rollback strategy** - If deployment fails, manual intervention needed

---

## Migration Path

### Option 1: Use Standard Template (Recommended)

Replace the entire workflow with the standard template:

```bash
# Backup current workflow
mv .github/workflows/deploy-to-railway.yml .github/workflows/deploy-to-railway.yml.backup

# Copy standard template
cp Core/infrastructure/tooling/workflows/templates/cd-railway.yml .github/workflows/deploy.yml

# Configure for Xero
```

Edit `.github/workflows/deploy.yml`:

```yaml
deploy:
  uses: SPECTRACoreSolutions/infrastructure/.github/workflows/deploy-railway.yml@v1
  with:
    service-name: xero
    health-endpoint: /health # Add health endpoint to xero app
    smoke-tests: true
    deployment-environment: production
  secrets:
    RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
    RAILWAY_PROJECT_ID: ${{ secrets.RAILWAY_PROJECT_ID }}
    RAILWAY_SERVICE_ID: ${{ secrets.RAILWAY_SERVICE_ID }}
```

**Benefits:**

- ✅ Fixed syntax error
- ✅ Health checks included
- ✅ Smoke tests included
- ✅ Rollback notifications
- ✅ Deployment artifacts
- ✅ Consistent with other SPECTRA services

### Option 2: Quick Fix (Temporary)

Just fix the syntax error:

```yaml
# Line 67-73: Fix the missing run:
- name: Set service variables from GitHub secrets
  run: |
    railway variables set CLIENT_ID="$CLIENT_ID"
    railway variables set CLIENT_SECRET="$CLIENT_SECRET"
    railway variables set REDIRECT_URI="$REDIRECT_URI"
    railway variables set FLASK_SECRET="$FLASK_SECRET"
    railway variables set WEBHOOK_KEY="$WEBHOOK_KEY"
```

**Not recommended:** This fixes the immediate issue but doesn't add health checks, smoke tests, or rollback capabilities.

---

## Required Changes to Xero App

### 1. Add Health Endpoint

Add to `app.py`:

```python
@app.route('/health')
def health():
    """Health check endpoint for Railway deployment verification."""
    try:
        # Optional: Check database connectivity
        # db.session.execute('SELECT 1')
        return {'status': 'healthy'}, 200
    except Exception as e:
        return {'status': 'unhealthy', 'error': str(e)}, 503
```

### 2. Environment Variables

**Move these to Railway Dashboard** (Variables tab):

- `CLIENT_ID`
- `CLIENT_SECRET`
- `REDIRECT_URI`
- `FLASK_SECRET`
- `WEBHOOK_KEY`

**Remove from workflow** - Setting variables on every deployment is inefficient and causes unnecessary redeployments.

### 3. Add railway.json

```json
{
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "numReplicas": 1,
    "restartPolicyType": "ON_FAILURE",
    "restartPolicyMaxRetries": 10
  },
  "healthcheck": {
    "path": "/health",
    "timeout": 100,
    "interval": 30
  }
}
```

---

## Migration Checklist

### Pre-Migration

- [ ] Backup current workflow file
- [ ] Review current deployment process
- [ ] Document current environment variables

### Add Health Endpoint

- [ ] Add `/health` endpoint to `app.py`
- [ ] Test locally: `curl http://localhost:5000/health`
- [ ] Commit and push to `dev` branch for testing

### Move Environment Variables

- [ ] Open Railway Dashboard → xero service
- [ ] Go to Variables tab
- [ ] Add all required variables:
  - [ ] `CLIENT_ID`
  - [ ] `CLIENT_SECRET`
  - [ ] `REDIRECT_URI`
  - [ ] `FLASK_SECRET`
  - [ ] `WEBHOOK_KEY`
- [ ] Note: This will trigger a redeploy

### Deploy New Workflow

- [ ] Create branch: `git checkout -b chore/fix-deployment-workflow`
- [ ] Copy standard template to `.github/workflows/deploy.yml`
- [ ] Customize `service-name` and `health-endpoint`
- [ ] Delete old workflow or keep as backup
- [ ] Add `railway.json` configuration
- [ ] Commit: `git commit -m "fix: migrate to standard Railway CD workflow"`
- [ ] Push and open PR

### Testing

- [ ] Push branch and verify workflow runs
- [ ] Check health check passes
- [ ] Check smoke tests pass
- [ ] Verify service is accessible
- [ ] Test OAuth flow still works

### Post-Migration

- [ ] Merge PR
- [ ] Monitor first production deployment
- [ ] Remove workflow step that sets variables
- [ ] Update xero documentation
- [ ] Delete backup workflow file

---

## Expected Improvements

### Before Migration

- ❌ Broken workflow (syntax error)
- ❌ No health verification
- ❌ No deployment artifacts
- ❌ Variables set on every deployment (slow)
- ❌ No rollback strategy

### After Migration

- ✅ Working workflow
- ✅ Health checks (10 retries, 30s delay)
- ✅ Smoke tests (basic connectivity, SSL)
- ✅ Deployment artifacts (90 day retention)
- ✅ Variables configured once in Railway
- ✅ Rollback notifications on failure
- ✅ Consistent with SPECTRA standards

---

## Timeline

**Estimated effort:** 1-2 hours

1. **Add health endpoint** (15 min)
2. **Move env vars to Railway** (10 min)
3. **Update workflow** (15 min)
4. **Test in PR** (30 min)
5. **Deploy to production** (15 min)
6. **Monitor and verify** (15 min)

---

## Support

**Questions?**

- Review [railway-cd-guide.md](../workflows/docs/railway-cd-guide.md)
- Check standard template: `workflows/templates/cd-railway.yml`
- Ask in #engineering Slack

**Need help?**

- Ping @infrastructure team
- Reference this migration note

---

_This migration note is part of Phase 3 (CD standardisation) of the workflow remediation project._

