# 🏠 Tomorrow: Building SPECTRA Home L1-MVP

**Date:** December 5, 2025 (Tomorrow!)  
**Project:** SPECTRA Home - Unified Smart Home Platform  
**Goal:** Raspberry Pi + Home Assistant + All integrations working

---

## 🎯 **What We're Building:**

**SPECTRA Home L1-MVP:**
- Raspberry Pi running Home Assistant OS
- Philips Hue integration (all bulbs controllable)
- OpenRGB integration (PC RGB over network)
- Nanoleaf integration (wall panels)
- UniFi integration (network + presence detection)
- SPECTRA-branded dashboard
- Unified control from phone/web

**Result:** Control 1000+ light points from one interface! 🎨

---

## 📋 **Prerequisites (Have These Ready):**

### **Hardware:**
- ✅ Raspberry Pi 4 or 5 (4GB+ RAM)
- ✅ MicroSD card (32GB+, fast - Class 10 or better)
- ✅ Power supply (official Pi power supply recommended)
- ✅ Ethernet cable (connect to UniFi switch)
- ✅ Case with cooling (fan recommended)

### **Network Info Needed:**
- Your UniFi controller IP
- UniFi username/password
- Hue Bridge IP (or will auto-discover)
- PC IP address (for OpenRGB remote control)
- Router/gateway IP

### **Software:**
- Raspberry Pi Imager (download if not installed)
- Balena Etcher (alternative)

---

## ⏱️ **Timeline for Tomorrow:**

### **Phase 1: Flash Pi (30 minutes)**
```
1. Download Home Assistant OS image
2. Flash to microSD with Pi Imager
3. Insert card, boot Pi
4. Wait for Home Assistant to initialise (5-10 mins)
5. Access: http://homeassistant.local:8123
```

### **Phase 2: Initial Setup (15 minutes)**
```
1. Create Home Assistant account
2. Set location, timezone
3. Configure WiFi/Ethernet
4. Basic onboarding wizard
```

### **Phase 3: Philips Hue (15 minutes)**
```
1. Settings → Integrations → Add Hue
2. Auto-discovers Hue Bridge
3. Press bridge button to link
4. Imports all bulbs automatically
5. Test: Turn lights on/off from HA!
```

### **Phase 4: OpenRGB PC Control (20 minutes)**
```
1. Configure PC OpenRGB for remote access
2. Add OpenRGB integration to HA
3. Enter PC IP (192.168.1.xxx)
4. Discovers your 9 devices
5. Test: Control PC RGB from Pi!
```

### **Phase 5: Nanoleaf (15 minutes)**
```
1. Add Nanoleaf integration
2. Discover panels (cloud or local)
3. Import scenes
4. Test: Control panels from HA!
```

### **Phase 6: UniFi (20 minutes)**
```
1. Add UniFi integration
2. Enter controller IP/credentials
3. Imports network devices
4. Enables presence detection
5. Test: See who's home!
```

### **Phase 7: Dashboard (30 minutes)**
```
1. Create custom SPECTRA-branded dashboard
2. Add lighting controls
3. Add quick scenes (work/gaming/relax)
4. Add PC RGB control
5. Add network status
6. Mobile optimisation
```

### **Phase 8: Basic Automations (30 minutes)**
```
1. Morning routine (lights gradually brighten)
2. Work mode (PC + room lights sync)
3. Gaming mode (immersive lighting)
4. Leaving home (all off, arm cameras)
5. Arriving home (welcome scene)
```

**Total Time: ~3 hours**  
**Result: Complete unified smart home!** ✅

---

## 🎨 **What You'll Be Able to Do:**

### **From Phone/Web Dashboard:**
```
One interface controls:
  ✅ 806 PC RGB LEDs (OpenRGB)
  ✅ 10-50 Hue bulbs (Philips Hue)
  ✅ Nanoleaf panels (Shapes/Lines/Canvas)
  ✅ Quick scenes (work/gaming/relax/sleep)
  ✅ Network status (UniFi)
  ✅ Presence detection (who's home?)
```

### **Voice Control:**
```
"Hey Google, work mode"
  → PC RGB: Blue
  → Hue: Cool white
  → Nanoleaf: Focus gradient
  → ALL IN SYNC!
```

### **Automations:**
```
Calendar event starts →
  → Auto-switches to work mode
  → No manual control needed!
```

---

## 📦 **Downloads for Tomorrow:**

### **1. Home Assistant OS Image**
**Download:** https://www.home-assistant.io/installation/raspberrypi

**Choose:**
- Raspberry Pi 4 (64-bit) if you have Pi 4
- Raspberry Pi 5 (64-bit) if you have Pi 5

### **2. Raspberry Pi Imager**
**Download:** https://www.raspberrypi.com/software/

**Used to:** Flash Home Assistant to microSD card

---

## 🔧 **PC OpenRGB Configuration (Do Before Tomorrow):**

### **Enable Remote Access:**

**In OpenRGB on your PC:**
1. Settings → SDK Server
2. ✅ Check "Start server"
3. ✅ Check "Auto-start server"
4. ✅ Check "Allow remote connections" ⭐ **(Important!)**
5. Port: 6742 (default)

**Firewall (May be needed):**
```powershell
# Allow OpenRGB through Windows Firewall
New-NetFirewallRule -DisplayName "OpenRGB SDK" -Direction Inbound -Protocol TCP -LocalPort 6742 -Action Allow
```

---

## 🏠 **Network Configuration:**

### **Recommended Setup:**

**Raspberry Pi:**
- Static IP: 192.168.1.50 (or similar)
- Hostname: homeassistant.local
- Connected to: UniFi switch (wired, stable)

**Your PC:**
- Static IP: 192.168.1.100 (recommended)
- OpenRGB SDK: Port 6742 open
- Allow remote SDK connections

**Hue Bridge:**
- Should already be on network
- Will auto-discover

---

## 📋 **Tomorrow's Checklist:**

### **Before Starting:**
- [ ] Raspberry Pi hardware ready
- [ ] MicroSD card (32GB+) ready
- [ ] Home Assistant OS image downloaded
- [ ] Pi Imager software installed
- [ ] PC OpenRGB configured for remote access
- [ ] Know your network IPs
- [ ] 3 hours free time

### **During Setup:**
- [ ] Flash Home Assistant to microSD
- [ ] Boot Pi, access web UI
- [ ] Complete initial setup wizard
- [ ] Add Hue integration
- [ ] Add OpenRGB integration (PC remote)
- [ ] Add Nanoleaf integration
- [ ] Add UniFi integration
- [ ] Create SPECTRA dashboard
- [ ] Build basic automations
- [ ] Test voice control

### **After Completion:**
- [ ] Test all integrations
- [ ] Verify PC RGB control from Pi
- [ ] Verify Hue control
- [ ] Test quick scenes
- [ ] Document any issues
- [ ] Celebrate! 🎉

---

## 🎨 **Example Scenes We'll Create:**

**Morning Routine:**
- Hue: Gradual brightness (30 min sunrise)
- Nanoleaf: Sunrise animation
- PC: Wake mode (if on)

**Work Mode:**
- PC RGB: Focus blue
- Hue: Cool white (5000K)
- Nanoleaf: Productivity gradient
- UniFi: QoS priority for work devices

**Gaming Mode:**
- PC RGB: Rainbow wave
- Hue: Dim ambient (red/purple)
- Nanoleaf: Reactive gaming scene
- UniFi: QoS priority for PC

**Movie Mode:**
- PC RGB: Off or minimal
- Hue: Dim warm (10%)
- Nanoleaf: Backlight only

**Leaving Home:**
- All RGB: Off
- Hue: Security lights only
- UniFi: Arm cameras

**Arriving Home:**
- PC RGB: Welcome colour
- Hue: Welcome scene
- Nanoleaf: Welcome animation

---

## 🚀 **Success Criteria:**

**By tomorrow evening, you should be able to:**

✅ Open phone → Home Assistant app  
✅ Press "Work Mode" → All 1000+ lights sync  
✅ Say "Hey Google, gaming mode" → Immersive lighting  
✅ Leave house → Presence detected → Lights auto-adjust  
✅ Control PC RGB from anywhere  
✅ See network status, camera feeds  

**Complete unified smart home!** 🏠

---

## 📍 **Resources:**

**Documentation:**
- Full architecture: `Core/labs/queue/SPECTRA-HOME-ARCHITECTURE.md`
- Labs queue entry: `Core/labs/queue/ideas.json` (spectra-home-001)

**Current RGB Setup:**
- Scripts: `Core/tooling/system-optimisation/rgb-control/`
- Quick start: `rgb-control/QUICK-START.md`
- Device list: `rgb-control/YOUR-RGB-DEVICES.md`

**Tomorrow's Tools:**
- Home Assistant: https://www.home-assistant.io/
- Installation guide: https://www.home-assistant.io/installation/raspberrypi
- Hue integration: Built-in to HA
- OpenRGB integration: Available as HA addon

---

## 💡 **Quick Wins for Tomorrow:**

**Easiest integrations first:**
1. ✅ Hue (auto-discovers in 5 minutes!)
2. ✅ OpenRGB PC remote (20 minutes)
3. ✅ Quick scenes (30 minutes)

**Then if time:**
4. 🔄 Nanoleaf (15 minutes)
5. 🔄 UniFi (20 minutes)
6. 🔄 Automations (30 minutes)

**Even with just Hue + OpenRGB, you'll have unified lighting control!**

---

## 🎁 **The Vision:**

**Right now:**
- PC RGB: Manual Python scripts
- Hue: Separate Hue app
- Nanoleaf: Separate Nanoleaf app
- UniFi: Separate UniFi app

**Tomorrow evening:**
- **ONE interface controls EVERYTHING**
- **ONE command syncs all lighting**
- **Voice control for the lot**
- **Automations run themselves**

**That's the power of SPECTRA Home!** 🚀

---

*See you tomorrow! Get some rest - we're building something epic!* 🎄

---

**Saved as:** `Core/tooling/TOMORROW-SPECTRA-HOME.md`




