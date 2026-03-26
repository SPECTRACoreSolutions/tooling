#!/usr/bin/env pwsh
# SPECTRA Universal Linting Script
# Auto-detects context (Fabric, tests, scripts, general) and applies appropriate rules

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$Path,
    
    [Parameter(Mandatory=$false)]
    [switch]$Fix,
    
    [Parameter(Mandatory=$false)]
    [switch]$ShowRules
)

Write-Host "`n🔍 SPECTRA Linter`n" -ForegroundColor Cyan

# Detect context
$context = "general"
$contextEmoji = "📄"
$contextName = "General Python"

if ($Path -like "*.Notebook/notebook_content.py" -or $Path -like "*.Notebook\notebook_content.py") {
    $context = "fabric"
    $contextEmoji = "☁️"
    $contextName = "Fabric Notebook"
} elseif ($Path -like "*test*.py" -or $Path -like "*\tests\*" -or $Path -like "*/tests/*") {
    $context = "test"
    $contextEmoji = "🧪"
    $contextName = "Test File"
} elseif ($Path -like "*\scripts\*" -or $Path -like "*/scripts/*") {
    $context = "script"
    $contextEmoji = "🔧"
    $contextName = "Script"
}

Write-Host "$contextEmoji Context: $contextName" -ForegroundColor Yellow
Write-Host ""

# Step 1: Syntax validation (ALWAYS BLOCKING)
Write-Host "Step 1: Syntax validation..." -ForegroundColor Yellow
python -m py_compile $Path 2>&1 | Out-Null

if ($LASTEXITCODE -ne 0) {
    Write-Host "  ❌ SYNTAX ERROR!" -ForegroundColor Red
    Write-Host ""
    python -m py_compile $Path
    Write-Host ""
    Write-Host "Fix syntax errors before proceeding.`n" -ForegroundColor Red
    exit 1
}

Write-Host "  ✓ Syntax valid" -ForegroundColor Green
Write-Host ""

# Step 2: Ruff linting (context-aware)
Write-Host "Step 2: Ruff linting ($contextName rules)..." -ForegroundColor Yellow

# Check if ruff is installed
try {
    ruff --version | Out-Null
} catch {
    Write-Host "  ⚠️  Ruff not installed (skipping)" -ForegroundColor Yellow
    Write-Host "  Install: pip install ruff`n" -ForegroundColor Gray
    exit 0
}

# Build ruff command based on context
$ruffArgs = @("check", $Path)

switch ($context) {
    "fabric" {
        # Fabric notebooks: Ignore runtime injections and metadata cells
        $ruffArgs += @(
            "--select", "E,F,W,I,B",
            "--ignore", "E402,F821,F401"  # Import order, undefined names, unused imports
        )
        if ($ShowRules) {
            Write-Host "  Fabric-specific ignores:" -ForegroundColor Gray
            Write-Host "    E402: Imports not at top (metadata cells)" -ForegroundColor Gray
            Write-Host "    F821: Undefined names (spark, notebookutils)" -ForegroundColor Gray
            Write-Host "    F401: Unused imports (conditional imports)" -ForegroundColor Gray
            Write-Host ""
        }
    }
    "test" {
        # Test files: Relaxed docstrings and annotations
        $ruffArgs += @(
            "--ignore", "D,ANN,S101"  # Docstrings, annotations, assert
        )
        if ($ShowRules) {
            Write-Host "  Test-specific ignores:" -ForegroundColor Gray
            Write-Host "    D: Docstrings (tests are self-documenting)" -ForegroundColor Gray
            Write-Host "    ANN: Type annotations (overkill for tests)" -ForegroundColor Gray
            Write-Host "    S101: Assert usage (required in tests!)" -ForegroundColor Gray
            Write-Host ""
        }
    }
    "script" {
        # Scripts: Relaxed structure and output
        $ruffArgs += @(
            "--ignore", "T201,D"  # print statements, docstrings
        )
        if ($ShowRules) {
            Write-Host "  Script-specific ignores:" -ForegroundColor Gray
            Write-Host "    T201: print() statements (needed for output)" -ForegroundColor Gray
            Write-Host "    D: Docstrings (scripts are ad-hoc)" -ForegroundColor Gray
            Write-Host ""
        }
    }
    "general" {
        # General Python: Strict rules (use default Ruff config)
        if ($ShowRules) {
            Write-Host "  Using strict rules (default Ruff config)" -ForegroundColor Gray
            Write-Host ""
        }
    }
}

# Add --fix flag if requested
if ($Fix) {
    $ruffArgs += "--fix"
    Write-Host "  Auto-fixing enabled" -ForegroundColor Cyan
    Write-Host ""
}

# Run Ruff
& ruff @ruffArgs

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "⚠️  Ruff found issues" -ForegroundColor Yellow
    Write-Host ""
    
    if (-not $Fix) {
        Write-Host "Tip: Run with -Fix to auto-fix some issues:" -ForegroundColor Gray
        Write-Host "  .\spectra-lint.ps1 $Path -Fix`n" -ForegroundColor Gray
    }
    
    exit 1
}

Write-Host "  ✓ Ruff checks passed" -ForegroundColor Green
Write-Host ""

# Success!
Write-Host "✅ LINT PASSED!`n" -ForegroundColor Green
exit 0

