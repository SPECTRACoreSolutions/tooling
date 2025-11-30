# Deploying Alana to Railway

This guide walks you through deploying Alana to Railway.

## Prerequisites

- Railway account ([railway.app](https://railway.app))
- GitHub repository with SPECTRA infrastructure code
- SSH public key for remote access
- SPECTRA service credentials (Fabric, GitHub App)

## Step 1: Create Railway Project

1. Log in to [Railway](https://railway.app)
2. Click "New Project"
3. Select "Deploy from GitHub repo"
4. Choose your SPECTRA repository

## Step 2: Configure Service

### Build Settings

**Root Directory:** `Core/infrastructure/devcontainer-service`  
**Dockerfile Path:** `Dockerfile`

Or use the Railway CLI:

```bash
railway init
railway up
```

### Environment Variables

Add these in Railway dashboard (Settings → Variables):

#### Required - SSH Access

```env
SSH_PUBLIC_KEY=ssh-rsa AAAAB3NzaC1yc2E... (your public key)
SSH_PORT=2222
DEV_USER=alana
```

#### Required - SPECTRA Configuration

```env
# Microsoft Fabric
SPECTRA_FABRIC_CLIENT_ID=your-client-id
SPECTRA_FABRIC_CLIENT_SECRET=your-client-secret
SPECTRA_FABRIC_TENANT_ID=your-tenant-id
SPECTRA_FABRIC_CAPACITY_ID=your-capacity-id

# GitHub App
SPECTRA_GITHUB_APP_ID=your-app-id
SPECTRA_GITHUB_APP_INSTALLATION_ID_CORE=your-installation-id
SPECTRA_GITHUB_APP_PRIVATE_KEY_PATH=/secrets/github-app-key.pem

# GitHub organisations (comma-separated)
SPECTRA_GITHUB_ORGS=SPECTRACoreSolutions,SPECTRADataSolutions
```

#### Optional

```env
# Enable password auth (not recommended)
SSH_PASSWORD=your-password

# Custom ports
CODE_PORT=8080
HEALTH_PORT=80
```

### Networking

1. Go to Settings → Networking
2. Ensure port **2222** is exposed
3. Note the public URL (e.g., `spectra-assistant-prod.up.railway.app`)

## Step 3: Deploy

Click "Deploy" or run:

```bash
railway up
```

Watch the logs:

```bash
railway logs
```

You should see:

- SSH server starting on port 2222
- Repos being cloned (if configured)
- Tooling being applied
- "Alana is ready" message

## Step 4: Connect from Your PC

### Add SSH Config

Edit `~/.ssh/config`:

```ssh-config
Host alana
    HostName spectra-assistant-prod.up.railway.app
    Port 2222
    User alana
    IdentityFile ~/.ssh/id_rsa
    StrictHostKeyChecking no
```

### Test Connection

```bash
ssh alana
```

You should be connected as the `alana` user!

### Connect via Cursor

1. Open Cursor
2. Press `Cmd/Ctrl+Shift+P`
3. Type "Remote-SSH: Connect to Host"
4. Select "alana"
5. Wait for connection...
6. You're in! 🚀

## Step 5: First-Time Setup

Once connected via SSH:

```bash
bash /opt/spectra-tooling/bootstrap-alana.sh
```

This will:

- Verify all tools are installed
- Authenticate GitHub & Azure (interactive)
- Clone all SPECTRA repositories
- Install packages and extensions
- Create workspace file

## Step 6: Open Your Workspace

In Cursor (connected to Alana):

1. File → Open Folder
2. Navigate to `/workspaces/SPECTRA`
3. Click "Open"

Or open the workspace file:

1. File → Open Workspace
2. Navigate to `/workspaces/SPECTRA/spectra.code-workspace`
3. Click "Open"

## Monitoring & Maintenance

### View Logs

```bash
railway logs
# Or in the Railway dashboard → Deployments → Logs
```

### Check Service Status

SSH into Alana:

```bash
ssh alana
ps aux | grep sshd
ps aux | grep cursor
```

### Update Environment Variables

1. Railway dashboard → Settings → Variables
2. Add/edit variables
3. Redeploy (automatic on variable change)

### Rebuild Container

```bash
railway up --detach
```

Or push changes to GitHub (auto-deploys).

## Troubleshooting

### Can't Connect via SSH

**Check exposed port:**

- Railway dashboard → Settings → Networking
- Ensure port 2222 is in the list

**Verify public key:**

```bash
railway variables get SSH_PUBLIC_KEY
```

**Check logs:**

```bash
railway logs | grep ssh
```

### Repos Not Cloning

**Check GitHub configuration:**

```bash
ssh alana
gh auth status
```

**Manually authenticate:**

```bash
ssh alana
gh auth login
```

**Check environment variables:**

```bash
ssh alana
echo $SPECTRA_GITHUB_ORGS
```

### Extensions Not Installing

**Check logs:**

```bash
ssh alana
cat /var/log/cursor-ext.log
```

**Manually install:**

```bash
cursor --install-extension <extension-id>
```

### Container Keeps Restarting

**Check healthcheck:**

```bash
railway logs | grep health
```

**Verify Dockerfile builds:**

```bash
cd Core/infrastructure/devcontainer-service
docker build -t alana-test .
docker run -p 2222:2222 alana-test
```

## Cost optimisation

Railway charges based on:

- CPU usage
- Memory usage
- Network egress

### Tips to Reduce Costs

1. **Hibernate when not in use:**

   ```bash
   railway down  # Stop service
   railway up    # Start service
   ```

2. **Use Resource Limits:**

   - Settings → Resources
   - Set memory limit (e.g., 2GB)
   - Set CPU limit

3. **Monitor Usage:**
   - Dashboard → Usage
   - Check daily/monthly usage
   - Set up alerts

## Advanced Configuration

### Custom Domain

1. Railway dashboard → Settings → Domains
2. Add custom domain
3. Update SSH config with new hostname

### Volume Storage (Persistent Data)

1. Railway dashboard → Settings → Volumes
2. Create volume at `/workspaces`
3. Redeploy

This ensures your workspace persists across deploys!

### Multiple Users

To add more users:

1. Update Dockerfile to create additional users
2. Add their SSH public keys
3. Configure separate home directories

### Auto-Scaling

Railway handles this automatically, but you can set limits:

- Settings → Resources
- Configure min/max replicas
- Set scaling rules

## Next Steps

- [Read the full Alana documentation](../docs/alana.md)
- [Quick connect reference](../docs/alana-quick-connect.md)
- [Customize your tooling.json](../tooling.json)

---

**Alana is now deployed and ready to assist! 🚀**
