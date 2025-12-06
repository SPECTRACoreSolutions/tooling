# Quick Reference: Connecting to Alana

## From your PC (Windows/Mac/Linux)

### 1. Add SSH Config Entry

Edit `~/.ssh/config` (or `C:\Users\<you>\.ssh\config` on Windows):

```ssh-config
Host alana
    HostName spectra-assistant-prod.up.railway.app
    Port 2222
    User alana
    IdentityFile ~/.ssh/id_rsa
```

### 2. Connect via Cursor

**Option A: Remote SSH Extension**

1. Open Cursor
2. Press `Cmd/Ctrl+Shift+P`
3. Type "Remote-SSH: Connect to Host"
4. Select "alana"
5. Wait for connection...
6. You're in! 🚀

**Option B: Terminal First**

```bash
ssh alana
cd /workspaces/SPECTRA
cursor .
```

### 3. First-Time Setup

Once connected, run the bootstrap:

```bash
bash /opt/spectra-tooling/bootstrap-alana.sh
```

This will:

- Authenticate GitHub & Azure
- Clone all SPECTRA repos
- Install packages & extensions
- Create your workspace

### 4. Open Your Workspace

In Cursor (connected to Alana):

- File → Open Folder → `/workspaces/SPECTRA`
- Or File → Open Workspace → `/workspaces/SPECTRA/spectra.code-workspace`

---

## Useful Commands (inside Alana)

```bash
# Check what's installed
cursor --version
python3 --version
node --version
gh --version
az --version

# Authenticate services
gh auth login
az login

# Update repos
cd /workspaces/SPECTRA/Core/framework
git pull

# Install new Cursor extension
cursor --install-extension <extension-id>

# Check environment
echo $SPECTRA_FABRIC_CLIENT_ID
```

---

## Troubleshooting

**Can't connect?**

- Check your SSH key is in Railway's `SSH_PUBLIC_KEY` env var
- Try: `ssh -v alana` to see verbose connection logs

**Cursor extensions missing?**

- Run: `cursor --list-extensions`
- Check: `/var/log/cursor-ext.log`

**Repos not cloned?**

- Check: `gh auth status`
- Re-run: `bash /opt/spectra-tooling/bootstrap-alana.sh`

---

**Pro Tip:** Bookmark this page for quick reference when connecting to Alana!
