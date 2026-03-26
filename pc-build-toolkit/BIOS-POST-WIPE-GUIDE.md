# BIOS configuration guide — your exact setup (MEG Z890 GODLIKE)

**Use:** After a clean Windows install (or when verifying BIOS). Follow each step in order. No decisions — this is tailored to your machine.

**iPad / PDF:** Export to PDF with branding (save to OneDrive Documents) and open on iPad to follow at the PC.

---

## Your hardware (from CURRENT-HARDWARE.md)

| Component    | Your spec |
|-------------|-----------|
| **Motherboard** | MSI MEG Z890 GODLIKE (MS-7E21) |
| **CPU**         | Intel Core Ultra 9 285K (24 cores: 8P + 16E) |
| **RAM**         | 48 GB (2×24 GB) Corsair DDR5-8400 (CMHC48GX5M2X8400C40) |
| **Cooler**      | MSI MAG CoreLiquid i360 (AIO) |
| **GPU**         | *See CURRENT-HARDWARE.md — Resizable BAR step below is **skipped** for this build.* |

If you change any part (especially GPU), update CURRENT-HARDWARE.md and this guide.

---

## 1. Enter BIOS

- **From cold boot:** Restart PC → when MSI logo appears, press **DELETE** repeatedly.
- **From Windows:** Settings → Update & Security → Recovery → Advanced startup → Restart → Troubleshoot → Advanced options → **UEFI Firmware Settings** → Restart.

---

## 2. Settings to configure (in order)

### 2.1 XMP (RAM speed) — do this

- Go to: **Settings** → **Advanced** → **Memory Settings** → **XMP**.
- Set to **XMP Profile 1** (Enabled).
- **Your RAM:** 2×24 GB Corsair DDR5-8400 (CMHC48GX5M2X8400C40), so with XMP enabled it will run at **8400 MT/s**. Without XMP it runs at a lower SPD profile (e.g. 5600 MT/s).

### 2.2 Boot order — do this

- Go to: **Settings** → **Boot**.
- Set the **Windows drive** as first boot device.
- After a fresh install it is usually already correct; confirm and save.

### 2.3 CPU and cooling — check only

- Go to: **Settings** → **Advanced** → **CPU Configuration** (and **Hardware Monitor** if available).
- **Your CPU:** 24 cores (8P + 16E) — confirm all detected.
- Idle temp: about **30–45°C**. If much higher, check AIO pump and mounting.
- **Your cooler:** MSI MAG CoreLiquid i360 — pump should be on **CPU_FAN** or **PUMP_FAN** header.

### 2.4 Fan curves — optional

- **Settings** → **Hardware Monitor** or **Fan Control**.
- Adjust only if you want quieter or more aggressive fan behaviour. Default is fine for this build.

### 2.5 Resizable BAR — skip for your build

- **Do not enable** for your current setup. Your GPU (see CURRENT-HARDWARE.md) does not require it for this guide.
- If you later install an **NVIDIA RTX 30-series+** or **AMD RX 6000-series+**, go to **Settings** → **Advanced** → **PCIe/PCI Subsystem Settings** and enable **Resizable BAR**, then save. Until then, leave as default.

### 2.6 Secure Boot — check only

- **Settings** → **Security** → **Secure Boot**.
- Check whether it is enabled or disabled. You can leave as-is or enable later; no change required for this guide.

---

## 3. Save and exit

- Press **F10** → confirm **Save and exit**.
- PC restarts and boots into Windows.

---

## 4. Verify from Windows (optional)

- Run toolkit script: **`05-Scripts\04-check-bios-settings.ps1`**.
- Confirms: RAM speed (should show 8400 MHz with XMP), CPU, Secure Boot (if detectable).

---

## Checklist (tick as you go)

- [ ] Entered BIOS (DELETE at boot or UEFI Firmware Settings).
- [ ] **XMP Profile 1** — Enabled (RAM at 8400 MT/s).
- [ ] **Boot order** — Windows drive first.
- [ ] CPU / temps — checked (24 cores, idle ~30–45°C).
- [ ] Fan curves — left default (or adjusted if you wanted).
- [ ] **Resizable BAR** — Skipped (not used for your current GPU).
- [ ] Secure Boot — checked (no change required).
- [ ] **F10** — Save and exit.

---

*Tailored to: MEG Z890 GODLIKE, Core Ultra 9 285K, 2×24 GB Corsair DDR5-8400, MSI MAG CoreLiquid i360. Update CURRENT-HARDWARE.md if you change GPU or other parts. Last updated: 2026-02-22.*
