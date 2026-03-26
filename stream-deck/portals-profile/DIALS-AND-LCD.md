# Stream Deck+ — Configuring Dials and LCD Strip

Dials and the touch strip are **configured in the Stream Deck desktop app**, not in the `.streamDeckProfile` file. After you install the Portals profile, use the steps below to set up the four dials and the LCD strip.

**Requirements:** Stream Deck 6.1+ (6.8+ for Action Trigger). Stream Deck+ hardware.

---

## 1. Open the Dials tab

1. Open **Stream Deck** (Elgato) and select your **Stream Deck+** device.
2. Switch to the **Dials** tab (below or beside the key grid).
3. You’ll see four dial slots, each with a segment on the **touch strip** above it.

---

## 2. Assign actions to each dial

- **Drag an action** from the left-hand panel onto a dial slot.
- Only actions that support **dials** will work (e.g. Volume Controller, Control Center brightness, some plugins). Keys-only actions can be used via **Action Trigger** (see below).

### Suggested layout (Windows)

| Dial | Action / Plugin | Rotate | Press / Tap strip |
|------|-----------------|--------|--------------------|
| **1** | **Volume Controller** → Manual Detection → e.g. “Default – System” or a specific app | System or app volume | Mute / unmute |
| **2** | **Volume Controller** → Manual Detection → e.g. Teams or browser | App volume | Mute / unmute |
| **3** | **Control Center** (if you use Elgato lights) **or** **Action Trigger** (e.g. brightness hotkeys) | Brightness / value | Toggle or reset |
| **4** | **Action Trigger** (e.g. scroll up/down, or page prev/next) | Scroll or page change | e.g. “Go to Page 1” |

### What people are actually doing with dials (from the wild)

Real use cases from video editors, streamers, designers, smart-home users, and power users. Pick what fits you.

---

**1. Dial stacks (one dial, multiple modes)**  
*Source: video editors (e.g. Jonny Elwyn), Stream Deck docs*

Use **Dial Stack** so one physical dial has several “layers”. **Press** the dial to cycle the mode; **rotate** to do the action for that mode. Example: one dial for “trim” with four modes—Ripple Trim, Trim to Playhead, Trim Frame by Frame, Trim Big—each with rotate = start/end of clip. Another example: Undo/Redo dial—rotate to blast backwards/forwards through undo history; press to jump to a state. Lets you pack many controls into four dials without memorising keys.

**How:** In Stream Deck, add a **Dial Stack** to a dial slot, then add multiple actions inside it. Press the dial to cycle; the strip updates to show the current mode.

---

**2. Video editing: timeline + colour**

- **Timeline zoom:** CW = zoom in, CCW = zoom out, press = fit timeline (e.g. `Shift+Z`). No mouse.
- **Jog / scrub:** Dials for timeline scrub, clip nudge, or scroll (Resolve/Premiere profiles from SideshowFX, BarRaider, or custom Action Trigger with arrow keys / J/K/L).
- **Colour grading:** Resolve/Premiere packs (e.g. SideshowFX) map dials to Lumetri/Resolve wheels—exposure, contrast, saturation, shadow/highlight. Touch strip shows parameter or value.
- **Stream Deck brightness:** Assign **Stream Deck Brightness** to a dial so you can dim the device in a dark edit suite (60–80% common for daylight; lower for grading).

---

**3. OBS / streaming**

- **Per-source volume:** OBS plugin “Audio Mixer” (or similar)—one dial per source; rotate = level, tap strip = mute. Strip shows level bar.
- **Camera control:** Plugins like **Dial Actions** (Lost Cause Photo): dial = ISO, shutter speed, aperture, or exposure comp; steps match camera; strip can show value.
- **Ad break (Streamer.bot etc.):** One dial: rotate = set ad length (e.g. 30s–5m), press = start ad; strip shows countdown or progress.

---

**4. Photoshop (native plugin)**

- **Brush size** on a dial (rotate = bigger/smaller).
- **Layer opacity** or **fill**.
- **Hue / saturation / lightness** (e.g. in adjustment layers).
- **Zoom** (CW/CCW) and **layer stack** (scroll layers).
- Strip shows value (e.g. brush %, opacity %). Requires Adobe Photoshop v22+ and Elgato Photoshop plugin.

---

**5. DAW (Ableton, Reaper)**

- **Track volume, pan, sends**—dials with two-way feedback; strip shows dB or value.
- **VST/plugin parameters**—map one dial to a macro or automation; rotate to sweep the parameter.
- **BPM** (rotate) and **scene launch** (press/tap). Often via MIDI/OSC plugins or vendor profiles (e.g. Reaper MC Stream Deck, Ableton profiles).

---

**6. Smart home (Home Assistant)**

- **Lights:** One dial per room or zone; rotate = dim/brighten, tap = on/off. Strip shows brightness or state.
- **Climate:** Dial = set target temperature; strip shows current/target.
- **Dashboard:** Strip or keys show sensor tiles (solar, router, server, door). Plugins: e.g. `streamdeck-homeassistant`, or YAML-based setups (e.g. home-assistant-streamdeck-yaml) that support “dial controls” for dimming and similar.

---

**7. Mic input (no system volume)**

- **Volume Controller** → Manual Detection → choose your **recording device** (mic). Rotate = input level, tap strip = mute. Used for voice-in-Cursor (Win+H), Teams, Discord, recordings. Strip shows input level.

---

**Quick takeaway**

The dials people stick with are usually: **one continuous parameter per dial** (volume, brightness, brush size, temperature, trim amount) with **press/tap for a related toggle or mode switch**, and **Dial Stacks** when one dial should switch between several such parameters. The strip is used for **value/state feedback** or **mode labels**. Start with one or two dials (e.g. mic + Stream Deck brightness, or timeline zoom + one stack), then add more as your workflow demands.

### Volume Controller (recommended for dials 1–2)

- **Plugin:** [Volume Controller](https://apps.elgato.com/plugins/com.elgato.volume-controller) (built in with Stream Deck 6.1).
- In the **Dials** tab, open **Volume Controller** and drag **Manual Detection** onto a dial.
- In the action settings, choose the **application** (e.g. System, Teams, Chrome). Rotate = volume; press or tap the strip = mute.

### Action Trigger (for dials without native support)

- **Stream Deck 6.8+** required.
- Right‑click a dial → **Create Action Trigger**, or find **Action Trigger** in the Dials section.
- Assign up to **three actions** per dial:
  - **Clockwise** — e.g. “System Hotkey: Volume Up” or “Next Page”
  - **Counter‑clockwise** — e.g. “Volume Down” or “Previous Page”
  - **Press** — e.g. “Mute” or “Go to Page 1”
- The assigned actions are shown on the **touch strip** for that dial.

---

## 3. Touch strip behaviour

- **Tap** — Often triggers a secondary action (e.g. toggle mute when the dial is Volume).
- **Tap-and-hold** — Plugin‑dependent (e.g. reset zoom or default value).
- **Swipe** (left/right) — Change **pages** (only if you have two or more pages).

The strip is split into four segments, one per dial. What you see on each segment (icon, bar, value) is defined by the **dial action** (e.g. Volume Controller shows a level indicator).

---

## 4. Customise the touch strip appearance

- **Right‑click the touch strip** in the Stream Deck app.
- You can adjust three layers:
  1. **Dial action icon** — What the action displays (often fixed by the plugin).
  2. **Dial background** — Background for each dial segment.
  3. **Touch strip background** — Overall strip background.

---

## 5. Quick reference

| Goal | Where to do it |
|-----|----------------|
| Assign volume to a dial | Dials tab → Volume Controller → Manual Detection → drag onto dial → pick app |
| Assign keypresses to a dial (e.g. scroll, brightness hotkeys) | Dials tab → Action Trigger → drag onto dial → set CW / CCW / Press |
| Change what the strip shows | Defined by the dial action; some plugins allow layout choice |
| Change strip look | Right‑click touch strip → Dial background / Touch strip background |
| Swipe between pages | Add a second page in the profile; swipe left/right on the strip |

---

## 6. Notes

- The **Portals** profile generated by `generate.js` does **not** set dial or LCD content; it only defines the **eight key** actions. Dial and strip setup is stored in the app after you assign actions.
- For **system volume** on Windows, use Volume Controller with “Default – System” (or your main output device).
- For **monitor brightness** on Windows, you may need a third‑party plugin or Action Trigger with an app that supports brightness hotkeys; there is no built‑in Windows brightness dial in Stream Deck.
