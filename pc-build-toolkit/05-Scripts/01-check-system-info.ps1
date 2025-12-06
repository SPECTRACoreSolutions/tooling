# ═══════════════════════════════════════════════════════════════════════════
# SPECTRA PC Toolkit - System Information Script
# Displays comprehensive system information
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n╔════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              SPECTRA SYSTEM INFORMATION                                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# CPU Information
Write-Host "🔥 CPU INFORMATION:" -ForegroundColor Yellow
Get-CimInstance Win32_Processor | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed | Format-List

# Motherboard Information
Write-Host "`n🎮 MOTHERBOARD INFORMATION:" -ForegroundColor Yellow
Get-CimInstance Win32_BaseBoard | Select-Object Manufacturer, Product, Version | Format-List

# RAM Information
Write-Host "`n💾 MEMORY INFORMATION:" -ForegroundColor Yellow
$ram = Get-CimInstance Win32_PhysicalMemory
$totalRAM = ($ram | Measure-Object Capacity -Sum).Sum / 1GB
Write-Host "Total RAM: $totalRAM GB"
Write-Host "RAM Sticks:"
$ram | Select-Object Manufacturer, Capacity, Speed, SMBIOSMemoryType | Format-Table

# Memory Type Legend
Write-Host "Memory Type: " -NoNewline
$memType = $ram[0].SMBIOSMemoryType
if ($memType -eq 26) { Write-Host "DDR4" -ForegroundColor Green }
elseif ($memType -eq 34) { Write-Host "DDR5" -ForegroundColor Green }
else { Write-Host "Unknown ($memType)" }

# GPU Information
Write-Host "`n🎨 GRAPHICS CARD INFORMATION:" -ForegroundColor Yellow
Get-CimInstance Win32_VideoController | Where-Object {$_.Name -notlike "*Microsoft*"} | Select-Object Name, DriverVersion, AdapterRAM | Format-List

# Storage Information
Write-Host "`n💽 STORAGE INFORMATION:" -ForegroundColor Yellow
Get-PhysicalDisk | Select-Object FriendlyName, MediaType, Size | Format-Table

# Windows Information
Write-Host "`n🪟 WINDOWS INFORMATION:" -ForegroundColor Yellow
Get-CimInstance Win32_OperatingSystem | Select-Object Caption, Version, BuildNumber, OSArchitecture | Format-List

# Windows Activation Status
Write-Host "`n🔐 WINDOWS ACTIVATION:" -ForegroundColor Yellow
$activation = Get-CimInstance SoftwareLicensingProduct | Where-Object {$_.PartialProductKey -and $_.Name -like "Windows*"}
if ($activation.LicenseStatus -eq 1) {
    Write-Host "Status: ACTIVATED ✅" -ForegroundColor Green
} else {
    Write-Host "Status: NOT ACTIVATED ❌" -ForegroundColor Red
}

Write-Host "`n" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# Ask to save to file
$save = Read-Host "Save this information to Desktop? (Y/N)"
if ($save -eq "Y" -or $save -eq "y") {
    $desktop = [Environment]::GetFolderPath("Desktop")
    $timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    $filename = "$desktop\system-info_$timestamp.txt"
    systeminfo > $filename
    Write-Host "✅ Saved to: $filename" -ForegroundColor Green
}

Read-Host "`nPress Enter to exit"

