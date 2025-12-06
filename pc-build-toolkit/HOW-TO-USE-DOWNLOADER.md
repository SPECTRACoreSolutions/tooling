# How to Use the Smart Downloader

The `download-toolkit.ps1` script automates most of your toolkit setup!

## 🚀 Quick Start

### **Option 1: Auto-detect USB (Easiest)**
```powershell
cd C:\Users\markm\OneDrive\SPECTRA\Core\tooling\pc-build-toolkit
.\download-toolkit.ps1
```

### **Option 2: Specify USB Drive**
```powershell
.\download-toolkit.ps1 -USBDrive "H:"
```

---

## 📋 What the Script Does

### **✅ Automatic Actions:**
1. Detects your USB drive (or you specify it)
2. Creates complete folder structure
3. Copies all documentation files (README, BUILD-GUIDE, etc.)
4. Copies all PowerShell scripts
5. Downloads utilities with direct URLs:
   - CPU-Z (portable)
   - HWiNFO64 (portable)
   - CrystalDiskInfo (portable)
   - 7-Zip installer

### **🌐 Opens Browser Tabs For:**
- MSI MEG Z890 GODLIKE drivers (all drivers page)
- MSI Center download
- MSI CoreLiquid i360 manual
- GPU-Z, Prime95, OCCT, CrystalDiskMark
- Rufus (USB boot creator)
- NVIDIA/AMD GPU drivers

Each tab includes **specific instructions** on what to download and where to save it!

---

## 🎯 Usage Examples

### **Full Download (Everything)**
```powershell
.\download-toolkit.ps1
```

### **Skip Utilities (Only Setup + Browser Tabs)**
```powershell
.\download-toolkit.ps1 -SkipUtilities
```

### **Specific USB Drive**
```powershell
.\download-toolkit.ps1 -USBDrive "E:"
```

---

## 📊 What Gets Downloaded Automatically

| Tool | Size | Location |
|------|------|----------|
| CPU-Z | ~2MB | 04-Utilities/System-Info/ |
| HWiNFO64 | ~5MB | 04-Utilities/Monitoring/ |
| CrystalDiskInfo | ~5MB | 04-Utilities/Drive-Tools/ |
| 7-Zip | ~2MB | 04-Utilities/General/ |

**Total Auto-Downloaded:** ~15MB

---

## 🌐 What Needs Manual Download

The script opens browser tabs with instructions for:

### **Priority 1 (Essential):**
- MSI Z890 GODLIKE Chipset driver (~5-10MB)
- MSI Z890 GODLIKE LAN driver (~10-50MB)
- MSI Center (~500MB)

### **Priority 2 (Highly Recommended):**
- MSI Z890 Audio, WiFi, Thunderbolt drivers (~300MB total)
- MSI BIOS update (~20-50MB)

### **Priority 3 (Nice to Have):**
- GPU drivers (~500MB-1GB)
- Additional utilities (~500MB)

**Total Manual Downloads:** ~2-3GB

---

## ⚡ Time Estimates

- **Script execution:** 2-3 minutes
- **Auto-downloads:** 2-5 minutes (depending on connection)
- **Manual downloads:** 15-30 minutes (depending on your speed)

**Total time:** ~20-40 minutes to have a complete toolkit!

---

## 🔄 Re-running the Script

**Safe to run multiple times!** Use it to:
- Update documentation on existing USB
- Re-download latest utilities
- Set up a new USB drive
- Fix corrupted/missing files

The script won't duplicate files - it overwrites with fresh copies.

---

## 🛠️ Troubleshooting

### **"No USB drives found"**
- Plug in your USB drive
- Make sure it's formatted (FAT32, NTFS, or exFAT)
- Check it appears in File Explorer

### **"Failed to download [utility]"**
- Check internet connection
- The URL might have changed (update script)
- Download manually from the tool's website

### **Browser tabs not opening**
- Default browser might be blocked
- Open tabs manually using URLs from DOWNLOAD-CHECKLIST.txt

---

## 📝 After Running the Script

1. **Complete manual downloads** from browser tabs
2. **Open START-HERE.txt** on the USB for next steps
3. **Verify downloads** using DOWNLOAD-CHECKLIST.txt
4. **Read BUILD-GUIDE.txt** before starting your build

---

## 🎁 Pro Tips

- Run the script while you're doing other tasks (downloads in background)
- Keep a browser window open to track manual downloads
- Use the checklist to mark off what you've downloaded
- Re-run script periodically to update utilities (latest versions)

---

**Created:** December 4, 2025  
**Part of:** SPECTRA PC Build Toolkit v1.0


