# Railway CD Guide - Deploying to Railway with GitHub Actions

**Last Updated:** 2025-11-29  
**Status:** Standard templates available  
**Owner:** Infrastructure team

---

## Overview

This guide explains how to deploy SPECTRA services to Railway using standardised GitHub Actions workflows. Railway is our chosen platform for deploying small to medium services with minimal operational overhead.

### Why Railway?

- **Low overhead:** No Kubernetes, no complex configuration
- **GitHub integration:** Automatic deployments from git
- **Cost-effective:** Pay for what you use
- **Simple secrets:** Environment variables in web UI
- **Good for SPECTRA scale:** Perfect for microservices and small apps

---

## Quick Start

### 1. Create Railway Project

```bash
# Install Railway CLI
npm install -g @railway/cli

# Login
railway login

# Create new project
railway init

# Link to existing service (if already created in UI)
railway link
```

### 2. Copy Workflow Template

```bash
# Copy the CD workflow
cp Core/infrastructure/tooling/workflows/templates/cd-railway.yml .github/workflows/deploy.yml

# Copy Railway configuration
cp Core/infrastructure/tooling/workflows/templates/railway.json railway.json
```

### 3. Configure GitHub Secrets

**Required secrets** (Settings → Secrets → Actions):

| Secret               | Description       | Where to Get                       |
| -------------------- | ----------------- | ---------------------------------- |
| `RAILWAY_TOKEN`      | Railway API token | Railway Settings → Tokens → Create |
| `RAILWAY_PROJECT_ID` | Project ID        | Railway CLI: `railway status`      |
| `RAILWAY_SERVICE_ID` | Service ID        | Railway CLI: `railway status`      |

**Optional secrets** (for your application):

- Add your app's environment variables (DATABASE_URL, API_KEYS, etc.)

### 4. Customize Workflow

Edit `.github/workflows/deploy.yml`:

```yaml
deploy:
  uses: SPECTRACoreSolutions/infrastructure/.github/workflows/deploy-railway.yml@v1
  with:
    service-name: my-service # Change this
    health-endpoint: /health # Your health endpoint
    smoke-tests: true
    deployment-environment: production
```

### 5. Deploy

```bash
git add .github/workflows/deploy.yml railway.json
git commit -m "chore: add Railway deployment"
git push origin main

# Deployment will trigger automatically
```

---

## Architecture

### Workflow Structure

```
Repository Workflow (cd-railway.yml)
├── CI Job (lint, test)
├── Deploy Job (calls reusable workflow)
│   └── deploy-railway.yml (reusable)
│       ├── Railway deployment
│       ├── Health check
│       ├── Smoke tests
│       └── Artifact creation
├── Verify Job (post-deployment checks)
└── Notify Job (summary & alerts)
```

### Deployment Flow

```
1. Push to main
   ↓
2. CI checks (lint, test)
   ↓
3. Deploy to Railway
   ↓
4. Wait for stabilization (30s)
   ↓
5. Health check (10 retries, 30s each)
   ↓
6. Smoke tests
   ↓
7. Create artifacts
   ↓
8. Verify deployment
   ↓
9. Notify (summary, Slack, etc.)
```

---

## Reusable Workflow

The `deploy-railway.yml` workflow is reusable across all repositories.

### Inputs

| Input                    | Required | Default      | Description                        |
| ------------------------ | -------- | ------------ | ---------------------------------- |
| `service-name`           | ✅ Yes   | -            | Service name for logging           |
| `railway-project-id`     | No       | -            | Railway project ID (or use secret) |
| `railway-service-id`     | No       | -            | Railway service ID (or use secret) |
| `health-endpoint`        | No       | `/health`    | Health check endpoint              |
| `smoke-tests`            | No       | `true`       | Run smoke tests after deployment   |
| `deployment-environment` | No       | `production` | GitHub environment name            |
| `max-retries`            | No       | `10`         | Max health check retries           |
| `retry-delay`            | No       | `30`         | Delay between retries (seconds)    |

### Secrets

| Secret               | Required | Description                   |
| -------------------- | -------- | ----------------------------- |
| `RAILWAY_TOKEN`      | ✅ Yes   | Railway API token             |
| `RAILWAY_PROJECT_ID` | No       | Project ID (if not in inputs) |
| `RAILWAY_SERVICE_ID` | No       | Service ID (if not in inputs) |

### Outputs

| Output              | Description           |
| ------------------- | --------------------- |
| `deployment-url`    | Deployed service URL  |
| `deployment-status` | `success` or `failed` |

### Usage Example

```yaml
jobs:
  deploy:
    uses: SPECTRACoreSolutions/infrastructure/.github/workflows/deploy-railway.yml@v1
    with:
      service-name: my-api
      health-endpoint: /api/health
      smoke-tests: true
      deployment-environment: production
    secrets:
      RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
      RAILWAY_PROJECT_ID: ${{ secrets.RAILWAY_PROJECT_ID }}
      RAILWAY_SERVICE_ID: ${{ secrets.RAILWAY_SERVICE_ID }}
```

---

## Health Checks

### Required: Health Endpoint

Your service **must** expose a health endpoint:

```python
# Python (Flask example)
@app.route('/health')
def health():
    return {'status': 'healthy'}, 200

# Python (FastAPI example)
@app.get('/health')
def health():
    return {'status': 'healthy'}
```

```typescript
// Node.js (Express example)
app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});
```

### Health Check behaviour

- **Endpoint:** Configurable (default: `/health`)
- **Expected response:** HTTP 200 or 204
- **Max retries:** 10 (configurable)
- **Retry delay:** 30 seconds (configurable)
- **Total timeout:** ~5 minutes (10 retries × 30s)

**If health check fails:**

- Deployment marked as failed
- Rollback notification created
- Workflow fails

---

## Smoke Tests

Smoke tests run after health checks pass:

### Default Tests

1. **Basic connectivity:** Can we reach the service?
2. **Health endpoint:** Is the health check responding?
3. **SSL certificate:** Is HTTPS working correctly?

### Custom Tests

Add custom smoke tests in your repository workflow:

```yaml
verify:
  needs: deploy
  runs-on: ubuntu-latest
  steps:
    - name: Custom API test
      run: |
        URL="${{ needs.deploy.outputs.deployment-url }}"

        # Test API endpoint
        curl -f "$URL/api/v1/status"

        # Test authentication
        curl -H "Authorization: Bearer ${{ secrets.API_TOKEN }}" \
             -f "$URL/api/v1/me"

        # Test database connectivity
        curl -f "$URL/api/v1/db/health"
```

---

## Rollback Strategies

### Automatic Rollback (Future)

**Status:** Not yet implemented (Railway CLI limitation)

**Planned:**

- Automatic rollback on health check failure
- Requires Railway GraphQL API integration

### Manual Rollback

**If deployment fails:**

1. Open [Railway Dashboard](https://railway.app)
2. Navigate to your service
3. Go to **Deployments** tab
4. Find the last successful deployment
5. Click **Rollback**

**Via CLI:**

```bash
railway status  # View deployments
# Note the deployment ID of a successful deployment
railway redeploy <deployment-id>
```

### Preventing Bad Deployments

1. **Run CI first:** Deploy workflow requires CI to pass
2. **Use staging:** Deploy to staging environment first
3. **Health checks:** Comprehensive health endpoint
4. **Smoke tests:** Test critical functionality
5. **Gradual rollout:** Consider canary deployments (future)

---

## Environment Variables

### Setting via Workflow

```yaml
- name: Set environment variables
  env:
    RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
  run: |
    railway variables set API_KEY="${{ secrets.API_KEY }}"
    railway variables set DATABASE_URL="${{ secrets.DATABASE_URL }}"
    railway variables set LOG_LEVEL="INFO"
```

### Setting via Railway UI

1. Open Railway Dashboard
2. Select your service
3. Go to **Variables** tab
4. Add variables (key = value)
5. Click **Save**

**Variables redeploy the service automatically**

### Environment-Specific Variables

Use GitHub Environments for different configs:

```yaml
deploy-staging:
  uses: ./.github/workflows/deploy-railway.yml
  with:
    deployment-environment: staging
  secrets:
    RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN_STAGING }}

deploy-production:
  uses: ./.github/workflows/deploy-railway.yml
  with:
    deployment-environment: production
  secrets:
    RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
```

---

## Railway Configuration

### railway.json

Configure Railway behaviour with `railway.json`:

```json
{
  "build": {
    "builder": "NIXPACKS",
    "watchPatterns": ["**/*.py", "requirements.txt"]
  },
  "deploy": {
    "numReplicas": 1,
    "restartPolicyType": "ON_FAILURE"
  },
  "healthcheck": {
    "path": "/health",
    "timeout": 100,
    "interval": 30
  },
  "regions": ["us-west1"]
}
```

### Build Settings

**Builder options:**

- `NIXPACKS` (default) - Auto-detects language
- `DOCKERFILE` - Uses your Dockerfile
- `BUILDPACKS` - Cloud Native Buildpacks

**Watch patterns:** Files that trigger rebuilds

### Deploy Settings

- `numReplicas`: Number of instances (default: 1)
- `restartPolicyType`: `ON_FAILURE` or `ALWAYS`
- `restartPolicyMaxRetries`: Max restart attempts

### Health Check

- `path`: Health endpoint (e.g., `/health`)
- `timeout`: Timeout in milliseconds
- `interval`: Check interval in seconds

---

## Deployment Environments

### GitHub Environments

**Create environments** (Settings → Environments):

1. **staging**

   - No protection rules
   - Automatic deployment from `dev` branch

2. **production**
   - Require approvers (1-2 people)
   - Automatic deployment from `main` branch
   - Deployment branch: `main` only

### Workflow Configuration

```yaml
on:
  push:
    branches:
      - main        # → production
      - dev         # → staging

jobs:
  deploy:
    with:
      deployment-environment: ${{
        github.ref == 'refs/heads/main' && 'production' || 'staging'
      }}
```

---

## Monitoring & Logs

### View Logs

**Railway Dashboard:**

1. Open your service
2. Go to **Deployments** tab
3. Click on a deployment
4. View logs in real-time

**Railway CLI:**

```bash
railway logs  # Stream logs
railway logs --tail 100  # Last 100 lines
```

### Deployment Artifacts

Each deployment creates an artifact with:

- Deployment metadata (commit, URL, timestamp)
- Health check results
- Smoke test results

**Download artifacts:**

- GitHub Actions → Workflow run → Artifacts section
- Retention: 90 days

### Monitoring Tools

**Recommended:**

- **Railway Metrics:** Built-in CPU, memory, network
- **Uptime monitoring:** UptimeRobot, Pingdom
- **APM:** Sentry, Datadog, New Relic (if needed)
- **Logs:** Railway built-in (sufficient for most)

---

## Cost optimisation

### Railway Pricing

- **Hobby Plan:** $5/month base + usage
- **Usage charges:**
  - CPU: ~$0.000463/vCPU/min
  - Memory: ~$0.000231/GB/min
  - Network: $0.10/GB egress

### Cost optimisation Tips

1. **Right-size resources:**

   - Start small (512MB RAM, 0.5 vCPU)
   - Scale up only if needed

2. **Use sleep mode for dev/staging:**

   ```json
   {
     "deploy": {
       "sleepApplication": true
     }
   }
   ```

   (Wakes on first request)

3. **optimise build times:**

   - Use caching (Nixpacks does this automatically)
   - Minimize dependencies
   - Use `.dockerignore` to exclude files

4. **Monitor usage:**
   - Railway Dashboard → Usage tab
   - Set budget alerts

### Estimated Costs (per service)

| Type       | Resources       | Monthly Cost |
| ---------- | --------------- | ------------ |
| Small API  | 512MB, 0.5 vCPU | ~$5-10       |
| Medium API | 1GB, 1 vCPU     | ~$15-25      |
| Large API  | 2GB, 2 vCPU     | ~$40-60      |

_Costs depend on traffic and uptime_

---

## Troubleshooting

### Common Issues

#### 1. Health Check Fails

**Symptoms:**

- Deployment fails after "Waiting for deployment"
- Health check returns non-200 status

**Solutions:**

1. Verify health endpoint exists and returns 200
2. Check service logs in Railway dashboard
3. Increase `max-retries` or `retry-delay`
4. Ensure service is listening on `0.0.0.0` (not `127.0.0.1`)
5. Check Railway's `PORT` environment variable is used

```python
# Correct:
port = int(os.environ.get('PORT', 8000))
app.run(host='0.0.0.0', port=port)

# Wrong:
app.run(host='127.0.0.1', port=8000)  # Won't work!
```

#### 2. Railway Link Fails

**Symptoms:**

- `railway link` command fails in workflow
- "Project not found" error

**Solutions:**

1. Verify `RAILWAY_TOKEN` is set correctly
2. Check `RAILWAY_PROJECT_ID` and `RAILWAY_SERVICE_ID` are correct
3. Ensure Railway token has correct permissions
4. Link manually in Railway UI (Settings → Connect Repo)

#### 3. Build Fails

**Symptoms:**

- Deployment fails during build phase
- "Build command failed" error

**Solutions:**

1. Check Railway build logs
2. Verify dependencies are correct (`requirements.txt`, `package.json`)
3. Check Python/Node version compatibility
4. Add build command to `railway.json` if needed

```json
{
  "build": {
    "buildCommand": "pip install -r requirements.txt && python build.py"
  }
}
```

#### 4. Environment Variables Missing

**Symptoms:**

- Service starts but crashes immediately
- "Environment variable not set" errors

**Solutions:**

1. Set variables in Railway Dashboard (Variables tab)
2. Or set via workflow:
   ```yaml
   - run: railway variables set KEY="value"
   ```
3. Check variable names match exactly (case-sensitive)

#### 5. Deployment Succeeds but Service Unreachable

**Symptoms:**

- Health check passes
- But service returns 503/502 in browser

**Solutions:**

1. Check Railway dashboard for service status
2. Verify domain is correctly configured
3. Wait a few minutes (DNS propagation)
4. Check Railway networking settings

---

## Best Practices

### DO ✅

**Deployment:**

- Always run CI before deploying
- Use health checks on all services
- Implement graceful shutdown
- Use environment variables for config
- Test in staging before production
- Monitor deployment metrics

**Configuration:**

- Keep `railway.json` in git
- Document environment variables in README
- Use GitHub Environments for protection
- Set reasonable health check timeouts
- Configure restart policies

**Security:**

- Use Railway secrets for sensitive data
- Rotate API tokens regularly
- Limit token permissions
- Use HTTPS only (Railway provides this)
- Don't log sensitive information

### DON'T ❌

**Deployment:**

- Deploy without testing locally
- Skip health checks
- Ignore deployment failures
- Deploy breaking changes directly to production
- Forget to set critical environment variables

**Configuration:**

- Hardcode secrets in code
- Use `127.0.0.1` for host (use `0.0.0.0`)
- Ignore Railway's PORT variable
- Set infinite restart retries
- Deploy without rollback plan

---

## Examples

### Python Flask API

```yaml
# .github/workflows/deploy.yml
name: Deploy to Railway

on:
  push:
    branches: [main]

jobs:
  deploy:
    uses: SPECTRACoreSolutions/infrastructure/.github/workflows/deploy-railway.yml@v1
    with:
      service-name: flask-api
      health-endpoint: /api/health
      smoke-tests: true
    secrets:
      RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
      RAILWAY_PROJECT_ID: ${{ secrets.RAILWAY_PROJECT_ID }}
      RAILWAY_SERVICE_ID: ${{ secrets.RAILWAY_SERVICE_ID }}
```

```python
# app.py
import os
from flask import Flask

app = Flask(__name__)

@app.route('/api/health')
def health():
    return {'status': 'healthy'}, 200

if __name__ == '__main__':
    port = int(os.environ.get('PORT', 5000))
    app.run(host='0.0.0.0', port=port)
```

```json
// railway.json
{
  "build": {
    "builder": "NIXPACKS"
  },
  "deploy": {
    "restartPolicyType": "ON_FAILURE"
  },
  "healthcheck": {
    "path": "/api/health",
    "timeout": 100,
    "interval": 30
  }
}
```

### Node.js Express API

```yaml
# .github/workflows/deploy.yml
name: Deploy to Railway

on:
  push:
    branches: [main]

jobs:
  deploy:
    uses: SPECTRACoreSolutions/infrastructure/.github/workflows/deploy-railway.yml@v1
    with:
      service-name: express-api
      health-endpoint: /health
      smoke-tests: true
    secrets:
      RAILWAY_TOKEN: ${{ secrets.RAILWAY_TOKEN }}
      RAILWAY_PROJECT_ID: ${{ secrets.RAILWAY_PROJECT_ID }}
      RAILWAY_SERVICE_ID: ${{ secrets.RAILWAY_SERVICE_ID }}
```

```javascript
// server.js
const express = require("express");
const app = express();
const PORT = process.env.PORT || 3000;

app.get("/health", (req, res) => {
  res.status(200).json({ status: "healthy" });
});

app.listen(PORT, "0.0.0.0", () => {
  console.log(`Server running on port ${PORT}`);
});
```

---

## Migration from Existing Railway Deployments

### If Using Railway's Auto-Deploy

**Current:** Railway auto-deploys on every git push

**Migration to GitHub Actions CD:**

1. **Disable auto-deploy in Railway:**

   - Railway Dashboard → Settings → Disable "Auto Deploy"

2. **Add deployment workflow:**

   ```bash
   cp Core/infrastructure/tooling/workflows/templates/cd-railway.yml .github/workflows/deploy.yml
   ```

3. **Configure secrets** (see Quick Start)

4. **Test:**
   ```bash
   git push origin main
   # Watch GitHub Actions, not Railway auto-deploy
   ```

**Benefits:**

- CI runs before deploy
- Health checks and smoke tests
- Deployment artifacts
- Better control and visibility

---

## Next Steps

### Immediate

1. **Review this guide**
2. **Copy templates to your repo**
3. **Configure Railway secrets**
4. **Test deployment**

### Future Enhancements

**Phase 4 (Security):**

- SAST scanning before deploy
- Container vulnerability scanning
- Compliance checks

**Future Features:**

- Automatic rollback on failure
- Canary deployments
- Blue-green deployments
- Multi-region deployments

---

## Support

**Questions?**

- Read this guide first
- Check Railway docs: https://docs.railway.app
- Ask in #engineering Slack channel
- Ping @infrastructure team

**Issues?**

- Check Railway dashboard logs
- Review GitHub Actions logs
- Open issue in infrastructure repo
- Include workflow run URL and error logs

**Improvements?**

- Suggest via PR to infrastructure repo
- Share learnings from your deployments
- Update this guide with new patterns

---

## Changelog

### 2025-11-29 - Initial Release

- Created reusable deploy-railway workflow
- Created standard CD template
- Created Railway configuration template
- Published comprehensive guide

---

_This guide is part of the workflow standardisation initiative (Phase 3) documented in `WORKFLOWS-ASSESSMENT-2025-11-29.md`_

