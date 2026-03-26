#Requires -Version 7.0

<#
.SYNOPSIS
    Restore Cursor configuration after profile switch

.DESCRIPTION
    After switching Windows profiles, this script restores:
    - Cursor extensions
    - Cursor settings
    - MCP configuration (if applicable)
    
    Run this from the SPECTRA workspace root after switching profiles.

.EXAMPLE
    .\Core\tooling\restore-cursor-profile.ps1
    Restore all Cursor configuration
#>

param(
    [Parameter(Mandatory=$false)]
    [switch]$SkipExtensions,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipSettings,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipMCP
)

$ErrorActionPreference = "Stop"

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  SPECTRA Cursor Profile Restoration                      ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Get workspace root (assumes script is in Core/tooling/)
$scriptRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$onboardingDir = Join-Path $scriptRoot "Core\onboarding"
$toolingDir = Join-Path $scriptRoot "Core\tooling"

# Step 1: Install Extensions
if (-not $SkipExtensions) {
    Write-Host "Step 1: Installing Cursor extensions..." -ForegroundColor Yellow
    
    $extensionsScript = Join-Path $toolingDir "install-cursor-extensions.ps1"
    if (Test-Path $extensionsScript) {
        & $extensionsScript -Profile all
        Write-Host "✅ Extensions installation complete`n" -ForegroundColor Green
    } else {
        Write-Host "⚠️  Extensions script not found: $extensionsScript" -ForegroundColor Yellow
        Write-Host "   Skipping extensions installation`n" -ForegroundColor Yellow
    }
} else {
    Write-Host "Step 1: Skipping extensions (--SkipExtensions)`n" -ForegroundColor Gray
}

# Step 2: Apply Settings
if (-not $SkipSettings) {
    Write-Host "Step 2: Applying Cursor settings..." -ForegroundColor Yellow
    
    $settingsSource = Join-Path $onboardingDir "settings.json"
    $settingsDest = "$env:APPDATA\Cursor\User\settings.json"
    $settingsDir = Split-Path $settingsDest -Parent
    
    if (Test-Path $settingsSource) {
        # Create directory if needed
        if (-not (Test-Path $settingsDir)) {
            New-Item -ItemType Directory -Path $settingsDir -Force | Out-Null
            Write-Host "  📁 Created settings directory" -ForegroundColor Gray
        }
        
        # Backup existing settings if they exist
        if (Test-Path $settingsDest) {
            $backupPath = "$settingsDest.backup-$(Get-Date -Format 'yyyyMMdd-HHmmss')"
            Copy-Item $settingsDest $backupPath -Force
            Write-Host "  💾 Backed up existing settings to: $(Split-Path $backupPath -Leaf)" -ForegroundColor Gray
        }
        
        # Merge settings (SPECTRA settings take precedence)
        if (Test-Path $settingsDest) {
            try {
                $existing = Get-Content $settingsDest -Raw | ConvertFrom-Json -AsHashtable
                $spectra = Get-Content $settingsSource -Raw | ConvertFrom-Json -AsHashtable
                
                foreach ($key in $spectra.Keys) {
                    $existing[$key] = $spectra[$key]
                }
                
                $existing | ConvertTo-Json -Depth 10 | Set-Content $settingsDest -Encoding utf8
                Write-Host "  ✅ Settings merged (SPECTRA settings applied)" -ForegroundColor Green
            } catch {
                Write-Host "  ⚠️  Failed to merge, copying instead: $_" -ForegroundColor Yellow
                Copy-Item $settingsSource $settingsDest -Force
                Write-Host "  ✅ Settings copied" -ForegroundColor Green
            }
        } else {
            Copy-Item $settingsSource $settingsDest -Force
            Write-Host "  ✅ Settings applied" -ForegroundColor Green
        }
    } else {
        Write-Host "  ⚠️  Settings file not found: $settingsSource" -ForegroundColor Yellow
    }
    
    Write-Host ""
} else {
    Write-Host "Step 2: Skipping settings (--SkipSettings)`n" -ForegroundColor Gray
}

# Step 3: Restore MCP Configuration
if (-not $SkipMCP) {
    Write-Host "Step 3: Restoring MCP configuration..." -ForegroundColor Yellow
    
    $mcpScript = Join-Path $toolingDir "sync-cursor-config.ps1"
    if (Test-Path $mcpScript) {
        try {
            & $mcpScript -Direction pull -Force
            Write-Host "✅ MCP configuration restored`n" -ForegroundColor Green
        } catch {
            Write-Host "  ⚠️  MCP sync failed (may not be configured): $_" -ForegroundColor Yellow
            Write-Host "     This is OK if you don't use MCP servers`n" -ForegroundColor Gray
        }
    } else {
        Write-Host "  ⚠️  MCP sync script not found: $mcpScript" -ForegroundColor Yellow
        Write-Host "     Skipping MCP configuration`n" -ForegroundColor Yellow
    }
} else {
    Write-Host "Step 3: Skipping MCP (--SkipMCP)`n" -ForegroundColor Gray
}

# Summary
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  Profile Restoration Complete!                            ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Restart Cursor to apply all changes" -ForegroundColor White
Write-Host "  2. Verify extensions: Ctrl+Shift+X" -ForegroundColor White
Write-Host "  3. Verify settings: Ctrl+, (check Python path, Ruff enabled)" -ForegroundColor White
Write-Host "  4. Test Python: Open any .py file (Pylance should work)" -ForegroundColor White

if (-not $SkipMCP) {
    Write-Host "  5. Check MCP: Ctrl+Shift+P → 'MCP: Show Servers'" -ForegroundColor White
}

Write-Host "`nSettings location: $env:APPDATA\Cursor\User\settings.json" -ForegroundColor Gray
Write-Host "Extensions location: $env:USERPROFILE\.cursor\extensions\`n" -ForegroundColor Gray

