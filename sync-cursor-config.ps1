#Requires -Version 7.0

<#
.SYNOPSIS
    Sync Cursor configuration between local and git repository

.DESCRIPTION
    Manages Cursor MCP configuration synchronization:
    - push: Local .cursor/mcp.json → Core/tooling/config/cursor/mcp.json (version controlled)
    - pull: Core/tooling/config/cursor/mcp.json → Local .cursor/mcp.json
    - diff: Compare local vs canonical

.PARAMETER Direction
    Sync direction: push, pull, or diff

.PARAMETER Force
    Overwrite without confirmation

.EXAMPLE
    .\sync-cursor-config.ps1 -Direction pull
    Restore Cursor config from git

.EXAMPLE
    .\sync-cursor-config.ps1 -Direction push
    Backup local Cursor config to git

.EXAMPLE
    .\sync-cursor-config.ps1 -Direction diff
    Compare local vs canonical config
#>

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet('push', 'pull', 'diff')]
    [string]$Direction = 'pull',
    
    [Parameter(Mandatory = $false)]
    [switch]$Force
)

# Paths
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$localConfig = Join-Path $root ".cursor\mcp.json"
$canonicalConfig = Join-Path $PSScriptRoot "config\cursor\mcp.json"

function Show-Diff {
    Write-Host "🔍 Comparing configurations..." -ForegroundColor Cyan
    
    if (!(Test-Path $localConfig)) {
        Write-Host "❌ Local config not found: $localConfig" -ForegroundColor Red
        return
    }
    
    if (!(Test-Path $canonicalConfig)) {
        Write-Host "❌ Canonical config not found: $canonicalConfig" -ForegroundColor Red
        return
    }
    
    $local = Get-Content $localConfig | ConvertFrom-Json
    $canonical = Get-Content $canonicalConfig | ConvertFrom-Json
    
    $localServers = $local.mcpServers.PSObject.Properties.Name | Sort-Object
    $canonicalServers = $canonical.mcpServers.PSObject.Properties.Name | Sort-Object
    
    Write-Host "`nLocal servers ($($localServers.Count)):" -ForegroundColor Yellow
    $localServers | ForEach-Object { Write-Host "  - $_" }
    
    Write-Host "`nCanonical servers ($($canonicalServers.Count)):" -ForegroundColor Yellow
    $canonicalServers | ForEach-Object { Write-Host "  - $_" }
    
    $onlyLocal = $localServers | Where-Object { $_ -notin $canonicalServers }
    $onlyCanonical = $canonicalServers | Where-Object { $_ -notin $localServers }
    
    if ($onlyLocal) {
        Write-Host "`n⚠️  Only in local:" -ForegroundColor Magenta
        $onlyLocal | ForEach-Object { Write-Host "  - $_" }
    }
    
    if ($onlyCanonical) {
        Write-Host "`n⚠️  Only in canonical:" -ForegroundColor Magenta
        $onlyCanonical | ForEach-Object { Write-Host "  - $_" }
    }
    
    if (!$onlyLocal -and !$onlyCanonical) {
        Write-Host "`n✅ Configurations are in sync!" -ForegroundColor Green
    }
    else {
        Write-Host "`n💡 Run with -Direction pull or push to sync" -ForegroundColor Cyan
    }
}

function Push-Config {
    Write-Host "📤 Pushing local config to git..." -ForegroundColor Cyan
    
    if (!(Test-Path $localConfig)) {
        Write-Host "❌ Local config not found: $localConfig" -ForegroundColor Red
        exit 1
    }
    
    if ((Test-Path $canonicalConfig) -and !$Force) {
        Write-Host "⚠️  Canonical config exists. Showing diff..." -ForegroundColor Yellow
        Show-Diff
        Write-Host "`n💡 Use -Force to overwrite canonical config"
        exit 0
    }
    
    Copy-Item $localConfig $canonicalConfig -Force
    Write-Host "✅ Config backed up to: config/cursor/mcp.json" -ForegroundColor Green
    Write-Host ""
    Write-Host "📋 Next steps:" -ForegroundColor Yellow
    Write-Host "   git add config/cursor/mcp.json"
    Write-Host "   git commit -m '🔧 Update Cursor MCP configuration'"
    Write-Host "   git push"
}

function Pull-Config {
    Write-Host "📥 Pulling canonical config from git..." -ForegroundColor Cyan
    
    if (!(Test-Path $canonicalConfig)) {
        Write-Host "❌ Canonical config not found: $canonicalConfig" -ForegroundColor Red
        Write-Host "💡 Run with -Direction push to create it first"
        exit 1
    }
    
    if ((Test-Path $localConfig) -and !$Force) {
        Write-Host "⚠️  Local config exists. Comparing..." -ForegroundColor Yellow
        Show-Diff
        Write-Host ""
        Write-Host "💡 Use -Force to overwrite local config"
        exit 0
    }
    
    # Ensure .cursor directory exists
    $cursorDir = Split-Path $localConfig
    if (!(Test-Path $cursorDir)) {
        New-Item -ItemType Directory -Path $cursorDir -Force | Out-Null
    }
    
    Copy-Item $canonicalConfig $localConfig -Force
    Write-Host "✅ Config restored to: .cursor/mcp.json" -ForegroundColor Green
    Write-Host ""
    Write-Host "⚠️  RESTART CURSOR to apply MCP configuration changes" -ForegroundColor Yellow
}

# Main execution
Write-Host "=" * 60
Write-Host "Cursor Configuration Sync" -ForegroundColor Cyan
Write-Host "=" * 60
Write-Host "Direction: $Direction"
Write-Host "Root: $root"
Write-Host "=" * 60
Write-Host ""

switch ($Direction) {
    'push' { Push-Config }
    'pull' { Pull-Config }
    'diff' { Show-Diff }
}

