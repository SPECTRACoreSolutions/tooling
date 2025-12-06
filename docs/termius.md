## Termius / SSH

### Connection Details

- **Host**: `spectra-assistant-prod.up.railway.app`
- **Port**: `2222`
- **User**: `alana`
- **Auth**: Use the private key matching Railway var `SSH_PUBLIC_KEY` (set on service).

### Setting up Termius on iOS

1. **Install Termius** from the App Store
2. **Add your SSH key**:
   - Open Termius → Settings → Keys
   - Tap "+" to add a new key
   - Import your private key (the one matching the public key in Railway's `SSH_PUBLIC_KEY` env var)
   - Or generate a new key pair and add the public key to Railway
3. **Create a new host**:
   - Tap "+" → "New Host"
   - **Label**: `Alana` (or any name you prefer)
   - **Address**: `spectra-assistant-prod.up.railway.app`
   - **Port**: `2222`
   - **Username**: `alana`
   - **Key**: Select the SSH key you added in step 2
   - Tap "Save"
4. **Connect**:
   - Tap the host entry
   - Tap "Connect"
   - You should now be connected to Alana!

### First-time Setup

Once connected, run:

```bash
bash /opt/spectra-tooling/bootstrap-alana.sh
```

Then navigate to your workspace:

```bash
cd /workspaces/SPECTRA
```

### Troubleshooting

- **Connection timeout**: Check that Railway service is running and port 2222 is exposed
- **Authentication failed**: Verify your SSH public key is in Railway's `SSH_PUBLIC_KEY` environment variable
- **Key not found**: Make sure you've imported the correct private key in Termius

### Additional Resources

- Termius docs: https://termius.com/documentation/getting-started
- VS Code Remote SSH: configure the same host/port/user/key
