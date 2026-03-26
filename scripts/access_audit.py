#!/usr/bin/env python3
"""
SPECTRA Access Audit

Goal: Make autonomy frictionless by answering:
- What integrations exist?
- Where do their credentials live (Vault / Bridge / GitHub Secrets / Windows env)?
- Are any placeholders or obvious gaps present?

CRITICAL: This tool prints METADATA ONLY. It MUST NOT print secret values.
"""

from __future__ import annotations

import argparse
import os
import re
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable

import yaml


WORKSPACE_ROOT = Path(__file__).resolve().parents[3]


def _read_text(path: Path) -> str:
    return path.read_text(encoding="utf-8", errors="replace")


def _parse_env_keys(env_text: str) -> set[str]:
    """
    Parse keys from .env even if it’s been flattened into one line.
    We extract KEY= occurrences and return unique keys.
    """
    keys = set()
    for m in re.finditer(r"([A-Z0-9_]+)=", env_text):
        keys.add(m.group(1))
    return keys


def _env_value(env_text: str, key: str) -> str | None:
    """
    Best-effort value extraction for a single key in a potentially single-line .env.
    Returns the raw value substring (not printed by default).
    """
    m = re.search(rf"{re.escape(key)}=([^\\s]+)", env_text)
    return m.group(1) if m else None


def _vault_registry_secret_names(vault_registry_md: str) -> set[str]:
    names = set()
    for line in vault_registry_md.splitlines():
        # Table row pattern: | NAME | `secrets/NAME.env.age` | ... |
        if "|" not in line:
            continue
        parts = [p.strip() for p in line.split("|")]
        if len(parts) < 3:
            continue
        candidate = parts[1]
        if re.fullmatch(r"[A-Z0-9_]+", candidate):
            names.add(candidate)
    return names


def _load_yaml(path: Path) -> dict:
    return yaml.safe_load(_read_text(path)) or {}


@dataclass(frozen=True)
class Finding:
    severity: str  # info|warn|error
    message: str


def audit() -> tuple[list[str], list[Finding]]:
    lines: list[str] = []
    findings: list[Finding] = []

    lines.append("# SPECTRA Access Audit")
    lines.append("")
    lines.append(f"- **workspace_root**: `{WORKSPACE_ROOT}`")
    lines.append("")

    # .env (names only)
    env_path = WORKSPACE_ROOT / ".env"
    if env_path.exists():
        env_text = _read_text(env_path)
        env_keys = sorted(_parse_env_keys(env_text))
        lines.append("## .env (keys only)")
        lines.append(f"- **path**: `{env_path}`")
        lines.append(f"- **keys_found**: {len(env_keys)}")
        lines.append("")
        for k in env_keys[:80]:
            lines.append(f"- `{k}`")
        if len(env_keys) > 80:
            lines.append(f"- ... and {len(env_keys) - 80} more")
        lines.append("")

        # Common placeholder detection (do not print secrets)
        for placeholder_key in ("DISCORD_WEBHOOK_URL_CHAT", "SPECTRA_FIGMA_API_TOKEN"):
            val = _env_value(env_text, placeholder_key)
            if val and val.strip() == "__SET_IN_WINDOWS_USER_ENV__":
                findings.append(
                    Finding(
                        "warn",
                        f"`.env` contains placeholder for `{placeholder_key}`; prefer Windows env var or move to Bridge/GitHub Secrets.",
                    )
                )
    else:
        findings.append(Finding("warn", "Workspace `.env` not found."))

    # Vault registry (names only)
    vault_root = WORKSPACE_ROOT / "Core" / "Vault"
    vault_registry = vault_root / "registry.md"
    lines.append("## Vault (bootstrap secrets)")
    lines.append(f"- **path**: `{vault_root}`")
    if vault_registry.exists():
        md = _read_text(vault_registry)
        secret_names = sorted(_vault_registry_secret_names(md))
        lines.append(f"- **registry**: `{vault_registry}`")
        lines.append(f"- **registered_secrets**: {len(secret_names)}")
        for name in secret_names:
            lines.append(f"  - `{name}`")
    else:
        findings.append(Finding("warn", "Vault registry.md not found; Vault may be incomplete or moved."))
    lines.append("")

    # Access registry (metadata)
    access_registry = WORKSPACE_ROOT / "Core" / "registries" / "access-registry.yaml"
    lines.append("## Access registry")
    if access_registry.exists():
        reg = _load_yaml(access_registry)
        integrations = reg.get("integrations", []) or []
        sessions = reg.get("interactive_sessions", []) or []
        lines.append(f"- **path**: `{access_registry}`")
        lines.append(f"- **integrations**: {len(integrations)}")
        lines.append(f"- **interactive_sessions**: {len(sessions)}")

        # Quick checks for Figma integration
        figma = next((x for x in integrations if x.get("vendor") == "figma"), None)
        if figma:
            lines.append("")
            lines.append("### Figma integration quick check")
            reqs = figma.get("required_inputs", []) or []
            required_secret_names = set()
            for r in reqs:
                for loc in (r.get("runtime_locations", []) or []):
                    if loc.get("type") == "github_actions_secret":
                        required_secret_names.add(loc.get("secret_name"))
            for s in sorted(required_secret_names):
                lines.append(f"- expects GitHub Actions secret: `{s}` (repo: `SPECTRADesignSolutions/design-system`)")
    else:
        findings.append(Finding("warn", "Access registry not found; add `Core/registries/access-registry.yaml`."))
    lines.append("")

    return lines, findings


def main() -> None:
    parser = argparse.ArgumentParser(description="SPECTRA access audit (metadata only).")
    parser.add_argument("--output", help="Write report to this path (markdown).")
    args = parser.parse_args()

    lines, findings = audit()

    lines.append("## Findings")
    if not findings:
        lines.append("- ✅ No obvious issues detected (metadata-only audit).")
    else:
        for f in findings:
            prefix = {"info": "ℹ️", "warn": "⚠️", "error": "❌"}.get(f.severity, "•")
            lines.append(f"- {prefix} **{f.severity}**: {f.message}")
    lines.append("")

    report = "\n".join(lines)
    if args.output:
        out = Path(args.output)
        out.parent.mkdir(parents=True, exist_ok=True)
        out.write_text(report, encoding="utf-8")
        # Avoid Windows console encoding issues (cp1252) by not printing emoji.
        print(f"Wrote report: {out}")
    else:
        print(report)


if __name__ == "__main__":
    main()

