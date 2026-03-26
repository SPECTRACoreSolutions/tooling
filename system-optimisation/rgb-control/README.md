# 🎨 SPECTRA RGB Control

Complete RGB automation for your PC via OpenRGB SDK.

---

## 🎯 **What This Is:**

Programmatic control of ALL your RGB devices:

- Motherboard RGB (Z890 GODLIKE)
- RAM RGB
- Razer Keyboard
- Razer Mouse
- Case fans
- AIO cooler display

**Control methods:**

- PowerShell scripts (quick profiles)
- Python scripts (advanced control)
- Temperature-reactive automation
- Time-based scenes
- **SPECTRA AI integration** (future)

---

## 📋 **Prerequisites:**

### **1. OpenRGB Running with SDK Server**

✅ OpenRGB installed
✅ SDK Server enabled (Settings → SDK Server → Start Server)
✅ Auto-start server enabled

### **2. Python Dependencies**

```powershell
pip install openrgb-python psutil
```

---

## 🚀 **Quick Start:**

### **PowerShell (Simple Profiles):**

```powershell
# Show available profiles
.\quick-rgb.ps1 list

# Set work mode (focus blue)
.\quick-rgb.ps1 work

# Set gaming mode
.\quick-rgb.ps1 gaming

# Turn off RGB
.\quick-rgb.ps1 off
```

### **Python (Advanced Control):**

```powershell
# Show help
python rgb_control.py help

# Set work mode
python rgb_control.py work

# Gaming rainbow
python rgb_control.py gaming

# Breathing effect
python rgb_control.py breathe

# Flash notification
python rgb_control.py flash

# List all devices
python rgb_control.py list
```

### **CPU Temperature Monitor:**

```powershell
# Start temperature-reactive RGB
python cpu_temp_rgb.py

# RGB changes colour based on CPU temp:
# Blue (cool) → Cyan → Green → Yellow → Orange → Red (critical!)
```

---

## 🎨 **Available Profiles:**

### **Work Mode** 🔵

- **Colour:** RGB(0, 100, 255) - Focus Blue
- **Purpose:** Calm, productive, reduces eye strain
- **Best for:** Deep work, coding, documentation

### **Gaming Mode** 🌈

- **Effect:** Rainbow wave / Animated cycling
- **Purpose:** Energetic, dynamic, immersive
- **Best for:** Gaming sessions, streaming

### **Relax Mode** 🟠

- **Colour:** RGB(255, 150, 50) - Warm Orange
- **Purpose:** Cosy, comfortable, evening vibes
- **Best for:** Evening browsing, casual use

### **Sleep Mode** 🔴

- **Colour:** RGB(100, 0, 0) - Dim Red
- **Purpose:** Night-friendly, minimal blue light
- **Best for:** Late night work, pre-bedtime

### **Off Mode** ⚫

- **Colour:** RGB(0, 0, 0) - All off
- **Purpose:** Complete darkness
- **Best for:** Focus, sleeping, power saving

---

## 🛠️ **Advanced Usage:**

### **Create Custom Profiles:**

Edit `rgb_control.py` and add your own colours:

```python
def custom_mode(self):
    """My custom purple mode"""
    self.set_colour(128, 0, 255, "Custom Purple")
```

### **Hotkey Shortcuts:**

Create Windows shortcuts with hotkeys:

1. Right-click `quick-rgb.ps1` → Create Shortcut
2. Right-click shortcut → Properties
3. Shortcut Key: Set to `Ctrl+Alt+1` (or any key)
4. Repeat for each mode

**Result:** Instant RGB changes with keyboard shortcuts!

### **Scheduled Task (Time-Based):**

Create Windows Task Scheduler tasks:

- 8 AM: Work mode
- 6 PM: Relax mode
- 10 PM: Sleep mode

---

## 🌡️ **CPU Temperature Reactive RGB:**

**What it does:**

- Continuously monitors CPU temperature
- Changes RGB colour based on temperature
- Real-time visual feedback

**Colour Scale:**

```
  < 50°C  →  Blue     (Cool ❄️)
  50-60°C →  Cyan     (Comfortable 😊)
  60-70°C →  Green    (Warm 🌡️)
  70-80°C →  Yellow   (Getting Hot 🔥)
  80-85°C →  Orange   (Hot! ⚠️)
  > 85°C  →  Red      (CRITICAL! 🚨)
```

**Run it:**

```powershell
python cpu_temp_rgb.py
```

**Use case:** Gaming sessions, stress tests, overclocking

---

## 🏠 **SPECTRA Home Integration (Future):**

When SPECTRA Home is ready, these RGB scripts will integrate:

```python
# SPECTRA AI will be able to:
spectra.rgb.work()              # Set work mode
spectra.rgb.react_to_temp()     # Auto temperature monitoring
spectra.rgb.sync_with_hue()     # Sync with room lights
spectra.rgb.notification(red)   # Flash for alerts
```

**Example automations:**

- Calendar event starts → Work mode
- Game launches → Gaming mode
- CPU temp > 80°C → Flash red + notification
- Leaving home → Off
- Arriving home → Welcome scene

---

## 🔧 **Troubleshooting:**

### **"Failed to connect to OpenRGB"**

- ✅ Check OpenRGB is running
- ✅ Check SDK Server is started (Settings → SDK Server)
- ✅ Check port 6742 is not blocked

### **"openrgb-python not installed"**

```powershell
pip install openrgb-python
```

### **"Unable to read CPU temperature"**

- Windows may not expose CPU temps via psutil
- Alternative: Use Open Hardware Monitor / LibreHardwareMonitor
- Or: MSI Center provides temperature APIs

### **"Device not responding"**

- Some devices need firmware updates for OpenRGB support
- Check: https://openrgb.org/devices.html
- Try: Restart OpenRGB, rescan devices

---

## 📊 **What Devices Are Supported?**

**Run this to see your devices:**

```powershell
python rgb_control.py list
```

**Should detect:**

- ✅ Motherboard RGB (MSI Z890 GODLIKE)
- ✅ RAM RGB (if Corsair has RGB)
- ✅ Razer Keyboard
- ✅ Razer Mouse
- ✅ Any ARGB devices connected to motherboard headers

**Note:** Razer devices require Razer SDK plugin for OpenRGB (may need separate setup).

---

## 🎯 **Next Steps:**

### **Immediate:**

1. ✅ Test profiles: `python rgb_control.py work`
2. ✅ Try temperature monitor: `python cpu_temp_rgb.py`
3. ✅ Create hotkey shortcuts for quick changes

### **Near Future:**

1. 🔄 Integrate with SPECTRA Home (Raspberry Pi)
2. 🔄 Add Home Assistant control
3. 🔄 Sync with Philips Hue room lights
4. 🔄 Voice control via Google/Alexa

### **Long Term:**

1. ⏳ AI-driven scene selection (SPECTRA learns preferences)
2. ⏳ Context-aware automation (calendar, apps, time)
3. ⏳ Music-reactive RGB
4. ⏳ Screen colour sync (Ambilight-style)

---

## 💡 **Tips:**

### **Performance:**

- RGB updates are instant (< 100ms)
- Temperature monitoring uses minimal CPU (< 1%)
- SDK Server uses ~50-100 MB RAM

### **Best Practices:**

- **Work:** Blue light for focus (morning/day)
- **Relax:** Warm colours for comfort (evening)
- **Sleep:** Red/off for night (minimal blue light)
- **Gaming:** Dynamic/bright for immersion

### **Health:**

- Blue light evening → disrupts sleep
- Warm light evening → better sleep
- Dim red night → preserves night vision
- Follow circadian rhythm!

---

## 🎨 **Created by SPECTRA AI**

_Part of the SPECTRA Home ecosystem_

**Files:**

- `quick-rgb.ps1` - Quick PowerShell profiles
- `rgb_control.py` - Advanced Python control
- `cpu_temp_rgb.py` - Temperature-reactive RGB
- `README.md` - This file

**Future additions:**

- Time-based automation (morning/evening transitions)
- Calendar integration (meeting modes)
- Application-based scenes (game launches → gaming mode)
- SPECTRA Home dashboard control

---

## 🚀 **Get Started:**

```powershell
# Try it now!
cd C:\Users\markm\OneDrive\SPECTRA\Core\tooling\system-optimisation\rgb-control

# Quick test
python rgb_control.py work

# Temperature monitor
python cpu_temp_rgb.py

# Enjoy your automated RGB! 🎨
```

---

**Questions? Check:** `Core/labs/queue/SPECTRA-HOME-ARCHITECTURE.md` for the full vision!









