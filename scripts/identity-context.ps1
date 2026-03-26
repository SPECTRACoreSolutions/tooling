<#
.SYNOPSIS
    SPECTRA Identity Context Manager
    Switches between Mark and Alana identities for SPECTRA development.

.DESCRIPTION
    This script manages identity context for SPECTRA by:
    - Setting SPECTRA_IDENTITY environment variable
    - Loading appropriate credentials for active identity
    - Supporting Mark (personal) and Alana (AI) personas

.PARAMETER Identity
    The identity to switch to: "mark" or "alana"

.PARAMETER Clear
    Clear all identity context and return to default (mark)

.EXAMPLE
    .\identity-context.ps1 -Identity alana

.EXAMPLE
    .\identity-context.ps1 -Clear
#>

param(
    [Parameter(Mandatory = $false)]
    [ValidateSet("mark", "alana")]
    [string]$Identity,

    [switch]$Clear,
    [switch]$Show
)

# Colors
$ColorInfo = "Cyan"
$ColorSuccess = "Green"
$ColorWarning = "Yellow"
$ColorError = "Red"

function Write-ColorOutput {
    param([string]$Message, [string]$Color = "White")
    Write-Host $Message -ForegroundColor $Color
}

function Get-IdentityCredential {
    param(
        [string]$VarName,
        [string]$Identity
    )

    # Try identity-specific variable first
    $identityVar = "${Identity}_$VarName"
    $value = [System.Environment]::GetEnvironmentVariable($identityVar, "User")

    if ($value) {
        return @{ Value = $value; Source = "OS User Variable ($identityVar)" }
    }

    # Fallback to process variable
    if (Get-Variable "env:$identityVar" -ErrorAction SilentlyContinue) {
        $value = Get-Variable "env:$identityVar" -ValueOnly
        if ($value) {
            return @{ Value = $value; Source = "Process Variable ($identityVar)" }
        }
    }

    # Check .env file
    $EnvFile = "$env:USERPROFILE\OneDrive\SPECTRA\.env"
    if (Test-Path $EnvFile) {
        $envContent = Get-Content $EnvFile
        $match = $envContent | Where-Object { $_ -match "^$identityVar=(.+)" }
        if ($match) {
            return @{ Value = $matches[1]; Source = ".env file ($identityVar)" }
        }
    }

    return $null
}

function Set-IdentityEnvironment {
    param(
        [string]$Identity
    )

    # Set the identity marker
    $env:SPECTRA_IDENTITY = $Identity

    # Define required credential variables
    $CredentialVars = @(
        "GITHUB_TOKEN",
        "AZURE_CLIENT_ID",
        "AZURE_CLIENT_SECRET",
        "AZURE_TENANT_ID",
        "MS365_CLIENT_ID",
        "MS365_CLIENT_SECRET",
        "MS365_TENANT_ID",
        "RAILWAY_TOKEN",
        "ATLASSIAN_TOKEN",
        "CLOUDFLARE_API_TOKEN"
    )

    $Loaded = @()
    $Missing = @()

    foreach ($var in $CredentialVars) {
        $cred = Get-IdentityCredential -VarName $var -Identity $Identity

        if ($cred) {
            Set-Item "env:$var" $cred.Value
            $Loaded += @{ Name = $var; Source = $cred.Source }
        }
        else {
            $Missing += $var
            # Clear the variable if it exists
            if (Get-Variable "env:$var" -ErrorAction SilentlyContinue) {
                Remove-Item "env:$var" -ErrorAction SilentlyContinue
            }
        }
    }

    return @{ Loaded = $Loaded; Missing = $Missing }
}

# Main execution
if ($Show) {
    # Show current identity
    $CurrentIdentity = $env:SPECTRA_IDENTITY ?? "mark"
    Write-ColorOutput "Current identity: $CurrentIdentity" $ColorInfo

    # Show which credentials are loaded
    Write-Host "`nLoaded credentials:" -ForegroundColor $ColorInfo
    $CredentialVars = @(
        "GITHUB_TOKEN",
        "AZURE_CLIENT_ID",
        "AZURE_CLIENT_SECRET",
        "AZURE_TENANT_ID",
        "MS365_CLIENT_ID",
        "MS365_CLIENT_SECRET",
        "MS365_TENANT_ID",
        "RAILWAY_TOKEN",
        "ATLASSIAN_TOKEN",
        "CLOUDFLARE_API_TOKEN"
    )

    foreach ($var in $CredentialVars) {
        $value = Get-Variable "env:$var" -ValueOnly -ErrorAction SilentlyContinue
        if ($value) {
            Write-Host "  ✅ $var" -ForegroundColor $ColorSuccess
        }
        else {
            Write-Host "  ❌ $var" -ForegroundColor $ColorError
        }
    }

    return
}

if ($Clear) {
    # Clear all ALANA_ variables and reset to mark
    Write-ColorOutput "`nClearing identity context..." $ColorInfo

    # Clear identity-specific variables
    Get-ChildItem env: | Where-Object Name -like "ALANA_*" | ForEach-Object {
        Remove-Item "env:$($_.Name)" -ErrorAction SilentlyContinue
    }

    # Reset to default identity
    $result = Set-IdentityEnvironment -Identity "mark"

    Write-ColorOutput "✅ Identity cleared, switched to: mark" $ColorSuccess

    if ($result.Missing.Count -gt 0) {
        Write-ColorOutput "`n⚠️  Missing credentials for mark:" $ColorWarning
        $result.Missing | ForEach-Object { Write-Host "   - $_" $ColorWarning }
    }

    return
}

if (-not $Identity) {
    Write-ColorOutput "Error: Identity parameter is required. Use -Identity mark or -Identity alana" $ColorError
    Write-ColorOutput "Or use -Show to see current identity, -Clear to reset" $ColorInfo
    exit 1
}

# Switch to specified identity
Write-ColorOutput "`nSwitching to identity: $Identity" $ColorInfo

$result = Set-IdentityEnvironment -Identity $Identity

Write-ColorOutput "`nCredentials loaded:" $ColorSuccess
$result.Loaded | ForEach-Object {
    Write-Host "  ✅ $($_.Name)" $ColorSuccess
    Write-Host "     Source: $($_.Source)" $ColorInfo
}

if ($result.Missing.Count -gt 0) {
    Write-ColorOutput "`n⚠️  Missing credentials for $Identity:" $ColorWarning
    $result.Missing | ForEach-Object { Write-Host "   - $_" $ColorWarning }
    Write-ColorOutput "`nTo set missing credentials:" $ColorInfo
    Write-Host "  1. Use System Properties → Environment Variables → User variables" $ColorInfo
    Write-Host "  2. Or edit: $env:USERPROFILE\OneDrive\SPECTRA\.env" $ColorInfo
    Write-Host "  3. Use format: $Identity`_$($result.Missing[0])=your_token_here" $ColorInfo
}

Write-ColorOutput "`n✅ Identity switched successfully!" $ColorSuccess
Write-ColorOutput "Current identity: $env:SPECTRA_IDENTITY" $ColorInfo

# Show git config if applicable
if ($Identity -eq "alana") {
    Write-ColorOutput "`nNote: When committing as Alana, consider using:" $ColorWarning
    Write-Host "  git config user.name 'Alana AI'" $ColorWarning
    Write-Host "  git config user.email 'alana@spectra.ai'" $ColorWarning
}
