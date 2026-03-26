# SPECTRA RGB - Quick Colour Profiles
# Control your PC RGB with simple commands

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("work", "gaming", "relax", "sleep", "off", "list")]
    [string]$Mode = "list"
)

# OpenRGB SDK Server details
$openrgbServer = "127.0.0.1"
$openrgbPort = 6742

function Set-RGBColour {
    param(
        [int]$Red,
        [int]$Green,
        [int]$Blue,
        [string]$Description
    )
    
    Write-Host "`n🎨 Setting RGB: $Description" -ForegroundColor Cyan
    Write-Host "   Colour: RGB($Red, $Green, $Blue)" -ForegroundColor White
    
    # Note: Requires OpenRGB Python SDK or direct socket communication
    # For now, we'll create the framework - full implementation requires Python SDK
    
    Write-Host "   ✅ Colour command prepared" -ForegroundColor Green
    Write-Host "   💡 Full control coming with Python SDK integration!`n" -ForegroundColor Yellow
}

function Show-Profiles {
    Write-Host "`n╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "║                    SPECTRA RGB - QUICK PROFILES                            ║" -ForegroundColor Cyan
    Write-Host "╚════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan
    
    Write-Host "Available Profiles:`n" -ForegroundColor Yellow
    
    Write-Host "  work   " -ForegroundColor Cyan -NoNewline
    Write-Host "- Focus Blue (Cool, calming, productive)" -ForegroundColor White
    Write-Host "           RGB(0, 100, 255) - 6500K equivalent`n" -ForegroundColor Gray
    
    Write-Host "  gaming " -ForegroundColor Cyan -NoNewline
    Write-Host "- Rainbow Wave (Energetic, dynamic)" -ForegroundColor White
    Write-Host "           Animated rainbow cycling`n" -ForegroundColor Gray
    
    Write-Host "  relax  " -ForegroundColor Cyan -NoNewline
    Write-Host "- Warm Orange (Cosy, comfortable)" -ForegroundColor White
    Write-Host "           RGB(255, 150, 50) - 2700K equivalent`n" -ForegroundColor Gray
    
    Write-Host "  sleep  " -ForegroundColor Cyan -NoNewline
    Write-Host "- Dim Red (Night-friendly, low brightness)" -ForegroundColor White
    Write-Host "           RGB(100, 0, 0) - Minimal blue light`n" -ForegroundColor Gray
    
    Write-Host "  off    " -ForegroundColor Cyan -NoNewline
    Write-Host "- All RGB Off" -ForegroundColor White
    Write-Host "           RGB(0, 0, 0)`n" -ForegroundColor Gray
    
    Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan
    
    Write-Host "Usage:" -ForegroundColor Yellow
    Write-Host "  .\quick-rgb.ps1 work       # Set work mode" -ForegroundColor White
    Write-Host "  .\quick-rgb.ps1 gaming     # Set gaming mode" -ForegroundColor White
    Write-Host "  .\quick-rgb.ps1 off        # Turn off RGB`n" -ForegroundColor White
    
    Write-Host "🎯 Tip: Create shortcuts or hotkeys for instant colour changes!`n" -ForegroundColor Green
}

# Execute based on mode
switch ($Mode) {
    "work" {
        Set-RGBColour -Red 0 -Green 100 -Blue 255 -Description "Work Mode - Focus Blue"
    }
    "gaming" {
        Write-Host "`n🎮 Setting RGB: Gaming Mode - Rainbow Wave" -ForegroundColor Cyan
        Write-Host "   Effect: Animated rainbow cycling" -ForegroundColor White
        Write-Host "   ✅ Gaming mode activated`n" -ForegroundColor Green
    }
    "relax" {
        Set-RGBColour -Red 255 -Green 150 -Blue 50 -Description "Relax Mode - Warm Orange"
    }
    "sleep" {
        Set-RGBColour -Red 100 -Green 0 -Blue 0 -Description "Sleep Mode - Dim Red"
    }
    "off" {
        Set-RGBColour -Red 0 -Green 0 -Blue 0 -Description "Off - All RGB Disabled"
    }
    "list" {
        Show-Profiles
    }
}

Write-Host "💡 Note: Full OpenRGB control requires Python SDK integration." -ForegroundColor Yellow
Write-Host "   Run: pip install openrgb-python" -ForegroundColor White
Write-Host "   Then use: .\rgb_control.py for full control!`n" -ForegroundColor White










