<#
.SYNOPSIS
    Identity Wrapper for SPECTRA Scripts
    Ensures correct identity context before executing commands.

.DESCRIPTION
    This script:
    - Loads the appropriate identity context
    - Executes the wrapped command with correct credentials
    - Used by MCP servers and other automated processes

.PARAMETER Identity
    Override identity (defaults to SPECTRA_IDENTITY env var)

.EXAMPLE
    .\identity-wrapper.ps1 npx -y @modelcontextprotocol/server-github
#>

param(
    [string]$Identity,
    [Parameter(ValueFromRemainingArguments)]
    $RemainingArgs
)

# Load identity context
$SPECTRARoot = "$env:USERPROFILE\OneDrive\SPECTRA"
$IdentityScript = "$SPECTRARoot\Core\tooling\scripts\identity-context.ps1"

if ($Identity) {
    # Use provided identity
    $env:SPECTRA_IDENTITY = $Identity
}

$CurrentIdentity = $env:SPECTRA_IDENTITY ?? "mark"

# Load identity if script exists
if (Test-Path $IdentityScript) {
    & $IdentityScript -Identity $CurrentIdentity | Out-Null
}

# Execute the command
if ($RemainingArgs.Count -gt 0) {
    $command = $RemainingArgs[0]
    $args = $RemainingArgs | Select-Object -Skip 1
    & $command @args
}
else {
    # No command provided, just ensure identity is loaded
    Write-Host "Identity context loaded: $CurrentIdentity" -ForegroundColor Green
}
