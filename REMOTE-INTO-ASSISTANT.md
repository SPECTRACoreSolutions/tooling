# Remote Into Assistant Service - Complete Guide

**How to SSH/shell into your Railway assistant container from Cursor**

---

## Option 1: Railway CLI Shell (Easiest - 30 seconds)

### Connect to Assistant Container:

```powershell
# From SPECTRA workspace root
cd Core/assistant

# Open shell in Railway container
railway shell

# Now you're inside the container!
# Check Python environment:
python --version
pip list

# Check environment variables:
env | grep SPECTRA

# Check if service is running:
ps aux | grep python

# Check logs:
railway logs
```

**This opens an interactive shell** inside your Railway container.

---

## Option 2: Cursor Remote-SSH Extension (More Powerful)

### Why Remote-SSH in Cursor?

**Benefits**:
- Full Cursor IDE inside container
- Edit files directly in container
- IntelliSense works
- Extensions work inside container
- Debug running service

**Use case**: When you need to debug live issues in production.

### Setup Railway SSH Tunnel:

#### Step 1: Install Remote-SSH Extension

```
Cursor: Ctrl+Shift+X
Search: "Remote - SSH"
By: Microsoft
Install
```

#### Step 2: Get Railway TCP Proxy Info

Railway containers don't have direct SSH, but you can:

**Method A: Railway Shell + Background Process**
```bash
# In Railway shell
railway shell

# Inside container, start SSH server (if available)
# Most Railway containers don't have sshd by default
```

**Method B: Railway TCP Proxy** (Better)
```bash
# Railway provides TCP proxy for services
railway status

# Shows service URL and TCP proxy if configured
```

#### Step 3: Configure SSH in Cursor

```
Ctrl+Shift+P → "Remote-SSH: Connect to Host"
Add new SSH host:
  Host: assistant-production
  HostName: trolley.proxy.rlwy.net
  Port: [YOUR_TCP_PROXY_PORT]
  User: root
```

**Problem**: Railway containers don't have SSH by default. You'd need to add it to Dockerfile.

---

## Option 3: Railway CLI in Cursor Terminal (Recommended)

**This is the practical approach for Railway containers:**

### Use Cursor's Integrated Terminal:

1. **Open Terminal in Cursor**:
   ```
   Ctrl+` or Ctrl+J
   ```

2. **Navigate to Assistant**:
   ```powershell
   cd Core/assistant
   ```

3. **Use Railway Commands**:

**Check service status**:
```bash
railway status
```

**View logs (real-time)**:
```bash
railway logs
```

**Open shell in container**:
```bash
railway shell
```

**Run commands in container**:
```bash
railway run python --version
railway run pip list
railway run env | grep SPECTRA
```

**Connect to specific environment**:
```bash
# Production
railway environment production
railway shell

# Staging
railway environment staging
railway shell
```

---

## What to Check in Assistant Container

### Once inside Railway shell:

#### 1. Check Python Environment
```bash
python --version
# Expected: Python 3.11+

pip list
# Should show: fastapi, uvicorn, openai, anthropic, etc.
```

#### 2. Check Environment Variables
```bash
env | grep SPECTRA
# Should show:
# SPECTRA_TENANT_ID=...
# SPECTRA_GRAPH_CLIENT_ID=...
# SPECTRA_GRAPH_CLIENT_SECRET=...
```

#### 3. Check Service Status
```bash
ps aux | grep python
# Should show: uvicorn process running

curl http://localhost:8000/health
# Should return: {"status": "healthy"}
```

#### 4. Check Installed Dependencies
```bash
cat pyproject.toml
# Shows declared dependencies

pip list | grep -E "(fastapi|openai|anthropic|httpx)"
# Shows installed versions
```

#### 5. Check Logs
```bash
# View service logs
cat /app/logs/*.log

# Or tail live logs
tail -f /app/logs/assistant.log
```

#### 6. Test API Endpoints
```bash
# Inside container
curl http://localhost:8000/health
curl http://localhost:8000/api/v1/status

# Check if MCP is working
curl http://localhost:8000/api/v1/tools
```

---

## Cursor Terminal Workflow (Practical)

### Your Cursor Layout:

```
┌─────────────────────────────────────────────────────────┐
│  Cursor IDE                                             │
│  ┌────────┬──────────┬────────────────────┐            │
│  │ Files  │   AI     │   Code Editor      │            │
│  │        │  CHAT    │                    │            │
│  │        │          │   assistant.py     │            │
│  └────────┴──────────┴────────────────────┘            │
│  ┌─────────────────────────────────────────┐           │
│  │  TERMINAL (Railway commands)            │           │
│  │  PS> cd Core/assistant                  │           │
│  │  PS> railway shell                      │           │
│  │  root@container:/app# python --version  │           │
│  │  Python 3.11.5                          │           │
│  │  root@container:/app# pip list          │           │
│  │  fastapi         0.109.0                │           │
│  │  uvicorn         0.27.0                 │           │
│  │  openai          1.12.0                 │           │
│  │  root@container:/app# █                 │           │
│  └─────────────────────────────────────────┘           │
└─────────────────────────────────────────────────────────┘

You're literally inside the Railway container!
```

---

## Quick Check Script

### Create a script to check assistant health:

```powershell
# Save as: Core/assistant/check-remote.ps1

Write-Host "Connecting to assistant service..." -ForegroundColor Cyan

cd Core/assistant

Write-Host "`nService status:" -ForegroundColor Yellow
railway status

Write-Host "`nChecking container environment..." -ForegroundColor Yellow
railway run python --version
railway run pip list | Select-String -Pattern "fastapi|openai|anthropic|httpx"

Write-Host "`nEnvironment variables (redacted):" -ForegroundColor Yellow
railway run bash -c "env | grep SPECTRA | sed 's/=.*/=***REDACTED***/'"

Write-Host "`nHealth check:" -ForegroundColor Yellow
railway run curl -s http://localhost:8000/health

Write-Host "`nRecent logs (last 50 lines):" -ForegroundColor Yellow
railway logs --tail 50
```

**Run it**:
```powershell
.\check-remote.ps1
```

---

## For Future: Add SSH to Assistant

If you want full SSH access to assistant container:

### Update Dockerfile:

```dockerfile
# Core/assistant/Dockerfile

FROM python:3.11-slim

# Install SSH server
RUN apt-get update && apt-get install -y openssh-server
RUN mkdir /var/run/sshd

# Configure SSH
RUN echo 'root:railway' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Start SSH alongside your app
CMD service ssh start && uvicorn main:app --host 0.0.0.0 --port 8000
```

**But**: Railway CLI shell is easier and more secure than SSH.

---

## TL;DR - Right Now

**To check assistant container**:

```powershell
# In Cursor terminal (Ctrl+`)
cd Core\assistant
railway shell

# Now you're inside! Check everything:
python --version
pip list
env | grep SPECTRA
ps aux
curl http://localhost:8000/health
exit
```

**Want to add Thunder Client first?**
```
Ctrl+Shift+X → Search "Thunder Client" → Install
```

Then you can call assistant APIs from Thunder Client with .env credentials! 🚀
