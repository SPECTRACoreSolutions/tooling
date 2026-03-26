# 🔵 All Lights Blue - Setup Guide

**Unified lighting control for OpenRGB, Philips Hue, and Nanoleaf**

---

## ✅ What Just Happened

Your **OpenRGB devices (PC RGB) are now blue!** ✨

The script successfully controlled:
- ✅ **6 OpenRGB devices** (keyboard, mouse, RAM, etc.)

To add Hue and Nanoleaf support, configure them below.

---

## 🎮 OpenRGB (Already Working!)

**Status:** ✅ Configured and working

Your PC RGB is controlled automatically. No configuration needed!

**Requirements:**
- OpenRGB running with SDK Server enabled
- Python package: `pip install openrgb-python`

---

## 💡 Philips Hue Setup

### Step 1: Find Your Hue Bridge IP

**Option A: From Hue App**
1. Open Philips Hue app
2. Settings → Hue Bridges
3. Note the IP address

**Option B: From Router**
1. Check your router's device list
2. Look for "Philips Hue Bridge" or similar
3. Note the IP address (usually 192.168.1.x)

**Option C: Auto-discover (Python)**
```python
import requests
response = requests.get("https://discovery.meethue.com/")
bridges = response.json()
print(bridges)  # Shows all bridges on network
```

### Step 2: Create Hue Username

The Hue Bridge requires a username (token) for API access.

**Quick Setup Script:**
```python
import httpx
import json

BRIDGE_IP = "192.168.1.xxx"  # Your bridge IP

# Press bridge button, then run this within 30 seconds
response = httpx.post(
    f"http://{BRIDGE_IP}/api",
    json={"devicetype": "SPECTRA#lights"},
    timeout=10.0
)

result = response.json()
print(json.dumps(result, indent=2))

# Save the username from the response!
```

**Or use the Hue app:**
1. Settings → Integrations → Philips Hue API
2. Create app/clip
3. Copy the username/token

### Step 3: Update Configuration

Edit `lighting-config.json`:
```json
{
  "hue_bridge_ip": "192.168.1.xxx",
  "hue_username": "your-username-here",
  ...
}
```

---

## ✨ Nanoleaf Setup

### Step 1: Find Your Nanoleaf IP

**From Nanoleaf App:**
1. Open Nanoleaf app
2. Settings → Device → Network
3. Note the IP address

**Or check router device list**

### Step 2: Get Auth Token

**Method 1: From Nanoleaf App (Easiest)**
1. Open Nanoleaf app
2. Settings → Device → Info
3. Copy the "Auth Token" or "API Key"

**Method 2: Generate Token (API)**

Press and hold the power button on your Nanoleaf controller for 5-7 seconds until LEDs start flashing. Then run:

```python
import httpx

NANOLEAF_IP = "192.168.1.xxx"  # Your panel IP

response = httpx.post(
    f"http://{NANOLEAF_IP}:16021/api/v1/new",
    timeout=10.0
)

token = response.json()["auth_token"]
print(f"Token: {token}")
# Save this token!
```

**Important:** You must press the power button within 30 seconds of running the script!

### Step 3: Update Configuration

Edit `lighting-config.json`:
```json
{
  "nanoleaf_ip": "192.168.1.xxx",
  "nanoleaf_token": "your-token-here",
  ...
}
```

---

## 🔧 Configuration File

**Location:** `Core/tooling/system-optimisation/rgb-control/lighting-config.json`

**Full Example:**
```json
{
  "hue_bridge_ip": "192.168.1.100",
  "hue_username": "abc123def456ghi789",
  "nanoleaf_ip": "192.168.1.101",
  "nanoleaf_token": "XYZ789ABC123DEF456",
  "openrgb_host": "127.0.0.1",
  "openrgb_port": 6742
}
```

The config file is automatically created on first run with empty values.

---

## 🚀 Usage

### Quick Commands

**PowerShell:**
```powershell
cd Core/tooling/system-optimisation/rgb-control
.\blue.ps1
```

**Python (Direct):**
```bash
python all_lights_blue.py
```

**Custom Blue:**
```bash
python all_lights_blue.py --color 0 150 255  # Lighter blue
python all_lights_blue.py --color 30 144 255 # Dodger blue
```

---

## 📦 Requirements

Install missing packages:

```bash
# For OpenRGB (PC RGB)
pip install openrgb-python

# For Hue and Nanoleaf (HTTP requests)
pip install httpx
```

---

## 🎨 Current Status

**Working:**
- ✅ OpenRGB (PC RGB) - 6 devices controlled

**Ready to configure:**
- 💡 Philips Hue (needs bridge IP + username)
- ✨ Nanoleaf (needs panel IP + auth token)

---

## 🆘 Troubleshooting

### OpenRGB Not Working

1. Make sure OpenRGB is running
2. Enable SDK Server: Settings → SDK Server → ✅ Start server
3. Check firewall allows port 6742

### Hue Not Working

1. Verify bridge IP is correct
2. Make sure username is valid (press bridge button if needed)
3. Check bridge is on same network

### Nanoleaf Not Working

1. Verify panel IP is correct
2. Make sure auth token is valid (may need to regenerate)
3. Check panel is powered on and connected

---

## 📚 Next Steps

Once all systems are configured:

1. **Quick scenes:** Create scripts for "work mode", "gaming mode", etc.
2. **Automations:** Integrate with Home Assistant (coming tomorrow!)
3. **Voice control:** Connect to Google Assistant/Amazon Alexa
4. **Custom colours:** Modify the script for your favourite colours

---

**Happy lighting!** 🎨✨




