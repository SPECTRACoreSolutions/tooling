# OpenAI Cheatsheet (CLI/API quick hits)

Prereqs: `OPENAI_API_KEY` set (we map `SPECTRA_OPENAI_ADMIN_KEY`/`SPECTRA_OPENAI_TOKEN` in `.env`). CLI comes from the `openai` Python package (see unified tooling).

## Model quick picks
- Chat/reasoning: `gpt-4o-mini` (fast/cost), `gpt-4o` (higher quality), `gpt-4.1` (most capable).
- JSON mode: add `--response-format json_object` (CLI) or `response_format={"type":"json_object"}`.
- Function calling: `tools`/`tool_choice` (CLI: `-g` to pass JSON).
- Vision: send an image in `content` (requires SDK/HTTP; CLI supports `-g` with an `image_url` object).
- Audio STT: `gpt-4o-transcribe` (new), `whisper-1` (classic).
- Audio TTS: `gpt-4o-audio` (voices like `alloy`, `verse`, etc.).
- Images: `gpt-image-1` (DALL·E 3.5).
- Embeddings: `text-embedding-3-small`/`-large`.
- Moderation: `omni-moderation-latest`.

## Common CLI snippets
- List models  
  `openai api models.list`

- Chat (text reply)  
  `openai api chat.completions.create -m gpt-4o-mini -g '{"role":"user","content":"hello"}'`

- Chat with JSON mode  
  `openai api chat.completions.create -m gpt-4o-mini --response-format json_object -g '{"role":"user","content":"give me a todo item"}'`

- Function calling (tool example)  
  `openai api chat.completions.create -m gpt-4o-mini -g '[{"role":"user","content":"what time is it in London?"}]' --tools '[{"type":"function","function":{"name":"get_time","parameters":{"type":"object","properties":{"city":{"type":"string"}},"required":["city"]}}}]'`

- Speech-to-text  
  `openai api audio.transcriptions.create -m gpt-4o-transcribe -f audio.wav`

- Text-to-speech (saves MP3)  
  `openai api audio.speech.create -m gpt-4o-audio -v alloy -o out.mp3 -g '{"input":"Hello"}'`

- Image generation  
  `openai api images.generate -m gpt-image-1 -g '{"prompt":"a minimal dashboard with neon accents"}' -o image.png`

- Embedding  
  `openai api embeddings.create -m text-embedding-3-small -g '{"input":"hello world"}'`

## Notes
- Set `OPENAI_API_KEY` per session or via `.env` (devcontainer mounts it). Avoid putting keys in command history/logs.
- For streaming chat or realtime speech, use the SDK/WebSocket Realtime API (not fully covered here).
- For Azure OpenAI, add `--api-type azure --azure-endpoint ... --api-version ...` and use the Azure key.
