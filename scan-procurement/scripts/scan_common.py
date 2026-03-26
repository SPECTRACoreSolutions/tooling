"""Shared Playwright helpers for Scan trade (managed) account."""
from __future__ import annotations

import os
import sys
from pathlib import Path


def spectra_root() -> Path:
    return Path(__file__).resolve().parents[4]


def load_dotenv_spectra() -> None:
    try:
        from dotenv import load_dotenv
    except ImportError:
        print("Install: pip install python-dotenv", file=sys.stderr)
        raise SystemExit(1) from None
    env_path = spectra_root() / ".env"
    if env_path.is_file():
        load_dotenv(env_path)


DEFAULT_TRADE_LOGIN_URL = (
    "https://secure.scan.co.uk/web/account/login"
    "?redirecturl=https%3A%2F%2Fwww.scan.co.uk%2F"
    "#page=trade"
)


def browser_context(playwright, headed: bool):
    """Reduce empty DOM / Cloudflare issues in plain headless Chromium."""
    browser = playwright.chromium.launch(
        headless=not headed,
        args=["--disable-blink-features=AutomationControlled"],
    )
    context = browser.new_context(
        user_agent=(
            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
            "(KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36"
        ),
        locale="en-GB",
        timezone_id="Europe/London",
        viewport={"width": 1280, "height": 900},
    )
    return browser, context


def trade_login(page, url: str | None = None) -> bool:
    """
    Fill trade form (#usernameTrade / #passwordTrade / #pinCodeTrade) and submit.
    Returns True if a session appears (Log out visible or trade form hidden).
    """
    login_url = url or os.getenv("SCAN_LOGIN_URL", DEFAULT_TRADE_LOGIN_URL)
    user = os.getenv("SCAN_ACCOUNT_USERNAME")
    password = os.getenv("SCAN_ACCOUNT_PASSWORD")
    pin = os.getenv("SCAN_ACCOUNT_PIN", "")

    page.goto(login_url, wait_until="domcontentloaded", timeout=90000)
    page.wait_for_timeout(3500)

    for name in ("Accept all", "Accept All"):
        btn = page.get_by_role("button", name=name)
        if btn.count():
            btn.first.click(timeout=5000)
            break

    page.wait_for_timeout(800)
    page.wait_for_selector("#usernameTrade", state="visible", timeout=30000)
    page.locator("#usernameTrade").fill(user or "")
    page.locator("#passwordTrade").fill(password or "")
    if pin:
        page.locator("#pinCodeTrade").fill(pin)

    page.locator("form:has(#usernameTrade) button[type='submit']").click(timeout=15000)
    page.wait_for_timeout(6000)

    if page.get_by_text("Log out", exact=False).count() > 0:
        return True
    if not page.locator("#usernameTrade").is_visible():
        return True
    return False
