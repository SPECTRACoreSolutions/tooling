# Installed apps scan — post-wipe winget list

**Source:** Scan of this machine (registry + winget list) and SE-First/SPECTRA docs.  
**Purpose:** You go through each row; mark **Include** Y/N. Then we drive the install script from the Y list (all via winget).

**How to use:** Set **Include** to `Y` or `N` for each app. When done, we’ll update `04-install-post-wipe-apps.ps1` to only install the `Y` ones.

---

## Dev / SE-First & SPECTRA (scripts, repos, Azure)

| App | Currently installed | winget id | Include (Y/N) |
|-----|---------------------|-----------|---------------|
| Cursor | Yes (User) | Anysphere.Cursor | |
| Git | Yes | Git.Git | |
| GitHub CLI | Yes | GitHub.cli | |
| Microsoft Azure CLI | Yes | Microsoft.AzureCLI | |
| Node.js | Yes (24.x) | OpenJS.NodeJS.LTS | |
| Python | Yes (3.11.9) | Python.Python.3.12 *(or 3.11)* | |
| PowerShell 7 | Yes | Microsoft.PowerShell | |
| Windows Terminal | Yes | Microsoft.WindowsTerminal | |
| Docker Desktop | Yes | Docker.DockerDesktop | |
| Microsoft PowerApps CLI | Yes | Microsoft.PowerAppsCLI | |
| SQL Server Management Studio 22 | Yes | Microsoft.SQLServerManagementStudio.22 | |
| cloudflared | Yes | Cloudflare.cloudflared | |

---

## Design / creative

| App | Currently installed | winget id | Include (Y/N) |
|-----|---------------------|-----------|---------------|
| Figma | Yes | Figma.Figma | |
| Figma Agent | Yes | *(same or separate?)* | |
| Blender | Yes | BlenderFoundation.Blender.LTS | |
| Adobe Creative Cloud | Yes | Adobe.CreativeCloud | |
| Adobe Acrobat Reader | Yes | Adobe.Acrobat.Reader.64-bit | |
| Graphviz | Yes | Graphviz.Graphviz | |

*Note: Other Adobe apps (Photoshop, Illustrator, After Effects, etc.) are usually installed via Creative Cloud after installing Adobe.CreativeCloud.*

---

## Hardware / peripherals / RGB

| App | Currently installed | winget id | Include (Y/N) |
|-----|---------------------|-----------|---------------|
| Elgato Stream Deck | Yes | Elgato.StreamDeck | |
| Keychron Assistant | Yes | *(winget?)* | |
| OpenRGB | Yes | OpenRGB.OpenRGB | |
| Raspberry Pi Imager | Yes | RaspberryPiFoundation.RaspberryPiImager | |

---

## Remote / access / VPN

| App | Currently installed | winget id | Include (Y/N) |
|-----|---------------------|-----------|---------------|
| TeamViewer | Yes | TeamViewer.TeamViewer | |
| Ubiquiti Identity (UID Enterprise) | Yes | Ubiquiti.IdentityDesktop.Enterprise | |

---

## Other (OCR, hex, games, etc.)

| App | Currently installed | winget id | Include (Y/N) |
|-----|---------------------|-----------|---------------|
| Tesseract OCR | Yes | *(winget: search Tesseract)* | |
| HxD Hex Editor | Yes | MHNexus.HxD | |
| Steam | Yes | Valve.Steam | |
| Discord | Yes | *(winget: Discord.Discord)* | N — use Teams for notifications |

---

## Not in winget / install separately

- **Microsoft 365 / Office** — usually from work account or Microsoft 365 portal.
- **NVIDIA drivers / app** — Windows Update or NVIDIA site; not in this list.
- **Insta360 Link Controller** — Insta360.Link.Controller (winget).
- **Cinema 4D, Razer Synapse, etc.** — add below if you want them tracked.

---

## Your notes (add rows or change Include)

*(Edit this doc: set Include to Y or N, add apps, fix winget ids. Then we’ll regenerate the script.)*

---

*Scanned: 2026-02-22. After you set Include, run: “update the install script from INSTALLED-APPS-SCAN.md” so only Y apps are in 04-install-post-wipe-apps.ps1.*
