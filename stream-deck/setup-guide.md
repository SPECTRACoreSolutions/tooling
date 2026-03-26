# Stream Deck Setup Guide

**Complete guide for setting up your Elgato Stream Deck with SPECTRA workflows**

---

## 📋 Prerequisites

Before you begin, ensure you have:

- ✅ Elgato Stream Deck device (any model)
- ✅ USB cable (included with device)
- ✅ Windows 10/11 computer
- ✅ Administrator access (for some actions)
- ✅ SPECTRA workspace set up

---

## 🔧 Step 1: Install Stream Deck Software

### **Download & Install**

1. Visit [Elgato Downloads](https://www.elgato.com/en/downloads)
2. Download **Stream Deck** software (latest version)
3. Run installer and follow prompts
4. Launch Stream Deck application

### **First Launch**

1. Connect Stream Deck device via USB
2. Stream Deck software should detect device automatically
3. If not detected, check USB connection and try different port
4. Device should appear in software with button grid

---

## 📥 Step 2: Import SPECTRA Profiles

### **Method 1: Import from File**

1. Open Stream Deck software
2. Click **Profiles** menu → **Import Profile**
3. Navigate to: `C:\Users\markm\OneDrive\SPECTRA\Core\tooling\stream-deck\profiles\`
4. Select profile file (e.g., `SPECTRA-Development.sdProfile`)
5. Click **Open**
6. Profile appears in profile list
7. Click profile name to activate

### **Method 2: Copy Profile Files**

1. Stream Deck profiles are stored in:
   ```
   %AppData%\Elgato\StreamDeck\Profiles\
   ```
2. Copy `.sdProfile` files from `Core/tooling/stream-deck/profiles/` to this location
3. Restart Stream Deck software
4. Profiles appear in profile list

### **Available Profiles**

- **SPECTRA-Development.sdProfile** - Development workflows
- **SPECTRA-Deployment.sdProfile** - Deployment shortcuts
- **SPECTRA-Productivity.sdProfile** - General productivity

---

## ⚙️ Step 3: Configure Actions

### **System Actions**

**Open Application:**

1. Drag **System** → **Open** action to button
2. Click button to configure
3. Browse to application executable
4. Set title/icon if desired

**Example: Open Cursor**

- Action: System → Open
- Path: `C:\Users\markm\AppData\Local\Programs\cursor\Cursor.exe`
- Title: "Cursor"

### **Hotkey Actions**

**Keyboard Shortcuts:**

1. Drag **System** → **Hotkey** action to button
2. Click button to configure
3. Press desired key combination
4. Stream Deck records shortcut

**Example: Git Commit**

- Action: System → Hotkey
- Hotkey: `Ctrl+Shift+G` (or your Git commit shortcut)
- Title: "Git Commit"

### **Multi Action**

**Multiple Actions on One Button:**

1. Drag **System** → **Multi Action** to button
2. Click button to configure
3. Add multiple actions (Open app, Hotkey, etc.)
4. Actions execute in sequence

**Example: Deploy Service**

- Action 1: Open Terminal
- Action 2: Hotkey (type command)
- Action 3: Hotkey (Enter)

### **Text Actions**

**Type Text/String:**

1. Drag **System** → **Text** action to button
2. Click button to configure
3. Enter text to type
4. Optionally add delay between characters

**Example: Quick Commands**

- Text: `cd C:\Users\markm\OneDrive\SPECTRA`
- Title: "Go to SPECTRA"

### **Website Actions**

**Open URLs:**

1. Drag **System** → **Website** action to button
2. Click button to configure
3. Enter URL
4. Choose browser (default or specific)

**Example: Open GitHub**

- URL: `https://github.com/SPECTRACoreSolutions`
- Title: "GitHub"

---

## 🎨 Step 4: Customise Icons

### **Using Built-in Icons**

1. Click button in Stream Deck software
2. Click icon area
3. Browse built-in icon library
4. Select icon
5. Adjust size/position if needed

### **Using Custom Icons**

1. Prepare icon image (72x72 pixels recommended)
2. Save to `Core/tooling/stream-deck/icons/`
3. Click button in Stream Deck software
4. Click icon area → **Choose File**
5. Navigate to icon file
6. Select and apply

### **SPECTRA Branding**

- Use SPECTRA logo for main profile buttons
- Custom icons available in `icons/` directory
- Maintain consistent style across profiles

---

## 🔌 Step 5: Install Plugins (Optional)

### **Recommended Plugins**

**For Development:**

- **Git** - Git operations
- **GitHub** - GitHub integration
- **VS Code** - VS Code/Cursor integration
- **Windows** - Windows system controls

**For Productivity:**

- **Spotify** - Music control
- **Discord** - Discord shortcuts
- **OBS Studio** - Streaming (if applicable)
- **Time** - Timer/stopwatch

### **Installing Plugins**

1. Open Stream Deck software
2. Click **More Actions** (bottom left)
3. Browse plugin store
4. Click **Install** on desired plugin
5. Plugin actions appear in action list
6. Drag plugin actions to buttons

---

## 📝 Step 6: Create SPECTRA-Specific Actions

### **PowerShell Script Actions**

**Run Scripts from Stream Deck:**

1. Create PowerShell script in `scripts/` directory
2. Drag **System** → **Open** action to button
3. Configure to run PowerShell:
   ```
   powershell.exe -ExecutionPolicy Bypass -File "C:\Users\markm\OneDrive\SPECTRA\Core\tooling\stream-deck\scripts\deploy-service.ps1"
   ```
4. Test button to ensure script runs

**Example Scripts:**

- `deploy-service.ps1` - Deploy SPECTRA service
- `open-project.ps1` - Open specific project
- `quick-commands.ps1` - Run common commands

### **SPECTRA CLI Actions**

**Run SPECTRA CLI Commands:**

1. Drag **System** → **Text** action to button
2. Configure to type command
3. Add **System** → **Hotkey** action (Enter) after
4. Use Multi Action to combine

**Example: Deploy Notifications**

- Action 1: Text → `cd Core/solution-engine && python -m solution_engine.cli run "deploy notifications to Railway production"`
- Action 2: Hotkey → Enter

---

## 🎯 Step 7: Profile-Specific Setup

### **SPECTRA Development Profile**

**Recommended Buttons:**

1. **Open Cursor** - System → Open → Cursor.exe
2. **Open SPECTRA** - System → Open → File Explorer → SPECTRA folder
3. **Git Status** - System → Hotkey → `Ctrl+Shift+G` (or your shortcut)
4. **Run Tests** - System → Text → `pytest` + Hotkey Enter
5. **Open Terminal** - System → Hotkey → `Ctrl+`` (backtick)
6. **Labs Queue** - System → Open → `Core/labs/queue/ideas.json`
7. **Documentation** - System → Website → SPECTRA docs URL
8. **Service Catalog** - System → Open → `Core/registries/service-catalog.yaml`

### **SPECTRA Deployment Profile**

**Recommended Buttons:**

1. **Deploy Notifications** - Multi Action (see example above)
2. **Deploy Assistant** - Multi Action
3. **Deploy Graph** - Multi Action
4. **Check Railway** - System → Website → Railway dashboard
5. **Service Status** - PowerShell script
6. **View Logs** - PowerShell script
7. **GitHub Actions** - System → Website → GitHub Actions
8. **Solution Engine** - System → Open → Terminal + Text command

### **SPECTRA Productivity Profile**

**Recommended Buttons:**

1. **OneDrive** - System → Open → OneDrive folder
2. **SPECTRA Folder** - System → Open → SPECTRA folder
3. **Lock PC** - System → Hotkey → `Win+L`
4. **Sleep** - System → Hotkey → `Win+X, U, S`
5. **Volume Up** - System → Hotkey → `Volume Up`
6. **Volume Down** - System → Hotkey → `Volume Down`
7. **Mute** - System → Hotkey → `Volume Mute`
8. **Calendar** - System → Open → Outlook Calendar

---

## 🔍 Step 8: Testing & Troubleshooting

### **Test Each Button**

1. Click each button in Stream Deck software
2. Verify action executes correctly
3. Check for errors in action configuration
4. Test on actual device (not just software)

### **Common Issues**

**Button Not Working:**

- Check action configuration
- Verify file paths are correct
- Ensure applications are installed
- Check Windows permissions

**Scripts Not Running:**

- Verify PowerShell execution policy: `Get-ExecutionPolicy`
- If Restricted, run: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Test script manually in PowerShell first

**Profile Not Loading:**

- Verify profile file is valid `.sdProfile` format
- Check profile location in AppData
- Restart Stream Deck software
- Re-import profile if needed

**Device Not Detected:**

- Check USB connection
- Try different USB port
- Restart Stream Deck software
- Update Stream Deck software
- Check Windows Device Manager

---

## 💾 Step 9: Backup & Version Control

### **Backup Profiles**

Profiles are automatically saved to:

```
%AppData%\Elgato\StreamDeck\Profiles\
```

**To Backup:**

1. Copy `.sdProfile` files from AppData
2. Save to `Core/tooling/stream-deck/profiles/`
3. Commit to Git for version control

### **Export Profile**

1. In Stream Deck software, select profile
2. Click **Profiles** → **Export Profile**
3. Save to `Core/tooling/stream-deck/profiles/`
4. Commit to Git

### **Version Control**

- All profile files tracked in Git
- OneDrive syncs automatically
- Version history preserved
- Easy to restore if needed

---

## 🎨 Step 10: Advanced Customisation

### **Folder Actions**

**Create Nested Button Groups:**

1. Drag **System** → **Folder** action to button
2. Click button to enter folder
3. Configure buttons inside folder
4. Add "Back" button to return

**Example: SPECTRA Services Folder**

- Folder button: "SPECTRA Services"
- Inside: Buttons for each service (notifications, assistant, graph, etc.)
- Back button: Return to main profile

### **Multi-Action Sequences**

**Complex Workflows:**

1. Create Multi Action
2. Add sequence of actions:
   - Open application
   - Wait (delay)
   - Type text
   - Press hotkey
   - Wait
   - Press another hotkey

**Example: Full Deployment Workflow**

1. Open Terminal
2. Wait 1 second
3. Type: `cd Core/solution-engine`
4. Press Enter
5. Wait 1 second
6. Type: `python -m solution_engine.cli run "deploy notifications to Railway production"`
7. Press Enter

### **Conditional Actions**

**Use Stream Deck Plus Dials:**

- Rotate dial for volume/brightness
- Press dial for mute/toggle
- Configure in Stream Deck software

---

## 📚 Additional Resources

### **Elgato Documentation**

- [Stream Deck User Guide](https://help.elgato.com/hc/en-us/categories/360002181612-Stream-Deck)
- [Plugin Development](https://developer.elgato.com/documentation/stream-deck/)
- [Community Forums](https://community.elgato.com/)

### **SPECTRA Resources**

- `Core/tooling/stream-deck/README.md` - Overview
- `Core/tooling/stream-deck/scripts/` - PowerShell scripts
- `Core/tooling/stream-deck/icons/` - Custom icons

---

## ✅ Setup Complete Checklist

- [ ] Stream Deck software installed
- [ ] Device connected and detected
- [ ] SPECTRA profiles imported
- [ ] Buttons configured and tested
- [ ] Custom icons applied (if desired)
- [ ] Plugins installed (if needed)
- [ ] PowerShell scripts tested
- [ ] Profiles backed up to Git
- [ ] All buttons working correctly

---

**Last Updated:** December 6, 2025  
**Maintained By:** Mark Maconnachie




