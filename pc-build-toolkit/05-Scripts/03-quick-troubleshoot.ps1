# ═══════════════════════════════════════════════════════════════════════════
# SPECTRA PC Toolkit - Quick Troubleshooting Script
# Checks common issues after new PC build
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n╔════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              SPECTRA QUICK TROUBLESHOOT                                ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

$issues = @()

# Check 1: RAM Detection
Write-Host "🔍 Checking RAM..." -ForegroundColor Yellow
$ram = Get-CimInstance Win32_PhysicalMemory
$ramCount = $ram.Count
$totalRAM = ($ram | Measure-Object Capacity -Sum).Sum / 1GB

Write-Host "   RAM Sticks Detected: $ramCount" -ForegroundColor Cyan
Write-Host "   Total RAM: $totalRAM GB" -ForegroundColor Cyan

if ($ramCount -lt 2) {
    $issues += "⚠️  Only $ramCount RAM stick detected. Check all sticks are fully seated."
}
if ($totalRAM -lt 8) {
    $issues += "⚠️  Low RAM detected ($totalRAM GB). Expected more?"
}

# Check 2: CPU Cores
Write-Host "`n🔍 Checking CPU..." -ForegroundColor Yellow
$cpu = Get-CimInstance Win32_Processor
$cores = $cpu.NumberOfCores
$threads = $cpu.NumberOfLogicalProcessors

Write-Host "   CPU: $($cpu.Name)" -ForegroundColor Cyan
Write-Host "   Cores: $cores | Threads: $threads" -ForegroundColor Cyan

if ($cores -lt 4) {
    $issues += "⚠️  Low core count detected ($cores). Is CPU properly installed?"
}

# Check 3: Storage Devices
Write-Host "`n🔍 Checking storage..." -ForegroundColor Yellow
$disks = Get-PhysicalDisk | Where-Object {$_.BusType -ne 'USB'}
$diskCount = $disks.Count

Write-Host "   Internal Drives Detected: $diskCount" -ForegroundColor Cyan
$disks | ForEach-Object {
    $sizeGB = [math]::Round($_.Size / 1GB, 2)
    Write-Host "   - $($_.FriendlyName): $sizeGB GB ($($_.MediaType))" -ForegroundColor Cyan
}

if ($diskCount -eq 0) {
    $issues += "❌ No storage devices detected! Check M.2/SATA connections."
}

# Check 4: Network Adapters
Write-Host "`n🔍 Checking network adapters..." -ForegroundColor Yellow
$adapters = Get-NetAdapter | Where-Object {$_.Status -eq 'Up'}
$adapterCount = $adapters.Count

if ($adapterCount -gt 0) {
    Write-Host "   Active Adapters: $adapterCount" -ForegroundColor Green
    $adapters | ForEach-Object {
        Write-Host "   - $($_.Name): $($_.Status)" -ForegroundColor Cyan
    }
} else {
    Write-Host "   No active network adapters!" -ForegroundColor Red
    $issues += "⚠️  No network connection. Install LAN driver from USB."
}

# Check 5: Graphics Card
Write-Host "`n🔍 Checking graphics..." -ForegroundColor Yellow
$gpu = Get-CimInstance Win32_VideoController | Where-Object {$_.Name -notlike "*Microsoft*" -and $_.Name -notlike "*Remote*"}

if ($gpu) {
    Write-Host "   GPU: $($gpu.Name)" -ForegroundColor Cyan
    $vramGB = [math]::Round($gpu.AdapterRAM / 1GB, 2)
    Write-Host "   VRAM: $vramGB GB" -ForegroundColor Cyan
} else {
    Write-Host "   Only basic display adapter detected" -ForegroundColor Yellow
    $issues += "⚠️  No dedicated GPU detected. Check GPU power cables and seating."
}

# Check 6: Windows Activation
Write-Host "`n🔍 Checking Windows activation..." -ForegroundColor Yellow
$activation = Get-CimInstance SoftwareLicensingProduct | Where-Object {$_.PartialProductKey -and $_.Name -like "Windows*"}

if ($activation.LicenseStatus -eq 1) {
    Write-Host "   Status: Activated ✅" -ForegroundColor Green
} else {
    Write-Host "   Status: Not Activated ❌" -ForegroundColor Red
    $issues += "⚠️  Windows not activated. Sign in with Microsoft account."
}

# Check 7: Device Manager Issues
Write-Host "`n🔍 Checking for device errors..." -ForegroundColor Yellow
$deviceErrors = Get-CimInstance Win32_PnPEntity | Where-Object {$_.ConfigManagerErrorCode -ne 0}
$errorCount = ($deviceErrors | Measure-Object).Count

if ($errorCount -gt 0) {
    Write-Host "   Devices with errors: $errorCount" -ForegroundColor Red
    $deviceErrors | Select-Object -First 5 | ForEach-Object {
        Write-Host "   - $($_.Name)" -ForegroundColor Yellow
    }
    $issues += "⚠️  $errorCount devices need drivers. Check Device Manager."
} else {
    Write-Host "   All devices working properly ✅" -ForegroundColor Green
}

# Check 8: Windows Update
Write-Host "`n🔍 Checking Windows Update..." -ForegroundColor Yellow
try {
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $searchResult = $updateSearcher.Search("IsInstalled=0")
    $pendingCount = $searchResult.Updates.Count
    
    if ($pendingCount -gt 0) {
        Write-Host "   Pending updates: $pendingCount" -ForegroundColor Yellow
        $issues += "ℹ️  $pendingCount Windows updates available. Run Windows Update."
    } else {
        Write-Host "   System up to date ✅" -ForegroundColor Green
    }
} catch {
    Write-Host "   Could not check Windows Update" -ForegroundColor Yellow
}

# Summary
Write-Host "`n═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                             SUMMARY                                       " -ForegroundColor Cyan
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

if ($issues.Count -eq 0) {
    Write-Host "🎉 ALL CHECKS PASSED! Your system looks great!" -ForegroundColor Green
    Write-Host "`nYou're ready to:" -ForegroundColor Green
    Write-Host "   1. Run stress tests (Prime95, MemTest86)"
    Write-Host "   2. Install your applications"
    Write-Host "   3. Enjoy your new build! 🎮"
} else {
    Write-Host "⚠️  Found $($issues.Count) issue(s) to address:`n" -ForegroundColor Yellow
    $issues | ForEach-Object {
        Write-Host $_ -ForegroundColor Yellow
    }
    Write-Host "`n💡 Check README.txt on this USB for troubleshooting guides!" -ForegroundColor Cyan
}

Write-Host "`n═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Read-Host "Press Enter to exit"

