# BIOS Settings Check - December 6, 2025

## ✅ What I Can See From Windows

### **Motherboard**

- **Manufacturer:** Micro-Star International Co., Ltd.
- **Model:** MEG Z890 GODLIKE (MS-7E21)
- **Version:** 1.0

### **BIOS/UEFI**

- **Manufacturer:** American Megatrends International, LLC. (AMI)
- **Version:** 1.A30
- **Firmware:** ALASKA - 1072009

### **CPU**

- **Processor:** Intel Core Ultra 9 285K ✅
- **Cores:** 24 (8P + 16E)
- **Base Clock:** 3700 MHz
- **Current Clock:** 3200 MHz (idle)

### **RAM**

- **Total Installed:** 64 GB ✅
- **Status:** All 4 sticks detected

### **Secure Boot**

- **Status:** Unable to determine from Windows (may need to check in BIOS)

---

## 🔍 What You Should Check in BIOS

Since Windows loaded fine, the critical settings are working, but here's what to verify for optimal performance:

### **1. XMP Profile (CRITICAL for RAM Speed)**

- **Location:** Settings → Advanced → Memory Settings → XMP
- **Action:** Enable XMP Profile 1
- **Expected:** RAM should run at 4800 MHz (your DDR5-4800 sticks)
- **Why:** Without XMP, RAM runs at JEDEC default (usually 4800 MHz for DDR5, but verify)

### **2. Boot Order**

- **Location:** Settings → Boot
- **Action:** Verify Windows drive is #1 boot device
- **Status:** ✅ Already working (Windows boots fine)

### **3. CPU Settings**

- **Location:** Settings → Advanced → CPU Configuration
- **Check:**
  - CPU temperature (should be 30-45°C idle)
  - All 24 cores detected
  - Power limits (default is fine unless overclocking)

### **4. Fan Curves**

- **Location:** Settings → Hardware Monitor or Fan Control
- **Action:** Adjust if fans are too loud or too quiet
- **AIO Pump:** Should be connected to CPU_FAN or PUMP_FAN header

### **5. Resizable BAR (for GPU)**

- **Location:** Settings → Advanced → PCIe/PCI Subsystem Settings
- **Action:** Enable if you have a modern GPU (RTX 30-series or newer, RX 6000-series or newer)
- **Benefit:** Better GPU performance in some games

### **6. Secure Boot**

- **Location:** Settings → Security → Secure Boot
- **Status:** Check if enabled (Windows couldn't determine)
- **Note:** Can be enabled later if needed

---

## 🚀 How to Access BIOS

### **Method 1: During Boot (Recommended)**

1. Restart your PC
2. When you see the MSI logo, **spam the DELETE key** repeatedly
3. You'll enter BIOS/UEFI setup

### **Method 2: From Windows**

1. Settings → Update & Security → Recovery
2. Under "Advanced startup", click **Restart Now**
3. Troubleshoot → Advanced Options → UEFI Firmware Settings
4. Click Restart

---

## 📋 Quick BIOS Checklist

When you're in BIOS, check these:

- [ ] **XMP Profile 1** - ENABLED (for RAM speed)
- [ ] **Boot Order** - Windows drive first (already working)
- [ ] **CPU Temperature** - 30-45°C idle (check Hardware Monitor)
- [ ] **All 24 CPU cores** - Detected (should show in CPU info)
- [ ] **Fan Curves** - Adjust if needed (check noise levels)
- [ ] **Resizable BAR** - Enable if you have modern GPU
- [ ] **Secure Boot** - Check status (can enable later)

---

## ⚠️ Important Notes

1. **XMP is the most important** - Without it, your RAM may run slower than rated speed
2. **Don't change anything you're not sure about** - Default settings are usually fine
3. **Save before exiting** - Press F10 to save and exit BIOS
4. **CPU temps** - If idle temp is above 50°C, check AIO pump is running

---

## 🎯 Next Steps After BIOS Check

1. ✅ Verify XMP is enabled (RAM speed)
2. ✅ Check CPU temps are reasonable
3. ✅ Adjust fan curves if needed
4. ✅ Continue with driver installation from USB toolkit
5. ✅ Run system verification scripts

---

**Generated:** December 6, 2025  
**System:** MSI MEG Z890 GODLIKE + Intel Core Ultra 9 285K




