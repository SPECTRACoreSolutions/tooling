# SPECTRA RGB Control Center Launcher

Write-Host "`n╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║              🎨 LAUNCHING SPECTRA RGB CONTROL CENTER 🎨                   ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Check if OpenRGB is running
$openrgb = Get-Process -Name "*OpenRGB*" -ErrorAction SilentlyContinue

if (-not $openrgb) {
    Write-Host "⚠️  OpenRGB is not running!`n" -ForegroundColor Yellow
    Write-Host "Starting OpenRGB...`n" -ForegroundColor Cyan
    
    # Try to find and start OpenRGB
    $openrgbPaths = @(
        "C:\Program Files\OpenRGB\OpenRGB.exe",
        "C:\Program Files (x86)\OpenRGB\OpenRGB.exe"
    )
    
    $started = $false
    foreach ($path in $openrgbPaths) {
        if (Test-Path $path) {
            Start-Process $path
            Write-Host "✅ OpenRGB started! Waiting 3 seconds for SDK Server...`n" -ForegroundColor Green
            Start-Sleep -Seconds 3
            $started = $true
            break
        }
    }
    
    if (-not $started) {
        Write-Host "❌ OpenRGB not found. Please start it manually.`n" -ForegroundColor Red
        exit 1
    }
}

Write-Host "✅ OpenRGB is running!`n" -ForegroundColor Green
Write-Host "🚀 Launching control center...`n" -ForegroundColor Cyan

# Launch control center
python control-center.py




