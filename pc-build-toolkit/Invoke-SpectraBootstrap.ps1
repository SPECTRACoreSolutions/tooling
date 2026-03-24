# =============================================================================
# SPECTRA Dev Setup - One-liner onboarding bootstrap
#
# Run on a fresh Windows machine (Cloud PC or physical) to install the full
# Nexus dev environment: Cursor, Python, Azure CLI, Docker, and more.
#
# One-liner (run in PowerShell):
#   irm https://raw.githubusercontent.com/SPECTRACoreSolutions/tooling/main/pc-build-toolkit/Invoke-SpectraBootstrap.ps1 | iex
#
# See: pc-build-toolkit/ONBOARDING-ONE-LINER.md
# =============================================================================

[CmdletBinding()]
param(
    [switch]$CloudPC,
    [switch]$WhatIf,
    [string]$TargetPath = ""
)

$ErrorActionPreference = "Stop"

# Tooling repo (has pc-build-toolkit with 04, 05 scripts). Public so no auth needed.
$TOOLING_CLONE_URL = "https://github.com/SPECTRACoreSolutions/tooling.git"
$BOOTSTRAP_SCRIPT_PATH = "pc-build-toolkit\05-Scripts\05-bootstrap-dev-setup.ps1"

if ($WhatIf) {
    Write-Host "WhatIf: would clone tooling and run 05-bootstrap-dev-setup.ps1" -ForegroundColor Yellow
    Write-Host "  CloudPC: $CloudPC  TargetPath: $TargetPath" -ForegroundColor Gray
    exit 0
}

# When run via irm | iex, params aren't passed. Use env var or prompt.
if (-not $CloudPC -and $env:SPECTRA_CLOUD_PC -eq "1") { $CloudPC = $true }
if (-not $CloudPC) {
    $r = Read-Host "Is this a Cloud PC? (y/N)"
    if ($r -match '^y') { $CloudPC = $true }
}

Write-Host ""
Write-Host "[ SPECTRA Dev Setup - Welcome ]" -ForegroundColor Cyan
Write-Host "This will install Cursor, Python, Azure CLI, Docker, and more. (~15 min)" -ForegroundColor Cyan
Write-Host ""

# Step 1: Ensure Git
Write-Host "[1/4] Checking Git..." -ForegroundColor Yellow
$git = Get-Command git -ErrorAction SilentlyContinue
if (-not $git) {
    Write-Host "  Git not found. Installing via winget..." -ForegroundColor Gray
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "  ERROR: winget not found. Update Windows or install App Installer from Store." -ForegroundColor Red
        exit 1
    }
    winget install --id Git.Git -e --accept-source-agreements --accept-package-agreements --silent
    $gitPath = "$env:ProgramFiles\Git\cmd\git.exe"
    if (Test-Path $gitPath) {
        $env:Path = "$env:ProgramFiles\Git\cmd;" + $env:Path
        Write-Host "  Git installed. Refreshed PATH." -ForegroundColor Green
    } else {
        Write-Host "  Git may need a new terminal. Run this script again." -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "  Git found: $($git.Source)" -ForegroundColor Green
}

# Step 2: Target path
if ([string]::IsNullOrWhiteSpace($TargetPath)) {
    $TargetPath = Join-Path $env:USERPROFILE "Repos"
}
$toolingPath = Join-Path $TargetPath "tooling"
$bootstrapPath = Join-Path $toolingPath $BOOTSTRAP_SCRIPT_PATH

if (-not (Test-Path $TargetPath)) {
    New-Item -ItemType Directory -Path $TargetPath -Force | Out-Null
    Write-Host "[2/4] Created: $TargetPath" -ForegroundColor Green
} else {
    Write-Host "[2/4] Target: $TargetPath" -ForegroundColor Gray
}

# Step 3: Clone or pull tooling
Write-Host "[3/4] Fetching dev setup scripts..." -ForegroundColor Yellow
if (Test-Path $toolingPath) {
    Write-Host "  Tooling already exists. Pulling latest..." -ForegroundColor Gray
    Push-Location $toolingPath
    try {
        git pull --quiet 2>$null
        if ($LASTEXITCODE -ne 0) { Write-Host "  (pull had issues; continuing)" -ForegroundColor Gray }
    } finally {
        Pop-Location
    }
} else {
    Write-Host "  Cloning tooling repo from GitHub..." -ForegroundColor Gray
    & git clone --depth 1 $TOOLING_CLONE_URL $toolingPath
    if ($LASTEXITCODE -ne 0) {
        Write-Host "  Clone failed. Check repo is public: $TOOLING_CLONE_URL" -ForegroundColor Red
        Write-Host "  Or run locally: cd path\to\tooling\pc-build-toolkit; .\Invoke-SpectraBootstrap.ps1 -CloudPC" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "  Cloned successfully." -ForegroundColor Green
}

if (-not (Test-Path $bootstrapPath)) {
    Write-Host "  ERROR: Bootstrap script not found at $bootstrapPath" -ForegroundColor Red
    Write-Host "  Ensure 04-install-post-wipe-apps.ps1 and 05-bootstrap-dev-setup.ps1 are in tooling." -ForegroundColor Gray
    exit 1
}

# Step 4: Run bootstrap
Write-Host "[4/4] Running dev setup (winget + az extension + pip tools)..." -ForegroundColor Yellow
Write-Host ""
# Use explicit -SkipDriverReminder (not array splat): PS 5.1 can mis-bind splatted strings as positional args.
if ($CloudPC) {
    & $bootstrapPath -SkipDriverReminder
} else {
    & $bootstrapPath
}
$bootstrapExit = $LASTEXITCODE

# Done
Write-Host ""
Write-Host "[ Tooling is at: $toolingPath ]" -ForegroundColor Cyan
Write-Host "Clone SPECTRA/SE-First from ADO for full workspace (Phase C)." -ForegroundColor Gray
Write-Host ""
Write-Host "Next: Restart if Cursor/Docker asked. Then clone SE-First, open workspace," -ForegroundColor White
Write-Host "      install Cursor extensions, restore .env. See dev-env-full-install-path.md" -ForegroundColor Gray
Write-Host ""

exit $bootstrapExit
