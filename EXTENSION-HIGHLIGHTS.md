# SPECTRA Extension Highlights - Must-Try List

**The best of the best - extensions that will transform your workflow**

---

## 🔥 Game Changers (Try These First)

### 1. Thunder Client ⭐⭐⭐⭐⭐
```
Downloads: 3M+
Install: code --install-extension rangav.vscode-thunder-client
```

**Why it's a game changer**:
- Postman inside Cursor
- Uses your .env credentials
- OAuth 2.0 helper
- Beautiful UI
- No need to switch to browser for API testing

**Try it**:
```
1. Install Thunder Client
2. New Request → GET https://graph.microsoft.com/v1.0/me
3. Env → Add from .env: SPECTRA_GRAPH_CLIENT_ID, etc.
4. Send → See your Microsoft profile data!
```

**You'll never open Postman again.**

### 2. Rainbow CSV ⭐⭐⭐⭐⭐
```
Downloads: 2M+
Install: code --install-extension mechatroner.rainbow-csv
```

**Why it's a game changer**:
- CSV columns in different colors
- Instantly readable
- SQL queries on CSV files
- Column alignment

**Try it**:
```
1. Install Rainbow CSV
2. Open Data/jira/output/issues.csv
3. Watch columns light up in colors
4. Ctrl+Shift+P → "Rainbow CSV: Align columns"
5. Mind blown 🤯
```

**You'll never look at plain CSV files again.**

### 3. GitLens ⭐⭐⭐⭐⭐
```
Downloads: 25M+ (most popular paid → free)
Install: code --install-extension eamodio.gitlens
```

**Why it's a game changer**:
- See who wrote each line (inline blame)
- File/line history
- Compare branches visually
- Git graph visualization
- Commit search

**Try it**:
```
1. Install GitLens
2. Open any Python file
3. See author annotations next to each line
4. Click annotation → See commit details
5. Click "View File History" → Visual timeline
```

**You'll understand your codebase's history instantly.**

### 4. Error Lens ⭐⭐⭐⭐⭐
```
Downloads: 3M+
Install: code --install-extension usernamehw.errorlens
```

**Why it's a game changer**:
- Errors shown INLINE (not just squiggly lines)
- See error messages without hovering
- Warnings highlighted
- Faster debugging

**Try it**:
```
1. Install Error Lens
2. Write Python code with an error
3. See error message appear INLINE in red
4. No more hovering to see what's wrong!
```

**You'll catch errors 3x faster.**

### 5. Todo Tree ⭐⭐⭐⭐⭐
```
Downloads: 2M+
Install: code --install-extension Gruntfuggly.todo-tree
```

**Why it's a game changer**:
- Collects all TODOs/FIXMEs in sidebar
- Jump to any TODO instantly
- Filter by tag
- Track what needs doing across entire project

**Try it**:
```
1. Install Todo Tree
2. Check sidebar → "Todo Tree" view
3. See ALL your TODOs/FIXMEs in one place
4. Click any TODO → Jump to that line
```

**You'll never lose track of TODOs again.**

---

## 💎 Hidden Gems (Underrated)

### REST Client (5M downloads)
```
Install: code --install-extension humao.rest-client
```

**Why it's underrated**:
- .http files in your repo (version controlled!)
- Uses .env variables
- Simpler than Thunder Client
- Team-friendly (everyone has same requests)

**Example**:
```http
### Get SPECTRA profile
@token = {{$dotenv GRAPH_TOKEN}}

GET https://graph.microsoft.com/v1.0/me
Authorization: Bearer {{token}}

### Save this file as: scripts/api-tests.http
### Now your whole team can run these requests!
```

### Project Manager (2M downloads)
```
Install: code --install-extension alefragnani.project-manager
```

**Why it's underrated**:
- Switch between Core/, Data/, Design/ instantly
- Keyboard shortcut to jump projects
- Remembers window layouts per project
- Perfect for SPECTRA's multi-workspace structure

**Try it**:
```
1. Install Project Manager
2. Save projects: Core/, Data/jira/, Data/xero/
3. Alt+Shift+P → Switch projects instantly
4. Each project remembers its own layout!
```

### Data Wrangler (500k downloads, official Microsoft)
```
Install: code --install-extension ms-toolsai.datawrangler
```

**Why it's underrated**:
- Visual pandas DataFrame explorer
- Filter, sort, group data visually
- Export operations to Python code
- Official Microsoft tool

**Try it**:
```python
import pandas as pd
df = pd.read_csv("data.csv")

# Click "Open in Data Wrangler" button
# Visual UI appears!
# Filter/transform visually → Generates Python code
```

---

## 🎯 For SPECTRA Specific Work

### Data Pipeline Development
```
Essential:
- Thunder Client     (API testing)
- Rainbow CSV        (view outputs)
- SQLTools          (database queries)
- Jupyter           (exploration)
- Data Wrangler     (pandas UI)

Nice:
- Excel Viewer      (spreadsheets)
- Data Preview      (multi-format files)
```

### Documentation Writing
```
Essential:
- Markdown All in One  (TOC, preview, shortcuts)

Nice:
- Draw.io Integration  (diagrams in Cursor)
- Markdown Preview Enhanced (Mermaid diagrams)
- Code Spell Checker   (catch typos)
```

### Railway/DevOps Work
```
Essential:
- Docker            (container management)
- YAML             (railway.json validation)
- DotENV           (.env syntax)
- Remote - SSH     (connect to containers)

Nice:
- Kubernetes       (if you use K8s)
- Terraform        (if you use IaC)
```

---

## 📈 Metrics-Based Quality

**We track**:
- Download counts (marketplace)
- GitHub stars (if open source)
- Last update date (must be <12 months)
- Average rating (must be >3★)
- Community backing (Reddit, blogs, tutorials)

**Example entry**:
```
Thunder Client
- Downloads: 3M+
- Rating: 4.8★
- GitHub: 2.5k★
- Last update: Nov 2024
- Official: No, but backed by large community
- Verdict: ✅ Include (high quality, proven)
```

---

## 🚀 Quick Install Profiles

### Profile 1: "SPECTRA Essentials" (10 extensions)
```powershell
.\install-spectra-extensions.ps1 -Profile essential
```
**Time**: 2 minutes  
**Impact**: Immediate productivity boost

### Profile 2: "Data Engineering" (9 extensions)
```powershell
.\install-spectra-extensions.ps1 -Profile data
```
**Time**: 2 minutes  
**Impact**: Transform data workflow

### Profile 3: "Full Stack" (30+ extensions)
```powershell
.\install-spectra-extensions.ps1 -Profile all
```
**Time**: 5 minutes  
**Impact**: Complete development environment

---

## 💡 Pro Tips

### Start Small
- Install essentials first (10 extensions)
- Use them for 1 week
- Add more only when you feel the need

### Use Extension Profiles
- Create profiles for different work types
- Switch profiles based on project
- Keeps Cursor fast (only load what you need)

### Learn Keyboard Shortcuts
- Extensions add shortcuts (check README)
- Learn 2-3 shortcuts per extension
- Muscle memory = 10x productivity

---

## 🎓 Learning Path

### Week 1: Master Essentials
```
Day 1-2: Thunder Client
  - Call Microsoft Graph API
  - Call Railway API
  - Set up .env integration

Day 3-4: Rainbow CSV
  - Open all your pipeline outputs
  - Try SQL queries on CSV
  - Configure column alignment

Day 5-7: GitLens
  - Explore file history
  - Check blame annotations
  - Compare branches
```

### Week 2: Add Data Tools
```
- Install Jupyter (data exploration)
- Install SQLTools (database queries)
- Install Data Wrangler (pandas UI)
```

### Week 3: Optimize Workflow
```
- Install Todo Tree (track work)
- Install Error Lens (faster debugging)
- Install Project Manager (multi-project)
```

---

## 🔍 Discoverability

**How to find new extensions**:

1. **Marketplace Trending**
   - Open Cursor → Extensions
   - Sort by "Most Downloaded"
   - Filter "Updated in last 12 months"

2. **GitHub Trending**
   - github.com/trending
   - Topic: vscode-extension
   - Check weekly

3. **Community Resources**
   - awesome-vscode (GitHub: 24k★)
   - r/vscode (Reddit: 200k+ members)
   - VS Code blog (code.visualstudio.com/blogs)

4. **SPECTRA Curated List**
   - `docs/cursor-extensions-curated.md` (this repo)
   - Monthly updates
   - Pre-vetted for quality

---

## 🎯 Top 5 for Immediate Impact

If you only install 5 extensions, make it these:

1. **Thunder Client** - API testing with .env (game-changer for SPECTRA)
2. **Rainbow CSV** - Instantly better CSV viewing (you look at CSVs daily)
3. **GitLens** - Git superpowers (understand code history)
4. **DotENV** - .env syntax highlighting (essential for SPECTRA)
5. **Error Lens** - Inline errors (3x faster debugging)

**Install now**:
```powershell
code --install-extension rangav.vscode-thunder-client
code --install-extension mechatroner.rainbow-csv
code --install-extension eamodio.gitlens
code --install-extension mikestead.dotenv
code --install-extension usernamehw.errorlens
```

**Time**: 1 minute  
**Impact**: Transform your workflow today

---

*Created: 2025-12-02*  
*Purpose: Highlight best extensions for immediate adoption*  
*Maintenance: Monthly reviews, community-backed only*

