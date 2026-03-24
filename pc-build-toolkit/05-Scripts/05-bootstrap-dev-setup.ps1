# -----------------------------------------------------------------------------
# SPECTRA PC Toolkit - Bootstrap dev tooling (any Windows machine)
# Runs: app install (winget) -> az extension -> pip tools.
# -----------------------------------------------------------------------------
# Usage: .\05-bootstrap-dev-setup.ps1
#
# OEM/chipset/GPU drivers are machine-specific (e.g. a custom desktop after a
# clean Windows install). That belongs in vendor docs or POST-WIPE-INSTALL-EVERYTHING.md
# for the SPECTRA USB home-build workflow — not in this generic bootstrap.
# -----------------------------------------------------------------------------

[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"
$ScriptDir = $PSScriptRoot

Write-Host "`n================================================================================" -ForegroundColor Cyan
Write-Host "     NEXUS DEV SETUP - Bootstrap" -ForegroundColor Cyan
Write-Host "================================================================================`n" -ForegroundColor Cyan

Write-Host "Installing dev apps and CLI tooling (Cursor, Git, Azure CLI, Python, Docker, ...)." -ForegroundColor Gray
Write-Host ""

# --- Step 1: Install apps (winget) ---
Write-Host "`n[1/3] Running app install script (04-install-post-wipe-apps.ps1)..." -ForegroundColor Yellow
$appScript = Join-Path $ScriptDir "04-install-post-wipe-apps.ps1"
if (-not (Test-Path $appScript)) {
    Write-Host "Not found: $appScript" -ForegroundColor Red
    exit 1
}
& $appScript
if ($LASTEXITCODE -ne 0) { Write-Host "App script had errors; continuing anyway." -ForegroundColor Gray }

# --- Step 2: Azure DevOps CLI extension ---
Write-Host "`n[2/3] Adding Azure DevOps CLI extension..." -ForegroundColor Yellow
$azPath = Get-Command az -ErrorAction SilentlyContinue
if (-not $azPath) {
    # Try common install path (Azure CLI may not be in PATH in this session)
    $azExe = "$env:ProgramFiles\Microsoft SDKs\Azure\CLI2\wbin\az.exe"
    if (Test-Path $azExe) { $azPath = @{ Source = $azExe } }
}
if ($azPath) {
    try {
        & az extension add --name azure-devops --only-show-errors 2>$null
        if ($LASTEXITCODE -eq 0) { Write-Host "  Azure DevOps extension installed." -ForegroundColor Green }
        else { Write-Host "  Run in a new terminal: az extension add --name azure-devops" -ForegroundColor Gray }
    } catch {
        Write-Host "  Run in a new terminal: az extension add --name azure-devops" -ForegroundColor Gray
    }
} else {
    Write-Host "  Azure CLI not in PATH in this session. Open a new PowerShell/Windows Terminal and run:" -ForegroundColor Gray
    Write-Host "  az extension add --name azure-devops" -ForegroundColor White
}

# --- Step 3: Python tools ---
Write-Host "`n[3/3] Installing Python tools (ruff, pyright, pytest, uv, azure-identity)..." -ForegroundColor Yellow
$py = Get-Command python -ErrorAction SilentlyContinue
if (-not $py) { $py = Get-Command py -ErrorAction SilentlyContinue }
if ($py) {
    try {
        & python -m pip install --quiet ruff pyright pytest uv azure-identity 2>$null
        if ($LASTEXITCODE -eq 0) { Write-Host "  Python tools installed." -ForegroundColor Green }
        else { Write-Host "  Run in a new terminal: pip install ruff pyright pytest uv azure-identity" -ForegroundColor Gray }
    } catch {
        Write-Host "  Run in a new terminal: pip install ruff pyright pytest uv azure-identity" -ForegroundColor Gray
    }
} else {
    Write-Host "  Python not in PATH in this session. Open a new terminal and run:" -ForegroundColor Gray
    Write-Host "  pip install ruff pyright pytest uv azure-identity" -ForegroundColor White
}

# --- Next steps ---
Write-Host "`n================================================================================" -ForegroundColor Cyan
Write-Host "     NEXT STEPS (Phase 5)" -ForegroundColor Cyan
Write-Host "================================================================================`n" -ForegroundColor Cyan
Write-Host "1. Restart if Cursor or Docker asked you to." -ForegroundColor White
Write-Host "2. Open Cursor and your SPECTRA + SE-First workspace." -ForegroundColor White
Write-Host "3. Install Vital extensions (see SE-First docs/content/process/nexus-dev-setup-full-design.md section 3.1)." -ForegroundColor White
Write-Host "4. Restore: Cursor profile, .ssh, .env (or Key Vault pull), then git pull in each repo." -ForegroundColor White
Write-Host "`nFull playbook: SE-First docs/process/post-wipe-full-rebuild-playbook.md" -ForegroundColor Gray
Write-Host ""
