# SPECTRA-Grade Tooling Centralization

**Status**: Canonical Approach  
**Date**: 2025-12-07  
**Principle**: Follow SPECTRA registry pattern for canonical sources of truth

---

## 🎯 SPECTRA Pattern Analysis

### Existing SPECTRA Registries

SPECTRA uses **YAML registries** in `Core/registries/` for canonical sources of truth:

1. **`service-catalog.yaml`** - All deployed services
2. **`tools-registry.yaml`** - All CLI tools

**Pattern:**
- Location: `Core/registries/`
- Format: YAML
- Structure: Metadata + hierarchical data
- Purpose: Single source of truth

### Current Tooling State

- **`Core/tooling/tooling.json`** - JSON format, used by assistant
- **`Core/onboarding/bootstrap/tooling-config.yaml`** - YAML format, used by onboarding
- **`Core/onboarding/bootstrap/tooling-versions.yaml`** - YAML format, version registry

**Problem**: Three files, three sources of truth (violates SPECTRA-grade principle)

---

## ✅ SPECTRA-Grade Solution

### Option 1: Registry Pattern (Most SPECTRA-Grade)

**Create**: `Core/registries/tooling-registry.yaml`

**Follows SPECTRA pattern:**
- ✅ Location: `Core/registries/` (same as other registries)
- ✅ Format: YAML (consistent with service-catalog, tools-registry)
- ✅ Structure: Metadata + hierarchical data
- ✅ Single source of truth

**Structure:**
```yaml
metadata:
  version: '2.0'
  last_updated: '2025-12-07T00:00:00Z'
  updated_by: solution-engine
  description: Canonical tooling manifest - single source of truth for all SPECTRA platforms

python:
  version: "3.11"
  packages:
    - ms-fabric-cli
    - ipykernel
    - ruff
    - openai
    - tomli
    - pytest
    - pytest-cov
    - pytest-asyncio
  editable:
    - cli

npm:
  global:
    - "@railway/cli@4.11.2"
    - "@pnp/cli-microsoft365@11.1.0"

vscode:
  extensions:
    - ms-vscode-remote.remote-containers
    - github.copilot
    - github.copilot-chat
    # ... etc

tools:
  git:
    required: true
    install:
      windows:
        winget_id: "Git.Git"
      macos:
        homebrew: "git"
      linux:
        apt: "git"
    verify: "git --version"
  
  python:
    version: "3.11"
    required: true
    install:
      windows:
        winget_id: "Python.Python.3.11"
      macos:
        homebrew: "python@3.11"
      linux:
        apt: "python3.11"
    verify: "python --version"
    install_path:
      windows: "${env:LOCALAPPDATA}/Programs/Python/Python311"

env:
  required:
    - SPECTRA_FABRIC_CLIENT_ID
    - SPECTRA_FABRIC_CLIENT_SECRET
    # ... etc
  optional:
    - SPECTRA_DATA_ROOT

shell_profiles:
  pwsh: |
    # Load local .env if present
    if (Test-Path "$PSScriptRoot/../../.env") {
      # ... etc
    }
  bash: |
    if [ -f "$(dirname "${BASH_SOURCE[0]}")/../../.env" ]; then
      # ... etc
    fi
```

**Benefits:**
- ✅ Follows SPECTRA registry pattern exactly
- ✅ Consistent with `service-catalog.yaml` and `tools-registry.yaml`
- ✅ YAML is more readable for complex nested structures
- ✅ Single source of truth in canonical location
- ✅ Can be updated by solution-engine (like service-catalog)

**Migration:**
- Assistant: Update `apply_tooling()` to read YAML
- Onboarding: Already uses YAML, just point to registry
- All services: Read from `Core/registries/tooling-registry.yaml`

---

### Option 2: Enhanced JSON (Pragmatic)

**Enhance**: `Core/tooling/tooling.json` (already exists)

**Benefits:**
- ✅ Already exists and works
- ✅ Assistant already uses it
- ✅ JSON is universal (works everywhere)
- ✅ Simpler migration path

**Trade-off:**
- ⚠️ Doesn't follow registry pattern (different location/format)
- ⚠️ Inconsistent with other SPECTRA registries

---

## 🎯 SPECTRA-Grade Recommendation

### **Option 1: Registry Pattern** (Most SPECTRA-Grade)

**Why:**
1. **Follows SPECTRA pattern** - Same location and format as other registries
2. **Consistency** - All canonical sources in `Core/registries/` as YAML
3. **Future-proof** - Can be updated by solution-engine like service-catalog
4. **SPECTRA-grade** - Zero inconsistency, perfect alignment with standards

**Implementation:**
1. Create `Core/registries/tooling-registry.yaml`
2. Migrate all tooling data from:
   - `Core/tooling/tooling.json`
   - `Core/onboarding/bootstrap/tooling-config.yaml`
   - `Core/onboarding/bootstrap/tooling-versions.yaml`
3. Update assistant's `apply_tooling()` to read YAML
4. Update onboarding scripts to read from registry
5. Deprecate old files (or keep as generated artifacts)

**Time**: 4-5 hours (includes testing)

---

## 📋 Implementation Plan

### Phase 1: Create Registry (1 hour)

1. Create `Core/registries/tooling-registry.yaml`
2. Merge all tooling data into single YAML file
3. Follow exact structure of `service-catalog.yaml` (metadata + data)

### Phase 2: Update Assistant (1 hour)

1. Update `apply_tooling()` in `start.sh` to read YAML
2. Add YAML parser (Python has `yaml` module)
3. Test in Docker container

### Phase 3: Update Onboarding (2 hours)

1. Update `setup-windows.ps1` to read from registry
2. Update `setup-macos.sh` to read from registry
3. Create universal loader script (Python, works from any platform)

### Phase 4: Deprecate Old Files (30 min)

1. Mark old files as deprecated
2. Add migration notes
3. Update documentation

---

## ✅ SPECTRA-Grade Checklist

- [x] Follows existing SPECTRA patterns (registry location/format)
- [x] Single source of truth (one file)
- [x] Zero duplication (all data in one place)
- [x] Consistent with other registries (YAML in `Core/registries/`)
- [x] Can be updated by solution-engine (like service-catalog)
- [x] Platform-agnostic (works everywhere)
- [x] Backward compatible migration path

---

## 🎯 Final Recommendation

**Create `Core/registries/tooling-registry.yaml`** following the exact pattern of `service-catalog.yaml` and `tools-registry.yaml`.

This is the **most SPECTRA-grade approach** because:
1. ✅ Follows established SPECTRA pattern
2. ✅ Consistent with other canonical sources
3. ✅ Zero inconsistency
4. ✅ Perfect alignment with standards
5. ✅ Future-proof (can integrate with solution-engine)

**Status**: Ready to implement  
**Priority**: High (achieves SPECTRA-grade consistency)


