# ═══════════════════════════════════════════════════════════════════════════
# SPECTRA PC Build Toolkit - Smart Downloader
# Automatically downloads what it can, opens browser for the rest
# ═══════════════════════════════════════════════════════════════════════════

param(
    [Parameter(Mandatory=$false)]
    [string]$USBDrive = "",
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipUtilities = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$SkipDrivers = $false
)

# ═══════════════════════════════════════════════════════════════════════════
# CONFIGURATION
# ═══════════════════════════════════════════════════════════════════════════

$ErrorActionPreference = "Continue"

Write-Host "`n╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         SPECTRA PC BUILD TOOLKIT - SMART DOWNLOADER v1.0                  ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# ═══════════════════════════════════════════════════════════════════════════
# DETECT USB DRIVE
# ═══════════════════════════════════════════════════════════════════════════

if ($USBDrive -eq "") {
    Write-Host "🔍 Detecting USB drives..." -ForegroundColor Yellow
    $usbDrives = Get-Volume | Where-Object {$_.DriveType -eq 'Removable' -and $_.Size -gt 0}
    
    if ($usbDrives.Count -eq 0) {
        Write-Host "❌ No USB drives found! Please plug in your USB drive." -ForegroundColor Red
        Read-Host "Press Enter to exit"
        exit 1
    }
    
    if ($usbDrives.Count -eq 1) {
        $USBDrive = $usbDrives[0].DriveLetter + ":"
        Write-Host "✅ Found USB drive: $USBDrive" -ForegroundColor Green
    } else {
        Write-Host "`nMultiple USB drives found:" -ForegroundColor Yellow
        $usbDrives | ForEach-Object {
            $sizeGB = [math]::Round($_.Size / 1GB, 2)
            Write-Host "   $($_.DriveLetter): - $($_.FileSystemLabel) ($sizeGB GB)" -ForegroundColor Cyan
        }
        $USBDrive = Read-Host "`nEnter drive letter (e.g., H)"
        if ($USBDrive -notlike "*:") { $USBDrive = $USBDrive + ":" }
    }
}

# Verify drive exists
if (-not (Test-Path $USBDrive)) {
    Write-Host "❌ Drive $USBDrive not found!" -ForegroundColor Red
    exit 1
}

Write-Host "`n📍 USB Drive: $USBDrive" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════════════════
# ENSURE FOLDER STRUCTURE EXISTS
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n📁 Ensuring folder structure exists..." -ForegroundColor Yellow

$folders = @(
    "$USBDrive\01-Windows",
    "$USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\Chipset",
    "$USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\LAN",
    "$USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\Audio",
    "$USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\WiFi-Bluetooth",
    "$USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\Thunderbolt",
    "$USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\BIOS",
    "$USBDrive\02-Drivers\Universal\NVIDIA",
    "$USBDrive\02-Drivers\Universal\AMD",
    "$USBDrive\02-Drivers\Universal\Intel",
    "$USBDrive\03-AIO-RGB\MSI-Center",
    "$USBDrive\03-AIO-RGB\MSI-CoreLiquid-i360",
    "$USBDrive\04-Utilities\System-Info",
    "$USBDrive\04-Utilities\Monitoring",
    "$USBDrive\04-Utilities\Stress-Testing",
    "$USBDrive\04-Utilities\Drive-Tools",
    "$USBDrive\04-Utilities\Driver-Tools",
    "$USBDrive\04-Utilities\General",
    "$USBDrive\05-Scripts",
    "$USBDrive\06-Documentation",
    "$USBDrive\07-Backup"
)

foreach ($folder in $folders) {
    if (-not (Test-Path $folder)) {
        New-Item -ItemType Directory -Path $folder -Force | Out-Null
    }
}

Write-Host "✅ Folder structure ready!" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════════════════
# COPY DOCUMENTATION & SCRIPTS
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n📄 Copying documentation and scripts..." -ForegroundColor Yellow

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$sourceDocs = @(
    "README.txt",
    "START-HERE.txt",
    "DOWNLOAD-CHECKLIST.txt",
    ".gitignore"
)

foreach ($doc in $sourceDocs) {
    $source = Join-Path $scriptPath $doc
    if (Test-Path $source) {
        Copy-Item $source -Destination $USBDrive -Force
    }
}

# Copy scripts
if (Test-Path "$scriptPath\05-Scripts") {
    Copy-Item "$scriptPath\05-Scripts\*" -Destination "$USBDrive\05-Scripts\" -Force
}

# Copy documentation
if (Test-Path "$scriptPath\06-Documentation") {
    Copy-Item "$scriptPath\06-Documentation\*" -Destination "$USBDrive\06-Documentation\" -Force
}

Write-Host "✅ Documentation copied!" -ForegroundColor Green

# ═══════════════════════════════════════════════════════════════════════════
# DOWNLOAD FUNCTION
# ═══════════════════════════════════════════════════════════════════════════

function Download-File {
    param(
        [string]$Url,
        [string]$Destination,
        [string]$Name
    )
    
    try {
        Write-Host "   ⬇️  Downloading $Name..." -ForegroundColor Cyan
        
        # Use BITS transfer if available (better for large files)
        if (Get-Command Start-BitsTransfer -ErrorAction SilentlyContinue) {
            Start-BitsTransfer -Source $Url -Destination $Destination -ErrorAction Stop
        } else {
            # Fallback to WebClient
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($Url, $Destination)
        }
        
        Write-Host "   ✅ Downloaded: $Name" -ForegroundColor Green
        return $true
    } catch {
        Write-Host "   ❌ Failed to download $Name" -ForegroundColor Red
        Write-Host "      Error: $($_.Exception.Message)" -ForegroundColor Gray
        return $false
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# AUTO-DOWNLOADABLE UTILITIES (Direct URLs)
# ═══════════════════════════════════════════════════════════════════════════

if (-not $SkipUtilities) {
    Write-Host "`n═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "   DOWNLOADING UTILITIES (Auto-downloadable)" -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

    $utilities = @(
        @{
            Name = "CPU-Z (Portable)"
            Url = "https://download.cpuid.com/cpu-z/cpu-z_2.10-en.zip"
            Destination = "$USBDrive\04-Utilities\System-Info\cpu-z.zip"
        },
        @{
            Name = "HWiNFO64 (Portable)"
            Url = "https://www.fosshub.com/HWiNFO.html?dwl=hwi_758.zip"
            Destination = "$USBDrive\04-Utilities\Monitoring\hwinfo64.zip"
        },
        @{
            Name = "CrystalDiskInfo (Portable)"
            Url = "https://github.com/hiyohiyo/CrystalDiskInfo/releases/latest/download/CrystalDiskInfo9_4_4.zip"
            Destination = "$USBDrive\04-Utilities\Drive-Tools\CrystalDiskInfo.zip"
        },
        @{
            Name = "7-Zip"
            Url = "https://www.7-zip.org/a/7z2408-x64.exe"
            Destination = "$USBDrive\04-Utilities\General\7zip-installer.exe"
        }
    )

    foreach ($util in $utilities) {
        Download-File -Url $util.Url -Destination $util.Destination -Name $util.Name
        Start-Sleep -Milliseconds 500
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# OPEN BROWSER TABS FOR MANUAL DOWNLOADS
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "   OPENING BROWSER TABS FOR MANUAL DOWNLOADS" -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "🌐 The following pages will open in your browser." -ForegroundColor Yellow
Write-Host "   Download files and save them to the specified locations:`n" -ForegroundColor Yellow

$manualDownloads = @(
    @{
        Name = "MSI MEG Z890 GODLIKE Drivers"
        Url = "https://www.msi.com/Motherboard/MEG-Z890-GODLIKE/support"
        Instructions = @"
Click 'Driver' tab → Download ALL drivers:
   • Chipset → Save to: $USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\Chipset\
   • LAN     → Save to: $USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\LAN\
   • Audio   → Save to: $USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\Audio\
   • WiFi/BT → Save to: $USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\WiFi-Bluetooth\
   • Thunderbolt → Save to: $USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\Thunderbolt\
   • BIOS    → Save to: $USBDrive\02-Drivers\MSI-MEG-Z890-GODLIKE\BIOS\
"@
    },
    @{
        Name = "MSI Center (AIO & RGB Control)"
        Url = "https://www.msi.com/Landing/MSI-Center"
        Instructions = "Download MSI Center → Save to: $USBDrive\03-AIO-RGB\MSI-Center\"
    },
    @{
        Name = "MSI CoreLiquid i360 Manual"
        Url = "https://www.msi.com/Liquid-Cooling/MAG-CORELIQUID-I360/support"
        Instructions = "Download manual PDF → Save to: $USBDrive\03-AIO-RGB\MSI-CoreLiquid-i360\"
    },
    @{
        Name = "GPU-Z (System Info)"
        Url = "https://www.techpowerup.com/gpuz/"
        Instructions = "Download GPU-Z → Save to: $USBDrive\04-Utilities\System-Info\"
    },
    @{
        Name = "Prime95 (CPU Stress Test)"
        Url = "https://www.mersenne.org/download/"
        Instructions = "Download Prime95 → Save to: $USBDrive\04-Utilities\Stress-Testing\"
    },
    @{
        Name = "OCCT (Stability Testing)"
        Url = "https://www.ocbase.com/"
        Instructions = "Download OCCT → Save to: $USBDrive\04-Utilities\Stress-Testing\"
    },
    @{
        Name = "CrystalDiskMark (Drive Benchmark)"
        Url = "https://crystalmark.info/en/download/"
        Instructions = "Download CrystalDiskMark → Save to: $USBDrive\04-Utilities\Drive-Tools\"
    },
    @{
        Name = "Rufus (USB Boot Creator)"
        Url = "https://rufus.ie/"
        Instructions = "Download Rufus (Portable) → Save to: $USBDrive\04-Utilities\General\"
    },
    @{
        Name = "NVIDIA GeForce Drivers (if applicable)"
        Url = "https://www.nvidia.com/download/index.aspx"
        Instructions = "Select your GPU → Download → Save to: $USBDrive\02-Drivers\Universal\NVIDIA\"
    },
    @{
        Name = "AMD Adrenalin Drivers (if applicable)"
        Url = "https://www.amd.com/en/support"
        Instructions = "Select your GPU → Download → Save to: $USBDrive\02-Drivers\Universal\AMD\"
    }
)

Write-Host "Press Enter to open browser tabs (or Ctrl+C to cancel)..." -ForegroundColor Yellow
Read-Host

foreach ($download in $manualDownloads) {
    Write-Host "`n📌 Opening: $($download.Name)" -ForegroundColor Cyan
    Write-Host $download.Instructions -ForegroundColor White
    Start-Process $download.Url
    Start-Sleep -Seconds 2
}

# ═══════════════════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                            DOWNLOAD SUMMARY                                " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "✅ Folder structure created on USB: $USBDrive" -ForegroundColor Green
Write-Host "✅ Documentation & scripts copied" -ForegroundColor Green
Write-Host "✅ Some utilities auto-downloaded" -ForegroundColor Green
Write-Host "🌐 Browser tabs opened for manual downloads`n" -ForegroundColor Yellow

Write-Host "NEXT STEPS:`n" -ForegroundColor Yellow
Write-Host "1. Complete the manual downloads from the browser tabs" -ForegroundColor White
Write-Host "2. Save each file to the location shown in the browser" -ForegroundColor White
Write-Host "3. Open $USBDrive\START-HERE.txt for build instructions" -ForegroundColor White
Write-Host "4. Check $USBDrive\DOWNLOAD-CHECKLIST.txt to verify you got everything`n" -ForegroundColor White

Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "💡 TIP: You can re-run this script anytime to:" -ForegroundColor Cyan
Write-Host "   • Recreate the USB structure" -ForegroundColor White
Write-Host "   • Update documentation/scripts" -ForegroundColor White
Write-Host "   • Download latest utilities`n" -ForegroundColor White

Read-Host "Press Enter to exit"


