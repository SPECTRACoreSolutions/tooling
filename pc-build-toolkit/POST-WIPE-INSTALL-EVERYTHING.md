# Post-wipe: install everything we need

**Purpose:** After a Windows reset (or clean install), use this so the toolkit USB gets you back to a full working setup: **drivers first**, then **apps** (Cursor, Figma, dev tools, etc.).

**Run from:** This USB (e.g. `H:\`) or from the toolkit folder in SPECTRA.  
**Script:** `05-Scripts\04-install-post-wipe-apps.ps1` — installs apps via winget. Run after drivers.

---

## Full rebuild (BIOS → Windows → dev setup)

**One process:** Use **SE-First [post-wipe-full-rebuild-playbook.md](SE-First)** for the full flow: BIOS (with PDF-for-iPad guide) → pre-wipe backup → wipe/Windows → drivers → **bootstrap script** → Cursor extensions + restore. The bootstrap script is **`05-Scripts/05-bootstrap-dev-setup.ps1`** (runs app install + az extension + pip tools).

---

## Where we are (rebuild checklist)

| Step | Doc / action | Status |
|------|----------------|--------|
| **1. Pre-wipe** | [pre-wipe-backup-checklist.md] — git push, backup Cursor/.ssh/.env, OneDrive sync | Do first |
| **2. Wipe** | [wipe-and-cloud-accounts-only.md](SE-First) — Option A (Reset this PC) or B (USB clean install); cloud accounts only | Then wipe |
| **3. Drivers** | This doc §1 — MSI Center → Live Update (Z890 GODLIKE) | After Windows |
| **4. Apps** | Run `04-install-post-wipe-apps.ps1` — Cursor, Git, GitHub CLI, Azure CLI, PowerShell 7, Windows Terminal, Python 3.12, Docker Desktop, Node LTS, Power Apps CLI, Azure Functions Core Tools, Figma | Then apps |
| **5. Azure DevOps CLI** | `az extension add --name azure-devops` | After Azure CLI |
| **6. Python tools** | `pip install ruff pyright pytest uv azure-identity` (or uv/poetry) | After Python |
| **7. Cursor extensions** | Install Vital list (Python, Cursor Pyright, debugpy, PowerShell, Docker, Azure*, YAML, EditorConfig, GitHub PRs, REST Client, dotenv, **ms-mssql**) — see SE-First [nexus-dev-setup-full-design.md](SE-First) §3.1 | After Cursor |
| **8. Restore** | [RESTORE-AFTER-WIPE.md](SE-First) — Cursor profile, .ssh, .env (or Key Vault pull), repo clones | Last |

*Pre-wipe and RESTORE docs live in SE-First `docs/process/` (or linked from wipe doc).*

---

## 1. Drivers (do this first)

1. **MSI Center** (on this USB: `03-AIO-RGB\MSI-Center\MSI-Center.zip`)  
   - Extract and install. Then open MSI Center → **Support** → **Live Update** → let it download and install all Z890 GODLIKE drivers (Chipset, LAN, Audio, WiFi/BT, Thunderbolt, etc.).

2. **Optional — drivers on USB**  
   - If you pre-downloaded drivers into `02-Drivers\MSI-MEG-Z890-GODLIKE\`, install **Chipset** first, then **LAN**, then the rest. Otherwise MSI Center covers it.

3. **GPU**  
   - Install from Windows Update, or download NVIDIA/AMD driver and put in `02-Drivers\Universal\` for next time.

---

## 2. Apps (run the script or install manually)

**Canonical list:** **[INSTALLED-APPS-SCAN.md](INSTALLED-APPS-SCAN.md)** — scanned from this machine; you mark Include Y/N per app. The install script is driven from that list (all winget).

The script **`04-install-post-wipe-apps.ps1`** installs the **Nexus Dev Setup required** set via **winget** (see SE-First [nexus-dev-setup-full-design.md](SE-First) §7):

| App | winget id |
|-----|-----------|
| Cursor | Anysphere.Cursor |
| Git | Git.Git |
| GitHub CLI | GitHub.cli |
| Azure CLI | Microsoft.AzureCLI |
| PowerShell 7 | Microsoft.PowerShell |
| Windows Terminal | Microsoft.WindowsTerminal |
| Python 3.12 | Python.Python.3.12 |
| Docker Desktop | Docker.DockerDesktop |
| Node.js LTS | OpenJS.NodeJS.LTS |
| Power Platform CLI (pac) | Microsoft.PowerAppsCLI |
| Azure Functions Core Tools | Microsoft.Azure.FunctionsCoreTools |
| Figma | Figma.Figma |

**To run the script (from USB or toolkit folder):**

```powershell
# From USB (e.g. H:)
Set-Location H:\05-Scripts
.\04-install-post-wipe-apps.ps1

# Preview only
.\04-install-post-wipe-apps.ps1 -WhatIf
```

**To add more apps:** Edit `04-install-post-wipe-apps.ps1` and add to the `$packages` list; use `winget search <name>` to find package IDs.

---

## 3. After apps: restore your profile

- **Cursor:** Restore from `SE-First\backups\pre-wipe-YYYY-MM-DD\Cursor-User\` or use File → Share → Import (if you exported). Open **SPECTRA and SE First.code-workspace** from OneDrive.
- **.ssh:** Restore from `SE-First\backups\pre-wipe-YYYY-MM-DD\ssh\` — see **RESTORE-AFTER-WIPE.md** in SE-First docs (e.g. `docs/process/RESTORE-AFTER-WIPE.md` in the docs repo).
- **Secrets:** Run `Pull-KeyVaultSecretsToEnv.ps1` from SE-First root (or restore `.env` from secure backup).
- **Repos:** `git pull` in each repo (Digital Transformation, docs, fusion, operations, SPECTRA).

---

## 4. Quick order of operations

1. Windows reset/install → sign in with mark.mac@me.com (and add work account).
2. Plug toolkit USB → install MSI Center → Live Update (drivers).
3. Run `04-install-post-wipe-apps.ps1` (Cursor, Figma, Git, Azure CLI, Python, Node, etc.).
4. Restore Cursor profile, .ssh, .env (or Key Vault pull); open workspace; `git pull` everywhere.

---

*Part of SPECTRA PC Build Toolkit. Edit this doc and the script when you add/remove standard apps.*
