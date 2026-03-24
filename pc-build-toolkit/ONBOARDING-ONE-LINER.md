# SPECTRA Dev Setup — One-liner onboarding

**Purpose:** Get the full dev environment onto a fresh machine with **one command**. No USB, no manual copy, no drag-and-drop. Smooth, fun onboarding.

**Epic 397.**

---

## The one-liner

Open **PowerShell** (or Windows Terminal) on your fresh machine and run:

```powershell
$env:SPECTRA_CLOUD_PC=1; irm https://raw.githubusercontent.com/SPECTRACoreSolutions/tooling/main/pc-build-toolkit/Invoke-SpectraBootstrap.ps1 | iex
```

Or let it prompt you:

```powershell
irm https://raw.githubusercontent.com/SPECTRACoreSolutions/tooling/main/pc-build-toolkit/Invoke-SpectraBootstrap.ps1 | iex
```

*(When prompted "Is this a Cloud PC?", type y for Cloud PC, n for physical.)*

---

## What it does

1. **Checks for Git** — Installs via winget if missing
2. **Clones tooling** from GitHub to `%USERPROFILE%\Repos\tooling` (public, no auth)
3. **Runs the bootstrap** — `05-bootstrap-dev-setup.ps1` (winget apps + az extension + pip tools)
4. **Done** — Cursor, Python, Azure CLI, Docker, Node, and more are installed

**~15 minutes** depending on connection and machine.

---

## Hosting

The one-liner fetches from **SPECTRACoreSolutions/tooling** on GitHub. The script lives at:

```
https://raw.githubusercontent.com/SPECTRACoreSolutions/tooling/main/pc-build-toolkit/Invoke-SpectraBootstrap.ps1
```

**Requirement:** The tooling repo must be **public** for `irm` to work. If it's private, use the local option below.

### Run from local tooling

If you already have the tooling repo (e.g. from SPECTRA workspace), run directly:

```powershell
cd path\to\tooling\pc-build-toolkit
.\Invoke-SpectraBootstrap.ps1 -CloudPC
```

---

## Execution policy

If you get "scripts are disabled", run:

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Or bypass for this run:

```powershell
pwsh -ExecutionPolicy Bypass -Command "irm https://... | iex -ArgumentList '-CloudPC'"
```

---

## After the bootstrap

1. **Restart** if Cursor or Docker asked you to
2. **Clone SE-First** — Four repos from ADO (Digital Transformation, docs, fusion, operations)
3. **Open workspace** — `SPECTRA and SE First.code-workspace` in Cursor (SPECTRA + SE-First for MCP, rules, etc.)
4. **Install Cursor extensions** — Vital list in [nexus-dev-setup-full-design.md](../../../SE-First/docs/content/process/nexus-dev-setup-full-design.md) §3.1
5. **Restore .env** — Copy from Key Vault or another machine to SE-First root

Full path: SE-First `Digital Transformation/epics/397-tenant-dev-and-cloud-architecture/design/dev-env-full-install-path.md`

---

## Parameters

| Parameter   | Meaning                                                                 |
|-------------|-------------------------------------------------------------------------|
| `-CloudPC`  | Skip driver reminder (no MSI drivers on Cloud PC)                      |
| `-WhatIf`  | Dry run — show what would happen                                       |
| `-TargetPath` | Where to clone tooling (default: `%USERPROFILE%\Repos`)            |

---

## Related

- [dev-env-full-install-path.md](../../../SE-First/Digital Transformation/epics/397-tenant-dev-and-cloud-architecture/design/dev-env-full-install-path.md) — Full install checklist
- [05-bootstrap-dev-setup.ps1](05-Scripts/05-bootstrap-dev-setup.ps1) — The script the bootstrap runs
- [POST-WIPE-INSTALL-EVERYTHING.md](POST-WIPE-INSTALL-EVERYTHING.md) — Post-wipe flow
