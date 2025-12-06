# Package Distribution

The `spectra-fabric-sdk` package is published to the Spectra GitHub Packages feed so every workspace can install the CLI and standards from a tagged artifact.

## Publishing Workflow

1. Tag or publish a release (e.g. `v1.5.3`).
2. The **Publish Framework Package** GitHub Actions workflow builds the wheel + sdist and uploads them via Twine to `https://pip.pkg.github.com/SPECTRADataSolutions`.
3. The workflow runs automatically on release publication or via manual dispatch. It uses the repository `GITHUB_TOKEN` with `packages:write` permission.

> Manual fallback: run `python -m build` locally and `python -m twine upload dist/* --repository-url https://pip.pkg.github.com/SPECTRADataSolutions` using a PAT with `write:packages` scope.

## Consuming the Package

Users need a Personal Access Token (PAT) with `read:packages` scope.

### pip.ini / pip.conf

Windows (`%APPDATA%/pip/pip.ini`):

```
[global]
extra-index-url = https://USERNAME:PAT@pip.pkg.github.com/SPECTRADataSolutions
```

macOS/Linux (`~/.config/pip/pip.conf`):

```
[global]
extra-index-url = https://USERNAME:PAT@pip.pkg.github.com/SPECTRADataSolutions
```

Replace `USERNAME` with your GitHub username and `PAT` with a token that has `read:packages`. Keep tokens secret (use environment variables or GitHub Codespaces secrets when possible).

### Install Commands

```
pip install spectra-fabric-sdk==1.5.3
pip install spectra-fabric-sdk --upgrade
```

For CI, set an environment variable instead of embedding credentials:

```
PIP_EXTRA_INDEX_URL=https://${GITHUB_ACTOR}:${PAT}@pip.pkg.github.com/SPECTRADataSolutions
```

## Release Notes & Evidence

- Update `RELEASES.md` with the new version, wheel hash, and download URL.
- Drop the release link (and installation snippet) into Zephyr discussion #48 so Spectrafy scoring can pick up the evidence.
- Fabric workspaces should pin the desired version in their bootstrap scripts to avoid drift.

## Troubleshooting

| Symptom | Fix |
| --- | --- |
| `HTTPError: 403 Client Error: Forbidden for url` | Ensure PAT includes `read:packages` (install) or `write:packages` (publish). |
| `File already exists` during upload | Bump the version in `pyproject.toml` before releasing. |
| pip ignores GitHub index | Confirm `extra-index-url` is set and not overwritten by corporate proxies; add `--trusted-host pip.pkg.github.com` if needed. |
