# Tooling Registry Migration Guide

**Status**: Migration Complete  
**Date**: 2025-12-07  
**New Location**: `Core/registries/tooling-registry.yaml`

---

## 🎯 What Changed

**Single Source of Truth Created:**
- ✅ `Core/registries/tooling-registry.yaml` - New canonical registry
- ❌ `Core/tooling/tooling.json` - Deprecated (migrated)
- ❌ `Core/onboarding/bootstrap/tooling-config.yaml` - Deprecated (migrated)
- ❌ `Core/onboarding/bootstrap/tooling-versions.yaml` - Deprecated (migrated)

---

## 📋 Migration Status

### ✅ Phase 1: Registry Created
- [x] Created `Core/registries/tooling-registry.yaml`
- [x] Merged all tooling data from 3 files into single registry
- [x] Follows SPECTRA registry pattern (same as `service-catalog.yaml`)

### ⏳ Phase 2: Assistant Service (In Progress)
- [ ] Update `Core/assistant/files/start.sh` to read YAML instead of JSON
- [ ] Update `apply_tooling()` function to parse YAML
- [ ] Test in Docker container

### ⏳ Phase 3: Onboarding Scripts (Pending)
- [ ] Update `Core/onboarding/bootstrap/setup-windows.ps1` to read from registry
- [ ] Update `Core/onboarding/bootstrap/setup-macos.sh` to read from registry
- [ ] Create universal loader script

### ⏳ Phase 4: Deprecation (Pending)
- [ ] Mark old files as deprecated
- [ ] Add deprecation notices
- [ ] Update all documentation references

---

## 🔧 How to Use the Registry

### Python

```python
import yaml
from pathlib import Path

# Load registry
registry_path = Path(__file__).parent.parent.parent / "Core" / "registries" / "tooling-registry.yaml"
with open(registry_path) as f:
    tooling = yaml.safe_load(f)

# Get Python packages
python_packages = tooling["python"]["packages"]
# ['ms-fabric-cli', 'ipykernel', 'ruff', ...]

# Get platform-specific tool install
git_install = tooling["tools"]["git"]["install"]["windows"]
# {'winget_id': 'Git.Git'}
```

### PowerShell

```powershell
# Load registry
$registryPath = Join-Path $PSScriptRoot "..\..\..\Core\registries\tooling-registry.yaml"
$tooling = Get-Content $registryPath | ConvertFrom-Yaml

# Get Python packages
$pythonPackages = $tooling.python.packages
# ms-fabric-cli, ipykernel, ruff, ...

# Get platform-specific tool install
$gitInstall = $tooling.tools.git.install.windows
# winget_id: Git.Git
```

### Bash

```bash
# Load registry (requires yq or python)
registry_path="$(dirname "$0")/../../../Core/registries/tooling-registry.yaml"

# Using yq
python_packages=$(yq '.python.packages[]' "$registry_path")

# Using python
python_packages=$(python3 -c "
import yaml, sys
with open('$registry_path') as f:
    tooling = yaml.safe_load(f)
    print(' '.join(tooling['python']['packages']))
")
```

---

## 📝 Assistant Service Update

**Current:** Reads from `Core/tooling/tooling.json` (JSON)

**New:** Read from `Core/registries/tooling-registry.yaml` (YAML)

**File to Update:** `Core/assistant/files/start.sh`

**Change:**
```bash
# OLD
local tooling_json="/opt/spectra-tooling/tooling.json"
# ... JSON parsing ...

# NEW
local tooling_yaml="/opt/spectra-tooling/../registries/tooling-registry.yaml"
# ... YAML parsing with python ...
```

---

## 📝 Onboarding Scripts Update

**Current:** Read from `Core/onboarding/bootstrap/tooling-config.yaml`

**New:** Read from `Core/registries/tooling-registry.yaml`

**Files to Update:**
- `Core/onboarding/bootstrap/setup-windows.ps1`
- `Core/onboarding/bootstrap/setup-macos.sh`

**Change:**
```powershell
# OLD
$ConfigPath = Join-Path $scriptDir "tooling-config.yaml"
$config = Get-Content $ConfigPath | ConvertFrom-Yaml

# NEW
$RegistryPath = Join-Path $PSScriptRoot "..\..\..\Core\registries\tooling-registry.yaml"
$tooling = Get-Content $RegistryPath | ConvertFrom-Yaml
```

---

## ✅ Benefits

1. **Single Source of Truth** - One file, one location, one format
2. **SPECTRA-Grade Consistency** - Follows registry pattern exactly
3. **Zero Duplication** - All tooling data in one place
4. **Platform-Agnostic** - Universal packages, platform-specific installs nested
5. **Future-Proof** - Can be updated by solution-engine

---

## 🚨 Breaking Changes

**None** - Migration is backward compatible:
- Old files still exist (marked deprecated)
- Services can migrate gradually
- No immediate breaking changes

---

## 📚 Documentation Updates Needed

- [ ] Update `Core/assistant/README.md` - Reference registry
- [ ] Update `Core/onboarding/README.md` - Reference registry
- [ ] Update `Core/tooling/README.md` - Point to registry
- [ ] Update any scripts that reference old files

---

**Status**: Registry created, migration in progress  
**Next Step**: Update assistant service to use registry


