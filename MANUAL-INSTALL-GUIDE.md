# Manual Extension Installation for Cursor

**Why this guide?** The `cursor` CLI command isn't in your PATH, so we'll install extensions manually (it's actually easier!).

---

## Method 1: Install from Cursor UI (Recommended - 2 minutes)

### Step-by-Step:

1. **Open Extensions Panel**:
   ```
   Press: Ctrl+Shift+X
   Or: Click Extensions icon in sidebar
   ```

2. **Install Each Extension**:

#### Essential Extensions (Install These 10):

**Thunder Client** (API testing with .env)
```
Search: "Thunder Client"
By: Ranga Vadhineni
Click: Install
```

**Rainbow CSV** (Beautiful CSV viewing)
```
Search: "Rainbow CSV"  
By: mechatroner
Click: Install
```

**DotENV** (.env syntax)
```
Search: "DotENV"
By: mikestead
Click: Install
```

**GitLens** (Git superpowers)
```
Search: "GitLens"
By: GitKraken
Click: Install
```

**YAML** (Railway configs)
```
Search: "YAML"
By: Red Hat
Click: Install
```

**Python** (Python development)
```
Search: "Python"
By: Microsoft
Click: Install
```

**Pylance** (Python IntelliSense)
```
Search: "Pylance"
By: Microsoft
Click: Install
```

**Black Formatter** (Python formatting)
```
Search: "Black Formatter"
By: Microsoft
Click: Install
```

**Markdown All in One** (Documentation)
```
Search: "Markdown All in One"
By: Yu Zhang
Click: Install
```

**Docker** (Container management)
```
Search: "Docker"
By: Microsoft
Click: Install
```

### Total Time: 2 minutes (they install in parallel)

---

## Method 2: Enable Cursor CLI (For Future)

If you want to use CLI commands for future installations:

### Enable Cursor CLI:

1. **Open Cursor**
2. Press `Ctrl+Shift+P` (Command Palette)
3. Type: `Shell Command: Install 'cursor' command in PATH`
4. Press Enter
5. **Restart PowerShell/Terminal**

### Verify:
```powershell
cursor --version
# Should show: Cursor version x.x.x
```

### Then Run:
```powershell
cd Core/tooling
.\install-cursor-extensions.ps1 -Profile essential
```

---

## Method 3: Install via Extension ID (Alternative)

If you prefer copying extension IDs:

### In Cursor:

1. `Ctrl+Shift+X` (Extensions)
2. In search box, paste extension ID
3. Click Install

**Extension IDs**:
```
rangav.vscode-thunder-client
mechatroner.rainbow-csv
mikestead.dotenv
eamodio.gitlens
redhat.vscode-yaml
ms-python.python
ms-python.vscode-pylance
ms-python.black-formatter
yzhang.markdown-all-in-one
ms-azuretools.vscode-docker
```

**Copy-paste each ID into Extensions search → Install**

---

## Verify Installation

### Check Installed Extensions:

1. `Ctrl+Shift+X` (Extensions)
2. Click "..." menu (top-right)
3. Select "Show Installed Extensions"
4. Verify you see all 10

### Test Thunder Client:

1. `Ctrl+Shift+P`
2. Type: `Thunder Client`
3. Should see: "Thunder Client: New Request"
4. If you see this → It's installed! ✅

### Test Rainbow CSV:

1. Open any CSV file: `Data/jira/output/issues.csv`
2. Columns should be in different colors
3. If you see colors → It's installed! ✅

---

## About Cursor vs VS Code

**Cursor and VS Code are separate apps**:
- Cursor: Your AI-powered IDE (what you're using)
- VS Code: Standard Microsoft IDE

**They have separate extension directories**:
```
VS Code:     %USERPROFILE%\.vscode\extensions\
Cursor:      %USERPROFILE%\.cursor\extensions\
```

**The `code` command installs to VS Code**  
**The `cursor` command installs to Cursor**

**That's why the first script didn't work** - it installed to VS Code, not Cursor!

---

## Assistant Service (Unrelated)

**Your question**: "Is that a problem inside assistant as well?"

**Answer**: No, the assistant service (`Core/assistant/`) is completely separate:

```
Assistant Service (Railway container):
- Python FastAPI app
- Runs in cloud
- No Cursor, no VS Code
- Uses Python packages (pyproject.toml)
- Dependencies: fastapi, uvicorn, openai, etc.

Your Local Cursor:
- Desktop IDE app
- Runs on Windows
- Has extensions (Thunder Client, etc.)
- Separate from assistant service
```

**Cursor extensions** = Local IDE tools on your machine  
**Assistant service** = Cloud Python service in Railway

**They don't interact.** Extensions are just for your local Cursor experience.

---

## Quick Start (Right Now)

**Easiest method** (2 minutes):

1. Press `Ctrl+Shift+X` in Cursor
2. Search: "Thunder Client"
3. Click "Install" on first result
4. Search: "Rainbow CSV"
5. Click "Install"
6. Search: "DotENV"
7. Click "Install"
8. Search: "GitLens"
9. Click "Install"
10. Done!

**Start with those 4**, then add more later if you want.

---

*Created: 2025-12-02*  
*Issue: Cursor CLI not in PATH*  
*Solution: Manual installation via Extensions panel (easier anyway!)*

