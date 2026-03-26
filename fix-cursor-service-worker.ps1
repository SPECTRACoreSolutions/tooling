#Requires -Version 7.0

<#
.SYNOPSIS
    Fix Cursor service worker registration errors

.DESCRIPTION
    Clears Cursor's cache and service worker data to fix webview errors.
    This resolves "Could not register service worker: InvalidStateError" errors.

.EXAMPLE
    .\fix-cursor-service-worker.ps1
    Clear cache and restart Cursor

.EXAMPLE
    .\fix-cursor-service-worker.ps1 -KeepCache
    Only clear service workers, keep cache
#>

param(
    [Parameter(Mandatory=$false)]
    [switch]$KeepCache
)

$ErrorActionPreference = "Stop"

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║  Cursor Service Worker Fix                                ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Cursor cache locations
$cursorCache = "$env:APPDATA\Cursor\Cache"
$cursorGPUCache = "$env:APPDATA\Cursor\GPUCache"
$cursorCodeCache = "$env:APPDATA\Cursor\Code Cache"
$cursorServiceWorkers = "$env:APPDATA\Cursor\Service Worker"
$cursorLocalStorage = "$env:APPDATA\Cursor\Local Storage"

# Check if Cursor is running
Write-Host "Step 1: Checking Cursor processes..." -ForegroundColor Yellow
$cursorProcs = Get-Process -Name "Cursor" -ErrorAction SilentlyContinue
if ($cursorProcs) {
    Write-Host "  ⚠️  Cursor is running - closing all instances..." -ForegroundColor Yellow
    
    # Try graceful shutdown first
    $cursorProcs | ForEach-Object {
        try {
            $_.CloseMainWindow() | Out-Null
        } catch {
            # Ignore errors
        }
    }
    
    # Wait a moment
    Start-Sleep -Seconds 2
    
    # Force kill if still running
    $stillRunning = Get-Process -Name "Cursor" -ErrorAction SilentlyContinue
    if ($stillRunning) {
        Write-Host "  🔄 Force closing remaining processes..." -ForegroundColor Yellow
        $stillRunning | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 1
    }
    
    Write-Host "  ✅ Cursor closed`n" -ForegroundColor Green
} else {
    Write-Host "  ✅ Cursor is not running`n" -ForegroundColor Green
}

# Clear service workers
Write-Host "Step 2: Clearing service workers..." -ForegroundColor Yellow
if (Test-Path $cursorServiceWorkers) {
    try {
        Remove-Item -Path $cursorServiceWorkers -Recurse -Force -ErrorAction Stop
        Write-Host "  ✅ Service workers cleared" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠️  Could not clear service workers: $_" -ForegroundColor Yellow
        Write-Host "     (This is OK if Cursor was using them)" -ForegroundColor Gray
    }
} else {
    Write-Host "  ℹ️  Service worker directory not found (already clean)" -ForegroundColor Gray
}

# Clear Local Storage (contains service worker registrations)
if (Test-Path $cursorLocalStorage) {
    try {
        Remove-Item -Path "$cursorLocalStorage\*" -Recurse -Force -ErrorAction SilentlyContinue
        Write-Host "  ✅ Local storage cleared" -ForegroundColor Green
    } catch {
        Write-Host "  ⚠️  Could not clear local storage: $_" -ForegroundColor Yellow
    }
}

Write-Host ""

# Clear cache (optional)
if (-not $KeepCache) {
    Write-Host "Step 3: Clearing cache..." -ForegroundColor Yellow
    
    $cacheDirs = @($cursorCache, $cursorGPUCache, $cursorCodeCache)
    $cleared = 0
    
    foreach ($dir in $cacheDirs) {
        if (Test-Path $dir) {
            try {
                Remove-Item -Path "$dir\*" -Recurse -Force -ErrorAction SilentlyContinue
                $cleared++
                Write-Host "  ✅ Cleared: $(Split-Path $dir -Leaf)" -ForegroundColor Green
            } catch {
                Write-Host "  ⚠️  Could not clear: $(Split-Path $dir -Leaf)" -ForegroundColor Yellow
            }
        }
    }
    
    if ($cleared -eq 0) {
        Write-Host "  ℹ️  No cache directories found" -ForegroundColor Gray
    }
} else {
    Write-Host "Step 3: Skipping cache (--KeepCache)`n" -ForegroundColor Gray
}

Write-Host ""

# Summary
Write-Host "╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Green
Write-Host "║  Service Worker Fix Complete!                               ║" -ForegroundColor Green
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Green

Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  1. Start Cursor (service workers will re-register)" -ForegroundColor White
Write-Host "  2. Open your workspace" -ForegroundColor White
Write-Host "  3. The error should be resolved`n" -ForegroundColor White

Write-Host "If the error persists:" -ForegroundColor Yellow
Write-Host "  1. Try opening Cursor in safe mode: cursor --disable-extensions" -ForegroundColor White
Write-Host "  2. Check Cursor logs: Help → Toggle Developer Tools → Console" -ForegroundColor White
Write-Host "  3. Report the issue if it continues`n" -ForegroundColor White

Write-Host "Cache locations cleared:" -ForegroundColor Gray
Write-Host "  Service Workers: $cursorServiceWorkers" -ForegroundColor Gray
Write-Host "  Local Storage: $cursorLocalStorage" -ForegroundColor Gray
if (-not $KeepCache) {
    Write-Host "  Cache: $cursorCache" -ForegroundColor Gray
    Write-Host "  GPU Cache: $cursorGPUCache" -ForegroundColor Gray
    Write-Host "  Code Cache: $cursorCodeCache" -ForegroundColor Gray
}
Write-Host ""


