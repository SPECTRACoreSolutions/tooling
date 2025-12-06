#!/usr/bin/env python3
"""Fetch and extract content from Microsoft Fabric documentation"""

import requests
from bs4 import BeautifulSoup


def fetch_doc(url):
    """Fetch and parse Microsoft Learn documentation page"""
    print(f"Fetching: {url}")
    print("=" * 80)

    try:
        response = requests.get(url, timeout=30)
        response.raise_for_status()

        soup = BeautifulSoup(response.text, "html.parser")

        # Extract main content
        main_content = (
            soup.find("main") or soup.find("article") or soup.find(class_="content")
        )

        if not main_content:
            print("❌ Could not find main content")
            return None

        # Extract title
        title = soup.find("h1")
        if title:
            print(f"\n📖 {title.get_text().strip()}\n")

        # Extract all text content
        text = main_content.get_text(separator="\n", strip=True)

        # Clean up multiple newlines
        import re

        text = re.sub(r"\n{3,}", "\n\n", text)

        return text

    except Exception as e:
        print(f"❌ Error fetching {url}: {e}")
        return None


if __name__ == "__main__":
    urls = [
        "https://learn.microsoft.com/en-us/fabric/data-engineering/microsoft-spark-utilities",
        "https://learn.microsoft.com/en-us/fabric/data-engineering/author-execute-notebook",
        "https://learn.microsoft.com/en-us/fabric/data-engineering/how-to-use-notebook",
    ]

    for url in urls:
        content = fetch_doc(url)
        if content:
            print(content[:3000])  # First 3000 chars
            print(f"\n\n... (total length: {len(content)} characters)\n")
            print("=" * 80)
            print()
