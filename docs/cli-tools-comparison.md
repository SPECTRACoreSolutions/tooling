# SPECTRA CLI & REST API Tooling - Best-of-Breed Analysis

**Purpose:** Definitive guide to the BEST CLI/REST API tools for Microsoft 365, Entra ID, and identity infrastructure

**Status:** 🎯 Opinionated recommendations based on 2025 best practices

---

## 🤔 The Problem: Too Many Tools

Microsoft's identity ecosystem has **too many overlapping tools**. Here's what exists:

### For Microsoft Graph / Entra ID

1. **Azure CLI** (`az`) - Original, broad Azure coverage
2. **Microsoft Graph CLI** (`mgc`) - New, official Graph CLI (2023+)
3. **M365 CLI** (`m365`) - Community PnP, comprehensive
4. **Azure PowerShell** (`Az` module) - PowerShell-native
5. **Microsoft.Graph PowerShell** - Graph SDK for PowerShell
6. **REST API** (direct) - curl/Postman/Bruno

### The Confusion

- ❓ Which one should I use for user management?
- ❓ Which has the best Conditional Access support?
- ❓ Which is most future-proof?
- ❓ Can they coexist or do I pick one?

---

## 🏆 The Definitive Answer for SPECTRA

### **Winner: Hybrid Approach** (Use the right tool for the job)

Here's what SPECTRA should **actually** use:

| Use Case                   | Tool                       | Why                                  | Status      |
| -------------------------- | -------------------------- | ------------------------------------ | ----------- |
| **Automation/IaC**         | Terraform + Bicep          | Industry standard, state management  | ✅ INSTALL  |
| **Interactive Admin**      | M365 CLI                   | Most comprehensive, community-driven | ✅ YOU HAVE |
| **Scripting (PowerShell)** | Microsoft.Graph PowerShell | Native Graph SDK, strongly typed     | ⚠️ INSTALL  |
| **CI/CD Pipelines**        | Azure CLI + REST           | Fastest, lightweight                 | ✅ YOU HAVE |
| **Development/Testing**    | Bruno + REST               | Visual, team collaboration           | ❌ INSTALL  |
| **Quick Queries**          | Microsoft Graph CLI        | Simple, fast, no auth hassle         | ✅ YOU HAVE |

---

## 📊 Detailed Tool Comparison

### 1. Azure CLI (`az`)

**What It Is:** Microsoft's original CLI for Azure services

```bash
az --version
az ad user list
az ad app create
```

**Pros:**

- ✅ Mature and stable (since 2017)
- ✅ Excellent for Azure resources (VMs, networks, etc.)
- ✅ Good CI/CD integration
- ✅ Fast and lightweight

**Cons:**

- ❌ Limited Entra ID coverage (legacy commands)
- ❌ Graph API support incomplete
- ❌ Not designed for M365 workloads
- ❌ Being superseded by Graph CLI

**Verdict for SPECTRA:** ⚠️ **Keep but don't rely on for identity**

- Use for: Azure resource management, service principals
- Don't use for: User management, Conditional Access, detailed Entra operations

---

### 2. Microsoft Graph CLI (`mgc`)

**What It Is:** Official Microsoft Graph CLI (released 2023)

```bash
mgc --version
mgc login --strategy DeviceCode
mgc users list --top 10
mgc identity conditional-access policies list
```

**Pros:**

- ✅ **Official Microsoft product** (future-proof)
- ✅ Auto-generated from Graph API specs (always up-to-date)
- ✅ Consistent with Graph API structure
- ✅ Supports all Graph endpoints
- ✅ Modern authentication strategies

**Cons:**

- ❌ Still maturing (some rough edges)
- ❌ Less "friendly" than community tools
- ❌ Documentation still catching up
- ❌ Verbose command structure

**Verdict for SPECTRA:** ✅ **Use for quick queries and modern endpoints**

- Use for: New Graph features, quick checks, CI/CD
- Don't use for: Complex scripting (use PowerShell SDK instead)

**Current Status:** ✅ You have 1.9.0 installed but not authenticated

---

### 3. M365 CLI (`m365`) - PnP Community

**What It Is:** Community-driven CLI for Microsoft 365 (PnP initiative)

```bash
m365 version
m365 login
m365 entra user list
m365 entra app list
m365 spo site list
```

**Pros:**

- ✅ **Most comprehensive coverage** (Entra, SharePoint, Teams, Planner, etc.)
- ✅ User-friendly command structure
- ✅ Excellent documentation and examples
- ✅ Active community support
- ✅ Cross-platform (Node.js)
- ✅ Great for interactive admin work

**Cons:**

- ❌ Not official Microsoft (community project)
- ❌ Can lag behind new features
- ❌ Requires Node.js runtime

**Verdict for SPECTRA:** ✅ **PRIMARY tool for interactive administration**

- Use for: Day-to-day admin tasks, user management, exploring tenant
- Don't use for: Production automation (prefer official tools/SDKs)

**Current Status:** ✅ You have 11.1.0 and it's authenticated - **PERFECT**

---

### 4. Azure PowerShell (`Az` module)

**What It Is:** PowerShell modules for Azure and Entra

```powershell
Import-Module Az
Connect-AzAccount
Get-AzADUser
New-AzADApplication
```

**Pros:**

- ✅ Native PowerShell experience
- ✅ Object-oriented (pipeline-friendly)
- ✅ Good for Windows admins
- ✅ Integrated with Azure Resource Manager

**Cons:**

- ❌ Azure-focused, limited pure Entra functionality
- ❌ Graph coverage incomplete
- ❌ Being replaced by Microsoft.Graph module for identity

**Verdict for SPECTRA:** ⚠️ **Install but use sparingly**

- Use for: Azure resource management, AD Connect scenarios
- Don't use for: Pure Entra/Graph operations (use Microsoft.Graph instead)

**Current Status:** ❌ Not installed (but should be)

---

### 5. Microsoft.Graph PowerShell SDK

**What It Is:** Official Graph SDK for PowerShell

```powershell
Install-Module Microsoft.Graph
Connect-MgGraph -Scopes "User.Read.All"
Get-MgUser
New-MgUser
Get-MgIdentityConditionalAccessPolicy
```

**Pros:**

- ✅ **Official Microsoft SDK** (most future-proof)
- ✅ Full Graph API coverage (1000+ cmdlets)
- ✅ Strongly typed (IntelliSense support)
- ✅ Best for complex PowerShell automation
- ✅ Supports all authentication methods
- ✅ Object-oriented pipeline

**Cons:**

- ❌ Verbose cmdlet names
- ❌ Large module (slow initial load)
- ❌ Can be overwhelming (so many cmdlets)

**Verdict for SPECTRA:** ✅ **PRIMARY tool for PowerShell automation**

- Use for: Production scripts, Conditional Access, complex workflows
- Don't use for: Quick one-liners (use M365 CLI instead)

**Current Status:** ❌ NOT installed - **CRITICAL MISSING PIECE**

---

### 6. Direct REST API (curl, Bruno, Postman)

**What It Is:** Direct HTTP calls to Microsoft Graph API

```bash
# Get token
curl -X POST "https://login.microsoftonline.com/$TENANT/oauth2/v2.0/token" \
  -d "client_id=$CLIENT_ID" \
  -d "client_secret=$CLIENT_SECRET" \
  -d "scope=https://graph.microsoft.com/.default" \
  -d "grant_type=client_credentials"

# Call Graph
curl -H "Authorization: Bearer $TOKEN" \
  "https://graph.microsoft.com/v1.0/users"
```

**Pros:**

- ✅ **Most flexible** (any language, any platform)
- ✅ No CLI dependencies
- ✅ Learn the API deeply
- ✅ Great for development/testing
- ✅ Visual tools (Bruno/Postman) for exploration

**Cons:**

- ❌ Manual token management
- ❌ More code to write
- ❌ Error handling is manual

**Verdict for SPECTRA:** ✅ **Essential for development**

- Use for: API exploration, custom integrations, learning
- Tools: **Bruno** (open source, Git-friendly) > Postman

**Current Status:** ❌ Bruno not installed - **SHOULD ADD**

---

### 7. Terraform (HashiCorp)

**What It Is:** Infrastructure as Code for Azure/Entra

```hcl
resource "azuread_conditional_access_policy" "require_mfa" {
  display_name = "Require MFA for all users"
  state        = "enabled"

  conditions {
    users {
      included_users = ["All"]
    }
  }

  grant_controls {
    built_in_controls = ["mfa"]
  }
}
```

**Pros:**

- ✅ **Industry standard for IaC**
- ✅ Declarative (state-based)
- ✅ Version controlled
- ✅ Team collaboration
- ✅ Excellent for Conditional Access
- ✅ Drift detection

**Cons:**

- ❌ Learning curve
- ❌ State management complexity
- ❌ Not for interactive admin

**Verdict for SPECTRA:** ✅ **CRITICAL for production identity infrastructure**

- Use for: Conditional Access policies, app registrations, groups
- Don't use for: User creation, ad-hoc queries

**Current Status:** ❌ NOT installed - **CRITICAL MISSING PIECE**

---

## 🎯 SPECTRA's Optimal Tool Stack

### Tier 1: Must Have (Install Immediately)

| Tool                           | Purpose                    | Install Command                  |
| ------------------------------ | -------------------------- | -------------------------------- |
| **Terraform**                  | IaC for Conditional Access | `choco install terraform`        |
| **Microsoft.Graph PowerShell** | Production automation      | `Install-Module Microsoft.Graph` |
| **Bruno**                      | REST API exploration       | `winget install Bruno.Bruno`     |

### Tier 2: Already Have (Keep Using)

| Tool                    | Purpose           | Status                         |
| ----------------------- | ----------------- | ------------------------------ |
| **M365 CLI**            | Interactive admin | ✅ Using correctly             |
| **Microsoft Graph CLI** | Quick queries     | ✅ Have, should authenticate   |
| **Azure CLI**           | Azure resources   | ✅ Keep for service principals |

### Tier 3: Optional (Add Later)

| Tool                 | Purpose              | Priority                   |
| -------------------- | -------------------- | -------------------------- |
| **Azure PowerShell** | Azure resources      | 🟡 Medium                  |
| **Postman**          | Alternative to Bruno | 🟢 Low (Bruno is better)   |
| **AADInternals**     | Advanced auditing    | 🟢 Low (security research) |

---

## 🔥 Hot Take: What Most Companies Get Wrong

### ❌ Common Mistakes

**Mistake 1: "Azure CLI for everything"**

```bash
# Don't do this for identity work
az ad user list
az ad app create
```

**Problem:** Limited identity features, being superseded

**Fix:** Use M365 CLI or Microsoft.Graph PowerShell

```powershell
# Do this instead
m365 entra user list
Get-MgUser
```

---

**Mistake 2: "Postman for API development"**
**Problem:** Not Git-friendly, closed source, heavy

**Fix:** Use Bruno (open source, Git-based)

- Collections are plain text JSON
- Version control friendly
- Team collaboration
- Lightweight

---

**Mistake 3: "Manual Conditional Access via portal"**
**Problem:** Not reproducible, no audit trail, error-prone

**Fix:** Use Terraform

```hcl
# Conditional Access as code
resource "azuread_conditional_access_policy" "..."
```

---

**Mistake 4: "PowerShell 5.1 with old modules"**
**Problem:** Missing modern features, EOL approaching

**Fix:** PowerShell 7 + Microsoft.Graph module

```powershell
# Check version
$PSVersionTable.PSVersion  # Should be 7.x

# Use modern module
Import-Module Microsoft.Graph
```

---

## 💡 Recommended Workflows

### Workflow 1: Explore Tenant (Interactive)

**Tool:** M365 CLI

```bash
# Quick tenant exploration
m365 login
m365 entra user list
m365 entra app list
m365 entra policy list --type conditionalAccess
```

**Why:** User-friendly, comprehensive, great for learning

---

### Workflow 2: Automate User Provisioning

**Tool:** Microsoft.Graph PowerShell

```powershell
# Production-grade user creation
Connect-MgGraph -Scopes "User.ReadWrite.All"

$users = Import-Csv "users.csv"
foreach ($user in $users) {
    New-MgUser -DisplayName $user.Name `
               -UserPrincipalName $user.Email `
               -AccountEnabled `
               -PasswordProfile @{
                   Password = New-RandomPassword
                   ForceChangePasswordNextSignIn = $true
               }
}
```

**Why:** Strongly typed, error handling, production-ready

---

### Workflow 3: Deploy Conditional Access

**Tool:** Terraform

```hcl
# conditional-access.tf
terraform {
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.45.0"
    }
  }
}

resource "azuread_conditional_access_policy" "require_mfa" {
  # ... policy definition ...
}
```

```bash
# Deploy
terraform init
terraform plan
terraform apply
```

**Why:** Version controlled, reproducible, drift detection

---

### Workflow 4: Develop UniFi Integration

**Tool:** Bruno + Python

```python
# Use Bruno to explore Graph API
# Export to Python code

import msal
import requests

# Get token
app = msal.ConfidentialClientApplication(
    client_id=CLIENT_ID,
    client_credential=CLIENT_SECRET,
    authority=f"https://login.microsoftonline.com/{TENANT_ID}"
)
token = app.acquire_token_for_client(scopes=["https://graph.microsoft.com/.default"])

# Update custom attribute
response = requests.patch(
    f"https://graph.microsoft.com/v1.0/users/{user_id}",
    headers={"Authorization": f"Bearer {token['access_token']}"},
    json={"extension_physicalPresence": "office"}
)
```

**Why:** Visual API exploration, then codify in Python

---

### Workflow 5: CI/CD Pipeline

**Tool:** Azure CLI + REST

```yaml
# GitHub Actions / Azure DevOps
- name: Update Entra Config
  run: |
    # Lightweight, fast
    az login --service-principal ...
    az rest --method PATCH \
            --url "https://graph.microsoft.com/v1.0/..." \
            --body @config.json
```

**Why:** Fast, lightweight, no runtime dependencies

---

## 🎨 Real-World SPECTRA Scenarios

### Scenario 1: Daily Admin - Check New Sign-ins

**Best Tool:** M365 CLI

```bash
# Quick check
m365 login
m365 entra signin list --top 20
```

**Alternative:** Microsoft Graph CLI

```bash
mgc login
mgc audit-logs sign-ins list --top 20
```

**Don't Use:** Azure CLI (limited sign-in log support)

---

### Scenario 2: Create 10 New Users from CSV

**Best Tool:** Microsoft.Graph PowerShell

```powershell
Connect-MgGraph -Scopes "User.ReadWrite.All"
Import-Csv users.csv | ForEach-Object {
    New-MgUser -DisplayName $_.Name -UserPrincipalName $_.Email ...
}
```

**Alternative:** M365 CLI (for small batches)

```bash
m365 entra user add --displayName "..." --userName "..."
```

**Don't Use:** Azure CLI (incomplete user creation features)

---

### Scenario 3: Deploy 5 Conditional Access Policies

**Best Tool:** Terraform

```hcl
# Git-tracked, reviewable, reproducible
resource "azuread_conditional_access_policy" "mfa" { ... }
resource "azuread_conditional_access_policy" "compliant_device" { ... }
resource "azuread_conditional_access_policy" "location" { ... }
```

**Alternative:** Microsoft.Graph PowerShell (for scripting)

```powershell
New-MgIdentityConditionalAccessPolicy -BodyParameter @{ ... }
```

**Don't Use:** M365 CLI (no CA creation support yet), Portal (not reproducible)

---

### Scenario 4: Build UniFi-Entra Middleware

**Best Tool:** Bruno (exploration) + Python (implementation)

**Step 1:** Use Bruno to test Graph API calls

- Create collection: "SPECTRA Identity Bridge"
- Add requests: Get User, Update Custom Attributes
- Test with your credentials
- Export to Python

**Step 2:** Implement in Python

```python
# Use msgraph-sdk (easier than raw REST)
from msgraph import GraphServiceClient
from azure.identity import ClientSecretCredential

credential = ClientSecretCredential(
    tenant_id=TENANT_ID,
    client_id=CLIENT_ID,
    client_secret=CLIENT_SECRET
)

client = GraphServiceClient(credential)

# Update user
await client.users.by_user_id(user_id).patch({
    "extension_physicalPresence": "office"
})
```

**Don't Use:** CLI tools (not suitable for production services)

---

### Scenario 5: Audit Tenant Security

**Best Tool:** Microsoft.Graph PowerShell

```powershell
# Get risky users
Connect-MgGraph -Scopes "IdentityRiskyUser.Read.All"
Get-MgRiskyUser | Where-Object { $_.RiskLevel -eq "high" }

# Get sign-ins with anomalies
Get-MgAuditLogSignIn -Filter "riskState eq 'atRisk'"

# Export to CSV
Get-MgUser | Select DisplayName, UserPrincipalName, AccountEnabled |
    Export-Csv "user-audit.csv"
```

**Alternative:** M365 CLI (for quick checks)

```bash
m365 entra user list --output json > users.json
```

**Don't Use:** Azure CLI (limited audit log support)

---

## 📚 Learning Path for SPECTRA Team

### Week 1: Foundations

**Focus:** M365 CLI (interactive exploration)

```bash
# Install and authenticate
npm install -g @pnp/cli-microsoft365
m365 login

# Explore tenant
m365 entra user list
m365 entra app list
m365 entra policy list --type authenticationMethods
```

**Goal:** Understand tenant structure

---

### Week 2: PowerShell Automation

**Focus:** Microsoft.Graph PowerShell

```powershell
# Install and authenticate
Install-Module Microsoft.Graph -Scope CurrentUser
Connect-MgGraph -Scopes "User.Read.All","Directory.Read.All"

# Basic operations
Get-MgUser
Get-MgApplication
Get-MgGroup
```

**Goal:** Automate repetitive tasks

---

### Week 3: Infrastructure as Code

**Focus:** Terraform

```bash
# Install
choco install terraform

# Create first policy
terraform init
terraform plan
terraform apply
```

**Goal:** Deploy Conditional Access as code

---

### Week 4: API Development

**Focus:** Bruno + Python msgraph-sdk

**Goal:** Build UniFi-Entra integration

---

## 🚀 Installation Priority for SPECTRA

### Install Today (Critical)

```powershell
# 1. Terraform (IaC for CA policies)
choco install terraform -y

# 2. Microsoft.Graph PowerShell (production automation)
Install-Module Microsoft.Graph -Scope CurrentUser -Force

# 3. Bruno (API development)
winget install Bruno.Bruno
```

### Configure Today (Already Installed)

```powershell
# Authenticate Graph CLI (you have it but not authenticated)
mgc login --strategy DeviceCode --scopes "User.Read.All Directory.Read.All"
```

### Install This Week (Nice to Have)

```powershell
# Azure PowerShell (for completeness)
Install-Module Az -Scope CurrentUser -Force

# MSAL.PS (token testing)
Install-Module MSAL.PS -Scope CurrentUser -Force
```

---

## 🎯 The Bottom Line

### What SPECTRA Should Use

**Daily Admin:** M365 CLI (✅ you have this, keep using it)
**PowerShell Scripts:** Microsoft.Graph PowerShell (❌ install this)
**Infrastructure:** Terraform (❌ install this - CRITICAL)
**API Development:** Bruno + Python msgraph-sdk (❌ install Bruno)
**CI/CD:** Azure CLI + REST (✅ you have this)
**Quick Queries:** Microsoft Graph CLI (✅ you have this, just authenticate it)

### What SPECTRA Can Ignore

- ❌ Azure PowerShell `Get-AzADUser` commands (superseded)
- ❌ `az ad` commands (limited functionality)
- ❌ Postman (use Bruno instead)
- ❌ Old `AzureAD` PowerShell module (EOL in 2024)
- ❌ Old `MSOnline` PowerShell module (EOL in 2024)

---

## 🏆 Final Verdict

You're **mostly** using the right tools! Here's the scorecard:

| Tool                           | Status                        | Grade                 |
| ------------------------------ | ----------------------------- | --------------------- |
| M365 CLI                       | ✅ Using correctly            | A+                    |
| Azure CLI                      | ✅ Have, good for Azure       | B+ (not for identity) |
| Graph CLI                      | ⚠️ Have but not authenticated | B (should use)        |
| **Microsoft.Graph PowerShell** | ❌ **MISSING**                | **F - CRITICAL GAP**  |
| **Terraform**                  | ❌ **MISSING**                | **F - CRITICAL GAP**  |
| **Bruno**                      | ❌ Missing                    | C (nice to have)      |

**Overall Grade:** B- (Good foundation, missing critical automation pieces)

---

## ✅ Action Plan

### Today

```powershell
# Run your installation script (it includes these)
.\Core\onboarding\bootstrap\install-identity-tools.ps1 -Tier1Only
```

This will install:

- ✅ Terraform
- ✅ Microsoft.Graph PowerShell
- ✅ Bruno

### This Week

1. Authenticate Graph CLI: `mgc login --strategy DeviceCode`
2. Learn Microsoft.Graph PowerShell basics
3. Create first Terraform config for Conditional Access

### This Month

1. Move all Conditional Access to Terraform
2. Build UniFi-Entra bridge with Bruno + Python
3. Document team workflows with new tools

---

**You're using the right tools, just missing 2 critical pieces: Terraform and Microsoft.Graph PowerShell. Install those and SPECTRA will have best-of-breed tooling.** 🎯

