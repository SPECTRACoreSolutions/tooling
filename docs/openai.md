# OpenAI CLI / API

Reference: https://platform.openai.com/docs/overview

## Install
- Included in unified tooling (`openai` Python package). Runs in venv/devcontainer via `pwsh ./infrastructure/tooling/scripts/install-tooling.ps1`.

## Auth
- Use `OPENAI_API_KEY` (we load `SPECTRA_OPENAI_ADMIN_KEY` or `SPECTRA_OPENAI_TOKEN` from `.env`). Do **not** commit keys.
- For Azure OpenAI, supply `--api-type azure --azure-endpoint ... --api-version ...` as needed.

## Common CLI calls
- List models:  
  `openai api models.list`
- Chat completion (text):  
  `openai api chat.completions.create -m gpt-4o-mini -g '{"role":"user","content":"hello"}'`
- Speech-to-text:  
  `openai api audio.transcriptions.create -m gpt-4o-transcribe -f audio.wav`
- Speech-to-speech (translation):  
  `openai api audio.translations.create -m gpt-4o-transcribe -f audio.wav`
- Moderation:  
  `openai api moderations.create -m omni-moderation-latest -g '{"input":"..."}'`

## Notes / best practices
- Keep keys in `.env` (mounted into devcontainer) or per-session env vars.
- Prefer `gpt-4o-transcribe` for STT; `whisper-1` is the classic Whisper model.
- For streaming chat, use SDK/websocket Realtime API (not covered here); ensure token scopes permit it.
- Avoid embedding secrets in logs; set `OPENAI_LOG=warn` if needed.
