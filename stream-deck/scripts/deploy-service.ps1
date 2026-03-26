# Deploy SPECTRA Service via Stream Deck
# Usage: .\deploy-service.ps1 -ServiceName "notifications" -Environment "production"

param(
    [Parameter(Mandatory = $true)]
    [string]$ServiceName,
    
    [Parameter(Mandatory = $false)]
    [string]$Environment = "production"
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Colours for output
$SuccessColour = "Green"
$ErrorColour = "Red"
$InfoColour = "Cyan"

Write-Host "`n========================================" -ForegroundColor $InfoColour
Write-Host "SPECTRA Service Deployment" -ForegroundColor $InfoColour
Write-Host "========================================`n" -ForegroundColor $InfoColour

# Navigate to solution-engine directory
$SolutionEnginePath = "C:\Users\markm\OneDrive\SPECTRA\Core\solution-engine"

if (-not (Test-Path $SolutionEnginePath)) {
    Write-Host "ERROR: Solution engine directory not found at: $SolutionEnginePath" -ForegroundColor $ErrorColour
    exit 1
}

Set-Location $SolutionEnginePath

Write-Host "Deploying service: $ServiceName" -ForegroundColor $InfoColour
Write-Host "Environment: $Environment" -ForegroundColor $InfoColour
Write-Host "`nStarting deployment...`n" -ForegroundColor $InfoColour

# Build deployment command
$DeployCommand = "deploy $ServiceName to Railway $Environment"

# Run solution-engine
try {
    python -m solution_engine.cli run $DeployCommand
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "`n========================================" -ForegroundColor $SuccessColour
        Write-Host "Deployment completed successfully!" -ForegroundColor $SuccessColour
        Write-Host "========================================`n" -ForegroundColor $SuccessColour
    }
    else {
        Write-Host "`n========================================" -ForegroundColor $ErrorColour
        Write-Host "Deployment failed with exit code: $LASTEXITCODE" -ForegroundColor $ErrorColour
        Write-Host "========================================`n" -ForegroundColor $ErrorColour
        exit $LASTEXITCODE
    }
}
catch {
    Write-Host "`nERROR: Deployment failed" -ForegroundColor $ErrorColour
    Write-Host $_.Exception.Message -ForegroundColor $ErrorColour
    exit 1
}

# Keep window open for 5 seconds to see results
Start-Sleep -Seconds 5





