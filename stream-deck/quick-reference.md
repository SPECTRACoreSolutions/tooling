# Stream Deck Quick Reference

**Quick reference guide for common Stream Deck actions**

---

## 🚀 Quick Setup

1. **Install Stream Deck Software**

   - Download from [elgato.com/downloads](https://www.elgato.com/en/downloads)
   - Install and launch
   - Connect device via USB

2. **Import Profiles**

   - Profiles → Import Profile
   - Select from `Core/tooling/stream-deck/profiles/`

3. **Configure Actions**
   - Drag actions to buttons
   - Customise icons
   - Test buttons

---

## 📋 Common Actions

### **System Actions**

| Action           | Use Case            | Example                        |
| ---------------- | ------------------- | ------------------------------ |
| **Open**         | Launch applications | Open Cursor, VS Code, Terminal |
| **Hotkey**       | Keyboard shortcuts  | Git commands, system shortcuts |
| **Text**         | Type text/commands  | Quick commands, paths          |
| **Website**      | Open URLs           | GitHub, documentation          |
| **Multi Action** | Multiple actions    | Complex workflows              |
| **Folder**       | Nested buttons      | Organise by category           |

### **SPECTRA-Specific**

| Button              | Action             | Configuration                                               |
| ------------------- | ------------------ | ----------------------------------------------------------- |
| **Open SPECTRA**    | Open File Explorer | System → Open → `C:\Users\markm\OneDrive\SPECTRA`           |
| **Open Cursor**     | Launch Cursor      | System → Open → `%LOCALAPPDATA%\Programs\cursor\Cursor.exe` |
| **Git Status**      | Check Git status   | System → Hotkey → Your Git shortcut                         |
| **Deploy Service**  | Deploy to Railway  | Multi Action (see scripts)                                  |
| **Labs Queue**      | Open ideas.json    | System → Open → `Core\labs\queue\ideas.json`                |
| **Service Catalog** | Open catalog       | System → Open → `Core\registries\service-catalog.yaml`      |
| **Documentation**   | Open docs          | System → Website → SPECTRA docs URL                         |

---

## 🔧 PowerShell Scripts

Scripts available in `scripts/` directory:

### **deploy-service.ps1**

Deploy SPECTRA service to Railway.

**Usage:**

```
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\markm\OneDrive\SPECTRA\Core\tooling\stream-deck\scripts\deploy-service.ps1" -ServiceName "notifications" -Environment "production"
```

**Stream Deck Configuration:**

- Action: System → Open
- Application: `powershell.exe`
- Arguments: `-ExecutionPolicy Bypass -File "C:\Users\markm\OneDrive\SPECTRA\Core\tooling\stream-deck\scripts\deploy-service.ps1" -ServiceName "notifications" -Environment "production"`

### **open-project.ps1**

Open SPECTRA project in Cursor.

**Usage:**

```
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\markm\OneDrive\SPECTRA\Core\tooling\stream-deck\scripts\open-project.ps1" -ProjectName "notifications"
```

**Available Projects:**

- notifications, assistant, graph, portal, cli, framework, solution-engine, labs
- jira, xero, zephyr, fabric-sdk

### **quick-commands.ps1**

Run quick SPECTRA commands.

**Usage:**

```
powershell.exe -ExecutionPolicy Bypass -File "C:\Users\markm\OneDrive\SPECTRA\Core\tooling\stream-deck\scripts\quick-commands.ps1" -Command "status"
```

**Available Commands:**

- `status` - Check Git and service status
- `sync` - Sync cosmic index
- `test` - Run tests
- `lint` - Run linter
- `docs` - Open documentation

---

## 🎨 Icon Tips

### **Icon Size**

- Recommended: 72x72 pixels
- Minimum: 72x72 pixels
- Maximum: 288x288 pixels (scaled down)

### **Icon Format**

- PNG (recommended)
- JPG (acceptable)
- SVG (if supported by Stream Deck)

### **Icon Location**

- Built-in icons: Stream Deck software library
- Custom icons: `Core/tooling/stream-deck/icons/`

---

## 🔑 Keyboard Shortcuts Reference

Common shortcuts for Hotkey actions:

| Shortcut         | Action                    |
| ---------------- | ------------------------- |
| `Win+L`          | Lock PC                   |
| `Win+X, U, S`    | Sleep                     |
| `Win+X, U, H`    | Hibernate                 |
| `Win+X, U, R`    | Restart                   |
| `Win+X, U, U`    | Shut down                 |
| `Ctrl+Shift+Esc` | Task Manager              |
| `Win+R`          | Run dialog                |
| `Win+E`          | File Explorer             |
| `Ctrl+``         | Terminal (VS Code/Cursor) |

---

## 📁 File Paths Reference

Common SPECTRA paths for Open actions:

| Path                                                                   | Description       |
| ---------------------------------------------------------------------- | ----------------- |
| `C:\Users\markm\OneDrive\SPECTRA`                                      | SPECTRA root      |
| `C:\Users\markm\OneDrive\SPECTRA\Core`                                 | Core organisation |
| `C:\Users\markm\OneDrive\SPECTRA\Core\labs\queue\ideas.json`           | Labs queue        |
| `C:\Users\markm\OneDrive\SPECTRA\Core\registries\service-catalog.yaml` | Service catalog   |
| `C:\Users\markm\OneDrive\SPECTRA\Core\docs`                            | Documentation     |
| `C:\Users\markm\OneDrive\SPECTRA\Core\memory\journal`                  | Journal entries   |

---

## 🔌 Recommended Plugins

### **For Development**

- **Git** - Git operations
- **GitHub** - GitHub integration
- **VS Code** - VS Code/Cursor integration

### **For Productivity**

- **Spotify** - Music control
- **Discord** - Discord shortcuts
- **Time** - Timer/stopwatch

### **For Streaming** (if applicable)

- **OBS Studio** - Streaming controls
- **Twitch** - Twitch integration

---

## ⚠️ Troubleshooting

### **Button Not Working**

- Check action configuration
- Verify file paths
- Test action manually
- Check Windows permissions

### **Scripts Not Running**

- Check PowerShell execution policy: `Get-ExecutionPolicy`
- Set policy: `Set-ExecutionPolicy RemoteSigned -Scope CurrentUser`
- Test script manually first

### **Profile Not Loading**

- Verify `.sdProfile` file is valid
- Check profile location
- Restart Stream Deck software
- Re-import profile

---

## 📚 Full Documentation

- **README.md** - Overview and structure
- **SETUP-GUIDE.md** - Complete setup instructions
- **profiles/README.md** - Profile management

---

**Last Updated:** December 6, 2025




