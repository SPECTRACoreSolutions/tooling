# Cloud PC dev provisioning — IT / Intune requirements

**Purpose:** Make **SPECTRA dev bootstrap** run **without interactive UAC** or failed winget installs on Windows 365 / Cloud PCs. This is an **Entra ID + Intune + device policy** problem, not something users fix in isolation.

**Audience:** IT, Endpoint Manager admins, whoever owns Cloud PC images and security baselines.

**Related:** [Invoke-SpectraBootstrap.ps1](Invoke-SpectraBootstrap.ps1) · [04-install-post-wipe-apps.ps1](05-Scripts/04-install-post-wipe-apps.ps1) (defaults to `winget --scope user`)

**Last updated:** 2026-03-24

---

## What “perfectly automated” needs

| Layer | Without IT change | With IT change |
|--------|-------------------|----------------|
| **Per-user winget** (`--scope user`) | Works on many packages if policy allows | Same; fewer App Installer / Store blocks |
| **Machine-wide installers** (some Docker, drivers, legacy MSI) | **Fails** without elevation | **Intune Win32** or **local admin** |
| **Unattended script** (no credential prompt) | **Fails** if anything still triggers UAC | **Pre-deploy apps** or **elevated rights** |

Scripts default to **per-user** installs to reduce UAC. **Elevation cannot be granted by a repo script** — only by **role**, **policy**, or **pre-installed software**.

---

## Resolution options (choose one primary path)

### 1) Intune: deploy the dev stack (recommended for automation)

Deploy **Win32 apps** and/or **Microsoft Store** apps to a **security group** used for **developer Cloud PCs** (e.g. `SG-CloudPC-Developers`).

**Typical packages** (mirror [04-install-post-wipe-apps.ps1](05-Scripts/04-install-post-wipe-apps.ps1)):

- Git for Windows  
- PowerShell 7  
- Windows Terminal  
- Azure CLI  
- Python 3.12  
- Node.js LTS  
- Cursor (if policy allows; otherwise users install once from vendor)  
- Docker Desktop (only if organisation allows; often restricted)  
- GitHub CLI, Power Platform CLI, Azure Functions Core Tools — as needed per persona  

**Outcome:** First logon is already equipped; bootstrap only adds **pip tools**, **az extension**, and **repo clones** — no mass winget elevation.

**Where in Intune:** Apps → Windows → Add → Win32 app / Microsoft Store app → Assign to Cloud PC group.

---

### 2) Local Administrator on developer Cloud PCs

Add the user (or a **group**) to the **Administrators** group on the Cloud PC **via Intune**:

- **Account protection** / **Local user group membership** (CSP), or  
- A **Settings catalog** policy that adds `AzureAD\user` or `SG-Developers` to **BUILTIN\Administrators**, per your security model.

**Outcome:** `winget --scope machine` and installers that require elevation work **without** a separate admin account, subject to your UAC settings.

**Trade-off:** Broader device rights — usually acceptable only on **dedicated dev** Cloud PCs, not generic productivity VMs.

---

### 3) Hybrid (common)

- **Intune** deploys “heavy” or policy-sensitive apps (Azure CLI, Python, Git).  
- **Bootstrap script** runs as user for **pip**, **az extension**, **git clone** — no admin.  
- **Optional:** Local admin **only** for roles that must install unsigned or niche tools.

---

## Policies to review (if winget still fails silently)

Work with IT to confirm nothing blocks **user-scoped** installs:

- **Windows App Installer** / **Microsoft Store** (winget source) allowed.  
- **Software restriction** / **AppLocker** — exceptions for `%LocalAppData%` installers if needed.  
- **Windows 365** / **Cloud PC** SKU — some SKUs restrict local admin; align **licence** with dev needs.

Exact names vary by tenant; Endpoint Manager support can map these to your baseline.

---

## What we do *not* require for basic automation

- **Domain join** beyond Entra-joined Cloud PC.  
- **Interactive admin password** in the bootstrap script (avoid storing credentials in scripts).  
- **Machine scope** for every package — default is **user** scope.

---

## Text for a service desk / IT request

You can paste this into a ticket:

> **Request:** Enable unattended dev tooling on **Windows 365 Cloud PCs** used for software delivery.  
> **Issue:** `winget` installs trigger **UAC**; user account is **not** local administrator; bootstrap cannot run fully unattended.  
> **Ask (pick one):**  
> (A) Deploy **Git, PowerShell 7, Windows Terminal, Azure CLI, Python, Node** (and agreed extras) via **Intune** to the **Cloud PC developer** group; **or**  
> (B) Grant **local Administrator** to **[named group / dev Cloud PC persona]** per security approval; **or**  
> (C) **Hybrid:** Intune for core tools + confirm policies allow **per-user** (`winget --scope user`) for remaining packages.  
> **Reference:** SPECTRA tooling repo — `pc-build-toolkit/CLOUD-PC-IT-PROVISIONING.md` (GitHub: `SPECTRACoreSolutions/tooling`).

---

## Maintenance

When **04-install-post-wipe-apps.ps1** package list changes, update **Intune** deployments or **image** docs in the same programme increment.
