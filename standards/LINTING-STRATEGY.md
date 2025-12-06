# SPECTRA Linting Strategy

**Date:** 2025-12-04  
**Scope:** Universal linting with context-aware rules

---

## 🎯 Vision

**One linting system, multiple contexts:**
- ✅ General Python code (strict)
- ✅ Fabric notebooks (relaxed for runtime injections)
- ✅ Test code (relaxed for docstrings/annotations)
- ✅ Scripts (relaxed for structure)

---

## 📦 Current State

### What We Have

1. **Fabric-Specific Script**
   - **Location:** `Data/zephyr/.pre-commit-lint.ps1`
   - **Scope:** Only for Zephyr Fabric notebook
   - **Rules:** Hardcoded for Fabric

2. **Fabric SDK Ruff Config**
   - **Location:** `Core/fabric-sdk/pyproject.toml`
   - **Scope:** Fabric-specific Python packages
   - **Rules:**
     ```toml
     [tool.ruff.lint.per-file-ignores]
     "*.Notebook/*.py" = [
         "E402",  # Import not at top (Fabric metadata cells)
         "F821",  # Undefined names (spark, notebookutils injected)
     ]
     ```

### What We Need

**Universal linting script that detects context:**
```bash
# Usage anywhere in SPECTRA
spectra-lint <file_or_directory>

# Auto-detects:
# - Fabric notebooks → apply Fabric rules
# - Test files → apply test rules
# - Regular Python → apply strict rules
```

---

## 🏗️ Proposed Architecture

### 1. **Universal Lint Script**
**Location:** `Core/tooling/scripts/spectra-lint.ps1`

**Features:**
- ✅ Context detection (Fabric, tests, scripts, general)
- ✅ Auto-apply appropriate rules
- ✅ Pre-commit hook friendly
- ✅ CI/CD ready

**Detection logic:**
```python
def detect_context(file_path):
    if ".Notebook/notebook-content.py" in file_path:
        return "fabric"
    elif file_path.startswith("tests/") or file_path.endswith("_test.py"):
        return "test"
    elif file_path.startswith("scripts/"):
        return "script"
    else:
        return "general"
```

### 2. **Context-Specific Rules**

#### **Fabric Notebooks**
```toml
# Relaxed rules for Fabric runtime environment
ignore = [
    "E402",   # Import not at top (metadata cells first)
    "F821",   # Undefined names (spark, notebookutils, display)
    "F401",   # Unused imports (conditional imports)
]

# Fabric-specific checks (custom)
# - Parameter cell structure validation
# - Variable Library usage patterns
# - Delta table naming conventions
```

#### **Test Files**
```toml
# Relaxed rules for tests
ignore = [
    "D",      # Docstrings (tests are self-documenting)
    "ANN",    # Type annotations (overkill for tests)
    "S101",   # assert usage (required in tests!)
]
```

#### **Scripts**
```toml
# Relaxed rules for automation scripts
ignore = [
    "T201",   # print() statements (needed for output)
    "D",      # Docstrings (scripts are ad-hoc)
]
```

#### **General Python**
```toml
# Strict rules for production code
select = [
    "E",    # pycodestyle errors
    "W",    # pycodestyle warnings
    "F",    # Pyflakes
    "I",    # isort
    "B",    # flake8-bugbear
    "N",    # pep8-naming
    "D",    # pydocstyle
    "ANN",  # flake8-annotations
]
```

### 3. **Central Configuration**
**Location:** `Core/tooling/ruff.toml`

```toml
[tool.ruff]
target-version = "py311"
line-length = 120

[tool.ruff.lint]
# Base rules (apply to all)
select = ["E", "F", "W", "I", "B"]

# Context-specific overrides
[tool.ruff.lint.per-file-ignores]
# Fabric notebooks
"**/*.Notebook/*.py" = ["E402", "F821", "F401"]

# Tests
"**/tests/**/*.py" = ["D", "ANN", "S101"]

# Scripts
"**/scripts/**/*.py" = ["T201", "D"]
```

---

## 🚀 Implementation Plan

### Phase 1: Universal Script (Quick Win)
**Create:** `Core/tooling/scripts/spectra-lint.ps1`
```powershell
# Detect context and apply appropriate rules
param(
    [Parameter(Mandatory=$true)]
    [string]$Path
)

# Detect file type
if ($Path -like "*.Notebook/notebook-content.py") {
    Write-Host "🔍 Fabric notebook detected" -ForegroundColor Cyan
    ruff check $Path --select E,F --ignore E402,F821,F401
} elseif ($Path -like "*test*.py") {
    Write-Host "🔍 Test file detected" -ForegroundColor Cyan
    ruff check $Path --ignore D,ANN,S101
} else {
    Write-Host "🔍 General Python file" -ForegroundColor Cyan
    ruff check $Path
}
```

### Phase 2: Central Config (Standard)
**Create:** `Core/tooling/ruff.toml`
- Single source of truth for all linting rules
- All projects reference this config
- Context-specific overrides

### Phase 3: Custom Fabric Rules (Advanced)
**Create:** `Core/fabric-sdk/linters/fabric_notebook_linter.py`
- Custom checks beyond Ruff's capabilities
- Parameter cell structure validation
- Delta table naming conventions
- SPECTRA standards enforcement

---

## 🎯 Key Decisions

### 1. **Fabric-Specific Ignores**

**WHY?**
- `F821` (undefined names): Fabric injects `spark`, `notebookutils`, `display` at runtime
- `E402` (imports not at top): Fabric notebooks have metadata cells before imports
- `F401` (unused imports): Conditional imports based on Fabric vs local mode

**Example:**
```python
# This is VALID in Fabric but triggers F821:
df = spark.createDataFrame([...])  # spark is injected by Fabric

# This is VALID in Fabric but triggers E402:
# METADATA CELL HERE
import json  # Import after metadata
```

### 2. **Where to Put Rules?**

**Option A: Per-Project `pyproject.toml`** ❌
- Duplicates configuration
- Hard to maintain consistency
- Each project needs its own config

**Option B: Central `Core/tooling/ruff.toml`** ✅
- Single source of truth
- Consistency across SPECTRA
- Easy to maintain

**Decision:** Central config in `Core/tooling/`

### 3. **How to Detect Fabric Notebooks?**

**Pattern:** `**/*.Notebook/*.py`
- Fabric exports notebooks to `<name>.Notebook/notebook-content.py`
- This is a reliable indicator
- No false positives

---

## 📊 Impact

| Context | Current | Proposed |
|---------|---------|----------|
| **Fabric Notebooks** | Manual, ad-hoc | Auto-detected, Fabric rules |
| **Test Files** | No linting | Auto-detected, relaxed rules |
| **Scripts** | No linting | Auto-detected, script rules |
| **General Python** | Inconsistent | Auto-detected, strict rules |

---

## ✅ Success Criteria

- [ ] Universal `spectra-lint` command works anywhere
- [ ] Auto-detects Fabric notebooks
- [ ] Applies context-appropriate rules
- [ ] Zero false positives for Fabric injected objects
- [ ] Catches real errors (like today's `should_test_endpoints`)
- [ ] Fast (<5 seconds for typical file)
- [ ] CI/CD ready

---

## 🎓 Key Insights

### 1. **Context Matters**
Fabric notebooks have different constraints than general Python:
- Runtime injections (`spark`, `notebookutils`)
- Metadata cells before imports
- Conditional imports (local vs Fabric)

### 2. **One System, Multiple Modes**
Better to have ONE linting system with context-awareness than separate systems for each context.

### 3. **Ruff Supports This!**
Ruff's `per-file-ignores` feature is PERFECT for context-specific rules:
```toml
[tool.ruff.lint.per-file-ignores]
"**/*.Notebook/*.py" = ["F821"]  # Fabric injections
"**/tests/**/*.py" = ["D"]        # Test docstrings
```

---

## 🚀 Next Steps

### Immediate (Do Now)
1. **Create universal lint script** in `Core/tooling/scripts/`
2. **Add central Ruff config** in `Core/tooling/ruff.toml`
3. **Update Zephyr to use universal script**

### Short-term (This Week)
1. **Roll out to all Fabric notebooks**
2. **Add to pre-commit hooks**
3. **Document in SPECTRA standards**

### Long-term (Future)
1. **Custom Fabric linting rules** (parameter cell validation, etc.)
2. **CI/CD integration**
3. **VS Code extension integration**

---

## 💡 Bottom Line

**Current:** Fabric-specific, one-off solution  
**Proposed:** Universal, context-aware, SPECTRA-grade

**The linting solution should be universal, but smart enough to know when it's linting a Fabric notebook and apply appropriate rules!** 🎯

