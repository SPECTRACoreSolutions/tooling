# Stream Deck Profile Recommendations

**Recommended profiles and cool coding features for your Stream Deck**

---

## 🎯 Recommended Profiles

### **1. SPECTRA Coding (Main Profile)** ⭐
**Your primary profile for development work**

**Why:** This should be your main profile - everything you need for coding in one place.

**Cool Features:**
- Git operations (status, commit, push, pull, branch switching)
- Quick project switching
- Code snippets
- Terminal commands
- Build/test/lint shortcuts
- File navigation
- Documentation lookup
- SPECTRA-specific shortcuts

**Layout:** 15 buttons (or use folders for organisation)

---

### **2. SPECTRA Deployment**
**For deploying and managing services**

**Use When:** Deploying services, checking status, viewing logs

**Buttons:**
- Deploy services (notifications, assistant, graph)
- Railway dashboard
- GitHub Actions
- Service status checks
- Log viewing

---

### **3. SPECTRA Productivity**
**General system shortcuts**

**Use When:** Not actively coding, general computer use

**Buttons:**
- System shortcuts (lock, sleep, volume)
- OneDrive, SPECTRA folder
- Calendar, Outlook
- Quick commands

---

### **4. SPECTRA Projects (Optional)**
**Quick access to specific projects**

**Use When:** Switching between different SPECTRA projects

**Buttons:**
- Open specific projects in Cursor
- Project-specific shortcuts
- Project documentation

---

## 🚀 Cool Things You Can Do for Coding

### **1. Git Workflow Automation**

**Multi-Action Sequences:**

Create buttons that do multiple Git operations:

**"Quick Commit & Push":**
1. Open terminal
2. Type: `git add .`
3. Press Enter
4. Wait 1 second
5. Type: `git commit -m "WIP"`
6. Press Enter
7. Wait 1 second
8. Type: `git push`
9. Press Enter

**"Git Status Check":**
- Shows current branch
- Shows modified files
- Shows if you're ahead/behind

**"Switch Branch":**
- Opens terminal
- Types: `git checkout `
- Waits for you to type branch name
- Presses Enter

---

### **2. Project Switching**

**Quick Project Access:**

Create buttons for each major project:
- **Notifications** → Opens `Core/notifications` in Cursor
- **Assistant** → Opens `Core/assistant` in Cursor
- **Graph** → Opens `Core/graph` in Cursor
- **Framework** → Opens `Core/framework` in Cursor
- **Labs** → Opens `Core/labs` in Cursor

**Or use a Folder:**
- **SPECTRA Projects** (folder button)
  - Inside: All project buttons
  - Back button to return

---

### **3. Code Snippets**

**Quick Code Insertion:**

Create buttons that type common code snippets:

**"Python Function":**
```python
def function_name():
    """Docstring here."""
    pass
```

**"SPECTRA Service Template":**
- Types boilerplate for new service
- Includes imports, structure

**"Test Function":**
```python
def test_function_name():
    """Test description."""
    assert True
```

---

### **4. Terminal Commands**

**One-Button Commands:**

**"Run Tests":**
- Opens terminal
- Types: `pytest`
- Presses Enter

**"Lint Code":**
- Opens terminal
- Types: `ruff check .`
- Presses Enter

**"Sync Cosmic Index":**
- Opens terminal
- Types: `cd Core/memory && python scripts/build_cosmic_index.py`
- Presses Enter

**"Deploy Service":**
- Opens terminal
- Types deployment command
- Presses Enter

---

### **5. File Navigation**

**Quick File Access:**

**"Open Labs Queue":**
- Opens `Core/labs/queue/ideas.json` in Cursor

**"Service Catalog":**
- Opens `Core/registries/service-catalog.yaml` in Cursor

**"Documentation":**
- Opens `Core/docs` folder

**"Standards":**
- Opens `Core/standards` folder

**"Journal":**
- Opens `Core/memory/journal` folder

---

### **6. Multi-Action Workflows**

**Complex Sequences:**

**"Start New Feature":**
1. Open Cursor
2. Wait 2 seconds
3. Open terminal (Ctrl+`)
4. Type: `git checkout -b feature/new-feature`
5. Press Enter
6. Wait 1 second
7. Open Labs queue
8. Wait 1 second
9. Type: `git status` (to verify)

**"Complete Feature":**
1. Run tests
2. Wait for completion
3. Lint code
4. Wait for completion
5. Git status
6. Open commit message template

**"Deploy Workflow":**
1. Run tests
2. Lint code
3. Git status
4. Deploy service
5. Open Railway dashboard

---

### **7. Folder Organisation**

**Nested Button Groups:**

**"Git Operations" (Folder):**
- Inside: Status, Commit, Push, Pull, Branch, Stash, Log
- Back button to return

**"SPECTRA Services" (Folder):**
- Inside: Notifications, Assistant, Graph, Portal, etc.
- Back button to return

**"Quick Commands" (Folder):**
- Inside: Test, Lint, Sync, Status, Docs
- Back button to return

---

### **8. Dynamic Content (Advanced)**

**With Plugins:**

**"Git Branch Display":**
- Shows current Git branch
- Updates automatically
- Changes colour if branch is dirty

**"Service Status":**
- Shows Railway service status
- Green = running, Red = down
- Updates every few minutes

**"Time Tracker":**
- Shows current session time
- Start/stop timer
- Log time to file

---

### **9. Debugging Shortcuts**

**Development Tools:**

**"Toggle Breakpoint":**
- Hotkey: F9 (VS Code/Cursor)

**"Start Debugging":**
- Hotkey: F5

**"Step Over":**
- Hotkey: F10

**"Step Into":**
- Hotkey: F11

**"Restart Debugger":**
- Hotkey: Ctrl+Shift+F5

---

### **10. Environment Switching**

**Context Switching:**

**"Switch to Production":**
- Sets environment variable
- Opens production dashboard
- Changes terminal prompt

**"Switch to Development":**
- Sets environment variable
- Opens dev tools
- Changes terminal prompt

---

### **11. Documentation Lookup**

**Quick Reference:**

**"SPECTRA Glossary":**
- Opens `Core/standards/SPECTRA-GLOSSARY.md`

**"Service Blueprint":**
- Opens `Core/standards/SERVICE-BLUEPRINT.md`

**"Deployment Guide":**
- Opens `Core/standards/DEPLOYMENT-PATTERN.md`

**"Seven Levels":**
- Opens `Core/doctrine/THE-SEVEN-LEVELS-OF-MATURITY.md`

---

### **12. SPECTRA-Specific Shortcuts**

**SPECTRA Workflows:**

**"Add to Labs Queue":**
- Opens `Core/labs/queue/ideas.json`
- Positions cursor for new entry

**"Create Journal Entry":**
- Opens journal folder
- Creates new entry with template

**"Sync Cosmic Index":**
- Runs cosmic index script
- Shows completion status

**"Check Service Catalog":**
- Opens service catalog
- Shows deployed services

**"Open Solution Engine":**
- Opens solution-engine folder
- Ready for deployment commands

---

## 🎨 Layout Suggestions

### **15-Button Stream Deck (Standard)**

**Top Row (Quick Access):**
1. Open Cursor
2. Open SPECTRA
3. Terminal
4. Git Status
5. Labs Queue

**Middle Row (Git Operations):**
6. Git Commit
7. Git Push
8. Git Pull
9. Switch Branch
10. Git Log

**Bottom Row (Commands):**
11. Run Tests
12. Lint Code
13. Sync Index
14. Documentation
15. Service Catalog

### **With Folders (Better Organisation)**

**Main Level:**
1. Git Operations (Folder)
2. Projects (Folder)
3. Commands (Folder)
4. SPECTRA (Folder)
5. Quick Access (Open Cursor, Terminal, etc.)

**Inside "Git Operations" Folder:**
- Status, Commit, Push, Pull, Branch, Stash, Log, Back

**Inside "Projects" Folder:**
- Notifications, Assistant, Graph, Framework, Labs, Back

**Inside "Commands" Folder:**
- Test, Lint, Sync, Status, Docs, Back

**Inside "SPECTRA" Folder:**
- Labs Queue, Service Catalog, Documentation, Standards, Journal, Back

---

## 🔌 Recommended Plugins for Coding

### **Essential:**
- **Git** - Git operations and branch display
- **VS Code** - VS Code/Cursor integration
- **GitHub** - GitHub integration

### **Nice to Have:**
- **Time** - Time tracking
- **System Monitor** - CPU/RAM usage
- **Spotify** - Music control (for focus)

---

## 💡 Pro Tips

1. **Use Folders** - Organise related buttons together
2. **Multi-Actions** - Combine multiple steps into one button
3. **Custom Icons** - Make buttons visually distinct
4. **Smart Profiles** - Auto-switch based on active app
5. **Hotkeys** - Use for frequently used shortcuts
6. **Text Actions** - Quick code snippets
7. **Website Actions** - Quick access to docs/dashboards
8. **PowerShell Scripts** - Complex workflows

---

## 🎯 Your Main Coding Profile Should Have:

**Must Have:**
- ✅ Open Cursor/VS Code
- ✅ Terminal access
- ✅ Git operations (status, commit, push)
- ✅ Run tests
- ✅ Quick project switching
- ✅ Documentation access

**Should Have:**
- ✅ Lint code
- ✅ Sync cosmic index
- ✅ Labs queue
- ✅ Service catalog
- ✅ Code snippets
- ✅ Folder organisation

**Nice to Have:**
- ✅ Git branch display (plugin)
- ✅ Service status (plugin)
- ✅ Time tracking
- ✅ Debugging shortcuts
- ✅ Environment switching

---

**Next Step:** I'll create an enhanced coding profile with all these features!

---

**Last Updated:** December 6, 2025





