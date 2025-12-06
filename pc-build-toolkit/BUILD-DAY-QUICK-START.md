# 🎄 Build Day Quick Start

**Build:** ASRock Z690 → MSI MEG Z890 GODLIKE + Intel Core Ultra 9 285K  
**Status:** ✅ Ready when you are!

---

## 📍 **Everything You Need:**

**Location:** `Core/tooling/pc-build-toolkit/`

**Key Files:**

- 📖 `06-Documentation/BUILD-GUIDE.txt` - Complete step-by-step guide
- 🔧 `06-Documentation/TROUBLESHOOTING.txt` - Common issues & solutions
- 📦 `03-AIO-RGB/MSI-Center/MSI-Center.zip` - Driver installer (532 MB)
- 🔍 `05-Scripts/` - 3 verification scripts

---

## ✅ **Pre-Build Checklist:**

- [x] RAM verified (64GB DDR5-4800 - compatible!)
- [x] Windows license verified (RETAIL - will reactivate)
- [x] System info backed up
- [x] Build toolkit created
- [x] MSI Center downloaded
- [x] System optimised (SignalRGB removed)
- [ ] Read BUILD-GUIDE.txt completely
- [ ] OneDrive fully synced
- [ ] Schedule 2-3 hours uninterrupted

---

## 🔨 **Build Day Steps:**

### **1. Hardware Swap (2-3 hours)**

→ Follow `BUILD-GUIDE.txt` exactly  
→ Take photos at each stage (optional)  
→ Check cable connections twice

### **2. First Boot**

→ Press DELETE to enter BIOS  
→ Verify CPU, RAM, drives detected  
→ Enable XMP for RAM (4800 MT/s)  
→ Save and boot to Windows

### **3. Windows Boots**

→ Sign in (might say "detecting hardware")  
→ Let Windows stabilise (2-3 minutes)  
→ Check Device Manager for yellow warnings

### **4. Install MSI Center**

→ Extract: `Core/tooling/pc-build-toolkit/03-AIO-RGB/MSI-Center/MSI-Center.zip`  
→ Run installer  
→ Restart

### **5. Auto-Download Drivers**

→ Open MSI Center  
→ Support → Live Update → Scan  
→ Download All → Install All  
→ Restart

### **6. Verify System**

→ Run: `05-Scripts/01-check-system-info.ps1`  
→ Check RAM shows 4800 MT/s  
→ Check all 64GB detected  
→ Run: `05-Scripts/03-quick-troubleshoot.ps1`

### **7. Done!** 🎉

→ Stress test (optional)  
→ Install your applications  
→ Enjoy your new beast!

---

## 🎯 **Your New System:**

**Specs:**

- **CPU:** Intel Core Ultra 9 285K (24 cores, 5.7 GHz)
- **Motherboard:** MSI MEG Z890 GODLIKE
- **RAM:** 64GB Corsair DDR5-4800
- **Cooler:** MSI MAG CoreLiquid i360

**Common Shortcuts:**

- **BIOS:** Press DELETE during boot
- **Task Manager:** Ctrl+Shift+Esc
- **Device Manager:** Win+X → Device Manager

---

## 🚨 **Quick Troubleshooting:**

### **No Display:**

1. Reseat RAM (push until both clips click)
2. Check 24-pin and 8-pin power cables
3. Try one RAM stick in slot A2
4. Check GPU power cables

### **Windows Won't Activate:**

1. Sign in with Microsoft account
2. Settings → Activation → Troubleshoot
3. Or run: `slmgr /ato`

### **High Temps:**

1. Check AIO pump is powered (CPU_FAN header)
2. Check pump feels firm on CPU
3. Check radiator fans spinning

---

## 🎁 **Post-Build Optimisations:**

After system is stable:

- [ ] Install OpenRGB (RGB control - already done!)
- [ ] Run system optimiser periodically
- [ ] Configure MSI Center (fan curves, AIO display)
- [ ] Set up SPECTRA Home (Raspberry Pi automation)

---

# 🎄 **Merry Christmas, Mark!**

**You've got this!** Take your time and enjoy the build process.

This is LEGO for adults - it's therapeutic and rewarding! 🚀

---

_Created by SPECTRA AI Assistant_  
_December 4, 2025_



