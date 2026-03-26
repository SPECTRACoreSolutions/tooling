# Deprecated Tooling Files

**Status**: Deprecated  
**Date**: 2025-12-07  
**Replacement**: `Core/registries/tooling-registry.yaml`

---

## ⚠️ Deprecated Files

These files are **deprecated** and will be removed in a future version. All tooling data has been migrated to the canonical registry.

### 1. `Core/tooling/tooling.json`

**Status**: ❌ **DEPRECATED**  
**Replacement**: `Core/registries/tooling-registry.yaml`  
**Migration Date**: 2025-12-07

**Reason**: Replaced by canonical registry following SPECTRA registry pattern.

**Action Required**: 
- Update any scripts reading from this file to use `Core/registries/tooling-registry.yaml`
- Assistant service: Already updated to use registry (with fallback for backward compatibility)

---

### 2. `Core/onboarding/bootstrap/tooling-config.yaml`

**Status**: ❌ **DEPRECATED**  
**Replacement**: `Core/registries/tooling-registry.yaml`  
**Migration Date**: 2025-12-07

**Reason**: Replaced by canonical registry. All configuration data merged into registry.

**Action Required**:
- Update `setup-windows.ps1` and `setup-macos.sh` to read from registry
- Update `setup-windows-v2.ps1` and `setup-macos-v2.sh` to read from registry

---

### 3. `Core/onboarding/bootstrap/tooling-versions.yaml`

**Status**: ❌ **DEPRECATED**  
**Replacement**: `Core/registries/tooling-registry.yaml`  
**Migration Date**: 2025-12-07

**Reason**: Version data merged into canonical registry under `tools.*.version` and `tools.*.current_version`.

**Action Required**:
- Update `check_tool_updates.py` to read/write registry
- Update `sync_versions_to_dockerfile.py` to read from registry

---

## ✅ Migration Status

- [x] Registry created: `Core/registries/tooling-registry.yaml`
- [x] Assistant service updated (with backward compatibility fallback)
- [ ] Onboarding scripts updated
- [ ] Tool update scripts updated
- [ ] All documentation updated

---

## 📋 How to Use Registry

### PowerShell

```powershell
$RegistryPath = Join-Path $PSScriptRoot "..\..\..\Core\registries\tooling-registry.yaml"
$tooling = Get-Content $RegistryPath | ConvertFrom-Yaml

# Get Python packages
$pythonPackages = $tooling.python.packages

# Get platform-specific tool install
$gitInstall = $tooling.tools.git.install.windows
```

### Python

```python
import yaml
from pathlib import Path

registry_path = Path(__file__).parent.parent.parent / "Core" / "registries" / "tooling-registry.yaml"
with open(registry_path) as f:
    tooling = yaml.safe_load(f)

# Get Python packages
python_packages = tooling["python"]["packages"]
```

### Bash

```bash
# Using python
registry_path="$(dirname "$0")/../../../Core/registries/tooling-registry.yaml"
python_packages=$(python3 -c "
import yaml
with open('$registry_path') as f:
    tooling = yaml.safe_load(f)
    print(' '.join(tooling['python']['packages']))
")
```

---

## 🗑️ Removal Timeline

**Phase 1** (Current): Deprecated, kept for backward compatibility  
**Phase 2** (2025-12-14): Remove if no references found  
**Phase 3** (2025-12-21): Final removal

---

**Note**: These files are kept temporarily for backward compatibility during migration. Once all consumers are updated, they will be removed.


