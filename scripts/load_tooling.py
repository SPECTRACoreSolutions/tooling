#!/usr/bin/env python3
"""
Universal tooling.json loader for all platforms.

This script provides a platform-agnostic way to load the canonical
SPECTRA tooling manifest from Core/tooling/tooling.json.

Usage:
    # Python
    from Core.tooling.scripts.load_tooling import load_tooling
    tooling = load_tooling()
    
    # PowerShell
    $tooling = python -c "from Core.tooling.scripts.load_tooling import load_tooling; import json; print(json.dumps(load_tooling()))" | ConvertFrom-Json
    
    # Bash
    tooling=$(python3 -c "from Core.tooling.scripts.load_tooling import load_tooling; import json; print(json.dumps(load_tooling()))")
"""

import json
import sys
from pathlib import Path
from typing import Any, Dict, Optional


def find_spectra_root(start_path: Optional[Path] = None) -> Path:
    """
    Find SPECTRA workspace root by looking for Core/tooling/tooling.json.
    
    Args:
        start_path: Path to start searching from (default: current working directory)
    
    Returns:
        Path to SPECTRA root directory
    
    Raises:
        ValueError: If SPECTRA root cannot be found
    """
    if start_path is None:
        start_path = Path.cwd()
    
    current = Path(start_path).resolve()
    
    # Walk up the directory tree looking for Core/tooling/tooling.json
    for path in [current] + list(current.parents):
        tooling_json = path / "Core" / "tooling" / "tooling.json"
        if tooling_json.exists():
            return path
    
    raise ValueError(
        f"Cannot find SPECTRA root. Looked for Core/tooling/tooling.json starting from {start_path}"
    )


def load_tooling(repo_root: Optional[Path] = None) -> Dict[str, Any]:
    """
    Load tooling.json from SPECTRA root.
    
    Args:
        repo_root: Path to SPECTRA root (auto-detected if None)
    
    Returns:
        Parsed tooling.json as dictionary
    
    Raises:
        FileNotFoundError: If tooling.json not found
        json.JSONDecodeError: If tooling.json is invalid JSON
    """
    if repo_root is None:
        repo_root = find_spectra_root()
    
    tooling_path = repo_root / "Core" / "tooling" / "tooling.json"
    
    if not tooling_path.exists():
        raise FileNotFoundError(f"tooling.json not found at {tooling_path}")
    
    return json.loads(tooling_path.read_text(encoding="utf-8"))


def get_platform_tool_install(
    tooling: Dict[str, Any], tool_name: str, platform: str
) -> Optional[Dict[str, Any]]:
    """
    Get platform-specific install configuration for a tool.
    
    Args:
        tooling: Loaded tooling.json dictionary
        tool_name: Name of tool (e.g., "git", "python")
        platform: Platform identifier ("windows", "macos", "linux")
    
    Returns:
        Platform-specific install config or None if not found
    """
    tools = tooling.get("tools", {})
    tool = tools.get(tool_name, {})
    install = tool.get("install", {})
    return install.get(platform)


def get_python_packages(tooling: Dict[str, Any]) -> list[str]:
    """Get list of Python packages from tooling.json."""
    return tooling.get("python", {}).get("packages", [])


def get_npm_packages(tooling: Dict[str, Any]) -> list[str]:
    """Get list of npm packages from tooling.json."""
    return tooling.get("npm", {}).get("global", [])


def get_vscode_extensions(tooling: Dict[str, Any]) -> list[str]:
    """Get list of VS Code extensions from tooling.json."""
    return tooling.get("vscode", {}).get("extensions", [])


def get_required_tools(tooling: Dict[str, Any]) -> list[str]:
    """Get list of required tool names."""
    tools = tooling.get("tools", {})
    return [name for name, config in tools.items() if config.get("required", False)]


def main():
    """CLI entry point - prints tooling.json as JSON."""
    try:
        tooling = load_tooling()
        print(json.dumps(tooling, indent=2))
        return 0
    except Exception as e:
        print(f"Error loading tooling.json: {e}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())

