#!/usr/bin/env node
/**
 * Generate Portals.streamDeckProfile for Stream Deck+ (8 keys, 4 dials, LCD strip).
 * Portals: Fabric, ADO, Azure, Entra, Intune, Power Platform, M365 Admin, Defender.
 * Run: npm install && npm run generate
 * Then double-click Portals.streamDeckProfile to install.
 *
 * Icons: 3D gradient product logos fetched from GitHub (MicrosoftCloudLogos +
 * dashboardicons). SVGs converted to 72x72 PNG via sharp.
 * Keys show icon only (no title text).
 */

const fs = require('fs');
const path = require('path');
const JSZip = require('jszip');
const sharp = require('sharp');

const ICON_SIZE = 72;

const MSCLOUD = 'https://raw.githubusercontent.com/loryanstrant/MicrosoftCloudLogos/main/';
const DASHICONS = 'https://raw.githubusercontent.com/homarr-labs/dashboard-icons/main/svg/';

const PORTALS = [
  {
    title: 'Fabric',
    url: 'https://app.fabric.microsoft.com/',
    iconUrl: MSCLOUD + 'Fabric/Fabric_256.svg',
  },
  {
    title: 'ADO',
    url: 'https://dev.azure.com/sefirst',
    iconUrl: DASHICONS + 'azure-devops.svg',
  },
  {
    title: 'Azure',
    url: 'https://portal.azure.com/',
    iconUrl: DASHICONS + 'microsoft-azure.svg',
  },
  {
    title: 'Entra',
    url: 'https://entra.microsoft.com/',
    iconUrl: MSCLOUD + 'Entra/Microsoft Entra Product Family.svg',
  },
  {
    title: 'Intune',
    url: 'https://intune.microsoft.com/',
    iconUrl: DASHICONS + 'microsoft-intune.svg',
  },
  {
    title: 'Power Apps',
    url: 'https://make.powerapps.com/',
    iconUrl: MSCLOUD + 'Power Platform/Power Apps/PowerApps_scalable.svg',
  },
  {
    title: 'M365 Admin',
    url: 'https://admin.microsoft.com/',
    iconUrl: DASHICONS + 'microsoft-365.svg',
  },
  {
    title: 'Defender',
    url: 'https://security.microsoft.com/',
    iconUrl: DASHICONS + 'microsoft-defender.svg',
  },
];

async function svgToPng(svgBuffer) {
  return sharp(svgBuffer)
    .resize(ICON_SIZE, ICON_SIZE, { fit: 'contain', background: { r: 0, g: 0, b: 0, alpha: 0 } })
    .png()
    .toBuffer();
}

async function fetchIcon(portal) {
  try {
    const res = await fetch(encodeURI(portal.iconUrl));
    if (!res.ok) throw new Error(`HTTP ${res.status}`);
    const svgBuffer = Buffer.from(await res.arrayBuffer());
    const png = await svgToPng(svgBuffer);
    console.log(`  \u2713 ${portal.title}`);
    return png;
  } catch (e) {
    console.warn(`  \u2717 ${portal.title}: ${e.message}`);
    return null;
  }
}

// --- Stream Deck profile helpers ---

function actionId() {
  return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
    const r = (Math.random() * 16) | 0;
    const v = c === 'x' ? r : (r & 0x3) | 0x8;
    return v.toString(16);
  });
}

function imageId() {
  return Array.from({ length: 26 }, () =>
    'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'[Math.floor(Math.random() * 32)]
  ).join('');
}

function profileId() {
  return actionId();
}

function profileFolderId(uuid) {
  const s = (uuid.replace(/-/g, '') + '000')
    .match(/.{5}/g)
    .map((g) => parseInt(g, 16).toString(32).padStart(4, '0'))
    .join('')
    .substring(0, 26)
    .toUpperCase()
    .replace(/V/g, 'W')
    .replace(/U/g, 'V') + 'Z';
  return s;
}

function websiteAction(title, url, imagePath) {
  return {
    ActionID: actionId(),
    LinkedTitle: false,
    Name: 'Website',
    Resources: null,
    Settings: { openInBrowser: true, path: url },
    State: 0,
    States: [{
      FontFamily: '',
      FontSize: 12,
      FontStyle: '',
      FontUnderline: false,
      Image: imagePath || '',
      OutlineThickness: 2,
      ShowTitle: false,
      Title: title,
      TitleAlignment: 'bottom',
      TitleColor: '#ffffff',
    }],
    UUID: 'com.elgato.streamdeck.system.website',
  };
}

// --- Main ---

async function main() {
  const mainUuid = profileId();
  const profileFolder = profileFolderId(mainUuid);

  console.log('Fetching product brand icons (3D gradient logos)...');
  const iconBuffers = await Promise.all(PORTALS.map(fetchIcon));

  const COLS = 4;
  const byCoordinate = {};
  const imagesDir = {};
  for (let i = 0; i < PORTALS.length; i++) {
    const p = PORTALS[i];
    const col = i % COLS;
    const row = Math.floor(i / COLS);
    let imagePath = '';
    if (iconBuffers[i]) {
      const imgId = imageId();
      imagePath = `Images/${imgId}.png`;
      imagesDir[imagePath] = iconBuffers[i];
    }
    byCoordinate[`${col},${row}`] = websiteAction(p.title, p.url, imagePath);
  }

  const encoderActions = {};
  const dialConfigs = [
    { idx: 0, title: 'Mic Vol', feedbackLayout: '$B1', triggerDescription: { Rotate: 'Mic Volume', Push: 'Mute Mic' } },
    { idx: 1, title: 'App Vol', feedbackLayout: '$B1', triggerDescription: { Rotate: 'App Volume', Push: 'Mute App' } },
    { idx: 2, title: 'Brightness', feedbackLayout: '$B1', triggerDescription: { Rotate: 'Brightness', Push: 'Reset' } },
    { idx: 3, title: 'Scroll', feedbackLayout: '$B1', triggerDescription: { Rotate: 'Scroll', Push: 'Page Top' } },
  ];
  for (const d of dialConfigs) {
    encoderActions[`${d.idx},0`] = {
      ActionID: actionId(),
      Name: d.title,
      Settings: {},
      State: 0,
      States: [{
        FontFamily: '',
        FontSize: 9,
        FontStyle: '',
        FontUnderline: false,
        Image: '',
        ShowTitle: false,
        Title: d.title,
        TitleAlignment: 'middle',
        TitleColor: '#ffffff',
      }],
      UUID: 'com.elgato.streamdeck.dial.brightness',
    };
  }

  const profileManifest = {
    Controllers: [
      { Actions: byCoordinate, Type: 'Keypad' },
      { Actions: encoderActions, Type: 'Encoder' },
    ],
    Icon: '',
    Name: 'Portals',
  };

  const topLevelManifest = {
    Name: 'Portals',
    Pages: {
      Current: mainUuid,
      Default: mainUuid,
      Pages: [mainUuid],
    },
    Version: '2.0',
  };

  const zip = new JSZip();
  const rootDir = zip.folder(`${mainUuid}.sdProfile`);
  rootDir.file('manifest.json', JSON.stringify(topLevelManifest));

  const profilesDir = rootDir.folder('Profiles');
  const profileDir = profilesDir.folder(profileFolder);
  profileDir.file('manifest.json', JSON.stringify(profileManifest));

  for (const [imgPath, buf] of Object.entries(imagesDir)) {
    profileDir.file(imgPath, buf);
  }

  const outPath = path.join(__dirname, 'Portals.streamDeckProfile');
  const buffer = await zip.generateAsync({ type: 'nodebuffer' });
  fs.writeFileSync(outPath, buffer);

  console.log(`\nCreated ${outPath}`);
  console.log('Double-click it to install the profile in Stream Deck.');
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
