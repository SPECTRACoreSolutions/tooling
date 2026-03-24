# -----------------------------------------------------------------------------
# SPECTRA PC Toolkit - Install dev apps via winget (Cursor, Git, Azure CLI, ...)
# Typically called from 05-bootstrap-dev-setup.ps1.
# -----------------------------------------------------------------------------
# Usage: .\04-install-post-wipe-apps.ps1
#        .\04-install-post-wipe-apps.ps1 -WhatIf
# -----------------------------------------------------------------------------

# Do not use SupportsShouldProcess here: it injects -WhatIf and conflicts with explicit $WhatIf below.
[CmdletBinding()]
param([switch]$WhatIf)

$ErrorActionPreference = "Stop"

# Required for Nexus Dev Setup (see SE-First docs/content/process/nexus-dev-setup-full-design.md §7)
$packages = @(
    @{ Id = "Anysphere.Cursor";              Name = "Cursor" },
    @{ Id = "Git.Git";                       Name = "Git" },
    @{ Id = "GitHub.cli";                    Name = "GitHub CLI" },
    @{ Id = "Microsoft.AzureCLI";            Name = "Azure CLI" },
    @{ Id = "Microsoft.PowerShell";          Name = "PowerShell 7" },
    @{ Id = "Microsoft.WindowsTerminal";    Name = "Windows Terminal" },
    @{ Id = "Python.Python.3.12";            Name = "Python 3.12" },
    @{ Id = "Docker.DockerDesktop";          Name = "Docker Desktop" },
    @{ Id = "OpenJS.NodeJS.LTS";             Name = "Node.js LTS" },
    @{ Id = "Microsoft.PowerAppsCLI";       Name = "Power Platform CLI (pac)" },
    @{ Id = "Microsoft.Azure.FunctionsCoreTools"; Name = "Azure Functions Core Tools" },
    @{ Id = "Figma.Figma";                   Name = "Figma" },
    @{ Id = "Adobe.CreativeCloud";           Name = "Adobe Creative Cloud" }
)

Write-Host "`n================================================================================" -ForegroundColor Cyan
Write-Host "     SPECTRA POST-WIPE - Install apps (winget)" -ForegroundColor Cyan
Write-Host "================================================================================`n" -ForegroundColor Cyan

if ($WhatIf) {
    Write-Host "WhatIf: would install the following via winget:" -ForegroundColor Yellow
    foreach ($p in $packages) { Write-Host "  - $($p.Name) ($($p.Id))" }
    Write-Host "`nRun without -WhatIf to install. Ensure winget is available (Windows 10/11)." -ForegroundColor Gray
    exit 0
}

# Check winget
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "winget not found. Install App Installer from Microsoft Store or update Windows." -ForegroundColor Red
    exit 1
}

$installed = 0
$failed = 0
foreach ($p in $packages) {
    Write-Host "Installing $($p.Name) ($($p.Id))..." -ForegroundColor Yellow
    try {
        winget install --id $p.Id -e --accept-source-agreements --accept-package-agreements --silent
        if ($LASTEXITCODE -eq 0) { $installed++ } else { $failed++; Write-Host "  (skipped or failed)" -ForegroundColor Gray }
    } catch {
        $failed++
        Write-Host "  Failed: $_" -ForegroundColor Red
    }
}

Write-Host "`nDone. Installed: $installed. Failed/skipped: $failed." -ForegroundColor Cyan
Write-Host "Next:" -ForegroundColor Yellow
Write-Host "  1. az extension add --name azure-devops  (Azure DevOps CLI)" -ForegroundColor Gray
Write-Host "  2. Python: pip install ruff pyright pytest uv azure-identity (or use uv/poetry)" -ForegroundColor Gray
Write-Host "  3. Cursor: install Vital extensions (see nexus-dev-setup-full-design.md §3.1)" -ForegroundColor Gray
Write-Host "  4. Restore: Cursor profile, .ssh, .env (see POST-WIPE-INSTALL-EVERYTHING.md)" -ForegroundColor Gray
