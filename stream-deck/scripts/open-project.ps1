# Open SPECTRA Project in Cursor
# Usage: .\open-project.ps1 -ProjectName "notifications"

param(
    [Parameter(Mandatory = $true)]
    [string]$ProjectName
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Colours for output
$SuccessColour = "Green"
$ErrorColour = "Red"
$InfoColour = "Cyan"

Write-Host "`n========================================" -ForegroundColor $InfoColour
Write-Host "Opening SPECTRA Project" -ForegroundColor $InfoColour
Write-Host "========================================`n" -ForegroundColor $InfoColour

# SPECTRA workspace root
$SpectraRoot = "C:\Users\markm\OneDrive\SPECTRA"

# Common project locations
$ProjectPaths = @{
    "notifications"   = "$SpectraRoot\Core\notifications"
    "assistant"       = "$SpectraRoot\Core\assistant"
    "graph"           = "$SpectraRoot\Core\graph"
    "portal"          = "$SpectraRoot\Core\portal"
    "cli"             = "$SpectraRoot\Core\cli"
    "framework"       = "$SpectraRoot\Core\framework"
    "solution-engine" = "$SpectraRoot\Core\solution-engine"
    "labs"            = "$SpectraRoot\Core\labs"
    "jira"            = "$SpectraRoot\Data\jira"
    "xero"            = "$SpectraRoot\Data\xero"
    "zephyr"          = "$SpectraRoot\Data\zephyr"
    "fabric-sdk"      = "$SpectraRoot\Data\fabric-sdk"
}

# Check if project exists in map
if (-not $ProjectPaths.ContainsKey($ProjectName)) {
    Write-Host "ERROR: Project '$ProjectName' not found in project map" -ForegroundColor $ErrorColour
    Write-Host "`nAvailable projects:" -ForegroundColor $InfoColour
    $ProjectPaths.Keys | ForEach-Object { Write-Host "  - $_" -ForegroundColor $InfoColour }
    exit 1
}

$ProjectPath = $ProjectPaths[$ProjectName]

# Check if path exists
if (-not (Test-Path $ProjectPath)) {
    Write-Host "ERROR: Project path not found: $ProjectPath" -ForegroundColor $ErrorColour
    exit 1
}

Write-Host "Opening project: $ProjectName" -ForegroundColor $InfoColour
Write-Host "Path: $ProjectPath`n" -ForegroundColor $InfoColour

# Cursor executable path
$CursorPath = "$env:LOCALAPPDATA\Programs\cursor\Cursor.exe"

if (-not (Test-Path $CursorPath)) {
    Write-Host "ERROR: Cursor not found at: $CursorPath" -ForegroundColor $ErrorColour
    Write-Host "Please install Cursor or update the path in this script" -ForegroundColor $ErrorColour
    exit 1
}

# Open project in Cursor
try {
    Start-Process -FilePath $CursorPath -ArgumentList $ProjectPath
    
    Write-Host "========================================" -ForegroundColor $SuccessColour
    Write-Host "Project opened successfully!" -ForegroundColor $SuccessColour
    Write-Host "========================================`n" -ForegroundColor $SuccessColour
}
catch {
    Write-Host "ERROR: Failed to open project" -ForegroundColor $ErrorColour
    Write-Host $_.Exception.Message -ForegroundColor $ErrorColour
    exit 1
}

# Keep window open for 3 seconds
Start-Sleep -Seconds 3





