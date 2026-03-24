# SPECTRA Dev Setup — Onboarding

**Purpose:** Get the full dev environment onto a fresh machine with one command. Easy to follow. **Epic 397.**

---

## Configure first (org maintainers — one-time)

Before new users can install **spectra-sdk** from Azure Artifacts, do this once:

| Step | Action | Doc |
|------|--------|-----|
| **1** | Create the feed (if not exists) | [artifacts-create-feed.md](../../../../SE-First/operations/playbooks/azure-devops/artifacts-create-feed.md) — create feed `spectra-sdk` in **SEFirst** → **Digital Transformation** |
| **2** | Configure `.pypirc` for publish | [artifacts-connect-to-feed-pip-twine.md](../../../../SE-First/operations/playbooks/azure-devops/artifacts-connect-to-feed-pip-twine.md) — add `[spectra-sdk]` with upload URL and PAT |
| **3** | Publish spectra-sdk | From SPECTRA: `cd spectra-sdk\scripts; .\publish_to_ado.ps1` |

**Feed URLs (reference):**

| Use | URL |
|-----|-----|
| **Install (pip)** | `https://pkgs.dev.azure.com/SEFirst/Digital%20Transformation/_packaging/spectra-sdk/pypi/simple/` |
| **Upload (twine)** | `https://pkgs.dev.azure.com/SEFirst/Digital%20Transformation/_packaging/spectra-sdk/pypi/upload/` |

*If you use the `nexus` feed instead of `spectra-sdk`, replace the feed name in the URLs above.*

---

## The one-liner (new users)

Open **PowerShell** (or Windows Terminal) and run:

```powershell
$env:SPECTRA_CLOUD_PC=1; irm https://raw.githubusercontent.com/SPECTRACoreSolutions/tooling/main/pc-build-toolkit/Invoke-SpectraBootstrap.ps1 | iex
```

**Or** without the env var:

```powershell
irm https://raw.githubusercontent.com/SPECTRACoreSolutions/tooling/main/pc-build-toolkit/Invoke-SpectraBootstrap.ps1 | iex
```

Bootstrap defaults to **per-user winget** (`--scope user`) to avoid UAC where possible. If installs still need **elevation** and your account is not local admin, **IT must** fix provisioning — see [CLOUD-PC-IT-PROVISIONING.md](CLOUD-PC-IT-PROVISIONING.md) (Intune deploy or local admin for dev Cloud PCs).

---

## What it does

| Step | Action |
|------|--------|
| 1 | Checks Git → installs via winget if missing |
| 2 | Clones **tooling** to `%USERPROFILE%\Repos\tooling` (public, no auth) |
| 3 | Runs **05-bootstrap-dev-setup.ps1** — winget apps, Azure DevOps CLI extension, pip tools |
| 4 | Done — Cursor, Python 3.12, Azure CLI, Docker, Node, and more are installed |

**~15 minutes** depending on connection and machine.

---

## After the bootstrap

Do these in order:

| # | Action |
|---|--------|
| 1 | **Restart** if Cursor or Docker asked you to |
| 2 | **Open Azure DevOps in the browser** — [https://dev.azure.com/SEFirst](https://dev.azure.com/SEFirst) → sign in → open project **Digital Transformation** → confirm **Repos** (and create a **PAT** under User settings if you have not yet — **Code (Read)** minimum; **Packaging (Read)** for **spectra-sdk** from Artifacts). |
| 3 | **Clone SE-First** — Four repos from ADO (Digital Transformation, docs, fusion, operations) |
| 4 | **Restore `.env`** — Copy from Key Vault or another machine → place at **SE-First root** |
| 5 | **Install spectra-sdk** — Run (requires PAT in `.env`): |
|   | `pip install spectra-sdk --extra-index-url "https://pkgs.dev.azure.com/SEFirst/Digital%20Transformation/_packaging/spectra-sdk/pypi/simple/"` |
|   | *First run may prompt for credentials: use any username, PAT as password (from `AZURE_DEVOPS_TOKEN` in `.env`)* |
| 6 | **Open workspace** — `SPECTRA and SE First.code-workspace` in Cursor |
| 7 | **Install Cursor extensions** — Vital list in [nexus-dev-setup-full-design.md](../../../../SE-First/docs/content/process/nexus-dev-setup-full-design.md) §3.1 |

**Full checklist:** [dev-env-full-install-path.md](../../../../SE-First/Digital Transformation/epics/397-tenant-dev-and-cloud-architecture/design/dev-env-full-install-path.md)

---

## Execution policy

If you get "scripts are disabled":

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Or bypass for this run:

```powershell
pwsh -ExecutionPolicy Bypass -Command "irm https://raw.githubusercontent.com/SPECTRACoreSolutions/tooling/main/pc-build-toolkit/Invoke-SpectraBootstrap.ps1 | iex -ArgumentList '-CloudPC'"
```

---

## Run from local tooling

If you already have the tooling repo:

```powershell
cd path\to\tooling\pc-build-toolkit
.\Invoke-SpectraBootstrap.ps1 -CloudPC
```

---

## Parameters

| Parameter | Meaning |
|-----------|---------|
| `-CloudPC` | Optional legacy flag (no longer required; bootstrap does not prompt for OEM drivers) |
| `-MachineWinget` | winget `--scope machine` (all users; needs elevation). Default is **per-user** (`--scope user`) to avoid UAC on Cloud PCs |
| `-WhatIf` | Dry run — show what would happen |
| `-TargetPath` | Where to clone tooling (default: `%USERPROFILE%\Repos`) |

---

## Related

- [CLOUD-PC-IT-PROVISIONING.md](CLOUD-PC-IT-PROVISIONING.md) — **IT / Intune:** unattended installs, elevation, zero-touch options
- [dev-env-full-install-path.md](../../../../SE-First/Digital Transformation/epics/397-tenant-dev-and-cloud-architecture/design/dev-env-full-install-path.md) — Full install checklist
- [05-bootstrap-dev-setup.ps1](05-Scripts/05-bootstrap-dev-setup.ps1) — Script the bootstrap runs
- [POST-WIPE-INSTALL-EVERYTHING.md](POST-WIPE-INSTALL-EVERYTHING.md) — Post-wipe flow
- [artifacts-connect-to-feed-pip-twine.md](../../../../SE-First/operations/playbooks/azure-devops/artifacts-connect-to-feed-pip-twine.md) — Azure Artifacts pip/twine setup
