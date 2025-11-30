# Alana - Remote Development with Cursor

Alana is SPECTRA's cloud-based AI development environment powered by Cursor IDE.

## Quick Start

**Connect from your PC:**

```bash
# Add to ~/.ssh/config
Host alana
    HostName spectra-assistant-prod.up.railway.app
    Port 2222
    User alana
    IdentityFile ~/.ssh/id_rsa

# Connect
ssh alana

# Or connect directly from Cursor:
# Cmd/Ctrl+Shift+P → "Remote-SSH: Connect to Host" → alana
```

**First-time setup:**

```bash
bash /opt/spectra-tooling/bootstrap-alana.sh
```

## What You Get

- ✨ **Cursor IDE** with AI coding assistance
- 🛠️ All dev tools: Python, Node, Go, Rust, .NET, Java, Terraform, kubectl
- ☁️ Cloud CLIs: GitHub, Azure, Fabric, Microsoft 365
- 📦 Auto-installed packages and extensions from `tooling.json`
- ⚙️ Pre-configured settings and keybindings
- 💾 Persistent workspace at `/workspaces/SPECTRA`

## Railway Configuration

**Environment Variables:**

```env
SSH_PUBLIC_KEY=<your-public-key>
SSH_PORT=2222
DEV_USER=alana

SPECTRA_GITHUB_ORGS=SPECTRACoreSolutions,SPECTRADataSolutions
SPECTRA_FABRIC_CLIENT_ID=<id>
SPECTRA_FABRIC_CLIENT_SECRET=<secret>
SPECTRA_FABRIC_TENANT_ID=<tenant>
SPECTRA_FABRIC_CAPACITY_ID=<capacity>
SPECTRA_GITHUB_APP_ID=<app-id>
SPECTRA_GITHUB_APP_INSTALLATION_ID_CORE=<installation-id>
SPECTRA_GITHUB_APP_PRIVATE_KEY_PATH=/secrets/github-app-key.pem
```

**Exposed Ports:**

- 2222 (SSH)
- 8080 (HTTP health check)

## Documentation

- 📖 [Full Documentation](alana.md) - Architecture, deployment, customization
- ⚡ [Quick Connect Guide](alana-quick-connect.md) - Fast reference for daily use
- 🔧 [Termius Setup](termius.md) - Mobile/tablet access

## Architecture

```
Your PC (Cursor) ←→ SSH ←→ Railway (Alana Container)
                              ├── Cursor IDE
                              ├── SPECTRA repos (auto-cloned)
                              ├── Dev tools & CLIs
                              └── Settings & extensions (auto-applied)
```

## Philosophy

Alana is not just a devcontainer - she's a persistent AI development assistant living in the cloud. Always ready, fully configured, accessible from anywhere. Born from SPECTRA's vision of cloud-first, AI-powered development.

---

**Next:** [Read the full Alana documentation →](alana.md)
