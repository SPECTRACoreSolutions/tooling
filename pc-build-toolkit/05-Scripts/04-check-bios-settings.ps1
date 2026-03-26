# ═══════════════════════════════════════════════════════════════════════════
# SPECTRA PC Toolkit - BIOS/UEFI Settings Checker
# Reads BIOS settings accessible from Windows
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n╔════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              BIOS/UEFI SETTINGS CHECKER                                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# BIOS Information
Write-Host "🔧 BIOS/UEFI INFORMATION:" -ForegroundColor Yellow
$bios = Get-CimInstance Win32_BIOS
$bios | Select-Object Manufacturer, Name, Version, ReleaseDate, SerialNumber | Format-List

# Check if UEFI or Legacy BIOS
Write-Host "`n💾 FIRMWARE TYPE:" -ForegroundColor Yellow
$firmware = Get-CimInstance Win32_ComputerSystem
if ($firmware.BootupState -like "*UEFI*" -or (Get-CimInstance Win32_SystemEnclosure).ChassisTypes -contains 9) {
    Write-Host "Firmware Type: UEFI ✅" -ForegroundColor Green
}
else {
    Write-Host "Firmware Type: Legacy BIOS" -ForegroundColor Yellow
}

# Check Secure Boot Status
Write-Host "`n🔒 SECURE BOOT STATUS:" -ForegroundColor Yellow
try {
    $secureBoot = Confirm-SecureBootUEFI -ErrorAction SilentlyContinue
    if ($secureBoot) {
        Write-Host "Secure Boot: ENABLED ✅" -ForegroundColor Green
    }
    else {
        Write-Host "Secure Boot: DISABLED" -ForegroundColor Yellow
    }
}
catch {
    Write-Host "Secure Boot: Unable to determine (may not be UEFI)" -ForegroundColor Gray
}

# CPU Information (including clock speeds)
Write-Host "`n🔥 CPU INFORMATION:" -ForegroundColor Yellow
$cpu = Get-CimInstance Win32_Processor
Write-Host "Processor: $($cpu.Name)" -ForegroundColor Cyan
Write-Host "Cores: $($cpu.NumberOfCores) | Logical Processors: $($cpu.NumberOfLogicalProcessors)" -ForegroundColor Cyan
Write-Host "Base Clock: $($cpu.MaxClockSpeed) MHz" -ForegroundColor Cyan
Write-Host "Current Clock: $($cpu.CurrentClockSpeed) MHz" -ForegroundColor Cyan

# RAM Information (including speed)
Write-Host "`n💾 MEMORY INFORMATION:" -ForegroundColor Yellow
$ram = Get-CimInstance Win32_PhysicalMemory
$totalRAM = ($ram | Measure-Object Capacity -Sum).Sum / 1GB
Write-Host "Total RAM: $totalRAM GB" -ForegroundColor Cyan
Write-Host "`nRAM Sticks:" -ForegroundColor Cyan
$ram | ForEach-Object {
    $speed = $_.Speed
    $capacity = $_.Capacity / 1GB
    $manufacturer = $_.Manufacturer
    $partNumber = $_.PartNumber
    Write-Host "  - $capacity GB @ $speed MHz | $manufacturer | $partNumber" -ForegroundColor White
}

# Check if XMP is enabled (RAM speed vs JEDEC)
Write-Host "`n⚡ RAM SPEED ANALYSIS:" -ForegroundColor Yellow
$ramSpeed = $ram[0].Speed
if ($ramSpeed -ge 4800) {
    Write-Host "RAM Speed: $ramSpeed MHz" -ForegroundColor Green
    Write-Host "Status: XMP/EXPO likely ENABLED ✅ (running at rated speed)" -ForegroundColor Green
}
elseif ($ramSpeed -eq 4800) {
    Write-Host "RAM Speed: $ramSpeed MHz" -ForegroundColor Green
    Write-Host "Status: Running at base DDR5 speed (XMP may not be enabled)" -ForegroundColor Yellow
    Write-Host "⚠️  Check BIOS: Enable XMP Profile 1 for optimal performance" -ForegroundColor Yellow
}
else {
    Write-Host "RAM Speed: $ramSpeed MHz" -ForegroundColor Yellow
    Write-Host "Status: Running below rated speed - XMP likely DISABLED" -ForegroundColor Red
    Write-Host "⚠️  ACTION REQUIRED: Enable XMP Profile 1 in BIOS!" -ForegroundColor Red
}

# Boot Configuration
Write-Host "`n🚀 BOOT CONFIGURATION:" -ForegroundColor Yellow
$bootDisk = Get-CimInstance Win32_DiskDrive | Where-Object { $_.MediaType -like "*SSD*" -or $_.MediaType -like "*NVMe*" } | Select-Object -First 1
if ($bootDisk) {
    Write-Host "Boot Drive: $($bootDisk.Model)" -ForegroundColor Cyan
    Write-Host "Interface: $($bootDisk.InterfaceType)" -ForegroundColor Cyan
}

# PCIe Information (for GPU and M.2 slots)
Write-Host "`n🔌 PCIe DEVICES:" -ForegroundColor Yellow
Get-CimInstance Win32_PnPEntity | Where-Object { $_.PNPClass -eq "PCI" -or $_.PNPClass -eq "PCIe" } | 
Select-Object Name, DeviceID | Format-Table -AutoSize

# Temperature Monitoring (if available)
Write-Host "`n🌡️  TEMPERATURE MONITORING:" -ForegroundColor Yellow
Write-Host "Note: Detailed temps require HWiNFO64 or MSI Center" -ForegroundColor Gray
Write-Host "Run HWiNFO64 from: 04-Utilities\Monitoring\" -ForegroundColor Gray

# Summary Recommendations
Write-Host "`n📋 BIOS SETTINGS CHECKLIST:" -ForegroundColor Yellow
Write-Host "To access BIOS:" -ForegroundColor Cyan
Write-Host "  1. Restart PC" -ForegroundColor White
Write-Host "  2. Press DELETE key repeatedly during boot (MSI logo screen)" -ForegroundColor White
Write-Host "  3. Or: Settings → Update & Security → Recovery → Advanced Startup → Restart Now" -ForegroundColor White
Write-Host "`nRecommended BIOS Settings:" -ForegroundColor Cyan
Write-Host "  [ ] Enable XMP Profile 1 (for RAM speed)" -ForegroundColor White
Write-Host "  [ ] Set boot order (Windows drive first)" -ForegroundColor White
Write-Host "  [ ] Enable Resizable BAR (for modern GPUs)" -ForegroundColor White
Write-Host "  [ ] Check fan curves (adjust if too loud/quiet)" -ForegroundColor White
Write-Host "  [ ] Verify CPU temperature (should be 30-45°C idle)" -ForegroundColor White

Write-Host "`n" -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# Ask to save to file
$save = Read-Host "Save this information to Desktop? (Y/N)"
if ($save -eq "Y" -or $save -eq "y") {
    $desktop = [Environment]::GetFolderPath("Desktop")
    $timestamp = Get-Date -Format "yyyy-MM-dd_HHmmss"
    $filename = "$desktop\bios-settings_$timestamp.txt"
    
    $output = @"
BIOS/UEFI Settings Report
Generated: $(Get-Date)

BIOS Information:
$(($bios | Select-Object Manufacturer, Name, Version, ReleaseDate | Format-List | Out-String))

CPU Information:
$(($cpu | Select-Object Name, NumberOfCores, NumberOfLogicalProcessors, MaxClockSpeed, CurrentClockSpeed | Format-List | Out-String))

Memory Information:
Total RAM: $totalRAM GB
RAM Speed: $ramSpeed MHz
$(($ram | Select-Object Capacity, Speed, Manufacturer, PartNumber | Format-Table | Out-String))

Secure Boot: $(if ($secureBoot) { "ENABLED" } else { "DISABLED or N/A" })
"@
    
    Set-Content -Path $filename -Value $output
    Write-Host "✅ Saved to: $filename" -ForegroundColor Green
}

Read-Host "`nPress Enter to exit"






