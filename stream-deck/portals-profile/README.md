# Portals Stream Deck Profile

**Purpose:** Generate a Stream Deck profile with one-tap website buttons for Fabric, ADO, Azure, Entra, Intune, and Power Platform — each with its favicon.

## Usage

```bash
npm install
npm run generate
```

Then double-click `Portals.streamDeckProfile` to install the profile in Stream Deck.

## Contents

| Button | URL |
|--------|-----|
| Fabric | https://app.fabric.microsoft.com/ |
| ADO | https://dev.azure.com/sefirst |
| Azure | https://portal.azure.com/ |
| Entra | https://entra.microsoft.com/ |
| Intune | https://intune.microsoft.com/ |
| Power Platform | https://make.powerapps.com/ |

## Icons

Uses **local branding icons** from `Core/branding/assets/icons/png/128/`:

| Button        | Icon file                  |
|---------------|----------------------------|
| Fabric        | devops-integration.png     |
| ADO           | devops-devops.png          |
| Azure         | support-cloud-computing.png|
| Entra         | devops-configuration.png   |
| Intune        | devops-operate.png         |
| Power Platform| devops-launch.png          |

If a local file is missing, falls back to favicon. To use different icons, edit the `iconFile` mapping in `generate.js`.
