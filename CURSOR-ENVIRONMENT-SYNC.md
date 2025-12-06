# Cursor Environment Synchronization System

**Date:** 2025-12-02  
**Purpose:** Keep Cursor settings and MCP configuration in sync across machines

---

## The Problem

**Cursor configuration files are NOT version controlled by default:**

- `.cursor/mcp.json` - MCP server configuration ❌ Not tracked
- `.cursor/settings.json` - Cursor-specific settings ❌ Not tracked
- `.vscode/settings.json` - Workspace settings ✅ Usually tracked

**Issues:**

- MCP servers not synced across machines
- Settings drift between environments
- Manual configuration on each machine
- No audit trail for configuration changes

---

## The Solution

### Strategy 1: Version Control Cursor Config (Recommended)

**Make `.cursor/mcp.json` part of the repository:**

#### Step 1: Add to Version Control

```bash
# Remove from .gitignore if present
# Add to git
git add .cursor/mcp.json
git commit -m "🔧 Add Cursor MCP configuration to version control"
```

#### Step 2: Create Sync Script

**File:** `Core/tooling/sync-cursor-config.ps1`

```powershell
# Sync Cursor configuration
# Usage: .\sync-cursor-config.ps1 [-Direction push|pull]

param(
    [ValidateSet('push','pull')]
    [string]$Direction = 'pull'
)

$root = "C:\Users\markm\OneDrive\SPECTRA"
$cursorConfig = "$root\.cursor\mcp.json"
$backupDir = "$root\Core\tooling\config\cursor"

# Ensure backup directory exists
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

if ($Direction -eq 'push') {
    # Local → Git (backup current config)
    Write-Host "📤 Backing up Cursor config to git..."
    Copy-Item $cursorConfig "$backupDir\mcp.json" -Force
    Write-Host "✅ Config backed up to Core/tooling/config/cursor/mcp.json"
    Write-Host "💡 Run 'git add' and 'git commit' to save"
}
elseif ($Direction -eq 'pull') {
    # Git → Local (restore from git)
    if (Test-Path "$backupDir\mcp.json") {
        Write-Host "📥 Restoring Cursor config from git..."
        Copy-Item "$backupDir\mcp.json" $cursorConfig -Force
        Write-Host "✅ Config restored from Core/tooling/config/cursor/mcp.json"
        Write-Host "⚠️  Restart Cursor to apply changes"
    } else {
        Write-Host "❌ No backup found in Core/tooling/config/cursor/"
        Write-Host "💡 Run with -Direction push to create backup first"
    }
}
```

---

### Strategy 2: Central Configuration File (Alternative)

**Keep canonical config in repository, sync on demand:**

#### Directory Structure

```
Core/tooling/config/
├── cursor/
│   ├── mcp.json              ← Canonical MCP config (version controlled)
│   ├── settings.json         ← Recommended Cursor settings
│   └── README.md             ← Config documentation
├── vscode/
│   └── settings.json         ← VS Code settings
└── sync-all.ps1              ← Master sync script
```

#### Benefits

- ✅ Single source of truth
- ✅ Version controlled
- ✅ Easy to sync across machines
- ✅ Can compare local vs canonical
- ✅ Audit trail via git history

---

## Recommended Implementation

### Phase 1: Version Control MCP Config (Now)

**1. Create config directory:**

```bash
mkdir -p Core/tooling/config/cursor
```

**2. Copy current config:**

```bash
cp .cursor/mcp.json Core/tooling/config/cursor/mcp.json
```

**3. Add to git:**

```bash
git add Core/tooling/config/cursor/mcp.json
git commit -m "🔧 Add canonical Cursor MCP configuration"
```

**4. Add sync script:**

```bash
# Create Core/tooling/sync-cursor-config.ps1
# (see template above)
```

**Result:** Configuration is now version controlled ✅

---

### Phase 2: Auto-Sync on Changes (Later)

**Option A: Git Hook (Automatic)**

Create `.git/hooks/post-merge`:

```bash
#!/bin/bash
# Auto-sync Cursor config after git pull

echo "🔄 Syncing Cursor configuration..."
pwsh Core/tooling/sync-cursor-config.ps1 -Direction pull
echo "⚠️  Restart Cursor if MCP config changed"
```

**Option B: Manual Sync (Simpler)**

```bash
# After git pull on new machine:
pwsh Core/tooling/sync-cursor-config.ps1 -Direction pull

# After changing MCP config locally:
pwsh Core/tooling/sync-cursor-config.ps1 -Direction push
git add Core/tooling/config/cursor/mcp.json
git commit -m "🔧 Update MCP config"
```

---

### Phase 3: Settings Profiles (Future)

**Create different profiles for different contexts:**

```
Core/tooling/config/cursor/
├── mcp.json                    ← Default (all servers)
├── mcp.minimal.json            ← Minimal (Railway + GitHub only)
├── mcp.data-engineering.json   ← Data focus (+ Database MCP)
├── mcp.full.json               ← Everything
└── switch-profile.ps1          ← Profile switcher
```

**Usage:**

```powershell
# Switch to data engineering profile
.\switch-profile.ps1 -Profile data-engineering
```

---

## Complete Sync Script

**File:** `Core/tooling/sync-cursor-config.ps1`

```powershell
#Requires -Version 7.0

<#
.SYNOPSIS
    Sync Cursor configuration between local and git repository

.DESCRIPTION
    Manages Cursor MCP configuration synchronization:
    - push: Local .cursor/mcp.json → Core/tooling/config/cursor/mcp.json (version controlled)
    - pull: Core/tooling/config/cursor/mcp.json → Local .cursor/mcp.json
    - diff: Compare local vs canonical

.PARAMETER Direction
    Sync direction: push, pull, or diff

.PARAMETER Force
    Overwrite without confirmation

.EXAMPLE
    .\sync-cursor-config.ps1 -Direction pull
    Restore Cursor config from git

.EXAMPLE
    .\sync-cursor-config.ps1 -Direction push
    Backup local Cursor config to git

.EXAMPLE
    .\sync-cursor-config.ps1 -Direction diff
    Compare local vs canonical config
#>

param(
    [Parameter(Mandatory=$false)]
    [ValidateSet('push','pull','diff')]
    [string]$Direction = 'pull',

    [Parameter(Mandatory=$false)]
    [switch]$Force
)

# Paths
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$localConfig = Join-Path $root ".cursor\mcp.json"
$canonicalConfig = Join-Path $PSScriptRoot "config\cursor\mcp.json"
$backupDir = Join-Path $PSScriptRoot "config\cursor"

# Ensure directories exist
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null

function Show-Diff {
    Write-Host "🔍 Comparing configurations..." -ForegroundColor Cyan

    if (!(Test-Path $localConfig)) {
        Write-Host "❌ Local config not found: $localConfig" -ForegroundColor Red
        return
    }

    if (!(Test-Path $canonicalConfig)) {
        Write-Host "❌ Canonical config not found: $canonicalConfig" -ForegroundColor Red
        return
    }

    $local = Get-Content $localConfig | ConvertFrom-Json
    $canonical = Get-Content $canonicalConfig | ConvertFrom-Json

    $localServers = $local.mcpServers.PSObject.Properties.Name | Sort-Object
    $canonicalServers = $canonical.mcpServers.PSObject.Properties.Name | Sort-Object

    Write-Host "`nLocal servers ($($localServers.Count)):" -ForegroundColor Yellow
    $localServers | ForEach-Object { Write-Host "  - $_" }

    Write-Host "`nCanonical servers ($($canonicalServers.Count)):" -ForegroundColor Yellow
    $canonicalServers | ForEach-Object { Write-Host "  - $_" }

    $onlyLocal = $localServers | Where-Object { $_ -notin $canonicalServers }
    $onlyCanonical = $canonicalServers | Where-Object { $_ -notin $localServers }

    if ($onlyLocal) {
        Write-Host "`n⚠️  Only in local:" -ForegroundColor Magenta
        $onlyLocal | ForEach-Object { Write-Host "  - $_" }
    }

    if ($onlyCanonical) {
        Write-Host "`n⚠️  Only in canonical:" -ForegroundColor Magenta
        $onlyCanonical | ForEach-Object { Write-Host "  - $_" }
    }

    if (!$onlyLocal -and !$onlyCanonical) {
        Write-Host "`n✅ Configurations are in sync!" -ForegroundColor Green
    }
}

function Push-Config {
    Write-Host "📤 Pushing local config to git..." -ForegroundColor Cyan

    if (!(Test-Path $localConfig)) {
        Write-Host "❌ Local config not found: $localConfig" -ForegroundColor Red
        exit 1
    }

    if ((Test-Path $canonicalConfig) -and !$Force) {
        Write-Host "⚠️  Canonical config exists. Use -Force to overwrite" -ForegroundColor Yellow
        Write-Host "   Or run with -Direction diff to compare first"
        exit 1
    }

    Copy-Item $localConfig $canonicalConfig -Force
    Write-Host "✅ Config backed up to: $canonicalConfig" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Yellow
    Write-Host "   cd Core/tooling"
    Write-Host "   git add config/cursor/mcp.json"
    Write-Host "   git commit -m '🔧 Update Cursor MCP configuration'"
    Write-Host "   git push"
}

function Pull-Config {
    Write-Host "📥 Pulling canonical config from git..." -ForegroundColor Cyan

    if (!(Test-Path $canonicalConfig)) {
        Write-Host "❌ Canonical config not found: $canonicalConfig" -ForegroundColor Red
        Write-Host "💡 Run with -Direction push to create it first"
        exit 1
    }

    if ((Test-Path $localConfig) -and !$Force) {
        Write-Host "⚠️  Local config exists. Comparing..." -ForegroundColor Yellow
        Show-Diff
        Write-Host ""
        Write-Host "💡 Use -Force to overwrite local config"
        exit 0
    }

    Copy-Item $canonicalConfig $localConfig -Force
    Write-Host "✅ Config restored from: $canonicalConfig" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  RESTART CURSOR to apply MCP configuration changes" -ForegroundColor Yellow
}

# Main execution
Write-Host "=" * 60
Write-Host "Cursor Configuration Sync" -ForegroundColor Cyan
Write-Host "=" * 60
Write-Host "Direction: $Direction"
Write-Host "Root: $root"
Write-Host "=" * 60
Write-Host ""

switch ($Direction) {
    'push' { Push-Config }
    'pull' { Pull-Config }
    'diff' { Show-Diff }
}
```

---

## Usage Guide

### Daily Workflow

**After pulling git changes:**

```powershell
cd Core/tooling
.\sync-cursor-config.ps1 -Direction pull
# Restart Cursor if MCP config changed
```

**After changing MCP config locally:**

```powershell
cd Core/tooling
.\sync-cursor-config.ps1 -Direction push
git add config/cursor/mcp.json
git commit -m "🔧 Update MCP config - added XYZ server"
git push
```

**Check if configs match:**

```powershell
.\sync-cursor-config.ps1 -Direction diff
```

---

### Multi-Machine Setup

**Machine 1 (Primary):**

```powershell
# Initial setup - push your current config
.\sync-cursor-config.ps1 -Direction push
git add config/cursor/mcp.json
git commit -m "🔧 Add canonical Cursor MCP configuration"
git push
```

**Machine 2 (Secondary):**

```powershell
# Clone SPECTRA repo
git pull

# Restore Cursor config
cd Core/tooling
.\sync-cursor-config.ps1 -Direction pull

# Restart Cursor
```

**Result:** Machine 2 has identical MCP configuration! ✅

---

## What Gets Synced

### Should Sync (Shareable)

✅ **`.cursor/mcp.json`** - MCP server list and configuration

- Server names and NPM packages
- Command configurations
- Shared settings

✅ **`Core/tooling/config/cursor/recommended-settings.json`** - Recommended Cursor settings

- Editor preferences
- Language settings
- Formatting rules

✅ **`.vscode/settings.json`** (workspace) - Already tracked usually

---

### Should NOT Sync (Machine-Specific)

❌ **Environment variables with secrets:**

- `GITHUB_PERSONAL_ACCESS_TOKEN`
- `ATLASSIAN_API_TOKEN`
- `JIRA_URL`

**Solution:** Keep env vars in separate file:

```
Core/tooling/config/cursor/mcp.json          ← Sync this (no secrets)
~/.cursor/user-env.json                      ← Local only (secrets)
```

❌ **Machine-specific paths:**

- Local file paths
- Drive letters
- User directories

---

## Enhanced MCP Config Structure

### Separate Secrets from Config

**Canonical (version controlled):**

```json
{
  "mcpServers": {
    "github": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"  ← Placeholder
      }
    }
  }
}
```

**Local secrets file (NOT version controlled):**

```json
{
  "GITHUB_TOKEN": "ghp_actual_token_here"
}
```

**Sync script expands placeholders from environment or secrets file**

---

## Complete Sync System

### Directory Structure

```
Core/tooling/
├── config/
│   ├── cursor/
│   │   ├── mcp.json                      ← Canonical MCP config (synced)
│   │   ├── recommended-settings.json     ← Recommended Cursor settings
│   │   ├── env.template.json             ← Template for secrets
│   │   └── README.md                     ← Config documentation
│   └── vscode/
│       └── recommended-settings.json
├── sync-cursor-config.ps1                ← Sync script
├── install-cursor-environment.ps1        ← Complete setup script
└── README.md
```

---

## Automated Sync

### Git Hooks (Optional)

**`.git/hooks/post-merge`:**

```bash
#!/bin/bash
# Auto-sync Cursor config after git pull

CHANGED=$(git diff-tree -r --name-only --no-commit-id ORIG_HEAD HEAD | grep "Core/tooling/config/cursor/mcp.json")

if [ ! -z "$CHANGED" ]; then
    echo "🔄 Cursor MCP config changed, syncing..."
    pwsh Core/tooling/sync-cursor-config.ps1 -Direction pull
    echo "⚠️  Restart Cursor to apply changes"
fi
```

**Makes it automatic!**

---

### VS Code Task

**`.vscode/tasks.json`:**

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Sync Cursor Config (Pull)",
      "type": "shell",
      "command": "pwsh",
      "args": ["Core/tooling/sync-cursor-config.ps1", "-Direction", "pull"],
      "problemMatcher": []
    },
    {
      "label": "Sync Cursor Config (Push)",
      "type": "shell",
      "command": "pwsh",
      "args": ["Core/tooling/sync-cursor-config.ps1", "-Direction", "push"],
      "problemMatcher": []
    }
  ]
}
```

**Usage:** Ctrl+Shift+P → "Run Task" → "Sync Cursor Config"

---

## Complete Setup Script

**File:** `Core/tooling/install-cursor-environment.ps1`

```powershell
# Complete Cursor environment setup
# Installs MCP servers and configures environment

Write-Host "🚀 SPECTRA Cursor Environment Setup" -ForegroundColor Cyan
Write-Host "=" * 60

# Step 1: Pull canonical config
Write-Host "`n📥 Step 1: Restoring Cursor configuration..."
.\sync-cursor-config.ps1 -Direction pull -Force

# Step 2: Install NPM-based MCP servers
Write-Host "`n📦 Step 2: Installing MCP servers..."
$servers = @(
    "@railway/mcp-server",
    "@modelcontextprotocol/server-github",
    "@modelcontextprotocol/server-playwright",
    "@modelcontextprotocol/server-filesystem",
    "@modelcontextprotocol/server-git",
    "@softeria/ms-365-mcp-server",
    "@cloudflare/mcp-server-dns-analytics",
    "@atlassian/mcp-server",
    "@azure/mcp-server"
)

foreach ($server in $servers) {
    Write-Host "  Installing $server..." -ForegroundColor Yellow
    npx -y $server --help 2>&1 | Out-Null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "    ✅ $server" -ForegroundColor Green
    } else {
        Write-Host "    ⚠️  $server (may install on first use)" -ForegroundColor Yellow
    }
}

# Step 3: Configure Python MCP (SPECTRA Context)
Write-Host "`n🐍 Step 3: Configuring Python MCP servers..."
$mcpService = "C:\Users\markm\OneDrive\SPECTRA\Core\mcp-service"
if (Test-Path $mcpService) {
    Push-Location $mcpService
    if (Test-Path "pyproject.toml") {
        Write-Host "  Installing spectra-context-mcp..."
        pip install -e . --quiet
        Write-Host "    ✅ spectra-context-mcp" -ForegroundColor Green
    }
    Pop-Location
}

# Step 4: Create secrets template
Write-Host "`n🔐 Step 4: Setting up secrets template..."
$envTemplate = @{
    GITHUB_PERSONAL_ACCESS_TOKEN = "ghp_your_token_here"
    ATLASSIAN_API_TOKEN = "your_jira_token_here"
    ATLASSIAN_DOMAIN = "your-domain.atlassian.net"
} | ConvertTo-Json

$envTemplatePath = "config/cursor/env.template.json"
$envTemplate | Set-Content $envTemplatePath
Write-Host "  Created: $envTemplatePath" -ForegroundColor Green
Write-Host "  💡 Copy to ~/.cursor/env.json and add your tokens"

# Summary
Write-Host "`n" + ("=" * 60)
Write-Host "✅ Cursor Environment Setup Complete!" -ForegroundColor Green
Write-Host ("=" * 60)
Write-Host "`n📋 Next steps:"
Write-Host "  1. Add secrets to ~/.cursor/env.json (or environment variables)"
Write-Host "  2. Restart Cursor"
Write-Host "  3. Verify MCP servers: Ask AI to list MCP resources"
Write-Host ""
Write-Host "🎭 MCP Servers Configured (10):"
Write-Host "  - Railway, GitHub, MS365, Playwright, Jira/Atlassian"
Write-Host "  - Azure, Cloudflare, Filesystem, Git, SPECTRA-Context"
```

---

## Quick Reference

### Sync Commands

```powershell
# Restore from git (after pull on new machine)
.\sync-cursor-config.ps1 -Direction pull

# Backup to git (after local changes)
.\sync-cursor-config.ps1 -Direction push

# Compare local vs canonical
.\sync-cursor-config.ps1 -Direction diff

# Force overwrite (no confirmation)
.\sync-cursor-config.ps1 -Direction pull -Force
```

---

### Complete Setup (New Machine)

```powershell
# 1. Clone SPECTRA
git clone https://github.com/SPECTRACoreSolutions/... SPECTRA
cd SPECTRA

# 2. Run complete setup
cd Core/tooling
.\install-cursor-environment.ps1

# 3. Add your secrets
# Edit ~/.cursor/env.json with your tokens

# 4. Restart Cursor
```

**Result:** Fully configured Cursor environment in ~5 minutes! ✅

---

## Benefits

### For You

✅ **One command sync** - Pull config on any machine  
✅ **Version controlled** - Config changes tracked in git  
✅ **No manual setup** - Automated installation  
✅ **Consistent everywhere** - Same MCP servers on all machines

### For Team

✅ **Onboarding** - New team members get config automatically  
✅ **Standards** - Everyone uses same tools  
✅ **Updates** - Config changes sync via git pull  
✅ **Audit trail** - Git history shows config evolution

---

## Status

### Current State

- ✅ `.cursor/mcp.json` exists (10 MCP servers)
- ❌ Not version controlled yet
- ❌ No sync script yet
- ❌ Manual sync required

### After Implementation

- ✅ Canonical config in `Core/tooling/config/cursor/`
- ✅ Sync script available
- ✅ One-command sync
- ✅ Automated setup for new machines

---

**Should I create the sync scripts and canonical config now?**

---

_Created: 2025-12-02_  
_Purpose: Keep Cursor environment consistent across machines_  
_Status: Design complete, ready to implement_
