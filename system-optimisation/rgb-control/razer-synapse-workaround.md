# 🎮 Razer Synapse Workaround - Keep Profiles, Control RGB

**Problem:** Razer Synapse overrides OpenRGB colour settings  
**Goal:** Keep Tartarus profiles, remove RGB interference

---

## 🎯 **Solution Options:**

### **Option 1: Disable RGB in Synapse (Easiest)** ⭐ **RECOMMENDED**

Keep Synapse running for Tartarus profiles, but disable RGB control.

**Steps:**

1. **Open Razer Synapse**
2. **Settings → Chroma Studio**
3. **Disable Chroma effects:**
   - Turn off "Enable Chroma"
   - Or set all devices to "Static" → Black (0, 0, 0)
4. **Settings → Devices**
   - For each device: **Disable lighting control**
   - Or set to "Hardware playback" (stores profile on device)

**Result:**

- ✅ Tartarus profiles still work
- ✅ Synapse doesn't override RGB
- ✅ OpenRGB controls colours
- ⚠️ Synapse still running (but not controlling RGB)

**RAM Usage:** ~300-400 MB (better than before)

---

### **Option 2: Minimal Synapse Installation**

Install only the minimum components needed for profiles.

**Steps:**

1. **Uninstall full Synapse**
2. **Download Razer Synapse 3 Minimal**
   - Look for "lite" or "core" version
   - Or custom install (only keybindings module)
3. **Reinstall with minimal components:**
   - ✅ Keybindings/Profiles
   - ❌ Chroma RGB control
   - ❌ Cloud sync (optional)
   - ❌ Analytics/tracking

**Result:**

- ✅ Profiles work
- ✅ No RGB interference
- ✅ Lower RAM usage

**Note:** May not be available as separate download

---

### **Option 3: Hardware Profile Storage** ❌ **NOT AVAILABLE**

**Unfortunately, Tartarus Pro does NOT support onboard memory/profiles.**

According to Razer support:

- Tartarus relies on Synapse for profile management
- No hardware profile storage available
- Profiles require Synapse to be running

**This option is not available for Tartarus.**

---

### **Option 4: Alternative Software**

Replace Synapse with lighter alternatives.

#### **A. AutoHotkey (Free, Powerful)**

**Pros:**

- ✅ Much lighter (~10 MB RAM)
- ✅ More powerful than Synapse
- ✅ Open source
- ✅ Full control

**Cons:**

- ⚠️ Requires scripting knowledge
- ⚠️ Manual setup needed

**Quick Start:**

1. Download AutoHotkey v2
2. Create script for Tartarus buttons
3. Map keys as needed

**Example Script:**

```autohotkey
; Tartarus Pro Profile Script
; Save as tartarus-profile.ahk

; Example: Button 1 = Escape
SC15B::Send "{Escape}"

; Example: Button 2 = Ctrl+C
SC15C::Send "^c"

; Example: Button 3 = Ctrl+V
SC15D::Send "^v"

; Add all your key mappings here
```

**Get Key Codes:**

- Use AutoHotkey Window Spy
- Press each Tartarus button
- Copy the scan code (SC####)

#### **B. ReWASD (Paid Alternative)**

**Pros:**

- ✅ Professional software
- ✅ Lighter than Synapse
- ✅ Better RGB control options
- ✅ Works with many devices

**Cons:**

- ⚠️ Paid software (~$20)
- ⚠️ Learning curve

---

### **Option 5: Export Profiles + AutoHotkey**

Save your current profiles, then recreate in AutoHotkey.

**Steps:**

1. **Export current profiles:**
   - Open Synapse
   - Note all keybindings
   - Screenshot profiles
   - Document macros
2. **Recreate in AutoHotkey:**
   - Create `.ahk` script
   - Map all buttons
   - Test thoroughly
3. **Uninstall Synapse**

**Result:**

- ✅ Exact same functionality
- ✅ Zero Synapse dependency
- ✅ Full RGB control via OpenRGB

---

## 🔍 **Recommended Approach:**

### **Phase 1: Quick Fix (5 minutes)**

1. Open Synapse → Settings → Chroma Studio
2. Disable all RGB effects
3. Set devices to "Hardware playback" if available
4. Test OpenRGB control

**This gives you immediate RGB control!**

### **Phase 2: Check Hardware Profiles (10 minutes)**

1. Check if Tartarus Pro supports hardware storage
2. If yes: Save profile to device, uninstall Synapse
3. If no: Continue to Phase 3

### **Phase 3: Long-term Solution (30-60 minutes)**

1. Document all Tartarus keybindings
2. Create AutoHotkey script
3. Test thoroughly
4. Uninstall Synapse

---

## 📋 **Action Plan:**

### **Right Now (Quick Win):**

```powershell
# 1. Open Synapse
# 2. Disable Chroma RGB
# 3. Test OpenRGB
python all_lights_blue.py
```

### **This Week (Proper Fix):**

1. Check hardware profile support
2. Export/backup current profiles
3. Choose replacement (AutoHotkey or minimal Synapse)
4. Test and migrate

---

## 🎯 **Priority Check:**

**Answer these:**

1. **Does Tartarus Pro support hardware profiles?**

   - Check Synapse settings
   - Look for "Onboard Memory" or "Hardware Playback"

2. **How complex are your profiles?**

   - Simple key remaps? → Easy AutoHotkey migration
   - Complex macros? → Might need to keep Synapse

3. **RAM usage concern?**
   - If minimal: Keep Synapse, disable RGB
   - If critical: Migrate to AutoHotkey

---

## 💡 **Quick Test:**

**Try this right now:**

1. Open Synapse
2. Go to Chroma Studio
3. Turn off all lighting effects
4. Run: `python all_lights_blue.py`
5. Check if colour sticks

**If it works:** You've solved it! Just disable RGB in Synapse.

**If it doesn't:** We need Option 3 or 4.

---

## 📚 **Resources:**

**AutoHotkey:**

- Website: https://www.autohotkey.com/
- Documentation: https://www.autohotkey.com/docs/
- Forum: https://www.autohotkey.com/boards/

**Razer Hardware Profiles:**

- Check Synapse → Device Settings → Onboard Memory
- Not all devices support this

**ReWASD:**

- Website: https://www.rewasd.com/
- Free trial available

---

## ✅ **Recommended Solution:**

**For immediate fix:**
→ **Disable RGB in Synapse** (Option 1)

**For permanent solution:**
→ **Check hardware profiles first** (Option 3)
→ **If not supported: AutoHotkey migration** (Option 5)

**Best of both worlds:**
→ Keep Synapse for profiles, disable RGB
→ Use OpenRGB for all lighting control

---

**Want me to help you check if Tartarus Pro supports hardware profiles, or create an AutoHotkey script?** 🚀
