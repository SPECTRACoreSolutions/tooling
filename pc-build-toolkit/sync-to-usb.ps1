# ═══════════════════════════════════════════════════════════════════════════
# SPECTRA PC Build Toolkit - Sync to USB
# Syncs Desktop working copy to USB drive
# USB stays plugged in, we keep it updated automatically!
# ═══════════════════════════════════════════════════════════════════════════

param(
    [Parameter(Mandatory=$false)]
    [string]$USBDrive = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$DryRun = $false
)

Write-Host "`n╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              SPECTRA PC TOOLKIT - SYNC TO USB                              ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# ═══════════════════════════════════════════════════════════════════════════
# DETECT DRIVES
# ═══════════════════════════════════════════════════════════════════════════

# Source location
$coreToolkit = "C:\Users\markm\OneDrive\SPECTRA\Core\tooling\pc-build-toolkit"

# Detect USB drive
if ($USBDrive -eq "") {
    Write-Host "🔍 Detecting USB drive..." -ForegroundColor Yellow
    $usbDrives = Get-Volume | Where-Object {$_.DriveType -eq 'Removable' -and $_.Size -gt 0}
    
    if ($usbDrives.Count -eq 0) {
        Write-Host "❌ No USB drive found! Please plug in your USB." -ForegroundColor Red
        exit 1
    }
    
    if ($usbDrives.Count -eq 1) {
        $USBDrive = $usbDrives[0].DriveLetter + ":"
    } else {
        Write-Host "Multiple USB drives found:" -ForegroundColor Yellow
        $usbDrives | ForEach-Object {
            $sizeGB = [math]::Round($_.Size / 1GB, 2)
            Write-Host "   $($_.DriveLetter): - $($_.FileSystemLabel) ($sizeGB GB)"
        }
        $USBDrive = Read-Host "`nEnter drive letter"
        if ($USBDrive -notlike "*:") { $USBDrive += ":" }
    }
}

Write-Host "✅ USB Drive: $USBDrive`n" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════════════════
# SYNC PLAN
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "📋 Sync Plan:`n" -ForegroundColor Yellow
Write-Host "   1. Core toolkit (everything) → USB" -ForegroundColor Cyan
Write-Host "   2. Maintain USB folder structure`n" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "🔍 DRY RUN MODE - No files will be copied`n" -ForegroundColor Yellow
}

# ═══════════════════════════════════════════════════════════════════════════
# SYNC: CORE TOOLKIT → USB
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "1. Syncing Documentation & Scripts (Core → USB)" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

$docFiles = @(
    "README.txt",
    "README.md",
    "START-HERE.txt",
    "DOWNLOAD-CHECKLIST.txt",
    "HOW-TO-USE-DOWNLOADER.md",
    ".gitignore"
)

foreach ($file in $docFiles) {
    $source = Join-Path $coreToolkit $file
    $dest = Join-Path $USBDrive $file
    
    if (Test-Path $source) {
        if (-not $DryRun) {
            Copy-Item $source -Destination $dest -Force
        }
        Write-Host "   ✓ $file" -ForegroundColor Green
    }
}

# Sync scripts
if (Test-Path "$coreToolkit\05-Scripts") {
    if (-not $DryRun) {
        Copy-Item "$coreToolkit\05-Scripts\*" -Destination "$USBDrive\05-Scripts\" -Force -Recurse
    }
    Write-Host "   ✓ 05-Scripts/" -ForegroundColor Green
}

# Sync documentation
if (Test-Path "$coreToolkit\06-Documentation") {
    if (-not $DryRun) {
        Copy-Item "$coreToolkit\06-Documentation\*" -Destination "$USBDrive\06-Documentation\" -Force -Recurse
    }
    Write-Host "   ✓ 06-Documentation/" -ForegroundColor Green
}

# Sync download toolkit script
$downloadScript = "$coreToolkit\download-toolkit.ps1"
if (Test-Path $downloadScript) {
    if (-not $DryRun) {
        Copy-Item $downloadScript -Destination "$USBDrive\download-toolkit.ps1" -Force
    }
    Write-Host "   ✓ download-toolkit.ps1" -ForegroundColor Green
}

# Sync this sync script!
$syncScript = "$coreToolkit\sync-to-usb.ps1"
if (Test-Path $syncScript) {
    if (-not $DryRun) {
        Copy-Item $syncScript -Destination "$USBDrive\sync-to-usb.ps1" -Force
    }
    Write-Host "   ✓ sync-to-usb.ps1`n" -ForegroundColor Green
}

# ═══════════════════════════════════════════════════════════════════════════
# SYNC: ALL CORE CONTENT → USB
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "2. Syncing All Content (Core → USB)" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# Sync entire toolkit folder structure
$foldersToSync = @("01-Windows", "02-Drivers", "03-AIO-RGB", "04-Utilities", "07-Backup")

foreach ($folder in $foldersToSync) {
    $source = Join-Path $coreToolkit $folder
    $dest = Join-Path $USBDrive $folder
    
    if (Test-Path $source) {
        if (-not $DryRun) {
            Copy-Item "$source\*" -Destination $dest -Recurse -Force -ErrorAction SilentlyContinue
        }
        
        # Count files
        $fileCount = (Get-ChildItem $source -Recurse -File -ErrorAction SilentlyContinue | Measure-Object).Count
        if ($fileCount -gt 0) {
            Write-Host "   ✓ $folder/ ($fileCount files)" -ForegroundColor Green
        }
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                              SYNC COMPLETE                                " -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

if ($DryRun) {
    Write-Host "🔍 This was a dry run. Run without -DryRun to actually sync.`n" -ForegroundColor Yellow
} else {
    Write-Host "✅ USB is now up to date!`n" -ForegroundColor Green
}

Write-Host "📍 Locations:" -ForegroundColor Cyan
Write-Host "   Source (Core): $coreToolkit" -ForegroundColor White
Write-Host "   Target (USB):  $USBDrive`n" -ForegroundColor White

Write-Host "💡 Workflow:" -ForegroundColor Yellow
Write-Host "   1. Add files to Core toolkit" -ForegroundColor White
Write-Host "   2. Run this script to sync Core → USB" -ForegroundColor White
Write-Host "   3. USB always current and ready!`n" -ForegroundColor White

Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Read-Host "Press Enter to exit"

