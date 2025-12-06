# System Optimisation Toolkit

**Version:** 1.0  
**Created:** December 4, 2025  
**Purpose:** Tools for optimising Windows system performance and automating RGB control

---

## 🎯 What's Included

### **system-optimiser.ps1**
Comprehensive system analyser and optimiser that:
- ✅ Identifies resource-hogging processes (RGB software, startup bloat)
- ✅ Analyses RAM and CPU usage
- ✅ Detects excessive startup programs
- ✅ Finds temporary files to clean
- ✅ Provides actionable recommendations
- ✅ Auto-cleans temp files with `-CleanTemp` flag

**Usage:**
```powershell
# Full analysis
.\system-optimiser.ps1

# Clean temp files
.\system-optimiser.ps1 -CleanTemp
```

### **openrgb-integration.md**
Complete guide to OpenRGB integration with SPECTRA:
- How SPECTRA AI can control RGB lighting via CLI/SDK
- Performance comparison (SignalRGB vs OpenRGB)
- Example automation scripts
- Installation instructions
- Future integration possibilities

---

## 💡 Key Findings (December 2025)

### **System Analysis Results:**
- 🔴 **SignalRGB:** 848 MB RAM (major performance issue)
- 🟡 **Razer processes:** 19+ instances using 2.3 GB RAM
- 🟡 **Startup bloat:** 8 non-essential programs auto-starting
- 🗑️ **Temp files:** 4+ GB cleanable

### **Optimisation Potential:**
- **RAM savings:** ~3 GB (by replacing SignalRGB + trimming Razer)
- **Boot time:** 20-30 seconds faster
- **Disk space:** 4+ GB from temp file cleanup

---

## 🚀 Quick Optimisation Guide

### **Step 1: Disable Startup Bloat (5 minutes)**
1. Press `Ctrl+Shift+Esc` (Task Manager)
2. Go to **Startup** tab
3. **Disable:**
   - SignalRGB / SignalRgbLauncher
   - RazerCentral
   - Razer Cortex
   - Adobe Creative Cloud
   - EA Desktop
   - Steam
   - Discord
4. **Keep:**
   - OneDrive
   - Windows Security
   - Razer Synapse (if needed)
5. Restart PC

### **Step 2: Replace SignalRGB (30 minutes)**
1. Download OpenRGB: https://openrgb.org/
2. Uninstall SignalRGB: `Settings → Apps → SignalRGB → Uninstall`
3. Install OpenRGB
4. Configure your RGB devices
5. Restart PC

**Result:** ~800 MB RAM freed, smoother performance

### **Step 3: Clean System (5 minutes)**
```powershell
.\system-optimiser.ps1 -CleanTemp
```

---

## 🎨 OpenRGB Integration

After installing OpenRGB, SPECTRA AI can:
- ✅ Set colours via scripts
- ✅ Create time-based profiles (morning/work/evening)
- ✅ React to system events (CPU temp → red warning)
- ✅ Integrate with productivity modes
- ✅ Control via voice commands (future)

**CLI Control:**
```powershell
# Set all devices to blue
.\OpenRGB.exe --colour 0000FF

# Load gaming profile
.\OpenRGB.exe --profile "Gaming.orp"
```

**Python SDK:**
```python
from openrgb import OpenRGBClient
from openrgb.utils import RGBColour

client = OpenRGBClient()
client.set_colour(RGBColour(255, 0, 0))  # Red
```

See `docs/openrgb-integration.md` for complete guide!

---

## 📊 Performance Comparison

| Software | RAM Usage | CPU Usage | Features |
|----------|-----------|-----------|----------|
| SignalRGB | 800+ MB | High | Many effects |
| Razer Synapse | ~300 MB | Medium | Device-specific |
| OpenRGB | 50-100 MB | Low | Universal, API |

**Winner:** OpenRGB (8-10x more efficient!)

---

## 🔄 Maintenance

**Weekly:**
- Run `system-optimiser.ps1` to check for new bloat
- Review Task Manager for new startup programs

**Monthly:**
- Clean temp files with `-CleanTemp`
- Review RGB automation needs
- Update OpenRGB if available

**After Major Software Installs:**
- Check for new startup programs
- Run optimiser to baseline performance

---

## 🎁 Future Enhancements

Planned additions to this toolkit:
- [ ] Automated RGB mood profiles (work/gaming/focus)
- [ ] CPU temperature reactive lighting
- [ ] Notification system via RGB
- [ ] Voice command integration
- [ ] Performance monitoring dashboard
- [ ] Startup optimiser GUI
- [ ] Registry cleaner (safe)

---

**Created:** December 4, 2025  
**Part of:** SPECTRA Core Tooling  
**Maintained by:** Mark Maconnachie  
**Language:** British English 🇬🇧

