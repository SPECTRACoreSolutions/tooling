#Requires -Version 7.0

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet('pull', 'diff')]
    [string]$Direction = 'pull',

    [Parameter(Mandatory = $false)]
    [ValidateSet('cursor', 'windsurf', 'rules', 'all')]
    [string]$Target = 'all',

    [Parameter(Mandatory = $false)]
    [switch]$Force
)

$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)

$canonicalYaml = Join-Path $PSScriptRoot "config\mcp\mcp-servers.yaml"
$renderScript = Join-Path $PSScriptRoot "scripts\render_mcp_configs.py"

$generatedRoot = Join-Path $env:TEMP "spectra-mcp-configs"

$generatedCursor = Join-Path $generatedRoot "cursor\mcp.json"
$generatedWindsurf = Join-Path $generatedRoot "windsurf\mcp_config.json"

$localCursor = Join-Path $root ".cursor\mcp.json"
$localWindsurf = Join-Path $env:USERPROFILE ".codeium\mcp_config.json"

$spectraRules = Join-Path $root ".spectra\rules"
$windsurfRules = Join-Path $root ".windsurf\rules"
$cursorRules = Join-Path $root ".cursorrules"

function Ensure-Dir([string]$path) {
    if (!(Test-Path $path)) {
        New-Item -ItemType Directory -Path $path -Force | Out-Null
    }
}

function Sync-Rules {
    Write-Host "🔧 Syncing canonical AI rules..." -ForegroundColor Cyan

    if (!(Test-Path $spectraRules)) {
        Write-Host "❌ Canonical rules not found: $spectraRules" -ForegroundColor Red
        exit 1
    }

    Ensure-Dir (Split-Path $windsurfRules -Parent)
    Ensure-Dir $windsurfRules

    Copy-Item -Path (Join-Path $spectraRules "*") -Destination $windsurfRules -Recurse -Force
    Write-Host "✅ Rules synced to .windsurf/rules" -ForegroundColor Green

    if (Test-Path $cursorRules) {
        $content = Get-Content $cursorRules -Raw
        if ($content -notmatch "\.spectra/rules") {
            Write-Host "⚠️  .cursorrules exists but does not reference .spectra/rules" -ForegroundColor Yellow
            Write-Host "   (Not overwriting; update manually if needed)" -ForegroundColor Yellow
        }
    }
    else {
        "# SPECTRA AI Rules - See .spectra/rules/ for canonical rules" | Out-File -FilePath $cursorRules -Encoding UTF8
        Write-Host "✅ Created .cursorrules wrapper" -ForegroundColor Green
    }
}

function Render-Configs {
    if (!(Test-Path $canonicalYaml)) {
        Write-Host "❌ Canonical YAML not found: $canonicalYaml" -ForegroundColor Red
        exit 1
    }
    if (!(Test-Path $renderScript)) {
        Write-Host "❌ Render script not found: $renderScript" -ForegroundColor Red
        exit 1
    }

    Write-Host "🔧 Rendering MCP configs from YAML..." -ForegroundColor Cyan
    if (Test-Path $generatedRoot) {
        Remove-Item -Recurse -Force $generatedRoot
    }
    Ensure-Dir $generatedRoot
    if ($Target -in @('windsurf', 'all')) {
        python $renderScript --yaml $canonicalYaml --output-dir $generatedRoot --target $Target --substitute-secrets-with-empty --exclude-windsurf spectra-context
    }
    else {
        python $renderScript --yaml $canonicalYaml --output-dir $generatedRoot --target $Target --substitute-secrets-with-empty
    }
    if ($LASTEXITCODE -ne 0) {
        Write-Host "❌ Render failed" -ForegroundColor Red
        exit 1
    }
    Write-Host "✅ Render complete" -ForegroundColor Green
}

function Show-Diff([string]$a, [string]$b, [string]$label) {
    Write-Host "=" * 60
    Write-Host "🔍 $label" -ForegroundColor Cyan
    Write-Host "  Local:     $a"
    Write-Host "  Canonical: $b"

    if (!(Test-Path $a)) {
        Write-Host "⚠️  Local file missing" -ForegroundColor Yellow
        return
    }
    if (!(Test-Path $b)) {
        Write-Host "⚠️  Canonical file missing" -ForegroundColor Yellow
        return
    }

    $la = (Get-FileHash $a -Algorithm SHA256).Hash
    $lb = (Get-FileHash $b -Algorithm SHA256).Hash

    if ($la -eq $lb) {
        Write-Host "✅ In sync" -ForegroundColor Green
    }
    else {
        Write-Host "⚠️  Different" -ForegroundColor Yellow
        Write-Host "   Use -Direction pull -Force to overwrite local" -ForegroundColor Yellow
    }
}

function Pull-File([string]$src, [string]$dst, [string]$dstDir, [string]$label) {
    Write-Host "📥 Installing $label..." -ForegroundColor Cyan

    if (!(Test-Path $src)) {
        Write-Host "❌ Source not found: $src" -ForegroundColor Red
        exit 1
    }

    if ((Test-Path $dst) -and !$Force) {
        Write-Host "⚠️  Destination exists. Use -Force to overwrite: $dst" -ForegroundColor Yellow
        return
    }

    Ensure-Dir $dstDir
    Copy-Item $src $dst -Force
    Write-Host "✅ Installed: $dst" -ForegroundColor Green
}

# Main
if ($Target -in @('cursor', 'windsurf', 'all')) {
    Render-Configs
}

switch ($Direction) {
    'diff' {
        if ($Target -in @('cursor', 'all')) {
            Show-Diff -a $localCursor -b $generatedCursor -label "Cursor MCP config"
        }
        if ($Target -in @('windsurf', 'all')) {
            Show-Diff -a $localWindsurf -b $generatedWindsurf -label "Windsurf MCP config"
        }
        if ($Target -in @('rules', 'all')) {
            Write-Host "=" * 60
            Write-Host "🔍 Rules status" -ForegroundColor Cyan
            Write-Host "  Canonical: $spectraRules"
            Write-Host "  Windsurf:   $windsurfRules"
            Write-Host "  Cursor:     $cursorRules"
        }
    }

    'pull' {
        if ($Target -in @('cursor', 'all')) {
            Pull-File -src $generatedCursor -dst $localCursor -dstDir (Split-Path $localCursor -Parent) -label "Cursor MCP config"
        }
        if ($Target -in @('windsurf', 'all')) {
            Pull-File -src $generatedWindsurf -dst $localWindsurf -dstDir (Split-Path $localWindsurf -Parent) -label "Windsurf MCP config"
            Write-Host "⚠️  Restart Windsurf after updating MCP config" -ForegroundColor Yellow
        }
        if ($Target -in @('rules', 'all')) {
            Sync-Rules
        }
    }
}
