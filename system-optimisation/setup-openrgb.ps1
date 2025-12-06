# OpenRGB Setup Script
# Extracts OpenRGB and creates admin shortcut

Write-Host "`n╔════════════════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                    OPENRGB SETUP SCRIPT                                      ║" -ForegroundColor Cyan
Write-Host "╚════════════════════════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Find ZIP file
Write-Host "🔍 Searching for OpenRGB ZIP in Downloads...`n" -ForegroundColor Yellow
$zipFile = Get-ChildItem "$env:USERPROFILE\Downloads" -Filter "*OpenRGB*.zip" -ErrorAction SilentlyContinue | 
Sort-Object LastWriteTime -Descending | 
Select-Object -First 1

if (-not $zipFile) {
    Write-Host "❌ OpenRGB ZIP not found in Downloads folder!`n" -ForegroundColor Red
    Write-Host "Please download OpenRGB from: https://openrgb.org/releases.html`n" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Found: $($zipFile.Name) ($([math]::Round($zipFile.Length/1MB,2)) MB)`n" -ForegroundColor Green

# Create OpenRGB directory
$openrgbDir = "C:\Program Files\OpenRGB"
Write-Host "📁 Creating directory: $openrgbDir" -ForegroundColor Cyan
New-Item -ItemType Directory -Path $openrgbDir -Force | Out-Null

# Extract ZIP
Write-Host "📦 Extracting OpenRGB (this may take a moment)...`n" -ForegroundColor Cyan
try {
    Expand-Archive -Path $zipFile.FullName -DestinationPath $openrgbDir -Force
    Write-Host "✅ Extraction complete!`n" -ForegroundColor Green
}
catch {
    Write-Host "❌ Extraction failed: $_`n" -ForegroundColor Red
    exit 1
}

# Find OpenRGB.exe
$exePath = Get-ChildItem $openrgbDir -Recurse -Filter "OpenRGB.exe" -ErrorAction SilentlyContinue | 
Select-Object -First 1

if (-not $exePath) {
    Write-Host "⚠️  OpenRGB.exe not found. Listing extracted files:`n" -ForegroundColor Yellow
    Get-ChildItem $openrgbDir -Recurse | Select-Object FullName
    exit 1
}

Write-Host "✅ OpenRGB.exe found: $($exePath.FullName)`n" -ForegroundColor Green

# Create desktop shortcut (run as admin)
Write-Host "🔗 Creating desktop shortcut (Run as Administrator)...`n" -ForegroundColor Cyan

$WshShell = New-Object -ComObject WScript.Shell
$shortcut = $WshShell.CreateShortcut("$env:USERPROFILE\Desktop\OpenRGB.lnk")
$shortcut.TargetPath = $exePath.FullName
$shortcut.WorkingDirectory = $exePath.DirectoryName
$shortcut.Description = "OpenRGB - Run as Administrator"
$shortcut.Save()

# Set shortcut to run as admin
$bytes = [System.IO.File]::ReadAllBytes("$env:USERPROFILE\Desktop\OpenRGB.lnk")
$bytes[0x15] = $bytes[0x15] -bor 0x20  # Set run as admin flag
[System.IO.File]::WriteAllBytes("$env:USERPROFILE\Desktop\OpenRGB.lnk", $bytes)

Write-Host "✅ Desktop shortcut created: OpenRGB.lnk`n" -ForegroundColor Green

Write-Host "═══════════════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "                         SETUP COMPLETE!                                    " -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════════════════════════════`n" -ForegroundColor Cyan

Write-Host "📍 OpenRGB Location: $($exePath.FullName)" -ForegroundColor Cyan
Write-Host "🔗 Desktop Shortcut: OpenRGB.lnk (Run as Administrator)`n" -ForegroundColor Cyan

Write-Host "📋 NEXT STEPS:`n" -ForegroundColor Yellow
Write-Host "1. Install PawnIO driver from: https://pawnio.eu" -ForegroundColor White
Write-Host "2. Double-click 'OpenRGB' shortcut on Desktop" -ForegroundColor White
Write-Host "3. OpenRGB will detect your RGB devices" -ForegroundColor White
Write-Host "4. Go to 'SDK Server' tab → Start Server → Auto-start server`n" -ForegroundColor White

Write-Host "Then tell me 'openrgb ready' and I'll create automation scripts! 🎨`n" -ForegroundColor Green




