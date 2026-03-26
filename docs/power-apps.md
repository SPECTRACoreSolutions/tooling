# Power Apps Tooling Reference

**Complete tooling documentation for Power Apps and Power Platform development**

**Last Updated:** 2025-01-09
**Status:** ✅ Active

---

## 🎯 Overview

This document consolidates all Power Apps tooling documentation including:
- Power Platform CLI (PAC) installation and usage
- Code Apps setup and configuration
- Dataverse access patterns
- Deployment workflows
- Authentication and environment management

---

## 📦 Installation

### Power Platform CLI (PAC)

**Status:** ✅ Installed
**Version:** 1.52.1
**Location:** Windows PATH

#### Install via npm

```powershell
npm install -g @microsoft/powerplatform-cli
```

#### Verify Installation

```powershell
pac --version
# Output: 1.52.1
```

---

## 🔐 Authentication

### Create Authentication Profile

```powershell
# Interactive authentication (opens browser)
pac auth create --url https://org82e73101.crm11.dynamics.com

# Or use environment-specific URL
pac auth create --url https://org.crm.dynamics.com
```

### List Authentication Profiles

```powershell
pac auth list
```

### Select Profile

```powershell
pac auth select --index 1
```

### Clear Authentication

```powershell
pac auth clear
```

### Who Am I?

```powershell
pac env who
```

---

## 🌍 Environment Management

### List Environments

```powershell
pac env list
```

### Get Environment Details

```powershell
pac env list --environment-id Default-89aaf206-0c55-4dd7-9147-9c95c1a0ff39
```

### Create Environment

```powershell
pac admin create `
  --name "SPECTRA Development" `
  --type Developer `
  --region unitedkingdom `
  --currency GBP
```

**Environment Types:**
- `Developer` - Free, limited capacity
- `Sandbox` - Testing environment
- `Production` - Production environment

**Regions:**
- `unitedkingdom` - UK
- `unitedstates` - US
- `europe` - Europe

---

## 🎨 Canvas Apps

### Unpack Power App to Source Control

```powershell
pac canvas unpack `
  --msapp MyApp.msapp `
  --sources ./src/MyApp
```

**What you get:**
- Human-readable YAML files (`.fx.yaml`)
- Git-friendly structure
- All formulas, screens, controls, data sources
- Metadata and resources

### Pack Source Code Back to .msapp

```powershell
pac canvas pack `
  --sources ./src/MyApp `
  --msapp MyApp_v2.msapp
```

### Download App from Power Platform

```powershell
pac canvas download `
  --id <app-id> `
  --output MyApp.msapp
```

### List Canvas Apps

```powershell
pac canvas list
```

### Validate Unpacked Sources

```powershell
pac canvas validate --sources ./src/MyApp
```

### Create App from Custom Connector

```powershell
pac canvas create --connector-id <connector-id>
```

---

## 💻 Code Apps (Preview)

**Status:** ⚠️ Preview Feature
**Requires:** Environment-level feature enablement

### Enable Code Apps in Environment

**Method 1: Admin Portal (Recommended)**

1. Navigate to: https://admin.powerplatform.microsoft.com
2. Select environment: **SPECTRA Data Solutions (default)**
3. Settings → Features
4. Toggle **"Power Apps code apps"** ON
5. Click **Save**
6. Wait 5-10 minutes for propagation

**Direct URL (with secret parameter):**
```
https://admin.powerplatform.microsoft.com/environments/environment/89aaf206-0c55-4dd7-9147-9c95c1a0ff39/settings/features?ecs.ShowCodeAppSetting=true
```

**Method 2: PowerShell (If Available)**

```powershell
Install-Module -Name Microsoft.PowerApps.Administration.PowerShell -Force
Import-Module Microsoft.PowerApps.Administration.PowerShell
Add-PowerAppsAccount

Set-AdminPowerAppEnvironmentProperty `
    -EnvironmentName "89aaf206-0c55-4dd7-9147-9c95c1a0ff39" `
    -IsCodeAppsEnabled $true
```

### Create Code App

```powershell
pac code init `
  --app-name "My Code App" `
  --app-id <app-id> `
  --environment-id Default-89aaf206-0c55-4dd7-9147-9c95c1a0ff39
```

### List Code Apps

```powershell
pac code list
```

### Deploy Code App

```powershell
cd path/to/code-app
npm run build
pac code push --solutionName "Common Data Services Default Solution"
```

### Code App Structure

```
my-code-app/
├── power.config.json      # App configuration
├── package.json           # Dependencies
├── vite.config.ts         # Build configuration
├── tsconfig.json          # TypeScript config
├── src/
│   ├── App.tsx            # Main React component
│   ├── App.css            # Styles
│   └── main.tsx           # Entry point
└── dist/                  # Build output
```

**power.config.json:**
```json
{
  "appId": "6fba5f40-3196-4f8c-9b81-1bd7204d9f68",
  "appDisplayName": "My App",
  "environmentId": "Default-89aaf206-0c55-4dd7-9147-9c95c1a0ff39",
  "buildPath": "./dist",
  "buildEntryPoint": "index.html",
  "connectionReferences": {},
  "databaseReferences": {}
}
```

### Known Limitations

- ⚠️ **Dataverse Access:** Code Apps (Preview) may not support direct Dataverse Web API calls via `fetch()`
- ⚠️ **Workaround:** Use Power Automate flows as proxy or wait for full support
- ⚠️ **CORS Issues:** Direct API calls may fail due to CORS restrictions

**See:** `Core/powerapps/service-catalog/DATAVERSE-ACCESS-LIMITATION.md` for details

---

## 📊 Solutions

### Create Solution

```powershell
pac solution init `
  --publisher-name SPECTRA `
  --publisher-prefix cr123 `
  --outputDirectory ./solutions/MySolution
```

### Export Solution from Environment

```powershell
pac solution export `
  --name MySolution `
  --path solution.zip
```

### Import Solution to Environment

```powershell
pac solution import --path solution.zip
```

### Unpack Solution to Source Control

```powershell
pac solution unpack `
  --zipfile solution.zip `
  --folder ./src
```

### Pack Solution from Source

```powershell
pac solution pack `
  --folder ./src `
  --zipfile solution_v2.zip
```

---

## 🗄️ Dataverse Tables

### List Tables

```powershell
pac org list-tables
```

### Create Table via Python SDK

**Example Script:**
```python
from msal import ConfidentialClientApplication
import requests

# Authenticate
app = ConfidentialClientApplication(
    client_id=CLIENT_ID,
    client_credential=CLIENT_SECRET,
    authority=f"https://login.microsoftonline.com/{TENANT_ID}"
)

result = app.acquire_token_for_client(scopes=["https://org82e73101.crm11.dynamics.com/.default"])
access_token = result["access_token"]

# Create table via Web API
headers = {
    "Authorization": f"Bearer {access_token}",
    "Content-Type": "application/json"
}

table_definition = {
    "LogicalName": "cr6a5_service",
    "DisplayName": "Service",
    "Description": "Service catalog entry"
}

response = requests.post(
    "https://org82e73101.crm11.dynamics.com/api/data/v9.2/EntityDefinitions",
    headers=headers,
    json=table_definition
)
```

**See:** `Core/powerapps/service-catalog/scripts/create_dataverse_table.py` for complete example

### Access Dataverse via Web API

**Base URL:**
```
https://org82e73101.crm11.dynamics.com/api/data/v9.2/
```

**Authentication:**
- Service Principal (recommended for automation)
- User credentials (interactive)

**Example Request:**
```powershell
$headers = @{
    "Authorization" = "Bearer $accessToken"
    "Accept" = "application/json"
    "OData-MaxVersion" = "4.0"
    "OData-Version" = "4.0"
}

$response = Invoke-RestMethod `
    -Uri "https://org82e73101.crm11.dynamics.com/api/data/v9.2/cr6a5_services" `
    -Method Get `
    -Headers $headers
```

---

## 🧩 Custom Components (PCF)

### Create PCF Component

```powershell
pac pcf init `
  --namespace SPECTRA `
  --name MyControl `
  --template field
```

**Templates:**
- `field` - Field control
- `dataset` - Dataset control
- `custom` - Custom control

### Push Component to Environment

```powershell
pac pcf push --publisher-prefix cr123
```

---

## 📝 Power Fx

### Interactive REPL

```powershell
pac power-fx repl
```

**Example Session:**
```javascript
> Filter([1,2,3,4,5], Value > 2)
[3, 4, 5]

> If(10 > 5, "Yes", "No")
"Yes"

> CountRows(Filter([{name:"Alice", age:30}, {name:"Bob", age:25}], age > 26))
1
```

### Validate Power Fx Formula

```powershell
pac power-fx validate --expression "Filter([1,2,3], Value > 1)"
```

---

## 🔄 Complete Git Workflow

### 1. Download App from Power Platform

```powershell
pac canvas download `
  --id <app-id> `
  --output ServiceCatalog.msapp
```

### 2. Unpack to Source Control

```powershell
pac canvas unpack `
  --msapp ServiceCatalog.msapp `
  --sources ./src
```

### 3. Commit to Git

```powershell
git add src/
git commit -m "feat: Initial Power App - Service Catalog"
git push
```

### 4. Edit Formulas in VS Code

Edit: `src/Src/ServiceGalleryScreen.fx.yaml`

### 5. Pack Updated App

```powershell
pac canvas pack `
  --sources ./src `
  --msapp ServiceCatalog_v2.msapp
```

### 6. Upload to Power Apps

1. Open Power Apps Studio
2. Open → Browse → `ServiceCatalog_v2.msapp`
3. File → Publish → Publish this version

---

## 🛠️ Common Commands Reference

### Authentication

| Command | Description |
|---------|-------------|
| `pac auth create` | Create authentication profile |
| `pac auth list` | List all profiles |
| `pac auth select --index N` | Select profile |
| `pac auth clear` | Clear authentication |

### Environments

| Command | Description |
|---------|-------------|
| `pac env list` | List all environments |
| `pac env who` | Show current user |
| `pac admin create` | Create new environment |

### Canvas Apps

| Command | Description |
|---------|-------------|
| `pac canvas unpack` | Unpack .msapp to source |
| `pac canvas pack` | Pack source to .msapp |
| `pac canvas download` | Download app from platform |
| `pac canvas list` | List all canvas apps |
| `pac canvas validate` | Validate unpacked sources |

### Code Apps

| Command | Description |
|---------|-------------|
| `pac code init` | Initialize code app |
| `pac code list` | List code apps |
| `pac code push` | Deploy code app |

### Solutions

| Command | Description |
|---------|-------------|
| `pac solution init` | Create new solution |
| `pac solution export` | Export solution |
| `pac solution import` | Import solution |
| `pac solution unpack` | Unpack solution to source |
| `pac solution pack` | Pack source to solution |

### PCF Components

| Command | Description |
|---------|-------------|
| `pac pcf init` | Create PCF component |
| `pac pcf push` | Push component to environment |

### Power Fx

| Command | Description |
|---------|-------------|
| `pac power-fx repl` | Interactive REPL |
| `pac power-fx validate` | Validate formula |

---

## 🔑 Credentials & Environment Variables

### Required Credentials

**Stored in:** `.env` file at workspace root

```
SPECTRA_TENANT_ID=89aaf206-0c55-4dd7-9147-9c95c1a0ff39
SPECTRA_GRAPH_CLIENT_ID=0d7652ce-6a03-489b-9097-3bbbe8f2486d
SPECTRA_GRAPH_CLIENT_SECRET=<secret>
SPECTRA_FABRIC_CLIENT_ID=<client-id>
SPECTRA_FABRIC_CLIENT_SECRET=<secret>
```

**Dataverse URLs:**
- Org URL: `https://org82e73101.crm11.dynamics.com`
- Web API: `https://org82e73101.crm11.dynamics.com/api/data/v9.2/`

### Authentication Methods

1. **Interactive (Browser):**
   ```powershell
   pac auth create
   ```

2. **Service Principal (Automation):**
   ```powershell
   pac auth create `
     --url https://org82e73101.crm11.dynamics.com `
     --applicationId <client-id> `
     --clientSecret <secret> `
     --tenantId 89aaf206-0c55-4dd7-9147-9c95c1a0ff39
   ```

---

## 📚 Additional Resources

### SPECTRA-Specific Documentation

- **Service Catalog:** `Core/powerapps/service-catalog/`
- **PAC CLI Guide:** `Core/powerapps/service-catalog/PAC-CLI-INSTALLED.md`
- **Code Apps Setup:** `Core/powerapps/service-catalog/ENABLE-CODE-APPS-GUIDE.md`
- **Dataverse Limitations:** `Core/powerapps/service-catalog/DATAVERSE-ACCESS-LIMITATION.md`

### Microsoft Documentation

- **Power Platform CLI:** https://aka.ms/PowerPlatformCLI
- **Code Apps:** https://learn.microsoft.com/power-apps/developer/code-apps/
- **Dataverse Web API:** https://learn.microsoft.com/power-apps/developer/data-platform/webapi/
- **Canvas Apps:** https://learn.microsoft.com/power-apps/maker/canvas-apps/
- **Power Fx:** https://learn.microsoft.com/power-platform/power-fx/

### Sample Apps

- **Microsoft Samples:** https://learn.microsoft.com/power-apps/maker/canvas-apps/sample-apps

---

## 🚨 Troubleshooting

### "Command not found: pac"

**Solution:**
```powershell
npm install -g @microsoft/powerplatform-cli
# Refresh PATH or restart terminal
```

### "Authentication failed"

**Solution:**
```powershell
pac auth clear
pac auth create
```

### "Code Apps not available"

**Solution:**
1. Enable Code Apps in Admin Portal
2. Wait 5-10 minutes for propagation
3. Re-authenticate: `pac auth clear && pac auth create`

### "Failed to fetch" (Code Apps)

**Known Issue:** Code Apps (Preview) may not support direct Dataverse API calls.

**Workarounds:**
1. Use Power Automate flows as proxy
2. Wait for full Dataverse support
3. See: `Core/powerapps/service-catalog/DATAVERSE-ACCESS-LIMITATION.md`

### "Cannot find module '@microsoft/power-apps'"

**Solution:**
```powershell
cd path/to/code-app
npm install @microsoft/power-apps
```

---

## ✅ Quick Reference

**Most Common Commands:**

```powershell
# Authenticate
pac auth create

# List environments
pac env list

# Unpack app
pac canvas unpack --msapp App.msapp --sources ./src

# Pack app
pac canvas pack --sources ./src --msapp App_v2.msapp

# Deploy code app
cd code-app && npm run build && pac code push

# Interactive Power Fx
pac power-fx repl
```

---

**Status:** ✅ All tooling documentation consolidated
**Location:** `Core/tooling/docs/power-apps.md`
**Related:** `Core/powerapps/service-catalog/` for service-specific docs

