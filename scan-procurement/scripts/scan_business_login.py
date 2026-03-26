#!/usr/bin/env python3
"""
Log in to Scan **Existing Business & Public Sector** account (welcome letter flow).

See README in `Core/tooling/scan-procurement/` for URL and field ids.
"""
from __future__ import annotations

import argparse
import sys
from pathlib import Path

# Allow `python scripts/scan_business_login.py` without package install
_SCRIPT_DIR = Path(__file__).resolve().parent
if str(_SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(_SCRIPT_DIR))

from scan_common import (  # noqa: E402
    DEFAULT_TRADE_LOGIN_URL,
    browser_context,
    load_dotenv_spectra,
    spectra_root,
    trade_login,
)


def main() -> int:
    ap = argparse.ArgumentParser(description="Scan UK: business / trade login only.")
    ap.add_argument("--headed", action="store_true", help="Show browser (use if login fails headless)")
    ap.add_argument("--dry-run", action="store_true", help="Print env only")
    ap.add_argument(
        "--url",
        default=None,
        help="Override login URL (default: SCAN_LOGIN_URL or built-in trade URL)",
    )
    args = ap.parse_args()

    import os

    load_dotenv_spectra()
    user = os.getenv("SCAN_ACCOUNT_USERNAME")
    password = os.getenv("SCAN_ACCOUNT_PASSWORD")
    pin = os.getenv("SCAN_ACCOUNT_PIN", "")

    if args.dry_run:
        print(f"SPECTRA root: {spectra_root()}")
        print(f"SCAN_ACCOUNT_USERNAME: {user or '(missing)'}")
        print(f"SCAN_ACCOUNT_PASSWORD: {'set' if password else '(missing)'}")
        print(f"SCAN_ACCOUNT_PIN: {'set' if pin else '(missing)'}")
        print(f"URL: {args.url or os.getenv('SCAN_LOGIN_URL', DEFAULT_TRADE_LOGIN_URL)}")
        return 0 if user and password else 1

    if not user or not password:
        print("Set SCAN_ACCOUNT_USERNAME and SCAN_ACCOUNT_PASSWORD in SPECTRA .env", file=sys.stderr)
        return 1

    try:
        from playwright.sync_api import sync_playwright  # type: ignore[import-untyped]
    except ImportError:
        print("Install: pip install playwright && playwright install chromium", file=sys.stderr)
        return 1

    with sync_playwright() as p:
        br, context = browser_context(p, args.headed)
        page = context.new_page()
        try:
            ok = trade_login(page, url=args.url)
            if not ok:
                print(
                    "Scan did not accept these credentials (or PIN), or session did not establish.",
                    file=sys.stderr,
                )
                print(f"(URL: {page.url})", file=sys.stderr)
                return 2

            print(f"Final URL: {page.url}")
            print(f"Page title: {page.title()}")
            print("Login appears successful.")

            if args.headed:
                input("Press Enter to close…")
        finally:
            br.close()

    return 0


if __name__ == "__main__":
    sys.exit(main())
