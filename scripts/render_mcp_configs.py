import argparse
import json
from pathlib import Path
from typing import Any, Dict, Optional

import yaml


def _is_secret_placeholder(value: Any) -> bool:
    if not isinstance(value, str):
        return False
    stripped = value.strip()
    if stripped == "":
        return True
    return stripped.startswith("__") and stripped.endswith("__")


def _strip_empty_or_placeholder_env(servers: Dict[str, Any]) -> Dict[str, Any]:
    """Remove env entries that are empty or unresolved placeholders.

    This prevents generated MCP configs from overriding real environment variables
    with empty strings.
    """

    cleaned: Dict[str, Any] = {}
    for name, cfg in servers.items():
        if not isinstance(cfg, dict):
            cleaned[name] = cfg
            continue

        new_cfg = dict(cfg)
        env = new_cfg.get("env")
        if isinstance(env, dict):
            filtered_env = {k: v for k, v in env.items() if not _is_secret_placeholder(v)}
            if filtered_env:
                new_cfg["env"] = filtered_env
            else:
                new_cfg.pop("env", None)

        cleaned[name] = new_cfg

    return cleaned


def _strip_unsupported_keys_for_windsurf(servers: Dict[str, Any]) -> Dict[str, Any]:
    """Windsurf MCP config follows the Claude Desktop schema; strip unsupported keys."""
    cleaned: Dict[str, Any] = {}
    for name, cfg in servers.items():
        if isinstance(cfg, dict):
            new_cfg = dict(cfg)
            # Windsurf validator rejects 'cwd'
            new_cfg.pop("cwd", None)
            cleaned[name] = new_cfg
        else:
            cleaned[name] = cfg
    return cleaned


def _exclude_servers(servers: Dict[str, Any], exclude: Optional[list[str]]) -> Dict[str, Any]:
    if not exclude:
        return servers
    exclude_set = {e.strip() for e in exclude if e and e.strip()}
    if not exclude_set:
        return servers
    return {k: v for k, v in servers.items() if k not in exclude_set}


def _find_spectra_root(start: Optional[Path] = None) -> Path:
    if start is None:
        start = Path.cwd()

    current = start.resolve()
    for p in [current] + list(current.parents):
        if (p / "Core" / "tooling").exists():
            return p
    raise RuntimeError(f"Unable to locate SPECTRA root from {start}")


def _load_yaml(path: Path) -> Dict[str, Any]:
    with path.open("r", encoding="utf-8") as f:
        return yaml.safe_load(f) or {}


def _apply_substitutions(value: Any, subs: Dict[str, str]) -> Any:
    if isinstance(value, str):
        out = value
        for k, v in subs.items():
            out = out.replace(k, v)
        return out
    if isinstance(value, list):
        return [_apply_substitutions(v, subs) for v in value]
    if isinstance(value, dict):
        return {k: _apply_substitutions(v, subs) for k, v in value.items()}
    return value


def render_configs(
    yaml_path: Path,
    output_dir: Path,
    target: str,
    substitutions: Dict[str, str],
) -> None:
    data = _load_yaml(yaml_path)
    servers = data.get("mcp_servers") or {}

    rendered_servers = _apply_substitutions(servers, substitutions)
    rendered_servers = _strip_empty_or_placeholder_env(rendered_servers)
    payload = {"mcpServers": rendered_servers}

    output_dir.mkdir(parents=True, exist_ok=True)

    if target in ("cursor", "all"):
        (output_dir / "cursor").mkdir(parents=True, exist_ok=True)
        (output_dir / "cursor" / "mcp.json").write_text(
            json.dumps(payload, indent=2), encoding="utf-8"
        )

    if target in ("windsurf", "all"):
        windsurf_servers = _strip_unsupported_keys_for_windsurf(rendered_servers)
        windsurf_payload = {"mcpServers": windsurf_servers}
        (output_dir / "windsurf").mkdir(parents=True, exist_ok=True)
        (output_dir / "windsurf" / "mcp_config.json").write_text(
            json.dumps(windsurf_payload, indent=2), encoding="utf-8"
        )


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--yaml",
        dest="yaml_path",
        default=None,
        help="Path to canonical mcp-servers.yaml",
    )
    parser.add_argument(
        "--output-dir",
        default=None,
        help="Directory to write vendor config outputs (default: Core/tooling/config)",
    )
    parser.add_argument(
        "--target",
        choices=["cursor", "windsurf", "all"],
        default="all",
    )
    parser.add_argument(
        "--spectra-root",
        default=None,
        help="SPECTRA workspace root (default: auto-detect)",
    )
    parser.add_argument(
        "--substitute-secrets-with-empty",
        action="store_true",
        help="Replace secret placeholders with empty strings",
    )

    parser.add_argument(
        "--exclude-cursor",
        action="append",
        default=None,
        help="MCP server name to exclude from Cursor output (repeatable)",
    )
    parser.add_argument(
        "--exclude-windsurf",
        action="append",
        default=None,
        help="MCP server name to exclude from Windsurf output (repeatable)",
    )

    args = parser.parse_args()

    spectra_root = Path(args.spectra_root).resolve() if args.spectra_root else _find_spectra_root()

    yaml_path = (
        Path(args.yaml_path).resolve()
        if args.yaml_path
        else spectra_root / "Core" / "tooling" / "config" / "mcp" / "mcp-servers.yaml"
    )

    output_dir = (
        Path(args.output_dir).resolve()
        if args.output_dir
        else spectra_root / "Core" / "tooling" / "config"
    )

    substitutions: Dict[str, str] = {
        "__SPECTRA_ROOT__": str(spectra_root),
    }

    if args.substitute_secrets_with_empty:
        substitutions.update(
            {
                "__GITHUB_PERSONAL_ACCESS_TOKEN__": "",
                "__ATLASSIAN_API_TOKEN__": "",
                "__ATLASSIAN_DOMAIN__": "",
            }
        )

    data = _load_yaml(yaml_path)
    servers = data.get("mcp_servers") or {}
    rendered_servers = _apply_substitutions(servers, substitutions)
    rendered_servers = _strip_empty_or_placeholder_env(rendered_servers)

    if args.target in ("cursor", "all"):
        cursor_servers = _exclude_servers(rendered_servers, args.exclude_cursor)
        payload = {"mcpServers": cursor_servers}
        (output_dir / "cursor").mkdir(parents=True, exist_ok=True)
        (output_dir / "cursor" / "mcp.json").write_text(
            json.dumps(payload, indent=2), encoding="utf-8"
        )

    if args.target in ("windsurf", "all"):
        windsurf_servers = _exclude_servers(rendered_servers, args.exclude_windsurf)
        windsurf_servers = _strip_unsupported_keys_for_windsurf(windsurf_servers)
        windsurf_payload = {"mcpServers": windsurf_servers}
        (output_dir / "windsurf").mkdir(parents=True, exist_ok=True)
        (output_dir / "windsurf" / "mcp_config.json").write_text(
            json.dumps(windsurf_payload, indent=2), encoding="utf-8"
        )
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
