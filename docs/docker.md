## Docker

- Base images: devcontainer uses `mcr.microsoft.com/devcontainers/base:ubuntu-22.04`.
- Railway builds:
  - `portal/Dockerfile` (Astro static site served via `serve` on `$PORT`/8080).
  - `devcontainer-service/Dockerfile` (tooling stack; SSH only on 2222).
- Local build/test: `docker build -t spectra-devcontainer -f devcontainer-service/Dockerfile .`
- Docs: https://docs.docker.com/
