# Quick wrapper script to turn all lights blue
# Usage: .\blue.ps1

$scriptPath = Join-Path $PSScriptRoot "all_lights_blue.py"

Write-Host "🔵 Turning all lights blue..." -ForegroundColor Cyan
python $scriptPath




