# Elgato Stream Deck Configuration

**Version:** 1.0  
**Created:** December 6, 2025  
**Purpose:** Stream Deck setup and profiles for SPECTRA workflows

---

## 🎯 What is This?

This directory contains configuration files, profiles, and documentation for setting up your Elgato Stream Deck with SPECTRA-specific workflows and productivity shortcuts.

**Stream Deck Models Supported:**

- Stream Deck (15 keys)
- Stream Deck Mini (6 keys)
- Stream Deck XL (32 keys)
- Stream Deck Plus (8 keys + 4 dials)
- Stream Deck MK.2 (15 keys)

---

## 📦 Repository Structure

```
stream-deck/
├── README.md                    ← You are here
├── setup-guide.md               ← Installation & setup instructions
├── profiles/                    ← Stream Deck profile files
│   ├── SPECTRA-Development.sdProfile
│   ├── SPECTRA-Deployment.sdProfile
│   └── SPECTRA-Productivity.sdProfile
├── portals-profile/             ← Generate Portals profile (Fabric, ADO, Azure, etc.)
│   ├── generate.js
│   ├── package.json
│   └── Portals.streamDeckProfile (run npm run generate)
├── icons/                       ← Custom icons for buttons
│   ├── spectra-logo.png
│   └── custom-icons/
└── scripts/                     ← PowerShell scripts for actions
    ├── deploy-service.ps1
    ├── open-project.ps1
    └── quick-commands.ps1
```

---

## 🚀 Quick Start

### **Step 1: Install Stream Deck Software**

1. Download Stream Deck software from [Elgato website](https://www.elgato.com/en/downloads)
2. Install and launch Stream Deck
3. Connect your Stream Deck device via USB

### **Step 2: Import SPECTRA Profiles**

1. Open Stream Deck software
2. Click **Profiles** → **Import Profile**
3. Navigate to `Core/tooling/stream-deck/profiles/`
4. Import desired profiles:
   - `SPECTRA-Development.sdProfile` - Development workflows
   - `SPECTRA-Deployment.sdProfile` - Deployment shortcuts
   - `SPECTRA-Productivity.sdProfile` - General productivity

### **Step 3: Customise for Your Workflow**

See `SETUP-GUIDE.md` for detailed customisation instructions.

---

## 📋 Available Profiles

### **SPECTRA Development Profile**

**Purpose:** Common development tasks and shortcuts

**Buttons Include:**

- Open Cursor/VS Code
- Open SPECTRA workspace
- Git operations (commit, push, pull)
- Run tests
- Open terminal
- Switch between projects
- Open documentation
- Quick access to Labs queue

### **SPECTRA Deployment Profile**

**Purpose:** Service deployment and infrastructure

**Buttons Include:**

- Deploy to Railway
- Check service status
- View logs
- Open service catalog
- Run solution-engine commands
- Open deployment docs
- Check GitHub Actions

### **Portals Profile** (generated)

**Purpose:** One-tap access to Fabric, ADO, Azure, Entra, Intune, Power Platform — with favicons.

**To generate and install:**

```bash
cd Core/tooling/stream-deck/portals-profile
npm install && npm run generate
```

Then double-click `Portals.streamDeckProfile` to install. Favicons are fetched at build time.

### **SPECTRA Productivity Profile**

**Purpose:** General productivity and system shortcuts

**Buttons Include:**

- Open OneDrive
- Open SPECTRA folder
- System shortcuts (lock, sleep, restart)
- Volume control
- Screen recording
- Quick notes
- Calendar/Outlook
- Microsoft 365 shortcuts

---

## 🔧 Customisation

### **Adding New Buttons**

1. Open Stream Deck software
2. Select profile to edit
3. Drag action from left panel to empty button
4. Configure action settings
5. Save profile (auto-saves to `profiles/` directory)

### **Creating Custom Actions**

See `scripts/` directory for PowerShell scripts that can be triggered from Stream Deck.

**Example:** Create button that runs `deploy-service.ps1` with parameters.

---

## 📚 Documentation

- **SETUP-GUIDE.md** - Complete setup instructions
- **README.md** - This file (overview)

---

## 🔄 Maintenance

**When to Update:**

- New SPECTRA services added → Update deployment profile
- New workflows created → Add buttons to relevant profile
- Stream Deck software updates → Test profiles still work
- New tools installed → Add shortcuts to productivity profile

**Backup:**

- Profiles auto-save to this directory
- Git tracks all profile changes
- OneDrive syncs automatically

---

## ⚠️ Important Notes

**Profile Location:**

- Stream Deck stores profiles in: `%AppData%\Elgato\StreamDeck\Profiles\`
- This directory contains **exported** profiles for version control
- Import profiles to Stream Deck to use them

**Icons:**

- Custom icons stored in `icons/` directory
- Use SPECTRA branding where appropriate
- Icons should be 72x72 pixels for best quality

**Scripts:**

- PowerShell scripts in `scripts/` can be triggered from Stream Deck
- Ensure execution policy allows script running
- Test scripts manually before adding to Stream Deck

---

## 🎯 Use Cases

This Stream Deck setup is optimised for:

1. **SPECTRA Development** - Quick access to common dev tasks
2. **Service Deployment** - One-button deployment workflows
3. **Productivity** - System shortcuts and tool access
4. **Documentation** - Quick access to SPECTRA docs
5. **Git Operations** - Common Git commands

---

## 📞 Support

**For Stream Deck Issues:**

- Check Elgato support: [support.elgato.com](https://support.elgato.com)
- Stream Deck software help menu
- Elgato community forums

**For SPECTRA-Specific:**

- Review `SETUP-GUIDE.md` for detailed instructions
- Check profile documentation in Stream Deck software
- Test scripts manually before adding to buttons

---

## 📄 License

Created with SPECTRA AI Assistant.  
Free to use, modify, and share.  
Maintain attribution when sharing with others.

---

**Last Updated:** December 6, 2025  
**Maintained By:** Mark Maconnachie  
**Repository:** SPECTRA Core (tooling/stream-deck)




