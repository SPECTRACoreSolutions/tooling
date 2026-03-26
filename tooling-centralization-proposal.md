# SPECTRA Tooling Centralization Proposal

**Status**: Proposal  
**Date**: 2025-12-07  
**Goal**: Single source of truth for all SPECTRA tooling across all platforms and services

---

## 🎯 SPECTRA-Grade Principle

**Single Source of Truth = Zero Duplication = SPECTRA-Grade**

One canonical tooling manifest that:
- ✅ Onboarding scripts read from
- ✅ Assistant service uses
- ✅ All services reference
- ✅ Platform-agnostic where possible
- ✅ Platform-specific where necessary

---

## 📊 Current State Analysis

### What Exists Now

1. **`Core/tooling/tooling.json`** (Simple, Universal)
   - Python packages
   - npm packages
   - VS Code extensions
   - Environment variables
   - Shell profiles
   - **Used by**: Assistant service (via `apply_tooling()`)

2. **`Core/onboarding/bootstrap/tooling-config.yaml`** (Platform-Specific)
   - Tool installation config (winget IDs, paths, verify commands)
   - Editor configuration
   - VS Code settings
   - GitHub orgs
   - **Used by**: Onboarding bootstrap scripts

3. **`Core/onboarding/bootstrap/tooling-versions.yaml`** (Version Registry)
   - Current versions
   - Update policies
   - **Used by**: Version sync scripts

### The Problem

- **Duplication**: Python packages listed in both `tooling.json` and `tooling-config.yaml`
- **Fragmentation**: Three files, three sources of truth
- **Maintenance burden**: Update tooling in multiple places

---

## ✅ SPECTRA-Grade Solution

### Architecture: Enhanced `tooling.json` as Canonical Source

**Location**: `Core/tooling/tooling.json` (already exists, already in Core/tooling/)

**Structure**:
```json
{
  "version": 2,
  "metadata": {
    "last_updated": "2025-12-07",
    "maintainer": "SPECTRA Infrastructure Team"
  },
  "python": {
    "packages": [...],
    "editable": [...]
  },
  "npm": {
    "global": [...]
  },
  "vscode": {
    "extensions": [...]
  },
  "tools": {
    "git": {
      "required": true,
      "install": {
        "windows": { "winget_id": "Git.Git" },
        "macos": { "homebrew": "git" },
        "linux": { "apt": "git" }
      },
      "verify": "git --version"
    },
    "python": {
      "version": "3.11",
      "required": true,
      "install": {
        "windows": { "winget_id": "Python.Python.3.11" },
        "macos": { "homebrew": "python@3.11" },
        "linux": { "apt": "python3.11" }
      },
      "verify": "python --version",
      "global_packages": ["ipykernel", "ms-fabric-cli", "ruff"]
    }
  },
  "env": {
    "required": [...],
    "optional": [...]
  },
  "shellProfiles": {...}
}
```

### Benefits

1. **Single Source of Truth**
   - One file to update
   - All platforms read from same source
   - All services use same manifest

2. **Platform-Agnostic Core**
   - Python packages, npm packages, extensions = universal
   - Platform-specific install details = nested under `tools.*.install`

3. **Backward Compatible**
   - Assistant's `apply_tooling()` already reads `tooling.json`
   - Onboarding scripts can migrate gradually
   - YAML files can be generated from JSON if needed

4. **SPECTRA-Grade**
   - Zero duplication
   - Perfect execution
   - Single canonical source

---

## 🚀 Migration Plan

### Phase 1: Enhance `tooling.json` (1 hour)

1. Add `tools` section with platform-specific install details
2. Add `metadata` section for versioning
3. Keep existing structure (backward compatible)

### Phase 2: Update Onboarding Scripts (2 hours)

1. Create `Core/tooling/scripts/load-tooling.py` - Universal loader
2. Update `setup-windows.ps1` to read from `tooling.json`
3. Update `setup-macos.sh` to read from `tooling.json`
4. Keep YAML files as generated artifacts (optional)

### Phase 3: Update Assistant (Already Done ✅)

- ✅ Dockerfile copies `tooling/` directory
- ✅ `apply_tooling()` reads `tooling.json`
- ✅ No changes needed

### Phase 4: Deprecate YAML Files (Optional)

- Generate YAML from JSON if needed for backward compatibility
- Or remove once onboarding scripts migrated

---

## 📋 Implementation Details

### Enhanced `tooling.json` Structure

```json
{
  "version": 2,
  "metadata": {
    "last_updated": "2025-12-07",
    "schema_version": "2.0",
    "maintainer": "SPECTRA Infrastructure Team"
  },
  
  "python": {
    "version": "3.11",
    "packages": [
      "ms-fabric-cli",
      "ipykernel",
      "ruff",
      "openai",
      "tomli",
      "pytest",
      "pytest-cov",
      "pytest-asyncio"
    ],
    "editable": [
      "cli"
    ]
  },
  
  "npm": {
    "global": [
      "@railway/cli@4.11.2",
      "@pnp/cli-microsoft365@11.1.0"
    ]
  },
  
  "vscode": {
    "extensions": [
      "ms-vscode-remote.remote-containers",
      "github.copilot",
      "github.copilot-chat",
      "ms-vscode.powershell",
      "ms-python.python",
      "ms-python.vscode-pylance",
      "charliermarsh.ruff",
      "ms-toolsai.jupyter",
      "bierner.markdown-preview-github-styles",
      "yzhang.markdown-all-in-one"
    ]
  },
  
  "tools": {
    "git": {
      "required": true,
      "install": {
        "windows": { "winget_id": "Git.Git" },
        "macos": { "homebrew": "git" },
        "linux": { "apt": "git" }
      },
      "verify": "git --version"
    },
    "github_cli": {
      "required": true,
      "install": {
        "windows": { "winget_id": "GitHub.cli" },
        "macos": { "homebrew": "gh" },
        "linux": { "apt": "gh" }
      },
      "verify": "gh --version",
      "auth_scopes": ["repo", "read:org", "workflow"]
    },
    "python": {
      "version": "3.11",
      "required": true,
      "install": {
        "windows": { "winget_id": "Python.Python.3.11" },
        "macos": { "homebrew": "python@3.11" },
        "linux": { "apt": "python3.11" }
      },
      "verify": "python --version",
      "install_path": {
        "windows": "${env:LOCALAPPDATA}/Programs/Python/Python311"
      }
    },
    "azure_cli": {
      "required": true,
      "install": {
        "windows": { "winget_id": "Microsoft.AzureCLI" },
        "macos": { "homebrew": "azure-cli" },
        "linux": { "script": "https://aka.ms/InstallAzureCLIDeb" }
      },
      "verify": "az --version"
    },
    "nodejs": {
      "required": false,
      "version": "lts",
      "install": {
        "windows": { "winget_id": "OpenJS.NodeJS.LTS" },
        "macos": { "homebrew": "node" },
        "linux": { "nodesource": "lts" }
      },
      "verify": "node --version"
    },
    "powershell": {
      "required": true,
      "install": {
        "windows": { "winget_id": "Microsoft.PowerShell" },
        "macos": { "homebrew": "powershell" },
        "linux": { "apt": "powershell" }
      },
      "verify": "pwsh --version"
    }
  },
  
  "env": {
    "required": [
      "SPECTRA_FABRIC_CLIENT_ID",
      "SPECTRA_FABRIC_CLIENT_SECRET",
      "SPECTRA_FABRIC_TENANT_ID",
      "SPECTRA_FABRIC_CAPACITY_ID",
      "SPECTRA_GITHUB_APP_ID",
      "SPECTRA_GITHUB_APP_INSTALLATION_ID_CORE",
      "SPECTRA_GITHUB_APP_PRIVATE_KEY_PATH"
    ],
    "optional": [
      "SPECTRA_DATA_ROOT"
    ]
  },
  
  "shellProfiles": {
    "pwsh": "...",
    "bash": "..."
  }
}
```

### Universal Loader Script

**Location**: `Core/tooling/scripts/load-tooling.py`

```python
"""Universal tooling.json loader for all platforms."""
import json
from pathlib import Path
from typing import Any, Dict

def load_tooling(repo_root: Path | None = None) -> Dict[str, Any]:
    """Load tooling.json from SPECTRA root."""
    if repo_root is None:
        # Auto-detect SPECTRA root (look for Core/tooling/tooling.json)
        current = Path(__file__).parent.parent
        if (current / "tooling.json").exists():
            repo_root = current.parent.parent
        else:
            raise ValueError("Cannot find SPECTRA root")
    
    tooling_path = repo_root / "Core" / "tooling" / "tooling.json"
    if not tooling_path.exists():
        raise FileNotFoundError(f"tooling.json not found at {tooling_path}")
    
    return json.loads(tooling_path.read_text())

def get_platform_tool_install(tooling: Dict, tool_name: str, platform: str) -> Dict | None:
    """Get platform-specific install config for a tool."""
    tools = tooling.get("tools", {})
    tool = tools.get(tool_name, {})
    install = tool.get("install", {})
    return install.get(platform)

# Usage in PowerShell:
# $tooling = python -c "from Core.tooling.scripts.load_tooling import load_tooling; import json; print(json.dumps(load_tooling()))" | ConvertFrom-Json

# Usage in Bash:
# tooling=$(python3 -c "from Core.tooling.scripts.load_tooling import load_tooling; import json; print(json.dumps(load_tooling()))")
```

---

## ✅ Benefits Summary

1. **Single Source of Truth**
   - One file: `Core/tooling/tooling.json`
   - All platforms read from it
   - All services use it

2. **Zero Duplication**
   - Python packages listed once
   - npm packages listed once
   - Extensions listed once
   - Tools defined once (with platform variants)

3. **Platform-Agnostic Core**
   - Universal packages/extensions
   - Platform-specific install details nested

4. **Backward Compatible**
   - Existing `apply_tooling()` works
   - Onboarding can migrate gradually
   - YAML files optional (can generate if needed)

5. **SPECTRA-Grade**
   - Perfect execution
   - Zero tech debt
   - Single canonical source

---

## 🎯 Recommendation

**Enhance `Core/tooling/tooling.json` to be the canonical source:**

1. ✅ Already exists in correct location (`Core/tooling/`)
2. ✅ Already used by assistant service
3. ✅ JSON is universal (works everywhere)
4. ✅ Can include platform-specific details
5. ✅ Single source of truth

**Migration path:**
- Phase 1: Enhance `tooling.json` (add `tools` section)
- Phase 2: Update onboarding scripts to read from `tooling.json`
- Phase 3: Deprecate YAML files (or generate from JSON)

**Time estimate**: 3-4 hours total

---

**Status**: Ready to implement  
**Priority**: High (reduces maintenance burden, aligns with SPECTRA principles)

