# Cloud PC dev provisioning — IT / Intune requirements

**Purpose:** Make **SPECTRA dev bootstrap** run **without interactive UAC** or failed winget installs on Windows 365 / Cloud PCs. This is an **Entra ID + Intune + device policy** problem, not something users fix in isolation.

**Audience:** IT, Endpoint Manager admins, whoever owns Cloud PC images and security baselines.

**Related:** [Invoke-SpectraBootstrap.ps1](Invoke-SpectraBootstrap.ps1) · [04-install-post-wipe-apps.ps1](05-Scripts/04-install-post-wipe-apps.ps1) (defaults to `winget --scope user`)

**Last updated:** 2026-03-24 (group naming aligned with SE First standards)

---

## Entra security group naming (SE First)

**Canonical standard:** `SE-First/docs/content/standards/identity-access-architecture.md` — **SE First RBAC Groups**:

- Pattern: `{organisation}-{environment}-{role}-{scope}` (lowercase kebab).
- Examples: `sefirst-dev-platform-admins`, `sefirst-test-data-engineers`, `sefirst-fabric-dev-admins`.

**Power Platform Nexus** uses a documented variant for environment access: `sefirst-nexus-{environment}-{role}` (e.g. `sefirst-nexus-dev-admin`) — see `SE-First/operations/powerapps/ENVIRONMENT-STRATEGY-SEFIRST-OWNED.md`.

**For Cloud PC / Intune (this doc),** use the **four-part** pattern so groups sit alongside other SE First Entra groups:

| Purpose | Suggested group name |
|---------|----------------------|
| Users who are **local Administrators** on **dev** Cloud PCs (Intune *Local user group membership*) | **`sefirst-dev-cloudpc-local-admins`** |
| **Device** group for assigning dev Cloud PCs (dynamic or static) | **`sefirst-dev-cloudpc-devices`** (or your existing Cloud PC device naming) |
| Intune **app** assignments to those developers (optional separate group) | **`sefirst-dev-cloudpc-developers`** |

Adjust **`dev`** → **`test`** / **`prod`** if you segment Cloud PCs by environment (use **prod** sparingly for local admin).

Do **not** use generic `SG-...` prefixes unless your tenant has a different written standard — the repo standard above is **`sefirst-...`** kebab-case.

---

## If you are the Intune admin (give the right permission yourself)

You can resolve elevation **without a ticket** by doing **one or both** of the following in **Microsoft Intune admin center** (`intune.microsoft.com`). Names vary slightly by tenant; use search in the policy blade if menus differ.

### A) Add developers to **BUILTIN\Administrators** on Cloud PCs (unblocks machine-wide winget)

1. **Entra admin center** → **Groups** → create (or reuse) a **Security** group per [naming above](#entra-security-group-naming-se-first), e.g. **`sefirst-dev-cloudpc-local-admins`**.
2. **Membership:** add accounts that should be **local admins** on dev Cloud PCs (yourself, devs).  
   - Prefer a **group**, not a single user, so onboarding is repeatable.
3. **Intune** → **Endpoint security** → **Account protection** → **Create policy**.
4. **Platform:** Windows 10, Windows 11, and Windows Server (or the option that includes **Local user group membership**).
5. **Profile type:** **Local user group membership** (if available in your tenant).
6. **Configuration:** add a row that puts **Administrators** (the built-in local group) in **Members** and add your **Entra group** (`sefirst-dev-cloudpc-local-admins`) as a member (the UI usually lets you pick **Users and groups** from Azure AD).
7. **Assignments:** assign to a **device group** that contains **only dev Cloud PCs** (recommended), e.g. **`sefirst-dev-cloudpc-devices`** or a dynamic group on **Cloud PC** SKU. **Do not** assign to every laptop in the org unless policy allows.

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

Deploy **Win32 apps** and/or **Microsoft Store** apps to a **device** or **user** group (e.g. **`sefirst-dev-cloudpc-devices`** / **`sefirst-dev-cloudpc-developers`**).

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
- A **Settings catalog** policy that adds `AzureAD\user` or a group such as **`sefirst-dev-cloudpc-local-admins`** to **BUILTIN\Administrators**, per your security model.

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
