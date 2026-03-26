# Cursor Configuration - Canonical Source

**Date:** 2025-12-02
**Purpose:** Version-controlled Cursor MCP configuration

---

## Files in This Directory

### `mcp.json` ✅ Version Controlled

**Canonical Cursor MCP server configuration**

Contains 10 MCP servers (priority ordered):

**Priority 1 - Critical (Required):**
1. **spectra-context** - SPECTRA's own MCP server (framework knowledge, 7-stage pipeline)
2. **Railway** - Primary deployment platform for SPECTRA services
3. **filesystem** - Essential for AI file operations and workspace access
4. **git** - Git operations for version control (non-interactive)
5. **github** - GitHub API operations (issues, PRs, repos) - *requires GITHUB_PERSONAL_ACCESS_TOKEN*

**Priority 2 - Important (Recommended):**
6. **ms365** - Microsoft 365 integration (Outlook, Calendar, OneDrive, Excel)
7. **azure** - Azure services integration (Fabric, authentication, resources)

**Priority 3 - Optional:**
8. **atlassian** - Jira/Confluence integration - *requires ATLASSIAN_API_TOKEN and ATLASSIAN_DOMAIN*
9. **cloudflare-dns** - Cloudflare DNS analytics

**Note:** Playwright MCP server removed - package `@modelcontextprotocol/server-playwright` does not exist in npm registry and is not supported.

See `.cursor/MCP-SERVERS-RECOMMENDATIONS.md` for full details and setup instructions.

---

## How to Use

### Sync Your Local Cursor Config

**From repository root:**

```powershell
cd Core/tooling
.\sync-cursor-config.ps1 -Direction pull
```

**Then restart Cursor** to apply changes

---

### After Changing MCP Config

**Push changes to repository:**

```powershell
cd Core/tooling
.\sync-cursor-config.ps1 -Direction push
git add config/cursor/mcp.json
git commit -m "🔧 Update MCP config - added XYZ"
git push
```

---

### Check Sync Status

```powershell
.\sync-cursor-config.ps1 -Direction diff
```

Shows differences between local and canonical configs

---

## Configuration Notes

### Secrets Management

**This file contains:** Server configurations (NPM packages, commands)

**This file does NOT contain:** Actual secrets/tokens

**Secrets are in environment variables:**

- `GITHUB_PERSONAL_ACCESS_TOKEN`
- `ATLASSIAN_API_TOKEN`
- `ATLASSIAN_DOMAIN`

**Add secrets to:**

- Windows: System environment variables
- OR: `.cursor/env.json` (local only, not version controlled)

---

## MCP Servers Overview

### Already Configured (10)

| Server          | Package                                   | Status | Credentials Needed                    |
| --------------- | ----------------------------------------- | ------ | ------------------------------------- |
| SPECTRA-Context | Python local service                      | ✅     | None (local service)                  |
| Railway         | `@railway/mcp-server`                     | ✅     | None (CLI auth)                       |
| Filesystem      | `@modelcontextprotocol/server-filesystem` | ✅     | None (uses ALLOWED_DIRECTORIES)       |
| Git             | `@modelcontextprotocol/server-git`        | ✅     | None                                  |
| GitHub          | `@modelcontextprotocol/server-github`     | ✅     | GITHUB_PERSONAL_ACCESS_TOKEN          |
| MS365           | `@softeria/ms-365-mcp-server`             | ✅     | None (OAuth flow)                     |
| Azure           | `@azure/mcp-server`                       | ✅     | None (uses Azure CLI)                 |
| Atlassian       | `@atlassian/mcp-server`                   | ⚠️     | ATLASSIAN_API_TOKEN, ATLASSIAN_DOMAIN |
| Cloudflare      | `@cloudflare/mcp-server-dns-analytics`    | ✅     | CLOUDFLARE_API_TOKEN (likely)         |

**Note:** Playwright MCP server removed - package `@modelcontextprotocol/server-playwright` does not exist in npm registry (404 error).

### Credentials Status

**Configured:**

- ✅ SPECTRA-Context (local Python service)
- ✅ Filesystem (ALLOWED_DIRECTORIES set)

**Need Configuration:**

- ⚠️ GitHub (GITHUB_PERSONAL_ACCESS_TOKEN empty)
- ⚠️ Atlassian/Jira (tokens empty)

---

## Setting Up Credentials

### Option 1: Environment Variables (Recommended)

```powershell
# Windows - Permanent (User level)
[Environment]::SetEnvironmentVariable("GITHUB_PERSONAL_ACCESS_TOKEN", "ghp_your_token", "User")
[Environment]::SetEnvironmentVariable("ATLASSIAN_API_TOKEN", "your_token", "User")
[Environment]::SetEnvironmentVariable("ATLASSIAN_DOMAIN", "your-domain.atlassian.net", "User")

# Restart Cursor after setting
```

### Option 2: Update mcp.json Directly (Not Recommended)

**Don't add secrets to version-controlled files!**

Instead, reference environment variables in the config:

```json
{
  "env": {
    "GITHUB_PERSONAL_ACCESS_TOKEN": "${GITHUB_TOKEN}"
  }
}
```

---

## Multi-Machine Setup

### Machine 1 (Already Set Up)

**Current state:**

- ✅ `.cursor/mcp.json` exists (9 servers - Playwright removed, package doesn't exist)
- ✅ `config/cursor/mcp.json` is canonical version
- ✅ Sync script available

**To push config to git:**

```powershell
cd Core/tooling
git add config/cursor/mcp.json sync-cursor-config.ps1
git commit -m "🔧 Add Cursor MCP canonical config + sync script"
git push
```

---

### Machine 2 (New Machine)

**Setup:**

```powershell
# 1. Clone SPECTRA
git clone https://github.com/SPECTRACoreSolutions/framework.git SPECTRA
cd SPECTRA

# 2. Sync Cursor config
cd Core/tooling
.\sync-cursor-config.ps1 -Direction pull -Force

# 3. Set environment variables (your tokens)
[Environment]::SetEnvironmentVariable("GITHUB_PERSONAL_ACCESS_TOKEN", "your_token", "User")

# 4. Restart Cursor
```

**Result:** Identical MCP configuration on Machine 2! ✅

---

## Maintenance

### When Adding New MCP Server

**Workflow:**

1. Add to local `.cursor/mcp.json` (via Cursor settings or manually)
2. Test that it works
3. Push to canonical: `.\sync-cursor-config.ps1 -Direction push`
4. Commit: `git add config/cursor/mcp.json && git commit -m "🔧 Add XYZ MCP"`
5. Push: `git push`

**Other machines:** `git pull` + `.\sync-cursor-config.ps1 -Direction pull`

---

### Regular Sync

**Recommended:**

- After `git pull`: Run `.\sync-cursor-config.ps1 -Direction diff`
- If changes detected: Run with `-Direction pull` and restart Cursor
- After local changes: Push to canonical and commit

---

## Troubleshooting

### "Configurations out of sync"

**Check differences:**

```powershell
.\sync-cursor-config.ps1 -Direction diff
```

**Resolve:**

- To adopt git version: `.\sync-cursor-config.ps1 -Direction pull -Force`
- To update git version: `.\sync-cursor-config.ps1 -Direction push -Force`

### "MCP server not working"

**Check:**

1. Is server in `mcp.json`?
2. Are credentials set in environment?
3. Has Cursor been restarted?
4. Check Cursor logs for MCP errors

### "Sync script fails"

**Check:**

- PowerShell 7.0+ installed?
- Correct working directory?
- File permissions OK?

---

## Git Ignore Settings

**DO commit:**

- ✅ `config/cursor/mcp.json` (no secrets)
- ✅ Sync scripts
- ✅ Documentation

**DON'T commit:**

- ❌ `.cursor/mcp.json` (local working copy)
- ❌ `.cursor/env.json` (secrets)
- ❌ `.cursor/cache/` (ephemeral)

**Current `.gitignore` should have:**

```
.cursor/
!Core/tooling/config/cursor/
```

This ignores `.cursor/` but allows `Core/tooling/config/cursor/`

---

## Status

✅ **Canonical config created** - `config/cursor/mcp.json` (9 servers - Playwright removed, package doesn't exist)
✅ **Sync script created** - `sync-cursor-config.ps1`
✅ **Both in sync** - Local and canonical match
✅ **Ready to commit** - Can be version controlled

---

**Next:** Commit to git, then sync is automatic on all machines!

---

_Created: 2025-12-02_
_Purpose: Version control for Cursor environment_
_Status: Active_
