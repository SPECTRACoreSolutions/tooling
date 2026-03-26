# Disable Razer Synapse RGB Control
# This script helps you disable RGB in Synapse so OpenRGB can control it

Write-Host "╔════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   Disable Razer Synapse RGB - Keep Profiles, Control RGB      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""

Write-Host "📋 Manual Steps (Synapse GUI):" -ForegroundColor Yellow
Write-Host ""

Write-Host "1. Open Razer Synapse" -ForegroundColor White
Write-Host "   → Look for Razer Synapse icon in system tray or Start menu"
Write-Host ""

Write-Host "2. Go to Chroma Studio" -ForegroundColor White
Write-Host "   → Click 'CHROMA STUDIO' tab or icon"
Write-Host ""

Write-Host "3. Disable Chroma Effects:" -ForegroundColor White
Write-Host "   → Turn OFF 'Enable Chroma' toggle"
Write-Host "   → OR set all devices to 'Static' → Black (0, 0, 0)"
Write-Host ""

Write-Host "4. Check Device Settings:" -ForegroundColor White
Write-Host "   → Go to each device (Huntsman, Tartarus, etc.)"
Write-Host "   → Look for 'Lighting' or 'Chroma' settings"
Write-Host "   → Disable lighting control if available"
Write-Host ""

Write-Host "5. Test OpenRGB:" -ForegroundColor White
Write-Host "   → Run: python all_lights_blue.py"
Write-Host "   → Check if colours stick now"
Write-Host ""

Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host "💡 Alternative: Kill Synapse RGB Process (Temporary)" -ForegroundColor Yellow
Write-Host ""
Write-Host "   This stops RGB control but profiles still work:" -ForegroundColor White

$synapseProcesses = Get-Process | Where-Object {
    $_.ProcessName -like "*Razer*" -or 
    $_.ProcessName -like "*Chroma*"
}

if ($synapseProcesses) {
    Write-Host ""
    Write-Host "   Found Razer/Chroma processes:" -ForegroundColor Yellow
    $synapseProcesses | ForEach-Object {
        Write-Host "   - $($_.ProcessName) (PID: $($_.Id), RAM: $([math]::Round($_.WorkingSet / 1MB, 0)) MB)" -ForegroundColor Gray
    }
    Write-Host ""
    Write-Host "   ⚠️  Killing these may affect profiles!" -ForegroundColor Red
    Write-Host "   Better to disable RGB in Synapse GUI instead." -ForegroundColor Yellow
} else {
    Write-Host "   No Razer processes found running." -ForegroundColor Green
}

Write-Host ""
Write-Host "═══════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

Write-Host "🎯 Recommended Approach:" -ForegroundColor Green
Write-Host ""
Write-Host "   1. Keep Synapse running (for Tartarus profiles)" -ForegroundColor White
Write-Host "   2. Disable RGB in Synapse settings (manual steps above)" -ForegroundColor White
Write-Host "   3. Use OpenRGB for all RGB control" -ForegroundColor White
Write-Host ""
Write-Host "   Result: Profiles work + OpenRGB controls colours ✅" -ForegroundColor Green
Write-Host ""

Write-Host "📚 See RAZER-SYNAPSE-WORKAROUND.md for full guide" -ForegroundColor Cyan
Write-Host ""




