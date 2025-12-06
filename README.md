# SPECTRA Tooling

**Curated, community-backed tools and configurations**

---

## What's Here

Configuration and tool recommendations for SPECTRA development:

### Cursor/VS Code Extensions
- **`cursor-extensions-curated.md`** - Living list of proven extensions (70+)
- **`install-spectra-extensions.ps1`** - Quick installer script

### PC Build Toolkit
- **`pc-build-toolkit/`** - Complete Windows PC build toolkit with drivers, utilities, and documentation
- **`PC-BUILD-READY.md`** - Build day checklist and quick start

### System Optimisation
- **`system-optimisation/`** - RGB control, OpenRGB integration, system optimiser scripts

### Cursor Configuration
- **`config/cursor/`** - Cursor MCP configuration and sync scripts
- **`CURSOR-ENVIRONMENT-SYNC.md`** - Environment sync documentation

**Quality threshold**: Only extensions with >500k downloads OR >1k GitHub stars OR official backing.

**Last updated**: 2025-12-02  
**Next review**: 2025-03-02 (monthly maintenance)

---

## Quick Start

### Install Essential Extensions (10 extensions, 2 minutes)

```powershell
# From Core/tooling/
.\install-spectra-extensions.ps1 -Profile essential
```

**Includes**:
- Thunder Client (API testing with .env)
- Rainbow CSV (beautiful CSV viewing)
- DotENV (.env syntax)
- GitLens (git superpowers)
- YAML (configs)
- Python + Pylance + Black (Python stack)
- Markdown All in One (docs)
- Docker (containers)

### Install by Workflow

```powershell
# Data engineering focus
.\install-spectra-extensions.ps1 -Profile data

# Includes: Jupyter, SQLTools, data viewers, etc.
```

```powershell
# Full recommended stack
.\install-spectra-extensions.ps1 -Profile recommended

# Adds: Todo Tree, Error Lens, Git History, etc.
```

```powershell
# Everything (30+ extensions)
.\install-spectra-extensions.ps1 -Profile all
```

---

## Browse Extensions

**See full catalog**: `cursor-extensions-curated.md`

**Organized by**:
- Top Tier (>5M downloads)
- High Quality (1M-5M downloads)
- Specialized (domain-specific)
- By workflow (Data, DevOps, Docs, etc.)

**Includes**:
- Download metrics
- GitHub star counts
- Use cases
- Why each extension matters
- Installation commands

---

## Maintenance

**This is a living document.**

**Update schedule**: Monthly reviews

**Update process**:
1. Check marketplace for trending extensions
2. Verify download counts (remove if dropped)
3. Check maintenance status (updated in last 12 months)
4. Add new high-traction extensions
5. Update installation scripts
6. Commit changes

**Next review**: 2025-03-02

**To contribute**: See "Contributing" section in `cursor-extensions-curated.md`

---

## Quality Standards

**We include extensions that**:
- ✅ Have >500k downloads OR >1k GitHub stars
- ✅ Are actively maintained (updated in last 12 months)
- ✅ Are official (Microsoft, GitHub, HashiCorp, etc.)
- ✅ Have community backing (high ratings, active issues)

**We exclude extensions that**:
- ❌ Have <100k downloads (unless exceptional)
- ❌ Haven't been updated in 18+ months
- ❌ Have <3★ rating
- ❌ Duplicate better-established tools
- ❌ Add unnecessary complexity

---

## Extension Profiles

**VS Code supports extension profiles** - different sets per project:

**SPECTRA Data Profile**:
- Python stack
- Jupyter
- Thunder Client
- Rainbow CSV
- SQLTools
- DotENV

**SPECTRA Docs Profile**:
- Markdown tools
- Draw.io
- Spell checker

**SPECTRA DevOps Profile**:
- Docker
- YAML
- Remote-SSH
- DotENV

**Create profiles**: Settings → Profiles → Create Profile

---

## Performance Tips

**Heavy extensions** (>100ms startup):
- GitLens (can be lightened in settings)
- Jupyter (only enable when needed)
- Docker (only when using containers)

**Solution**: Use extension profiles to enable only what you need per project.

---

## Contributing

**To propose an extension**:
1. Check quality criteria (downloads, stars, official)
2. Verify actively maintained
3. Ensure no better alternative exists
4. Add to `cursor-extensions-curated.md` with metrics
5. Update install script if in recommended tier

**To report issues**:
- Open issue in SPECTRA repo
- Tag: `tooling`, `extensions`
- Include: Extension name, issue description, proposed action

---

*Maintained by: SPECTRA Team*  
*Purpose: Prevent extension bloat, ensure quality*  
*Philosophy: Community-backed > trending, proven > new*
