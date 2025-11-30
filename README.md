# Tooling (Unified)

Single manifest-driven setup for local, devcontainer, and Windows/macOS environments.

- Manifest: `infrastructure/tooling/tooling.json` (Python packages, npm globals, VS Code extensions, required env vars, profile snippets)
- Installer: `infrastructure/tooling/scripts/install-tooling.ps1`
- Health check: `infrastructure/tooling/scripts/tooling-check.ps1`
- Docs: `infrastructure/tooling/docs/`

Usage examples:
- Devcontainer postCreate: `pwsh ./infrastructure/tooling/scripts/install-tooling.ps1 -SkipExtensions`
- Host install: `pwsh ./infrastructure/tooling/scripts/install-tooling.ps1`
- Health check: `pwsh ./infrastructure/tooling/scripts/tooling-check.ps1`

Legacy bootstraps under `onboarding/bootstrap` should call into these scripts to avoid duplicating package/extension lists.
