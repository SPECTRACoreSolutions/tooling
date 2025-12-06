$ErrorActionPreference = "Stop"

param(
    [string]$RepoRoot,
    [string]$ManifestPath
)

$ScriptDir = $PSScriptRoot
if (-not $RepoRoot) {
    $RepoRoot = Resolve-Path (Join-Path $ScriptDir "..\..\..") -ErrorAction SilentlyContinue
}
if (-not $ManifestPath) {
    $ManifestPath = Resolve-Path (Join-Path $ScriptDir "..\tooling.json") -ErrorAction SilentlyContinue
}
if (-not (Test-Path $ManifestPath)) {
    Write-Host "ERROR: Tooling manifest not found at $ManifestPath" -ForegroundColor Red
    exit 1
}

$Manifest = Get-Content $ManifestPath -Raw | ConvertFrom-Json

$missingEnv = @()
foreach ($key in $Manifest.env.required) {
    if (-not $env:$key) { $missingEnv += $key }
}

$status = @{
    python = [bool](Get-Command python -ErrorAction SilentlyContinue)
    npm    = [bool](Get-Command npm -ErrorAction SilentlyContinue)
    code   = [bool](Get-Command code -ErrorAction SilentlyContinue)
}

Write-Host "Tooling manifest: $ManifestPath"
Write-Host "Repo root: $RepoRoot"
Write-Host ""
Write-Host "Commands:"
Write-Host ("  python: {0}" -f ($status.python ? "ok" : "missing"))
Write-Host ("  npm   : {0}" -f ($status.npm ? "ok" : "missing"))
Write-Host ("  code  : {0}" -f ($status.code ? "ok" : "missing"))

if ($missingEnv.Count -gt 0) {
    Write-Host "`nMissing env vars:" -ForegroundColor Yellow
    $missingEnv | ForEach-Object { Write-Host "  $_" }
}
else {
    Write-Host "`nRequired env vars present."
}

Write-Host "`nOptional env vars:"
foreach ($key in $Manifest.env.optional) {
    Write-Host ("  {0}: {1}" -f $key, (if ($env:$key) { "set" } else { "not set" }))
}

Write-Host "`nHealth check complete."
