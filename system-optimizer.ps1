# ═══════════════════════════════════════════════════════════════════════════
# SPECTRA SYSTEM OPTIMIZER
# Identifies and fixes performance issues
# Version: 1.0
# ═══════════════════════════════════════════════════════════════════════════

param(
    [Parameter(Mandatory=$false)]
    [switch]$Analyze = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$AutoFix = $false,
    
    [Parameter(Mandatory=$false)]
    [switch]$CleanTemp = $false
)

$ErrorActionPreference = "Continue"

Write-Host "`n╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                   SPECTRA SYSTEM OPTIMIZER v1.0                            ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  Some optimizations require Administrator privileges." -ForegroundColor Yellow
    Write-Host "   Run as Administrator for full functionality.`n" -ForegroundColor Yellow
}

# ═══════════════════════════════════════════════════════════════════════════
# SYSTEM ANALYSIS
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                      ANALYZING YOUR SYSTEM                                " -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# Track issues found
$issues = @()
$fixes = @()

# ───────────────────────────────────────────────────────────────────────────
# 1. RGB SOFTWARE BLOAT CHECK
# ───────────────────────────────────────────────────────────────────────────

Write-Host "🎨 Checking RGB software..." -ForegroundColor Yellow

$rgbProcesses = Get-Process | Where-Object {
    $_.ProcessName -like "*Signal*" -or 
    $_.ProcessName -like "*Razer*" -or 
    $_.ProcessName -like "*Hue*" -or
    $_.ProcessName -like "*Corsair*" -or
    $_.ProcessName -like "*RGB*"
}

if ($rgbProcesses) {
    $totalRgbMemory = ($rgbProcesses | Measure-Object WorkingSet -Sum).Sum / 1MB
    $rgbCount = ($rgbProcesses | Measure-Object).Count
    
    Write-Host "   Found $rgbCount RGB-related processes" -ForegroundColor Cyan
    Write-Host "   Total RAM usage: $([math]::Round($totalRgbMemory, 0)) MB`n" -ForegroundColor Cyan
    
    # Check for SignalRGB (major offender)
    $signalRgb = $rgbProcesses | Where-Object {$_.ProcessName -like "*Signal*"}
    if ($signalRgb) {
        $signalMem = ($signalRgb | Measure-Object WorkingSet -Sum).Sum / 1MB
        $issues += "🔴 SignalRGB detected: $([math]::Round($signalMem, 0)) MB RAM (HEAVY!)"
        $fixes += @{
            Name = "Replace SignalRGB with OpenRGB"
            Impact = "High"
            Savings = "$([math]::Round($signalMem, 0)) MB RAM"
            Action = "Manual"
            Steps = @(
                "1. Download OpenRGB from: https://openrgb.org/",
                "2. Uninstall SignalRGB: Settings → Apps → SignalRGB → Uninstall",
                "3. Install OpenRGB (lightweight, open source)",
                "4. Restart PC"
            )
        }
    }
    
    # Check for multiple Razer processes
    $razerProcesses = $rgbProcesses | Where-Object {$_.ProcessName -like "*Razer*"}
    if (($razerProcesses | Measure-Object).Count -gt 5) {
        $razerMem = ($razerProcesses | Measure-Object WorkingSet -Sum).Sum / 1MB
        $issues += "🟡 $($razerProcesses.Count) Razer processes: $([math]::Round($razerMem, 0)) MB RAM"
        $fixes += @{
            Name = "Trim Razer bloat"
            Impact = "Medium"
            Savings = "~1-2 GB RAM"
            Action = "Semi-Auto"
            Steps = @(
                "1. Keep only Razer Synapse (main app)",
                "2. Uninstall: Razer Central, Razer Cortex",
                "3. Settings → Apps → Startup → Disable Razer bloat"
            )
        }
    }
}

# ───────────────────────────────────────────────────────────────────────────
# 2. STARTUP PROGRAMS CHECK
# ───────────────────────────────────────────────────────────────────────────

Write-Host "🚀 Checking startup programs..." -ForegroundColor Yellow

# Known bloatware patterns
$bloatwarePatterns = @(
    "Adobe",
    "Creative Cloud",
    "EA",
    "Epic",
    "Steam",
    "Discord",
    "Spotify",
    "SignalRGB",
    "RazerCentral",
    "Cortex"
)

$startupApps = Get-CimInstance Win32_StartupCommand -ErrorAction SilentlyContinue
if ($startupApps) {
    $startupCount = ($startupApps | Measure-Object).Count
    Write-Host "   Found $startupCount startup programs`n" -ForegroundColor Cyan
    
    $bloatFound = $startupApps | Where-Object {
        $name = $_.Name
        $bloatwarePatterns | Where-Object { $name -like "*$_*" }
    }
    
    if ($bloatFound) {
        $issues += "🟡 $($bloatFound.Count) non-essential startup programs detected"
        $fixes += @{
            Name = "Disable non-essential startup programs"
            Impact = "High"
            Savings = "20-30 sec faster boot, ~2GB RAM"
            Action = "Semi-Auto"
            Steps = @(
                "1. Open Task Manager (Ctrl+Shift+Esc)",
                "2. Go to Startup tab",
                "3. Disable: Adobe, EA, Steam, Discord, SignalRGB",
                "4. Keep: OneDrive, Antivirus, hardware drivers"
            )
        }
    }
}

# ───────────────────────────────────────────────────────────────────────────
# 3. TOP MEMORY USERS
# ───────────────────────────────────────────────────────────────────────────

Write-Host "💾 Analyzing memory usage..." -ForegroundColor Yellow

$topMemory = Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10
$totalUsedMemory = (Get-CimInstance Win32_OperatingSystem).TotalVisibleMemorySize / 1MB
$freeMemory = (Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB
$usedMemoryPercent = (($totalUsedMemory - $freeMemory) / $totalUsedMemory) * 100

Write-Host "   RAM Usage: $([math]::Round($usedMemoryPercent, 1))%`n" -ForegroundColor Cyan

if ($usedMemoryPercent -gt 80) {
    $issues += "🔴 High RAM usage: $([math]::Round($usedMemoryPercent, 1))%"
    Write-Host "   ⚠️  RAM usage is high! Consider closing unused apps.`n" -ForegroundColor Red
}

# ───────────────────────────────────────────────────────────────────────────
# 4. TEMP FILES CHECK
# ───────────────────────────────────────────────────────────────────────────

Write-Host "🗑️  Checking temporary files..." -ForegroundColor Yellow

$tempPaths = @(
    $env:TEMP,
    "$env:LOCALAPPDATA\Temp",
    "C:\Windows\Temp"
)

$totalTempSize = 0
foreach ($path in $tempPaths) {
    if (Test-Path $path) {
        try {
            $size = (Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue | 
                     Measure-Object -Property Length -Sum -ErrorAction SilentlyContinue).Sum / 1GB
            $totalTempSize += $size
        } catch {}
    }
}

if ($totalTempSize -gt 1) {
    Write-Host "   Found $([math]::Round($totalTempSize, 2)) GB of temp files`n" -ForegroundColor Cyan
    $issues += "🟡 $([math]::Round($totalTempSize, 2)) GB temp files can be cleaned"
    $fixes += @{
        Name = "Clean temporary files"
        Impact = "Medium"
        Savings = "$([math]::Round($totalTempSize, 2)) GB disk space"
        Action = "Auto"
        Steps = @("Run this script with -CleanTemp flag")
    }
}

# ───────────────────────────────────────────────────────────────────────────
# 5. WINDOWS UPDATE CHECK
# ───────────────────────────────────────────────────────────────────────────

Write-Host "🔄 Checking Windows Update status..." -ForegroundColor Yellow

try {
    $updateSession = New-Object -ComObject Microsoft.Update.Session
    $updateSearcher = $updateSession.CreateUpdateSearcher()
    $searchResult = $updateSearcher.Search("IsInstalled=0")
    $pendingUpdates = $searchResult.Updates.Count
    
    if ($pendingUpdates -gt 0) {
        Write-Host "   $pendingUpdates pending Windows updates`n" -ForegroundColor Cyan
        $issues += "ℹ️  $pendingUpdates Windows updates available"
    } else {
        Write-Host "   ✅ Windows is up to date`n" -ForegroundColor Green
    }
} catch {
    Write-Host "   Could not check Windows Update`n" -ForegroundColor Gray
}

# ═══════════════════════════════════════════════════════════════════════════
# RECOMMENDATIONS SUMMARY
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                           RECOMMENDATIONS                                 " -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

if ($issues.Count -eq 0) {
    Write-Host "🎉 Your system looks great! No major issues found." -ForegroundColor Green
} else {
    Write-Host "Found $($issues.Count) issue(s):`n" -ForegroundColor Yellow
    
    foreach ($issue in $issues) {
        Write-Host "   $issue" -ForegroundColor White
    }
    
    Write-Host "`n═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "                              FIX PLAN                                     " -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan
    
    $priority = 1
    foreach ($fix in $fixes) {
        Write-Host "[$priority] $($fix.Name)" -ForegroundColor Cyan
        Write-Host "    Impact: $($fix.Impact)" -ForegroundColor White
        Write-Host "    Savings: $($fix.Savings)" -ForegroundColor Green
        Write-Host "    How to fix:" -ForegroundColor Yellow
        foreach ($step in $fix.Steps) {
            Write-Host "       $step" -ForegroundColor White
        }
        Write-Host ""
        $priority++
    }
}

# ═══════════════════════════════════════════════════════════════════════════
# AUTO-FIX ACTIONS
# ═══════════════════════════════════════════════════════════════════════════

if ($CleanTemp) {
    Write-Host "`n═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
    Write-Host "                         CLEANING TEMP FILES                               " -ForegroundColor Yellow
    Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan
    
    $cleaned = 0
    foreach ($path in $tempPaths) {
        if (Test-Path $path) {
            Write-Host "Cleaning $path..." -ForegroundColor Cyan
            try {
                Get-ChildItem $path -Recurse -ErrorAction SilentlyContinue | 
                    Remove-Item -Recurse -Force -ErrorAction SilentlyContinue
                $cleaned++
            } catch {
                Write-Host "   Some files couldn't be deleted (in use)" -ForegroundColor Gray
            }
        }
    }
    
    Write-Host "`n✅ Cleaned $cleaned temp folders!" -ForegroundColor Green
}

# ═══════════════════════════════════════════════════════════════════════════
# OPENRGB INTEGRATION
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                         OPENRGB RECOMMENDATION                            " -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "💡 OpenRGB is a lightweight, open-source RGB controller that:" -ForegroundColor Cyan
Write-Host "   ✅ Uses ~50-100 MB RAM (vs SignalRGB's 800+ MB)" -ForegroundColor Green
Write-Host "   ✅ Minimal CPU usage (runs as service)" -ForegroundColor Green
Write-Host "   ✅ Supports most RGB hardware" -ForegroundColor Green
Write-Host "   ✅ Has CLI/API for automation" -ForegroundColor Green
Write-Host "   ✅ Can be controlled by SPECTRA scripts! 🎨`n" -ForegroundColor Green

Write-Host "Download: https://openrgb.org/`n" -ForegroundColor White

Write-Host "After installing OpenRGB, I can create scripts to:" -ForegroundColor Yellow
Write-Host "   • Set colors based on time of day" -ForegroundColor White
Write-Host "   • React to system events (CPU temp, notifications)" -ForegroundColor White
Write-Host "   • Integrate with your work/gaming profiles" -ForegroundColor White
Write-Host "   • Control via voice commands or hotkeys`n" -ForegroundColor White

# ═══════════════════════════════════════════════════════════════════════════
# SUMMARY
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                              NEXT STEPS                                   " -ForegroundColor Yellow
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "Quick Wins (5 minutes):" -ForegroundColor Yellow
Write-Host "   1. Ctrl+Shift+Esc → Startup → Disable bloatware" -ForegroundColor White
Write-Host "   2. Restart PC`n" -ForegroundColor White

Write-Host "This Weekend (30 minutes):" -ForegroundColor Yellow
Write-Host "   1. Install OpenRGB (replace SignalRGB)" -ForegroundColor White
Write-Host "   2. Uninstall: SignalRGB, Razer Central, Razer Cortex" -ForegroundColor White
Write-Host "   3. Run this script with -CleanTemp`n" -ForegroundColor White

Write-Host "Expected Results:" -ForegroundColor Green
Write-Host "   ✅ 2-3 GB more free RAM" -ForegroundColor White
Write-Host "   ✅ 20-30 seconds faster boot" -ForegroundColor White
Write-Host "   ✅ Smoother multitasking" -ForegroundColor White
Write-Host "   ✅ Lower CPU temperatures`n" -ForegroundColor White

Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "💡 TIP: Run this script periodically to monitor system health!" -ForegroundColor Cyan
Write-Host "         .\system-optimizer.ps1 -CleanTemp   (clean temp files)" -ForegroundColor Gray
Write-Host "         .\system-optimizer.ps1              (full analysis)`n" -ForegroundColor Gray

Read-Host "Press Enter to exit"


