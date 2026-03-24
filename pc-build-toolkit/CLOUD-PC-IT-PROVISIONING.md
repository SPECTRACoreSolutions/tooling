# Cloud PC dev provisioning — IT / Intune requirements

**Purpose:** Make **SPECTRA dev bootstrap** run **without interactive UAC** or failed winget installs on Windows 365 / Cloud PCs. This is an **Entra ID + Intune + device policy** problem, not something users fix in isolation.

**Audience:** IT, Endpoint Manager admins, whoever owns Cloud PC images and security baselines.

**Related:** [Invoke-SpectraBootstrap.ps1](Invoke-SpectraBootstrap.ps1) · [04-install-post-wipe-apps.ps1](05-Scripts/04-install-post-wipe-apps.ps1) (defaults to `winget --scope user`)

**Last updated:** 2026-03-24 (SEC_Intune_Cloud_PC device group; SEC_ tenant convention)

---

## Entra security group naming (SE First)

### Tenant operational groups (`SEC_…`)

The SEFirst tenant uses **`SEC_`-prefixed** security groups for many assignments (Intune, SharePoint, SQL, etc.). Examples from the directory include `SEC_Developers`, `SEC_ITTeam`, `SEC_Intune_Macbook`, and:

| Purpose | Group (tenant) |
|---------|----------------|
| **Windows 365 / Cloud PC devices** — target Intune **configuration profiles**, **app** deployments, and **Account protection** assignments here | **`SEC_Intune_Cloud_PC`** |

Populate **`SEC_Intune_Cloud_PC`** with **Cloud PC device objects** (static membership or a **dynamic device** group rule on Cloud PC / Windows 365), not user accounts.

### Canonical identity doc (`sefirst-…` kebab)

**New RBAC-style groups** for Azure/Fabric/subscription access follow `SE-First/docs/content/standards/identity-access-architecture.md`:

- Pattern: `{organisation}-{environment}-{role}-{scope}` (lowercase kebab).
- Examples: `sefirst-dev-platform-admins`, `sefirst-fabric-dev-admins`.

**Power Platform Nexus:** `sefirst-nexus-{environment}-{role}` — see `SE-First/operations/powerapps/ENVIRONMENT-STRATEGY-SEFIRST-OWNED.md`.

**Optional** (if you add a *new* Entra group only for “who becomes local admin on Cloud PCs” and want it next to other `sefirst-*` names): e.g. **`sefirst-dev-cloudpc-local-admins`**, with members = people. Intune **policy assignment** still targets **`SEC_Intune_Cloud_PC`** (devices).

---

## If you are the Intune admin (give the right permission yourself)

You can resolve elevation **without a ticket** by doing **one or both** of the following in **Microsoft Intune admin center** (`intune.microsoft.com`). Names vary slightly by tenant; use search in the policy blade if menus differ.

### A) Add developers to **BUILTIN\Administrators** on Cloud PCs (unblocks machine-wide winget)

1. **Entra admin center** → **Groups** → create (or reuse) a **Security** group whose **members are users** who should be local admins (e.g. **`SEC_Developers`** or a dedicated group — see [naming above](#entra-security-group-naming-se-first)).
2. **Membership:** add accounts that should be **local admins** on Cloud PCs (yourself, devs).  
   - Prefer a **group**, not a single user, so onboarding is repeatable.
3. **Intune** → **Endpoint security** → **Account protection** → **Create policy**.
4. **Platform:** Windows 10, Windows 11, and Windows Server (or the option that includes **Local user group membership**).
5. **Profile type:** **Local user group membership** (if available in your tenant).
6. **Configuration:** add a row that puts **Administrators** (the built-in local group) in **Members** and add your **user security group** (e.g. **`SEC_Developers`**) as a member.
7. **Assignments:** assign the policy to the **Cloud PC device group** **`SEC_Intune_Cloud_PC`** (see [tenant operational groups](#tenant-operational-groups-sec)). **Do not** assign to every laptop in the org unless policy allows.

8. **Sync / policy refresh:** on the Cloud PC run **Settings → Accounts → Access work or school → your org → Info → Sync**, or wait for the next MDM cycle. Sign out and back in (or reboot) so the new **Administrators** token applies.

**Verify on the Cloud PC:** open **cmd** or PowerShell **as normal user**, run `net localgroup administrators` — your account or group should appear.

**Alternative UI:** some tenants expose the same under **Devices** → **Configuration** → **Create** → **Settings catalog** → search for **local user** / **group membership** and configure **Administrators** membership. Prefer **Account protection → Local user group membership** when it exists; it is easier to audit.

---

### B) Deploy the dev stack as Intune apps (best for “nothing to install” automation)

Even with local admin, **pre-deploying** Git, Azure CLI, PowerShell 7, Python, etc. avoids long winget runs on first day.

1. **Intune** → **Apps** → **All apps** → **Add** → **Windows app (Win32)** (or **Microsoft Store app** where appropriate).
2. Package each tool (`.intunewin` from vendor installers or use Microsoft’s guidance per app).
3. **Assignments:** same **device** or **user** group as your Cloud PC devs.
4. Keep the list aligned with [04-install-post-wipe-apps.ps1](05-Scripts/04-install-post-wipe-apps.ps1) so docs and device state match.

---

### Governance (still do this even if it is “just us”)

- **Scope:** restrict **local admin** policy to **dev Cloud PC devices** only, not every Entra-joined PC.
- **Change record:** note the policy name, group name, and assignment in your usual change log.
- **Conflict check:** if a **Security baseline** or **Device restriction** profile removes local admin or blocks installers, **exclude** dev Cloud PCs from that baseline or adjust the baseline with an **exclusion** group.

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

Deploy **Win32 apps** and/or **Microsoft Store** apps to **`SEC_Intune_Cloud_PC`** (devices) and/or a **user** group such as **`SEC_Developers`** if you assign per user.

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
- A **Settings catalog** policy that adds `AzureAD\user` or a user group such as **`SEC_Developers`** to **BUILTIN\Administrators**, assigned to **`SEC_Intune_Cloud_PC`**, per your security model.

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
