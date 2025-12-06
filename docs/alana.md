# Alana - SPECTRA Cloud Development Environment

**Alana** is SPECTRA's cloud-based AI development assistant - a fully-configured, persistent development environment running Cursor with all your tools, settings, and workspaces pre-installed.

## What is Alana?

Alana is a Docker container deployed to Railway (or any cloud provider) that includes:

- ✨ **Cursor IDE** (not VS Code) - full AI-powered development
- 🛠️ **All dev tools** - Python, Node, Go, Rust, .NET, Java, Terraform, kubectl, etc.
- 📦 **Package managers** - pip, npm, cargo, apt
- ☁️ **Cloud CLIs** - GitHub, Azure, Fabric, Microsoft 365
- 🔐 **SSH access** - connect from anywhere
- 💾 **Persistent storage** - your work is saved
- ⚙️ **Auto-configured** - extensions and settings applied on startup

## Architecture

```
Your PC (Cursor) ←→ SSH ←→ Railway Container (Alana)
                              ├── Cursor IDE
                              ├── All SPECTRA repos
                              ├── Dev tools & CLIs
                              └── Your settings & extensions
```

## Getting Started

### 1. Deploy Alana to Railway

The container is built from `Core/infrastructure/devcontainer-service/Dockerfile`.

**Required Environment Variables:**

```env
# SSH Access
SSH_PUBLIC_KEY=<your-public-ssh-key>
SSH_PORT=2222
DEV_USER=alana

# SPECTRA Configuration
SPECTRA_FABRIC_CLIENT_ID=<your-client-id>
SPECTRA_FABRIC_CLIENT_SECRET=<your-client-secret>
SPECTRA_FABRIC_TENANT_ID=<your-tenant-id>
SPECTRA_FABRIC_CAPACITY_ID=<your-capacity-id>
SPECTRA_GITHUB_APP_ID=<your-app-id>
SPECTRA_GITHUB_APP_INSTALLATION_ID_CORE=<your-installation-id>
SPECTRA_GITHUB_APP_PRIVATE_KEY_PATH=/secrets/github-app-key.pem

# GitHub Orgs to Clone (comma-separated)
SPECTRA_GITHUB_ORGS=SPECTRACoreSolutions,SPECTRADataSolutions
```

**Railway Deployment:**

1. Create a new service in Railway
2. Link to your GitHub repo (or use the Dockerfile directly)
3. Set all environment variables above
4. Expose port `2222` for SSH
5. Deploy!

### 2. Connect from Your PC

#### Option A: Cursor Remote SSH (Recommended)

1. Install the **Remote - SSH** extension in Cursor (if not already installed)
2. Add to your SSH config (`~/.ssh/config`):

```ssh-config
Host alana
    HostName spectra-assistant-prod.up.railway.app
    Port 2222
    User alana
    IdentityFile ~/.ssh/id_rsa
    StrictHostKeyChecking no
```

3. In Cursor: `Cmd/Ctrl+Shift+P` → "Remote-SSH: Connect to Host" → select "alana"
4. Cursor will connect and open your remote workspace!

#### Option B: Direct SSH (Terminal Only)

```bash
ssh alana@spectra-assistant-prod.up.railway.app -p 2222
```

Once connected, run the bootstrap script:

```bash
bash /opt/spectra-tooling/bootstrap-alana.sh
```

### 3. Open Your Workspace

Once connected via Remote SSH in Cursor:

1. Open folder: `/workspaces/SPECTRA`
2. Or open workspace: `/workspaces/SPECTRA/spectra.code-workspace`

All your SPECTRA repositories will be organized by org!

## What Happens on Startup

When Alana starts (via `start.sh`):

1. **SSH Setup** - Configures your public key for authentication
2. **Repo Cloning** - Clones all repos from configured GitHub orgs
3. **Tooling Install** - Applies packages from `tooling.json`:
   - Python packages (`pip install`)
   - npm global packages
   - Cursor extensions
4. **Settings Applied** - Copies `settings.json` to Cursor config
5. **Ready to Code!** 🚀

## Bootstrap Script

Run `/opt/spectra-tooling/bootstrap-alana.sh` to:

- Verify all tools are installed
- Authenticate GitHub & Azure
- Sync all SPECTRA repositories
- Install packages & extensions
- Create workspace file

## Customization

### Add New Tools

Edit `Core/infrastructure/tooling/tooling.json`:

```json
{
  "python": {
    "packages": ["ms-fabric-cli", "ipykernel", "ruff", "your-package"]
  },
  "npm": {
    "global": ["@railway/cli", "your-global-package"]
  },
  "vscode": {
    "extensions": ["github.copilot", "your-extension"]
  }
}
```

Rebuild the container or run the bootstrap script to apply changes.

### Update Settings

Edit `Core/onboarding/settings.json` and rebuild the container.
Settings are automatically applied to `~/.config/Cursor/User/settings.json` on startup.

### Add More Orgs

Set environment variable:

```env
SPECTRA_GITHUB_ORGS=SPECTRACoreSolutions,SPECTRADataSolutions,YourOrg
```

## Troubleshooting

### Can't Connect via SSH

- Verify your public key is set in `SSH_PUBLIC_KEY` environment variable
- Check Railway logs for SSH startup messages
- Ensure port 2222 is exposed in Railway

### Extensions Not Installing

- Check `/var/log/cursor-ext.log` in the container
- Manually install: `cursor --install-extension <extension-id>`

### Repos Not Cloning

- Verify `SPECTRA_GITHUB_ORGS` is set
- Check GitHub authentication: `gh auth status`
- Check `/var/log/git-clone.log` for errors

### Missing Environment Variables

- Run the bootstrap script to see which vars are missing
- Set them in Railway's environment variable settings

## Philosophy

> "Alana represents the SPECTRA vision: an AI-first development environment that's accessible from anywhere, fully configured, and ready to assist. No more local setup, no more 'works on my machine' - just pure, cloud-based development powered by Cursor's AI."

## Next Steps

- [ ] Add X11 forwarding for GUI applications
- [ ] Integrate with VS Code Server for web access
- [ ] Auto-backup workspaces to cloud storage
- [ ] Multi-user support with separate workspace isolation
- [ ] Integration with SPECTRA framework for automated deployments

---

**Alana is born. She lives in the cloud, ready to assist 24/7.** 🚀
