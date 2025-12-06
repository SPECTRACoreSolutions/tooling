# ═══════════════════════════════════════════════════════════════════════════
# SPECTRA PC Toolkit - Windows Activation Checker & Fixer
# ═══════════════════════════════════════════════════════════════════════════

Write-Host "`n╔════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║         SPECTRA WINDOWS ACTIVATION CHECKER                             ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Check if running as Administrator
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (-not $isAdmin) {
    Write-Host "⚠️  This script needs to run as Administrator for activation!" -ForegroundColor Yellow
    Write-Host "Right-click and select 'Run as Administrator'`n" -ForegroundColor Yellow
}

# Get activation status
Write-Host "🔍 Checking Windows activation status...`n" -ForegroundColor Yellow

$activation = Get-CimInstance SoftwareLicensingProduct | Where-Object {$_.PartialProductKey -and $_.Name -like "Windows*"}

Write-Host "Windows Edition: " -NoNewline
$activation.Name
Write-Host "License Status: " -NoNewline
switch ($activation.LicenseStatus) {
    0 { Write-Host "Unlicensed ❌" -ForegroundColor Red }
    1 { Write-Host "Licensed ✅" -ForegroundColor Green }
    2 { Write-Host "Out-of-Box Grace Period" -ForegroundColor Yellow }
    3 { Write-Host "Out-of-Tolerance Grace Period" -ForegroundColor Yellow }
    4 { Write-Host "Non-Genuine Grace Period" -ForegroundColor Red }
    5 { Write-Host "Notification" -ForegroundColor Yellow }
    6 { Write-Host "Extended Grace" -ForegroundColor Yellow }
    default { Write-Host "Unknown" -ForegroundColor Red }
}

Write-Host "Partial Product Key: " -NoNewline
Write-Host $activation.PartialProductKey -ForegroundColor Cyan

Write-Host "`n═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

# If not activated, offer to fix
if ($activation.LicenseStatus -ne 1) {
    Write-Host "⚠️  Windows is NOT activated!" -ForegroundColor Red
    Write-Host "`nTroubleshooting steps:`n" -ForegroundColor Yellow
    Write-Host "1. Make sure you're signed in with your Microsoft account"
    Write-Host "   Settings → Accounts → Your info → Sign in with Microsoft account"
    Write-Host "`n2. After signing in, try activating:" -ForegroundColor Yellow
    
    if ($isAdmin) {
        $activate = Read-Host "`nTry activating now? (Y/N)"
        if ($activate -eq "Y" -or $activate -eq "y") {
            Write-Host "`nAttempting activation..." -ForegroundColor Yellow
            Start-Process "slmgr.vbs" -ArgumentList "/ato" -Wait
            Write-Host "Check the popup dialog for results!" -ForegroundColor Green
        }
    } else {
        Write-Host "`n⚠️  Run this script as Administrator to attempt activation!" -ForegroundColor Yellow
    }
    
    Write-Host "`n3. If still not activated:" -ForegroundColor Yellow
    Write-Host "   Settings → System → Activation → Troubleshoot"
    Write-Host "   This will detect hardware changes and reactivate"
    
} else {
    Write-Host "✅ Windows is properly activated! You're good to go!" -ForegroundColor Green
}

Write-Host "`n═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Read-Host "Press Enter to exit"

