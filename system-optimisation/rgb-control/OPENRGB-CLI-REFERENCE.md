# OpenRGB CLI Reference

**Two ways to control OpenRGB:** CLI (direct) or SDK (Python)

---

## 🎯 **OpenRGB CLI Commands:**

### **Basic Usage:**

```powershell
# Assuming OpenRGB.exe is in PATH or use full path
OpenRGB.exe [options]
```

### **Common Commands:**

**List all devices:**

```powershell
OpenRGB.exe --list-devices
```

**Set colour (all devices):**

```powershell
# Hex colour format (RRGGBB)
OpenRGB.exe --color FF0000          # Red
OpenRGB.exe --color 0064FF          # Blue (work mode)
OpenRGB.exe --color FF9632          # Orange (relax mode)
OpenRGB.exe --color 000000          # Off
```

**Set colour (specific device):**

```powershell
# Get device ID from --list-devices first
OpenRGB.exe --device 0 --color FF0000
OpenRGB.exe --device "Razer Huntsman V2" --color 0064FF
```

**Set mode/effect:**

```powershell
OpenRGB.exe --mode "Rainbow Wave"
OpenRGB.exe --mode "Static"
OpenRGB.exe --mode "Breathing"
```

**Set brightness:**

```powershell
OpenRGB.exe --brightness 50         # 50%
OpenRGB.exe --brightness 100        # 100%
```

**Load saved profile:**

```powershell
OpenRGB.exe --profile "Work Mode"
OpenRGB.exe --profile "Gaming"
```

**Start SDK server (headless):**

```powershell
OpenRGB.exe --server --noautoconnect
```

**Connect to remote OpenRGB:**

```powershell
OpenRGB.exe --client 192.168.1.100
```

---

## 🎨 **SPECTRA Wrapper Scripts (Using CLI):**

### **Option A: PowerShell CLI Wrapper**

```powershell
# quick-rgb-cli.ps1

param([string]$Mode)

$openrgb = (Get-Process -Name "OpenRGB" -ErrorAction SilentlyContinue).Path

switch ($Mode) {
    "work" {
        & $openrgb --color 0064FF  # Blue
    }
    "gaming" {
        & $openrgb --mode "Rainbow Wave"
    }
    "relax" {
        & $openrgb --color FF9632  # Orange
    }
    "sleep" {
        & $openrgb --color 640000  # Dim red
    }
    "off" {
        & $openrgb --color 000000  # Off
    }
}
```

### **Option B: Python SDK (Current Method)**

```python
# rgb-control.py (what we built)

from openrgb import OpenRGBClient
client = OpenRGBClient()
client.devices[0].set_color(RGBColor(0, 100, 255))
```

---

## 💡 **CLI vs SDK Comparison:**

| Feature          | CLI                   | Python SDK                   |
| ---------------- | --------------------- | ---------------------------- |
| **Speed**        | Fast (one command)    | Fast (persistent connection) |
| **Simplicity**   | ✅ Very simple        | Medium (need Python)         |
| **Flexibility**  | Basic                 | ✅ Complete control          |
| **Verification** | ❌ No feedback        | ✅ Can query state           |
| **Scripting**    | ✅ Easy (PowerShell)  | ✅ Powerful (Python)         |
| **Effects**      | Basic modes only      | ✅ Custom animations         |
| **Per-device**   | ✅ Yes                | ✅ Yes                       |
| **Real-time**    | New process each time | ✅ Persistent connection     |

---

## 🎯 **For SPECTRA Monitoring:**

### **CLI Approach (Simpler):**

```powershell
# Set colour via CLI
OpenRGB.exe --color 0064FF

# Verify via screenshot (monitoring system)
$screenshot = Capture-Screenshot "keyboard"
$colour = Detect-Dominant-Colour $screenshot

if ($colour -eq "0064FF") {
    Write-Host "✅ RGB verified: Blue"
} else {
    Write-Host "❌ RGB mismatch: Expected blue, got $colour"
}
```

### **SDK Approach (Current):**

```python
# Set colour via SDK
from openrgb import OpenRGBClient
client = OpenRGBClient()
for device in client.devices:
    device.set_color(RGBColor(0, 100, 255))

# Verify via screenshot (monitoring system)
# Same visual verification as CLI
```

---

## 🚀 **Quick CLI Test:**

```powershell
# Get OpenRGB path
$openrgb = (Get-Process -Name "OpenRGB" -ErrorAction SilentlyContinue).Path

# List your devices
& $openrgb --list-devices

# Try work mode (blue)
& $openrgb --color 0064FF

# Try gaming mode (rainbow)
& $openrgb --mode "Rainbow Wave"

# Turn off
& $openrgb --color 000000
```

---

## 💡 **Both Methods Work Together:**

**CLI for:**

- Quick commands
- Simple scripts
- Batch operations
- Profile loading

**SDK for:**

- Advanced control
- Custom animations
- Real-time monitoring
- Complex logic

**We have BOTH available!** ✅

---

## 🎯 **For Monitoring/Verification:**

**Either method works, but needs visual verification:**

```
1. Send RGB command (CLI or SDK)
2. Screenshot device (monitoring system)
3. Analyse colours (image processing)
4. Verify match (expected vs actual)
5. Report result (success/failure)
```

**This is why SPECTRA Monitoring is critical!** 👁️

---

**Want me to create CLI-based alternatives to the Python scripts?** Or stick with SDK since it's more powerful? 🎨



