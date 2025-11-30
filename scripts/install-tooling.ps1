$ErrorActionPreference = "Stop"

param(
    [string]$RepoRoot,
    [string]$ManifestPath,
    [switch]$SkipExtensions
)

# Resolve repo root and manifest defaults
$ScriptDir = $PSScriptRoot
if (-not $RepoRoot) {
    $RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..") -ErrorAction SilentlyContinue
    if (-not $RepoRoot) {
        Write-Host "ERROR: Unable to resolve repo root." -ForegroundColor Red
        exit 1
    }
}
if (-not $ManifestPath) {
    $ManifestPath = Resolve-Path (Join-Path $ScriptDir "..\tooling.json") -ErrorAction SilentlyContinue
}
if (-not (Test-Path $ManifestPath)) {
    Write-Host "ERROR: Tooling manifest not found at $ManifestPath" -ForegroundColor Red
    exit 1
}

try {
    $Manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json
}
catch {
    Write-Host "ERROR: Failed to parse tooling manifest: $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}

function Ensure-PythonPackages {
    param($Manifest, $RepoRoot)
    $pythonCmd = Get-Command python -ErrorAction SilentlyContinue
    if (-not $pythonCmd) {
        Write-Host "WARNING: python not found; skipping Python package install." -ForegroundColor Yellow
        return
    }
    $packages = @()
    if ($Manifest.python.packages) { $packages += $Manifest.python.packages }
    if ($packages.Count -gt 0) {
        Write-Host "Installing/upgrading Python packages: $($packages -join ', ')"
        & $pythonCmd -m pip install --upgrade @packages | Out-Null
    }
    if ($Manifest.python.editable) {
        foreach ($relPath in $Manifest.python.editable) {
            $targetPath = Join-Path $RepoRoot $relPath
            if (-not (Test-Path $targetPath)) {
                Write-Host "WARNING: Editable target not found: $targetPath" -ForegroundColor Yellow
                continue
            }
            Write-Host "Installing editable package at $targetPath"
            & $pythonCmd -m pip install -e $targetPath | Out-Null
        }
    }
}

function Ensure-NpmGlobals {
    param($Manifest)
    $npmCmd = Get-Command npm -ErrorAction SilentlyContinue
    if (-not $npmCmd) {
        Write-Host "WARNING: npm not found; skipping npm global installs." -ForegroundColor Yellow
        return
    }
    if ($Manifest.npm.global) {
        Write-Host "Installing npm global packages: $($Manifest.npm.global -join ', ')"
        & $npmCmd install -g @($Manifest.npm.global) | Out-Null
    }
}

function Ensure-VSCodeExtensions {
    param($Manifest)
    $codeCmd = Get-Command code -ErrorAction SilentlyContinue
    if (-not $codeCmd) {
        Write-Host "WARNING: VS Code CLI (code) not found; skipping extension install." -ForegroundColor Yellow
        return
    }
    if (-not $Manifest.vscode.extensions) { return }

    $installed = @()
    try {
        $installed = & $codeCmd --list-extensions
    }
    catch {
        Write-Host "WARNING: Unable to list VS Code extensions; attempting installs anyway." -ForegroundColor Yellow
    }

    foreach ($ext in $Manifest.vscode.extensions) {
        if ($installed -and ($installed -contains $ext)) {
            Write-Host "$ext already installed; skipping."
            continue
        }
        Write-Host "Installing VS Code extension $ext ..."
        & $codeCmd --install-extension $ext
    }
}

Ensure-PythonPackages -Manifest $Manifest -RepoRoot $RepoRoot
Ensure-NpmGlobals -Manifest $Manifest
if (-not $SkipExtensions) {
    Ensure-VSCodeExtensions -Manifest $Manifest
}

Write-Host "Tooling install complete from manifest $ManifestPath"
