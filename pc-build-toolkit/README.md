# SPECTRA PC Build Toolkit

**Version:** 1.0  
**Created:** December 4, 2025  
**Purpose:** Reusable PC building toolkit for any hardware build or upgrade

---

## 🎯 What is This?

This is a **complete PC building toolkit** designed to be deployed on a USB drive. It contains:

- ✅ Complete build documentation (step-by-step guides)
- ✅ PowerShell automation scripts (system checks, troubleshooting)
- ✅ Organized folder structure for drivers, utilities, and tools
- ✅ Troubleshooting guides for common issues
- ✅ Download checklists with direct links

Originally created for Mark's Christmas 2025 build:
- **FROM:** ASRock Z690 Taichi Razer Edition
- **TO:** MSI MEG Z890 GODLIKE + Intel Core Ultra 9 285K + MSI MAG CoreLiquid i360

---

## 📦 Repository Structure

This Git repository contains **ONLY** the toolkit structure and documentation (~80KB).

**Included in Git:**
- 📄 All `.txt`, `.md`, `.ps1` documentation and scripts
- 📁 Folder structure (empty folders)
- ✅ Immediately usable - no downloads needed for docs!

**Excluded from Git (via .gitignore):**
- ❌ Downloaded drivers (typically 5-20GB)
- ❌ Utility software installers (500MB-2GB)
- ❌ Windows installation media (5GB+)
- ❌ User backups (variable size)

**Why?** Large binary files don't belong in Git. The toolkit can be **recreated anytime** by:
1. Copying this structure to a USB drive
2. Following `DOWNLOAD-CHECKLIST.txt` to get current drivers/software

---

## 🚀 How to Use

### **Method 1: Create a New USB Toolkit**

```powershell
# 1. Copy this folder to a USB drive
Copy-Item -Path "C:\Users\markm\OneDrive\SPECTRA\Core\tooling\pc-build-toolkit\*" `
          -Destination "E:\" `
          -Recurse -Force

# 2. Open START-HERE.txt on the USB for next steps
# 3. Follow DOWNLOAD-CHECKLIST.txt to download current drivers
```

### **Method 2: Update Existing USB**

```powershell
# Sync documentation/scripts only (no downloads)
Copy-Item -Path "C:\Users\markm\OneDrive\SPECTRA\Core\tooling\pc-build-toolkit\*.txt" `
          -Destination "E:\" -Force

Copy-Item -Path "C:\Users\markm\OneDrive\SPECTRA\Core\tooling\pc-build-toolkit\05-Scripts\*" `
          -Destination "E:\05-Scripts\" -Force

Copy-Item -Path "C:\Users\markm\OneDrive\SPECTRA\Core\tooling\pc-build-toolkit\06-Documentation\*" `
          -Destination "E:\06-Documentation\" -Force
```

---

## 📋 Folder Structure

```
pc-build-toolkit/
├── START-HERE.txt              ← Read this first!
├── README.txt                  ← Quick reference
├── DOWNLOAD-CHECKLIST.txt      ← What to download & where
│
├── 01-Windows/                 ← Windows 11 installation media
├── 02-Drivers/                 ← Motherboard & GPU drivers
│   ├── MSI-MEG-Z890-GODLIKE/   (or whatever board)
│   └── Universal/              (NVIDIA, AMD, Intel)
├── 03-AIO-RGB/                 ← AIO control & RGB software
├── 04-Utilities/               ← Monitoring, testing, tools
│   ├── System-Info/
│   ├── Monitoring/
│   ├── Stress-Testing/
│   ├── Drive-Tools/
│   ├── Driver-Tools/
│   └── General/
├── 05-Scripts/                 ← PowerShell automation
│   ├── 01-check-system-info.ps1
│   ├── 02-check-windows-activation.ps1
│   └── 03-quick-troubleshoot.ps1
├── 06-Documentation/           ← Build guides
│   ├── BUILD-GUIDE.txt         (complete step-by-step)
│   └── TROUBLESHOOTING.txt     (common issues)
└── 07-Backup/                  ← User backups & settings
```

---

## 🔄 Updating the Toolkit

### **When to Update:**

1. **New hardware build** - Customize for new motherboard/CPU/AIO
2. **Driver updates** - Every 3-6 months download latest drivers
3. **Utility updates** - Update monitoring/testing tools annually
4. **Documentation improvements** - Fix typos, add new troubleshooting

### **What to Update:**

#### **For New Builds:**
1. Edit `DOWNLOAD-CHECKLIST.txt` - change motherboard/AIO links
2. Edit `BUILD-GUIDE.txt` - update component names
3. Edit `README.txt` - update build specs
4. Create new folders in `02-Drivers/` for new board
5. Update `03-AIO-RGB/` for new cooler

#### **For Driver Updates:**
1. Download latest drivers per `DOWNLOAD-CHECKLIST.txt`
2. Replace old drivers on USB
3. Update checklist with new version numbers/dates

#### **For Script Improvements:**
1. Edit PowerShell scripts in `05-Scripts/`
2. Test thoroughly before deploying
3. Update documentation if behavior changes

---

## 💾 Backup Strategy

**This folder is in SPECTRA Core/tooling (Git-tracked):**
```
C:\Users\markm\OneDrive\SPECTRA\Core\tooling\pc-build-toolkit/
```

**Automatic Backups:**
- ✅ OneDrive syncs to cloud automatically
- ✅ Git tracks all documentation/script changes
- ✅ Version history preserved in Git

**When Recreating USB:**
1. Copy this folder to USB drive (E:, F:, G:, etc.)
2. Follow `DOWNLOAD-CHECKLIST.txt` to get latest drivers
3. Total time: 30-60 minutes (mostly download time)

---

## 🎯 Use Cases

This toolkit is designed for:

1. **Personal PC builds** - Your own hardware upgrades
2. **Family/friend builds** - Help others build PCs
3. **Troubleshooting** - System won't boot? Use this USB
4. **Clean installs** - Fresh Windows with all drivers ready
5. **System recovery** - Drivers, tools, and scripts all in one place

---

## 📝 Customization Guide

### **For Different Motherboards:**

1. Create new folder: `02-Drivers/[BOARD-NAME]/`
2. Update `DOWNLOAD-CHECKLIST.txt` with new support links
3. Download drivers to new folders
4. Update `BUILD-GUIDE.txt` with board-specific instructions

### **For Different Coolers:**

1. Create new folder: `03-AIO-RGB/[COOLER-NAME]/`
2. Download software/manual
3. Update installation section in `BUILD-GUIDE.txt`

### **Adding Custom Scripts:**

1. Create new `.ps1` file in `05-Scripts/`
2. Follow existing script structure (headers, colors, prompts)
3. Add description to `README.txt` script section
4. Test thoroughly!

---

## 🔧 Maintenance

**Monthly:**
- Check for motherboard driver updates
- Update GPU drivers (NVIDIA/AMD)

**Quarterly:**
- Update utility software
- Review and improve documentation
- Test scripts on clean system

**Annually:**
- Full toolkit review
- Remove outdated utilities
- Update Windows installation media
- Archive old driver versions

---

## ⚠️ Important Notes

**Git vs USB:**
- Git = Documentation + Scripts (always current)
- USB = Documentation + Scripts + Downloaded Binaries (gets outdated)

**Size Management:**
- Toolkit structure: ~80KB (Git)
- With all downloads: 15-30GB (USB only)
- Keep USB updated manually!

**Version Control:**
- Commit documentation/script changes to Git
- Don't commit downloaded binaries
- Tag releases when making major updates

---

## 🎄 Original Build Info

**Created for:** Mark Maconnachie  
**Date:** December 4, 2025  
**Occasion:** Christmas present to self!  

**Original Build:**
- **CPU:** Intel Core Ultra 9 285K (Arrow Lake, LGA 1851)
- **Motherboard:** MSI MEG Z890 GODLIKE
- **RAM:** 64GB Corsair DDR5-4800 (4x 16GB)
- **Cooler:** MSI MAG CoreLiquid i360
- **Previous:** ASRock Z690 Taichi Razer Edition

---

## 📞 Support

**For this toolkit:**
- Check `TROUBLESHOOTING.txt` first
- Run `05-Scripts/03-quick-troubleshoot.ps1`
- Review `BUILD-GUIDE.txt` for step-by-step help

**For hardware:**
- Motherboard manufacturer support
- Component manuals (on USB in respective folders)
- Reddit r/buildapc community

---

## 📄 License

Created with SPECTRA AI Assistant.  
Free to use, modify, and share.  
Maintain attribution when sharing with others.

---

## 🔄 Changelog

### Version 1.0 (December 4, 2025)
- Initial creation
- Complete folder structure
- 8 documentation files
- 3 PowerShell automation scripts
- Build guide for Z690 → Z890 upgrade
- Comprehensive troubleshooting guide
- Download checklist with direct links

---

**Last Updated:** December 4, 2025  
**Maintained By:** Mark Maconnachie  
**Repository:** SPECTRA Core (tooling/pc-build-toolkit)

