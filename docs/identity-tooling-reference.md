# SPECTRA Identity Tooling Quick Reference

**Purpose:** Quick command reference for SPECTRA's identity infrastructure management

---

## Authentication Status Checks

### Azure CLI
```powershell
# Check login status
az account show

# Login with service principal (using .env)
$env:AZURE_CLIENT_ID = (Get-Content .env | Select-String "SPECTRA_FABRIC_CLIENT_ID=" | % { $_.Line.Split('=')[1] })
$env:AZURE_CLIENT_SECRET = (Get-Content .env | Select-String "SPECTRA_FABRIC_CLIENT_SECRET=" | % { $_.Line.Split('=')[1] })
$env:AZURE_TENANT_ID = (Get-Content .env | Select-String "SPECTRA_AZURE_TENANT_ID=" | % { $_.Line.Split('=')[1] })
az login --service-principal -u $env:AZURE_CLIENT_ID -p $env:AZURE_CLIENT_SECRET --tenant $env:AZURE_TENANT_ID

# List subscriptions
az account list --output table
```

### Microsoft Graph CLI
```powershell
# Check version
mgc --version

# Login (device code)
mgc login --strategy DeviceCode

# Login with environment variables
mgc login --strategy Environment --tenant-id $env:AZURE_TENANT_ID

# Test connection
mgc users list --top 5
```

### M365 CLI
```powershell
# Check status
m365 status

# Login with client credentials (current setup)
# Already authenticated as: spectra-graph-app-admin-prod

# Logout
m365 logout

# Login with device code
m365 login
```

### GitHub CLI
```powershell
# Check status
gh auth status

# Login
gh auth login

# Test
gh repo list
```

---

## Common Identity Management Tasks

### User Management

#### List Users
```powershell
# M365 CLI
m365 entra user list --output json | ConvertFrom-Json | Select displayName, userPrincipalName | Format-Table

# Graph CLI
mgc users list --select displayName,userPrincipalName

# Azure CLI (requires correct permissions)
az ad user list --query "[].{name:displayName, upn:userPrincipalName}" --output table
```

#### Get User Details
```powershell
# M365 CLI
m365 entra user get --userName mark@spectradatasolutions.com

# PowerShell Graph SDK
Connect-MgGraph -Scopes "User.Read.All"
Get-MgUser -UserId mark@spectradatasolutions.com
```

#### Create User
```powershell
# M365 CLI
m365 entra user add --displayName "New User" --userName newuser@spectradatasolutions.com --password "Temp@Pass123!" --forceChangePasswordNextSignIn

# PowerShell Graph SDK
New-MgUser -DisplayName "New User" -UserPrincipalName "newuser@spectradatasolutions.com" -AccountEnabled -PasswordProfile @{ Password = "Temp@Pass123!"; ForceChangePasswordNextSignIn = $true } -MailNickname "newuser"
```

### App Registration Management

#### List Apps
```powershell
# M365 CLI
m365 entra app list --output json | ConvertFrom-Json | Select displayName, appId | Format-Table

# PowerShell Graph SDK
Get-MgApplication | Select DisplayName, AppId
```

#### Get App Details
```powershell
# M365 CLI
m365 entra app get --appId 0d7652ce-6a03-489b-9097-3bbbe8f2486d

# PowerShell Graph SDK
Get-MgApplication -Filter "appId eq '0d7652ce-6a03-489b-9097-3bbbe8f2486d'"
```

#### List App Permissions
```powershell
# M365 CLI
m365 entra app permission list --appId 0d7652ce-6a03-489b-9097-3bbbe8f2486d
```

### Authentication Methods

#### List Enabled Methods
```powershell
# M365 CLI
m365 entra policy list --type authenticationMethods --output json | ConvertFrom-Json | Select -ExpandProperty authenticationMethodConfigurations

# PowerShell Graph SDK
Get-MgPolicyAuthenticationMethodPolicy
```

#### Enable FIDO2
```powershell
# PowerShell Graph SDK
$params = @{
    "@odata.type" = "#microsoft.graph.fido2AuthenticationMethodConfiguration"
    State = "enabled"
    IsSelfServiceRegistrationAllowed = $true
}
Update-MgPolicyAuthenticationMethodMethodConfiguration -AuthenticationMethodConfigurationId "Fido2" -BodyParameter $params
```

### Conditional Access

#### List Policies
```powershell
# PowerShell Graph SDK
Connect-MgGraph -Scopes "Policy.Read.All"
Get-MgIdentityConditionalAccessPolicy | Select DisplayName, State

# M365 CLI
m365 entra policy list --type conditionalAccess
```

#### Create MFA Policy (Example)
```powershell
# PowerShell Graph SDK
$conditions = @{
    Users = @{
        IncludeUsers = @("All")
        ExcludeUsers = @() # Add break-glass account
    }
    Applications = @{
        IncludeApplications = @("All")
    }
}

$grantControls = @{
    Operator = "OR"
    BuiltInControls = @("mfa")
}

$params = @{
    DisplayName = "Require MFA for All Users"
    State = "enabledForReportingButNotEnforced"
    Conditions = $conditions
    GrantControls = $grantControls
}

New-MgIdentityConditionalAccessPolicy -BodyParameter $params
```

### Group Management

#### List Groups
```powershell
# M365 CLI
m365 entra m365group list

# PowerShell Graph SDK
Get-MgGroup | Select DisplayName, Mail
```

#### Create Security Group
```powershell
# PowerShell Graph SDK
New-MgGroup -DisplayName "Identity Admins" -MailEnabled:$false -MailNickname "identity-admins" -SecurityEnabled
```

---

## UniFi Integration Commands

### Check UniFi Connection
```powershell
# Load .env
$env:SPECTRA_UNIFI_TOKEN = (Get-Content .env | Select-String "SPECTRA_UNIFI_TOKEN=" | % { $_.Line.Split('=')[1] })
$env:SPECTRA_UNIFI_PORTAL_URL = (Get-Content .env | Select-String "SPECTRA_UNIFI_PORTAL_URL=" | % { $_.Line.Split('=')[1] })

# Test API connection (Python)
python -c "import os; from aiounifi import Controller; print('UniFi credentials loaded')"
```

### Python UniFi Example
```python
import os
import asyncio
from aiounifi import Controller

async def test_unifi():
    controller = Controller(
        host=os.getenv("SPECTRA_UNIFI_PORTAL_URL"),
        username="admin",  # Or use token auth
        password=os.getenv("SPECTRA_UNIFI_TOKEN"),
        site="default",
        ssl_context=None  # Adjust for your setup
    )
    
    await controller.login()
    print(f"Connected to UniFi: {controller.site}")
    
    # List devices
    await controller.initialize()
    for device in controller.devices.values():
        print(f"Device: {device.name} - {device.mac}")
    
    await controller.logout()

asyncio.run(test_unifi())
```

---

## Branding Configuration

### Get Current Branding
```powershell
# PowerShell Graph SDK
Connect-MgGraph -Scopes "organisation.Read.All"
Get-MgOrganizationBranding
```

### Set Company Branding
```powershell
# PowerShell Graph SDK
Connect-MgGraph -Scopes "organisation.ReadWrite.All"

$params = @{
    BackgroundColor = "#0078D4"  # SPECTRA blue
    SignInPageText = "Welcome to SPECTRA Data Solutions"
    UsernameHintText = "user@spectradatasolutions.com"
}

Update-MgOrganizationBranding -OrganizationId "spectradatasolutions.com" -BodyParameter $params
```

### Upload Logo
```powershell
# PowerShell Graph SDK
$logoPath = "C:\Users\markm\OneDrive\SPECTRA\Data\branding\assets\logo.png"
$logoBytes = [System.IO.File]::ReadAllBytes($logoPath)

Set-MgOrganizationBrandingLogo -OrganizationId "spectradatasolutions.com" -InFile $logoPath
```

---

## GitHub OAuth Setup

### Create GitHub OAuth App
```bash
# Via GitHub CLI
gh api /user/apps -X POST -f name="SPECTRA SSO" \
  -f redirect_uri="https://login.spectradatasolutions.com/oauth/callback" \
  -f homepage_url="https://spectradatasolutions.com"

# Note the client_id and client_secret
```

### Register in Entra
```powershell
# PowerShell Graph SDK
$params = @{
    DisplayName = "GitHub Identity Provider"
    ClientId = "<github-oauth-app-client-id>"
    ClientSecret = "<github-oauth-app-client-secret>"
    "@odata.type" = "#microsoft.graph.socialIdentityProvider"
    IdentityProviderType = "GitHub"
}

New-MgIdentityProvider -BodyParameter $params
```

---

## Audit & Reporting

### Sign-in Logs (Last 24 hours)
```powershell
# PowerShell Graph SDK
Connect-MgGraph -Scopes "AuditLog.Read.All"
$startDate = (Get-Date).AddDays(-1).ToString("yyyy-MM-ddTHH:mm:ssZ")
Get-MgAuditLogSignIn -Filter "createdDateTime ge $startDate" | Select UserPrincipalName, CreatedDateTime, Status
```

### Audit Logs
```powershell
# PowerShell Graph SDK
Get-MgAuditLogDirectoryAudit -Top 50 | Select ActivityDisplayName, ActivityDateTime, InitiatedBy
```

### Risky Users
```powershell
# PowerShell Graph SDK
Connect-MgGraph -Scopes "IdentityRiskyUser.Read.All"
Get-MgRiskyUser | Select UserPrincipalName, RiskLevel, RiskState
```

### MFA Registration Status
```powershell
# M365 CLI
m365 entra user list --output json | ConvertFrom-Json | % {
    $user = $_
    # Note: Full MFA status requires separate API call per user
    Write-Output "$($user.displayName) - $($user.userPrincipalName)"
}
```

---

## Terraform Examples

### Provider Configuration
```hcl
# main.tf
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.45.0"
    }
  }
}

provider "azuread" {
  tenant_id     = var.tenant_id
  client_id     = var.client_id
  client_secret = var.client_secret
}
```

### Create App Registration
```hcl
# app-registration.tf
resource "azuread_application" "spectra_identity_webhook" {
  display_name = "spectra-identity-webhook-receiver"
  
  api {
    requested_access_token_version = 2
  }
  
  required_resource_access {
    resource_app_id = "00000003-0000-0000-c000-000000000000" # Microsoft Graph
    
    resource_access {
      id   = "df021288-bdef-4463-88db-98f22de89214" # User.Read.All
      type = "Role"
    }
  }
}

resource "azuread_service_principal" "spectra_identity_webhook" {
  application_id = azuread_application.spectra_identity_webhook.application_id
}
```

### Conditional Access Policy
```hcl
# conditional-access.tf
resource "azuread_conditional_access_policy" "require_mfa" {
  display_name = "Require MFA for all users"
  state        = "enabledForReportingButNotEnforced"
  
  conditions {
    users {
      included_users = ["All"]
      excluded_users = [azuread_user.break_glass.object_id]
    }
    
    applications {
      included_applications = ["All"]
    }
  }
  
  grant_controls {
    operator          = "OR"
    built_in_controls = ["mfa"]
  }
}
```

---

## Troubleshooting

### Check Permissions
```powershell
# List current user's roles
Connect-MgGraph
Get-MgContext | Select-Object -ExpandProperty Scopes

# Check app permissions
m365 entra app permission list --appId 0d7652ce-6a03-489b-9097-3bbbe8f2486d
```

### Token Issues
```powershell
# Clear token cache (M365 CLI)
m365 logout
Remove-Item -Path "~/.config/m365/*" -Recurse -Force

# Clear token cache (Azure CLI)
az account clear
Remove-Item -Path "~/.azure/*" -Recurse -Force

# Clear MSAL cache (Python)
Remove-Item -Path "~/.msal_token_cache.bin" -Force
```

### Test Graph API Directly
```powershell
# Get token
$token = az account get-access-token --resource https://graph.microsoft.com --query accessToken -o tsv

# Call API
$headers = @{ Authorization = "Bearer $token" }
Invoke-RestMethod -Uri "https://graph.microsoft.com/v1.0/users" -Headers $headers
```

---

## Environment Setup

### Load .env Variables
```powershell
# PowerShell
Get-Content .env | ForEach-Object {
    if ($_ -match '^([^#][^=]+)=(.*)$') {
        [System.Environment]::SetEnvironmentVariable($matches[1], $matches[2], "Process")
    }
}

# Verify
Get-ChildItem Env:SPECTRA_*
```

### Verify All Secrets Present
```powershell
$requiredSecrets = @(
    "SPECTRA_AZURE_TENANT_ID",
    "SPECTRA_GRAPH_CLIENT_ID",
    "SPECTRA_GRAPH_CLIENT_SECRET",
    "SPECTRA_UNIFI_TOKEN",
    "SPECTRA_UNIFI_PORTAL_URL"
)

foreach ($secret in $requiredSecrets) {
    $value = [System.Environment]::GetEnvironmentVariable($secret)
    if ($value) {
        Write-Host "✅ $secret is set" -ForegroundColor Green
    } else {
        Write-Host "❌ $secret is MISSING" -ForegroundColor Red
    }
}
```

---

## Quick Links

- **Azure Portal:** https://portal.azure.com
- **Entra Admin centre:** https://entra.microsoft.com
- **Microsoft Graph Explorer:** https://developer.microsoft.com/graph/graph-explorer
- **M365 CLI Docs:** https://pnp.github.io/cli-microsoft365/
- **Terraform AzureAD Provider:** https://registry.terraform.io/providers/hashicorp/azuread/latest/docs

---

**Last Updated:** 2025-11-28  
**For:** SPECTRA Data Solutions Identity Infrastructure


