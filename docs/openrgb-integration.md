# OpenRGB Integration with SPECTRA

**How SPECTRA AI Can Control Your RGB Lighting**

---

## 🎨 **What is OpenRGB?**

OpenRGB is a **lightweight, open-source** RGB control software that:
- ✅ Uses **50-100 MB RAM** (vs SignalRGB's 800+ MB!)
- ✅ Minimal CPU overhead
- ✅ Supports 200+ devices (Razer, Corsair, Logitech, ASUS, MSI, etc.)
- ✅ Has **CLI and SDK** (programmable!)
- ✅ Cross-platform (Windows, Linux, macOS)

**Download:** https://openrgb.org/

---

## 🤖 **How I Can Control OpenRGB:**

### **Method 1: CLI (Command Line)**

OpenRGB has a CLI that I can call from PowerShell/Python:

```bash
# Set all devices to red
OpenRGB.exe --color FF0000

# Set specific device
OpenRGB.exe --device 0 --color 00FF00

# Load a saved profile
OpenRGB.exe --profile "Gaming.orp"

# Set mode (static, breathing, rainbow, etc.)
OpenRGB.exe --mode static --color 0000FF
```

### **Method 2: SDK (Direct Control)**

OpenRGB has a Python SDK for direct control:

```python
from openrgb import OpenRGBClient
from openrgb.utils import RGBColor

# Connect to OpenRGB
client = OpenRGBClient()

# Set all devices to blue
for device in client.devices:
    device.set_color(RGBColor(0, 0, 255))

# Set specific device
keyboard = client.get_devices_by_name("Razer BlackWidow")[0]
keyboard.set_color(RGBColor(255, 0, 255))  # Purple

# Per-LED control
for led in keyboard.leds:
    led.set_color(RGBColor(255, 255, 0))  # Yellow
```

### **Method 3: HTTP API**

OpenRGB can run as a server with REST API access.

---

## 🎯 **What I Can Build For You:**

### **1. Time-Based Profiles**
```powershell
# Morning (8 AM): Warm white
# Work hours (9-5): Focus blue
# Evening (6 PM): Relaxing warm
# Night (10 PM): Dim red
```

### **2. System Event Reactions**
```python
# CPU temp > 80°C → Turn red
# Build successful → Green pulse
# Error/alert → Red flash
# Low battery → Orange fade
```

### **3. Activity-Based**
```python
# Coding mode → Blue/purple
# Gaming mode → Aggressive rainbow
# Meeting/call → Muted colors
# Focus mode → Single calming color
```

### **4. Notification Lighting**
```python
# Email received → Quick blue flash
# Calendar reminder → Yellow pulse
# Teams message → Purple blink
```

### **5. Voice Control Integration**
```
"Set RGB to red"
"Gaming mode"
"Turn off RGB"
"Breathing effect blue"
```

---

## 📦 **Installation & Setup:**

### **Step 1: Install OpenRGB**
1. Download from https://openrgb.org/
2. Extract and run `OpenRGB.exe`
3. It will auto-detect your RGB devices

### **Step 2: Enable SDK Server**
1. Open OpenRGB
2. Go to **SDK Server** tab
3. Click **Start Server**
4. Check **Auto-start server**

### **Step 3: Test CLI**
```powershell
# Navigate to OpenRGB folder
cd "C:\Program Files\OpenRGB"

# Test command
.\OpenRGB.exe --list-devices
.\OpenRGB.exe --color FF0000  # All red
```

### **Step 4: Install Python SDK (Optional)**
```powershell
pip install openrgb-python
```

---

## 🚀 **Example SPECTRA Scripts I Can Create:**

### **Script 1: Smart RGB Automation**
```python
# File: Core/tooling/openrgb-smart-controller.py

from openrgb import OpenRGBClient
from datetime import datetime
import psutil

client = OpenRGBClient()

def set_time_based_colors():
    hour = datetime.now().hour
    
    if 8 <= hour < 12:  # Morning
        client.set_color(RGBColor(255, 200, 150))  # Warm white
    elif 12 <= hour < 18:  # Afternoon
        client.set_color(RGBColor(100, 150, 255))  # Cool blue
    elif 18 <= hour < 22:  # Evening
        client.set_color(RGBColor(255, 150, 100))  # Warm orange
    else:  # Night
        client.set_color(RGBColor(100, 0, 0))  # Dim red

def react_to_cpu_temp():
    temps = psutil.sensors_temperatures()
    cpu_temp = temps['coretemp'][0].current
    
    if cpu_temp > 80:
        client.set_color(RGBColor(255, 0, 0))  # Hot = Red
    elif cpu_temp > 70:
        client.set_color(RGBColor(255, 165, 0))  # Warm = Orange
    else:
        set_time_based_colors()  # Normal

# Run automation
while True:
    react_to_cpu_temp()
    time.sleep(5)
```

### **Script 2: Quick Profiles (PowerShell)**
```powershell
# File: Core/tooling/rgb-profiles.ps1

function Set-RGBProfile {
    param([string]$Profile)
    
    $openRgbPath = "C:\Program Files\OpenRGB\OpenRGB.exe"
    
    switch ($Profile) {
        "work" {
            & $openRgbPath --mode static --color 4080FF  # Focus blue
        }
        "gaming" {
            & $openRgbPath --mode rainbow
        }
        "movie" {
            & $openRgbPath --mode static --color 200020  # Dim purple
        }
        "off" {
            & $openRgbPath --mode static --color 000000  # Off
        }
    }
}

# Usage:
# Set-RGBProfile work
# Set-RGBProfile gaming
```

### **Script 3: Voice Command Integration**
```python
# Coming soon: Integrate with Windows Speech Recognition
# "Hey SPECTRA, set RGB to gaming mode"
# "Hey SPECTRA, turn off RGB"
```

---

## 📊 **Performance Comparison:**

| Feature | SignalRGB | OpenRGB |
|---------|-----------|---------|
| RAM Usage | 800+ MB | 50-100 MB |
| CPU Usage | High | Low |
| Startup Time | 10-15s | 2-3s |
| Automation | Limited | Full API |
| Cost | Free | Free |
| Open Source | No | Yes |

**Winner:** OpenRGB (8-10x more efficient!)

---

## 🎁 **What Happens After You Install:**

1. **Immediate:** 
   - 700-800 MB RAM freed up
   - Smoother system performance
   - Faster startup

2. **I can then create:**
   - Custom automation scripts
   - Voice control integration
   - System event reactions
   - Time-based profiles
   - Hotkey shortcuts

3. **You get:**
   - Same RGB control (or better!)
   - Way less system overhead
   - Programmable lighting effects
   - SPECTRA AI integration 🤖

---

## 🚀 **Quick Start After Installation:**

1. Install OpenRGB
2. Run: `.\system-optimizer.ps1` (to verify improvement)
3. Tell me: "Create RGB automation scripts"
4. I'll build custom controllers based on your preferences!

---

## 💡 **Future Possibilities:**

- **Home automation:** Sync with Philips Hue
- **Productivity:** Focus mode dims RGB automatically
- **Gaming:** Per-game RGB profiles
- **Health:** Breathing exercises with color sync
- **Notifications:** Calendar/email visual alerts

---

**Ready to install OpenRGB?** Let me know when you've installed it and I'll create your first automation scripts! 🎨

---

**Created:** December 4, 2025  
**Part of:** SPECTRA Core Tooling  
**Status:** Ready to implement


