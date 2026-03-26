# Stream Deck Profiles

**Location for exported Stream Deck profile files**

---

## 📋 Profile Files

Profile files (`.sdProfile`) should be exported from Stream Deck software and saved here for version control.

### **Creating Profiles**

1. Configure your Stream Deck in Stream Deck software
2. Click **Profiles** → **Export Profile**
3. Save to this directory (`Core/tooling/stream-deck/profiles/`)
4. Commit to Git

### **Importing Profiles**

1. Open Stream Deck software
2. Click **Profiles** → **Import Profile**
3. Select `.sdProfile` file from this directory
4. Profile appears in profile list

---

## 📝 Available Profiles

Five profiles have been created and are ready to import:

- 🎯 **SPECTRA-Coding-Intuitive.sdProfile** - **MOST INTUITIVE** (15 buttons) - **⭐ RECOMMENDED**
- ⭐ **SPECTRA-Coding-Enhanced.sdProfile** - Enhanced coding profile (15 buttons)
- ✅ **SPECTRA-Development.sdProfile** - Basic development workflows (8 buttons)
- ✅ **SPECTRA-Deployment.sdProfile** - Deployment shortcuts (8 buttons)
- ✅ **SPECTRA-Productivity.sdProfile** - General productivity (10 buttons)

### **Which Profile Should You Use?**

**For Coding (Main Profile - RECOMMENDED):**

- 🎯 **SPECTRA-Coding-Intuitive.sdProfile** - **Based on real developer research!**
  - 15 most intuitive buttons based on actual developer usage
  - IDE shortcuts (Terminal, Command Palette, Quick Open)
  - Code editing (Comment, Format, Split)
  - Debugging (Breakpoint, Start Debug)
  - Git operations (Status, Commit, Push)
  - See `DEVELOPER-RESEARCH.md` for research details

**Alternative Coding Profile:**

- ⭐ **SPECTRA-Coding-Enhanced.sdProfile** - SPECTRA-specific features
  - Includes SPECTRA workflows (Labs Queue, Service Catalog)
  - More SPECTRA-focused shortcuts
  - See `COOL-CODING-FEATURES.md` for details

**For Deployment:**

- **SPECTRA-Deployment.sdProfile** - When deploying services

**For General Use:**

- **SPECTRA-Productivity.sdProfile** - System shortcuts, productivity

### **Profile Contents**

**SPECTRA Development:**

- Open Cursor, SPECTRA folder, Terminal
- Git Status, Labs Queue, Service Catalog
- Documentation, Run Tests

**SPECTRA Deployment:**

- Deploy Notifications, Assistant, Graph
- Railway Dashboard, GitHub Actions
- Service Catalog, Solution Engine, Deployment Docs

**SPECTRA Productivity:**

- OneDrive, SPECTRA Folder
- Lock PC, Task Manager
- Volume controls, Calendar
- Quick Status, Sync Index

## 📝 Profile Naming Convention

When creating additional profiles, use descriptive names:

- `SPECTRA-Development.sdProfile` - Development workflows
- `SPECTRA-Deployment.sdProfile` - Deployment shortcuts
- `SPECTRA-Productivity.sdProfile` - General productivity
- `SPECTRA-Gaming.sdProfile` - Gaming/streaming (if applicable)

---

## 🔄 Version Control

- All profile files tracked in Git
- Export profiles regularly to keep Git in sync
- OneDrive syncs automatically
- Easy to restore if Stream Deck is reset

---

## ⚠️ Note

**Profile files must be created in Stream Deck software first.**

This directory is for **storing** exported profiles, not creating them.

See `../SETUP-GUIDE.md` for instructions on creating profiles.
