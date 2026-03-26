# Scan Computers — Managed Account (SPECTRA procurement)

**Purpose:** Hold **documented env vars** and optional **local automation** to sign in to Scan’s business portal, search, and **add items to the basket** — with **no automated payment** (human completes checkout).

**Last updated:** 2026-02-19

---

## 1. Environment variables (SPECTRA `.env`)

All secrets live in the **SPECTRA workspace root** `.env` (gitignored). Do **not** commit passwords or PINs.

| Variable | Required | Description |
|----------|----------|-------------|
| `SCAN_ACCOUNT_USERNAME` | Yes | Business login user name (e.g. **SPECTRAA**). |
| `SCAN_ACCOUNT_PASSWORD` | Yes | Website password from welcome letter. |
| `SCAN_ACCOUNT_PIN` | Optional | PIN if the site prompts for it. |
| `SCAN_BASE_URL` | No | Default `https://www.scan.co.uk` (shop/search after login). |
| `SCAN_LOGIN_URL` | No | Default: **secure** trade login with `#page=trade` (see `scripts/scan_business_login.py`). |

**Welcome letter vs live site:** The PDF describes “My Account → Login → existing business customer”. On the current site you can use the **BUSINESS LOGIN** link on [scan.co.uk](https://www.scan.co.uk) (same as the default `SCAN_LOGIN_URL`). The trade form uses **Username**, **Password**, and **Pin code** — DOM ids: `usernameTrade`, `passwordTrade`, `pinCodeTrade` (not the retail Email field).

**Setup:** Copy lines from `Core/tooling/scan-procurement/.env.example` into your SPECTRA root `.env` and fill values from your welcome PDF or Scan account settings.

---

## 2. Business login only

Try a managed-account login (no basket):

```powershell
cd "Core\tooling\scan-procurement"
python scripts\scan_business_login.py
python scripts\scan_business_login.py --headed
```

If Scan rejects the password, confirm in a normal browser, use “Forgotten password”, or check that the welcome letter password was copied correctly (no extra spaces).

---

## 3. Integration model (agent / Alana)

| Stage | Who | Notes |
|-------|-----|--------|
| Search + basket | Automation **or** agent-guided browser | Script loads `SCAN_*` from `.env`, logs in, searches, adds line to basket. |
| Review basket | **You** | Check SKU, qty, address, VAT. |
| Payment | **You** | Card/BACS per your terms (“payment ahead of despatch”). No headless card storage in repo. |

**Principle:** Treat this like **Starling read-only style** — credentials in `.env`, automation only up to **pre-payment**; no storing card numbers in env.

---

## 3. Script: add search to basket (Playwright)

From SPECTRA workspace root (or anywhere), with Python 3.11+:

```powershell
cd "Core\tooling\scan-procurement"
pip install -r requirements.txt
playwright install chromium
```

Run (example: NVMe SSD):

```powershell
python scripts\scan_basket_add.py --query "nvme ssd 2tb"
```

- `--headed` — show the browser (recommended until selectors stabilise).
- `--dry-run` — load env and print steps only (no browser).

**First run:** Site markup changes often; if login or search fails, update selectors in `scripts/scan_basket_add.py` (or run headed and complete manually).

---

## 5. Related

- Welcome letter PDF extraction (optional): `SE-First/operations/playbooks/azure-devops/scripts/extract_pdf_text.py`
- PC build / hardware context: `Core/tooling/pc-build-toolkit/`

---

## 6. Security

- Rotate the website password if it was ever pasted into chat or committed.
- Keep `SCAN_*` only in `.env` or Vault — never in Markdown or JSON in git.
