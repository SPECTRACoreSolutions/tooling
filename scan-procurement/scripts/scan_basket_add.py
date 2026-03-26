#!/usr/bin/env python3
"""
Scan.co.uk — trade login, search, add first sensible result to basket.
Stops before checkout. Credentials from SPECTRA workspace root `.env` (SCAN_*).

Usage:
  python scripts/scan_basket_add.py --query "nvme ssd 2tb" --headed
"""
from __future__ import annotations

import argparse
import os
import sys
from pathlib import Path

_SCRIPT_DIR = Path(__file__).resolve().parent
if str(_SCRIPT_DIR) not in sys.path:
    sys.path.insert(0, str(_SCRIPT_DIR))

from scan_common import browser_context, load_dotenv_spectra, spectra_root, trade_login  # noqa: E402


def main() -> int:
    ap = argparse.ArgumentParser(description="Scan UK: login, search, add to basket (no checkout).")
    ap.add_argument("--query", "-q", required=True, help='Search text, e.g. "nvme ssd 2tb"')
    ap.add_argument("--headed", action="store_true", help="Show browser")
    ap.add_argument("--dry-run", action="store_true", help="Print config only (no browser)")
    args = ap.parse_args()

    load_dotenv_spectra()
    user = os.getenv("SCAN_ACCOUNT_USERNAME")
    password = os.getenv("SCAN_ACCOUNT_PASSWORD")
    base = os.getenv("SCAN_BASE_URL", "https://www.scan.co.uk").rstrip("/")

    if args.dry_run:
        print(f"SPECTRA root: {spectra_root()}")
        print(f"SCAN_ACCOUNT_USERNAME: {user or '(missing)'}")
        print(f"SCAN_ACCOUNT_PASSWORD: {'set' if password else '(missing)'}")
        print(f"SCAN_BASE_URL: {base}")
        print(f"query: {args.query}")
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
        browser, context = browser_context(p, args.headed)
        page = context.new_page()
        try:
            if not trade_login(page):
                print("Trade login failed — fix credentials or use scan_business_login.py --headed", file=sys.stderr)
                return 2

            page.goto(base, wait_until="domcontentloaded", timeout=60000)
            page.wait_for_timeout(1500)

            search = page.locator(
                "input[type='search'], input[name*='q' i], input[placeholder*='Search' i]"
            ).first
            search.fill(args.query)
            search.press("Enter")
            page.wait_for_load_state("domcontentloaded", timeout=60000)
            page.wait_for_timeout(2000)

            product = page.locator(
                "a[href*='/products/'], a[href*='/product/'], .product-item a"
            ).first
            product.click(timeout=15000)
            page.wait_for_load_state("domcontentloaded", timeout=60000)
            page.wait_for_timeout(1500)

            atb = page.get_by_role("button", name="Add to basket")
            if atb.count() == 0:
                atb = page.get_by_role("button", name="Add to Basket")
            if atb.count() == 0:
                atb = page.locator("button:has-text('Add to basket'), button:has-text('Add to Basket')")
            atb.first.click(timeout=15000)

            print("Added to basket. Review in browser; checkout manually (no payment in this script).")

            if args.headed:
                input("Press Enter to close the browser…")
        finally:
            browser.close()

    return 0


if __name__ == "__main__":
    sys.exit(main())
