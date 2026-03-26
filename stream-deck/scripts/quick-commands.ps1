# Quick SPECTRA Commands
# Usage: .\quick-commands.ps1 -Command "status"

param(
    [Parameter(Mandatory = $true)]
    [ValidateSet("status", "sync", "test", "lint", "docs")]
    [string]$Command
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Colours for output
$SuccessColour = "Green"
$ErrorColour = "Red"
$InfoColour = "Cyan"

Write-Host "`n========================================" -ForegroundColor $InfoColour
Write-Host "SPECTRA Quick Command" -ForegroundColor $InfoColour
Write-Host "========================================`n" -ForegroundColor $InfoColour

# SPECTRA workspace root
$SpectraRoot = "C:\Users\markm\OneDrive\SPECTRA"

Set-Location $SpectraRoot

switch ($Command) {
    "status" {
        Write-Host "Checking SPECTRA status...`n" -ForegroundColor $InfoColour
        
        # Check Git status
        Write-Host "Git Status:" -ForegroundColor $InfoColour
        git status --short
        
        # Check service status (if Railway CLI available)
        if (Get-Command railway -ErrorAction SilentlyContinue) {
            Write-Host "`nRailway Services:" -ForegroundColor $InfoColour
            railway status
        }
    }
    
    "sync" {
        Write-Host "Syncing cosmic index...`n" -ForegroundColor $InfoColour
        
        $CosmicIndexScript = "$SpectraRoot\Core\memory\scripts\build_cosmic_index.py"
        
        if (Test-Path $CosmicIndexScript) {
            Set-Location "$SpectraRoot\Core\memory"
            python scripts\build_cosmic_index.py
            
            Write-Host "`n========================================" -ForegroundColor $SuccessColour
            Write-Host "Cosmic index synced!" -ForegroundColor $SuccessColour
            Write-Host "========================================`n" -ForegroundColor $SuccessColour
        }
        else {
            Write-Host "ERROR: Cosmic index script not found" -ForegroundColor $ErrorColour
            exit 1
        }
    }
    
    "test" {
        Write-Host "Running tests...`n" -ForegroundColor $InfoColour
        
        # Run pytest in current directory or common test locations
        $TestPaths = @(
            "tests",
            "Core\tests",
            "Data\framework\tests"
        )
        
        $TestFound = $false
        foreach ($TestPath in $TestPaths) {
            $FullPath = Join-Path $SpectraRoot $TestPath
            if (Test-Path $FullPath) {
                Set-Location $FullPath
                pytest
                $TestFound = $true
                break
            }
        }
        
        if (-not $TestFound) {
            Write-Host "No test directories found" -ForegroundColor $ErrorColour
            exit 1
        }
    }
    
    "lint" {
        Write-Host "Running linter...`n" -ForegroundColor $InfoColour
        
        $LintScript = "$SpectraRoot\Core\tooling\scripts\spectra-lint.ps1"
        
        if (Test-Path $LintScript) {
            & $LintScript
        }
        else {
            Write-Host "Lint script not found, running ruff directly..." -ForegroundColor $InfoColour
            ruff check .
        }
    }
    
    "docs" {
        Write-Host "Opening SPECTRA documentation...`n" -ForegroundColor $InfoColour
        
        $DocsPath = "$SpectraRoot\Core\docs"
        
        if (Test-Path $DocsPath) {
            Start-Process explorer.exe -ArgumentList $DocsPath
            Write-Host "Documentation folder opened!" -ForegroundColor $SuccessColour
        }
        else {
            Write-Host "Documentation folder not found" -ForegroundColor $ErrorColour
            exit 1
        }
    }
}

# Keep window open for 5 seconds
Start-Sleep -Seconds 5





