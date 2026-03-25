# -----------------------------------------------------------------------------
# Verify SPECTRA / Nexus dev bootstrap on Windows (Cloud PC or physical).
# Shipped with public tooling: after Invoke-SpectraBootstrap this file is at
#   %USERPROFILE%\Repos\tooling\pc-build-toolkit\05-Scripts\Verify-SpectraDevBootstrap.ps1
# Aligns with 04-install-post-wipe-apps.ps1 and Invoke-SpectraBootstrap.ps1.
#
# Why optional ADO sync is not in Invoke-SpectraBootstrap:
#   The one-liner only clones public GitHub tooling (no secrets). SE-First
#   operations (Azure DevOps) needs your auth — use -PullOperations here when ready.
#
# Usage (PowerShell 5.1 or 7+):
#   .\Verify-SpectraDevBootstrap.ps1
#   .\Verify-SpectraDevBootstrap.ps1 -Strict
#   .\Verify-SpectraDevBootstrap.ps1 -ToolingRoot "D:\Repos"
#   .\Verify-SpectraDevBootstrap.ps1 -PullTooling
#   .\Verify-SpectraDevBootstrap.ps1 -PullOperations -OperationsRepoPath "C:\work\SE-First\operations"
#   # or: $env:SPECTRA_OPERATIONS_REPO = "C:\...\operations"; .\Verify-SpectraDevBootstrap.ps1 -PullOperations
# -----------------------------------------------------------------------------

[CmdletBinding()]
param(
    [switch]$Strict,
    [string]$ToolingRoot = "",
    [switch]$PullTooling,
    [switch]$PullOperations,
    [string]$OperationsRepoPath = ""
)

$ErrorActionPreference = "Continue"

function Test-Command {
    param([string]$Name, [string]$Arg = "--version")
    $cmd = Get-Command $Name -ErrorAction SilentlyContinue
    if (-not $cmd) { return $null }
    try {
        if ($Arg) {
            $out = & $Name $Arg.Split(" ") 2>&1 | Out-String
            return ($out.Trim() -split "`n" | Select-Object -First 1)
        }
        return $cmd.Source
    } catch {
        return $cmd.Source
    }
}

function Get-AzCliInvocation {
    $cmd = Get-Command az -ErrorAction SilentlyContinue
    if ($cmd) { return @{ Invoke = "az"; Note = $null } }
    foreach ($candidate in @(
            "$env:ProgramFiles\Microsoft SDKs\Azure\CLI2\wbin\az.cmd",
            "$env:ProgramFiles\Microsoft SDKs\Azure\CLI2\wbin\az.exe",
            "${env:ProgramFiles(x86)}\Microsoft SDKs\Azure\CLI2\wbin\az.cmd"
        )) {
        if (Test-Path $candidate) {
            return @{ Invoke = $candidate; Note = "not on PATH; open a new terminal after install or add CLI2\wbin to PATH" }
        }
    }
    return $null
}

function Test-WingetId {
    param([string]$Id)
    if (-not (Get-Command winget -ErrorAction SilentlyContinue)) { return $false }
    $r = winget list --id $Id -e 2>&1 | Out-String
    return ($r -match [regex]::Escape($Id))
}

$expectedWinget = @(
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

$coreCommands = @(
    @{ Key = "winget";  Arg = "--version" },
    @{ Key = "git";     Arg = "--version" },
    @{ Key = "az";      Arg = "--version" },
    @{ Key = "python";  Arg = "--version" }
)

if ([string]::IsNullOrWhiteSpace($ToolingRoot)) {
    $ToolingRoot = Join-Path $env:USERPROFILE "Repos"
}
$toolingClone = Join-Path $ToolingRoot "tooling"
$bootstrapScript = Join-Path $toolingClone "pc-build-toolkit\05-Scripts\05-bootstrap-dev-setup.ps1"
$canonicalVerifySelf = Join-Path $toolingClone "pc-build-toolkit\05-Scripts\Verify-SpectraDevBootstrap.ps1"

$opsRoot = $OperationsRepoPath
if ([string]::IsNullOrWhiteSpace($opsRoot)) { $opsRoot = $env:SPECTRA_OPERATIONS_REPO }

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host " SPECTRA dev bootstrap verification" -ForegroundColor Cyan
Write-Host "================================================================================" -ForegroundColor Cyan
Write-Host ""

$fail = 0
$warn = 0

function Invoke-GitPullIfRepo {
    param(
        [string]$Path,
        [string]$Label
    )
    if ([string]::IsNullOrWhiteSpace($Path)) {
        Write-Host "  [SKIP] $Label (no path; set -OperationsRepoPath or SPECTRA_OPERATIONS_REPO)" -ForegroundColor Gray
        return
    }
    if (-not (Test-Path $Path)) {
        Write-Host "  [SKIP] $Label not found: $Path" -ForegroundColor Gray
        return
    }
    $gitDir = Join-Path $Path ".git"
    if (-not (Test-Path $gitDir)) {
        Write-Host "  [WARN] $Label is not a git repository: $Path" -ForegroundColor Yellow
        $script:warn++
        return
    }
    Push-Location $Path
    try {
        $err = $false
        git pull --ff-only 2>&1 | ForEach-Object { Write-Host "         $_" -ForegroundColor DarkGray }
        if ($LASTEXITCODE -ne 0) { $err = $true }
        if ($err) {
            Write-Host "  [WARN] $Label git pull failed (auth, conflicts, or offline?)" -ForegroundColor Yellow
            $script:warn++
        } else {
            $rev = git rev-parse --short HEAD 2>$null
            $br = git rev-parse --abbrev-ref HEAD 2>$null
            Write-Host "  [OK]   $Label synced ($br @ $rev)" -ForegroundColor Green
        }
    } finally {
        Pop-Location
    }
}

if ($PullTooling -or $PullOperations) {
    Write-Host "--- Git sync (optional) ---" -ForegroundColor Yellow
    if ($PullTooling) {
        Invoke-GitPullIfRepo -Path $toolingClone -Label "Public tooling (GitHub)"
    }
    if ($PullOperations) {
        Invoke-GitPullIfRepo -Path $opsRoot -Label "SE-First operations (ADO)"
    }
    Write-Host ""
}

if (-not [string]::IsNullOrWhiteSpace($opsRoot) -and (Test-Path $opsRoot)) {
    Write-Host "--- SE-First operations clone ---" -ForegroundColor Yellow
    if (Test-Path (Join-Path $opsRoot ".git")) {
        Push-Location $opsRoot
        try {
            $br = git rev-parse --abbrev-ref HEAD 2>$null
            $rev = git rev-parse --short HEAD 2>$null
            Write-Host "  [OK]   $opsRoot ($br @ $rev)" -ForegroundColor Green
        } finally {
            Pop-Location
        }
    } else {
        Write-Host "  [INFO] Path exists but is not a git repo: $opsRoot" -ForegroundColor Gray
    }
    $launcher = Join-Path $opsRoot "playbooks\pc-setup\scripts\Verify-SpectraDevBootstrap.ps1"
    if (Test-Path $launcher) {
        Write-Host "  [OK]   ADO playbook launcher: playbooks\pc-setup\scripts\ (delegates to tooling or raw)" -ForegroundColor Green
    }
    Write-Host ""
}

Write-Host "--- Core commands (bootstrap should provide these) ---" -ForegroundColor Yellow
foreach ($c in $coreCommands) {
    if ($c.Key -eq "az") {
        $az = Get-AzCliInvocation
        if ($az) {
            try {
                $argParts = $c.Arg.Split(" ", [System.StringSplitOptions]::RemoveEmptyEntries)
                $line = & $az.Invoke @argParts 2>&1 | Out-String
                $line = ($line.Trim() -split "`n" | Select-Object -First 1)
                if ($az.Note) {
                    Write-Host "  [OK]   az: $line" -ForegroundColor Green
                    Write-Host "         ($($az.Note))" -ForegroundColor Gray
                } else {
                    Write-Host "  [OK]   az: $line" -ForegroundColor Green
                }
            } catch {
                Write-Host "  [FAIL] az: found at $($az.Invoke) but failed to run" -ForegroundColor Red
                $fail++
            }
        } else {
            Write-Host "  [FAIL] az: not installed (or not on PATH and not under Program Files\Microsoft SDKs\Azure\CLI2)" -ForegroundColor Red
            Write-Host "         Install: winget install Microsoft.AzureCLI -e --scope user --accept-source-agreements --accept-package-agreements" -ForegroundColor Gray
            Write-Host "         Then: open a new terminal; az extension add --name azure-devops" -ForegroundColor Gray
            $fail++
        }
        continue
    }
    $line = Test-Command -Name $c.Key -Arg $c.Arg
    if ($line) {
        Write-Host "  [OK]   $($c.Key): $line" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] $($c.Key): not on PATH" -ForegroundColor Red
        $fail++
    }
}

$pwsh = Get-Command pwsh -ErrorAction SilentlyContinue
if ($pwsh) {
    $ver = & pwsh -NoProfile -Command '$PSVersionTable.PSVersion.ToString()'
    if ([version]$ver -ge [version]"7.0") {
        Write-Host "  [OK]   pwsh: $ver ($($pwsh.Source))" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] pwsh version low: $ver" -ForegroundColor Yellow
        $warn++
    }
} else {
    Write-Host "  [FAIL] pwsh (PowerShell 7): not on PATH" -ForegroundColor Red
    $fail++
}

$isAdmin = ([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(
    [Security.Principal.WindowsBuiltInRole]::Administrator)
Write-Host "  [INFO] Elevated shell: $isAdmin (normal user shell may show False; OK for per-user winget)" -ForegroundColor Gray

Write-Host ""
Write-Host "--- Tooling repo (Invoke-SpectraBootstrap default) ---" -ForegroundColor Yellow
if (Test-Path $bootstrapScript) {
    Write-Host "  [OK]   $bootstrapScript" -ForegroundColor Green
} elseif (Test-Path $toolingClone) {
    Write-Host "  [WARN] tooling exists but bootstrap script missing: $bootstrapScript" -ForegroundColor Yellow
    $warn++
} else {
    Write-Host "  [WARN] Clone not found: $toolingClone (expected after one-liner bootstrap)" -ForegroundColor Yellow
    $warn++
}
if (Test-Path $canonicalVerifySelf) {
    Write-Host "  [OK]   This verify script (canonical): pc-build-toolkit\05-Scripts\Verify-SpectraDevBootstrap.ps1" -ForegroundColor Green
}

Write-Host ""
Write-Host "--- winget packages (04-install-post-wipe-apps.ps1 list) ---" -ForegroundColor Yellow
$missingWinget = @()
foreach ($p in $expectedWinget) {
    if (Test-WingetId -Id $p.Id) {
        Write-Host "  [OK]   $($p.Name) ($($p.Id))" -ForegroundColor Green
    } else {
        Write-Host "  [MISS] $($p.Name) ($($p.Id))" -ForegroundColor DarkYellow
        $missingWinget += $p
    }
}

Write-Host ""
Write-Host "--- Azure DevOps CLI extension ---" -ForegroundColor Yellow
$azForExt = Get-AzCliInvocation
if ($azForExt) {
    $ext = & $azForExt.Invoke extension list -o json 2>$null | ConvertFrom-Json
    $ado = $ext | Where-Object { $_.name -eq "azure-devops" }
    if ($ado) {
        Write-Host "  [OK]   azure-devops extension installed" -ForegroundColor Green
    } else {
        Write-Host "  [WARN] Run: az extension add --name azure-devops" -ForegroundColor Yellow
        $warn++
    }
} else {
    Write-Host "  [SKIP] az not available" -ForegroundColor Gray
}

Write-Host ""
Write-Host "--- Python pip tools (05-bootstrap step 3) ---" -ForegroundColor Yellow
$pyOk = $false
foreach ($name in @("python", "py")) {
    if (Get-Command $name -ErrorAction SilentlyContinue) { $pyOk = $true; break }
}
if ($pyOk) {
    $pipList = & python -m pip list --format=columns 2>$null | Out-String
    foreach ($pkg in @("ruff", "pyright", "pytest", "uv", "azure-identity")) {
        if ($pipList -match "(?m)^$pkg\s") {
            Write-Host "  [OK]   pip: $pkg" -ForegroundColor Green
        } else {
            Write-Host "  [WARN] pip missing: $pkg  -> pip install $pkg" -ForegroundColor Yellow
            $warn++
        }
    }
} else {
    Write-Host "  [WARN] python not on PATH; open new terminal after install" -ForegroundColor Yellow
    $warn++
}

Write-Host ""
Write-Host "================================================================================" -ForegroundColor Cyan
if ($Strict -and $missingWinget.Count -gt 0) {
    Write-Host " RESULT: FAIL (Strict: $($missingWinget.Count) winget package(s) not reported installed)" -ForegroundColor Red
    exit 1
}
if ($fail -gt 0) {
    Write-Host " RESULT: FAIL ($fail core check(s) failed)" -ForegroundColor Red
    exit 1
}
if ($warn -gt 0 -or $missingWinget.Count -gt 0) {
    Write-Host " RESULT: PASS with warnings (core OK; install optional items or open a new terminal)" -ForegroundColor Yellow
    exit 0
}
Write-Host " RESULT: PASS" -ForegroundColor Green
exit 0
