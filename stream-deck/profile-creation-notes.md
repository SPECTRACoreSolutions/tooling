# Stream Deck Profile Creation Notes

**Notes on creating and customising Stream Deck profiles**

---

## 📋 Profile Files Created

I've created three basic profile files:

1. **SPECTRA-Development.sdProfile** - 8 buttons for development workflows
2. **SPECTRA-Deployment.sdProfile** - 8 buttons for deployment shortcuts
3. **SPECTRA-Productivity.sdProfile** - 10 buttons for general productivity

---

## ⚠️ Important Notes

### **Profile Format**

The profile files I've created use a simplified JSON structure. However, Stream Deck software may require additional metadata or a different format when importing.

**If profiles don't import correctly:**

1. **Option 1: Create in Stream Deck Software**
   - Open Stream Deck software
   - Create new profile manually
   - Configure buttons as described in `SETUP-GUIDE.md`
   - Export profile to save it

2. **Option 2: Use as Reference**
   - Use these JSON files as a reference for button configurations
   - Manually recreate buttons in Stream Deck software
   - The action UUIDs and settings are correct

### **Action UUIDs**

The profiles use standard Stream Deck action UUIDs:

- `com.elgato.streamdeck.system.open` - Open application/file
- `com.elgato.streamdeck.system.hotkey` - Keyboard shortcut
- `com.elgato.streamdeck.system.text` - Type text
- `com.elgato.streamdeck.system.website` - Open URL

### **File Paths**

All paths in the profiles use your SPECTRA workspace path:
- `C:\Users\markm\OneDrive\SPECTRA`

**If your path is different:**
- Update paths in profile files, OR
- Create profiles in Stream Deck software (it will use correct paths automatically)

---

## 🔧 Customising Profiles

### **Adding More Buttons**

The profiles I created have a basic set of buttons. You can:

1. Import profile into Stream Deck software
2. Add more buttons by dragging actions
3. Re-export profile to save changes

### **Changing Button Actions**

In Stream Deck software:

1. Click button to edit
2. Change action type or settings
3. Profile auto-saves

### **Custom Icons**

1. Prepare icon (72x72 pixels, PNG)
2. Save to `Core/tooling/stream-deck/icons/`
3. In Stream Deck software, click button → icon area → Choose File
4. Select custom icon

---

## 📝 Profile Contents

### **SPECTRA Development Profile**

**Buttons:**
1. Open Cursor
2. Open SPECTRA folder
3. Open Terminal (Ctrl+`)
4. Git Status (Ctrl+Shift+G)
5. Labs Queue (opens ideas.json)
6. Service Catalog (opens service-catalog.yaml)
7. Documentation (opens docs folder)
8. Run Tests (types "pytest" + Enter)

### **SPECTRA Deployment Profile**

**Buttons:**
1. Deploy Notifications (runs PowerShell script)
2. Deploy Assistant (runs PowerShell script)
3. Deploy Graph (runs PowerShell script)
4. Railway Dashboard (opens Railway website)
5. GitHub Actions (opens GitHub)
6. Service Catalog (opens service-catalog.yaml)
7. Solution Engine (opens solution-engine folder)
8. Deployment Docs (opens DEPLOYMENT-PATTERN.md)

### **SPECTRA Productivity Profile**

**Buttons:**
1. OneDrive (opens OneDrive folder)
2. SPECTRA Folder (opens SPECTRA folder)
3. Lock PC (Win+L)
4. Task Manager (Ctrl+Shift+Esc)
5. Volume Up
6. Volume Down
7. Mute
8. Calendar (opens Outlook Calendar)
9. Quick Status (runs status command)
10. Sync Index (runs sync command)

---

## 🚀 Next Steps

1. **Try Importing Profiles**
   - Open Stream Deck software
   - Profiles → Import Profile
   - Select `.sdProfile` file
   - See if it imports correctly

2. **If Import Fails**
   - Use profiles as reference
   - Create profiles manually in Stream Deck software
   - Follow button configurations from profile files

3. **Customise Further**
   - Add more buttons as needed
   - Change icons
   - Adjust button layouts
   - Create additional profiles

---

## 🔍 Troubleshooting

### **Profile Won't Import**

- Check file extension is `.sdProfile`
- Verify JSON is valid (use JSON validator)
- Try creating profile manually in Stream Deck software
- Check Stream Deck software version (profiles require 6.0.0+)

### **Buttons Don't Work**

- Verify file paths are correct
- Check PowerShell execution policy
- Test scripts manually first
- Ensure applications are installed

### **Actions Not Recognised**

- Update Stream Deck software to latest version
- Some actions may require plugins
- Check action UUID is correct

---

## 📚 Additional Resources

- **Stream Deck Software** - Primary tool for creating/editing profiles
- **Elgato Marketplace** - Pre-made profiles and icons
- **SETUP-GUIDE.md** - Complete setup instructions
- **QUICK-REFERENCE.md** - Quick reference for actions

---

**Note:** These profile files are a starting point. The best way to create profiles is usually through Stream Deck software itself, but these files provide a reference structure you can follow.

---

**Last Updated:** December 6, 2025





