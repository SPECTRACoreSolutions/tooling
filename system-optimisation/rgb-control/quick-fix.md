# ⚡ Quick Fix: Disable Synapse RGB (2 Minutes)

**Problem:** Synapse is overriding your blue lights  
**Solution:** Disable RGB in Synapse, keep profiles working

---

## ✅ **Simple 3-Step Fix:**

### **Step 1: Open Razer Synapse**

- Look for Razer icon in system tray (bottom right)
- Or search "Razer Synapse" in Start menu

### **Step 2: Disable Chroma RGB**

1. Click **"CHROMA STUDIO"** tab (or icon)
2. Turn **OFF** "Enable Chroma" toggle
   - OR set all devices to "Static" → Black colour
   - OR set brightness to 0%

### **Step 3: Test**

```powershell
python all_lights_blue.py
```

**Colours should stick now!** ✅

---

## 🎯 **What This Does:**

- ✅ **Tartarus profiles:** Still work (Synapse still running)
- ✅ **RGB control:** OpenRGB takes over (Synapse RGB disabled)
- ✅ **No interference:** Synapse won't override colours anymore

---

## 💡 **Alternative: Per-Device Settings**

If Chroma Studio doesn't work, disable RGB per device:

1. **Click on each device** (Huntsman, Tartarus, etc.)
2. **Find "Lighting" or "Chroma" settings**
3. **Set to "Off" or "Hardware Playback"**

---

## 🚀 **Quick Test Script:**

Run this to see current status:

```powershell
.\disable-synapse-rgb.ps1
```

Then follow the manual steps it shows.

---

**After disabling RGB in Synapse, your OpenRGB scripts will work perfectly!** 🎨




