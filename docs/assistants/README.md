# Assistant Tooling

Utilities and procedures for defining Company-as-Code assistants live here. They complement the `assistant/` product repo by providing reusable scaffolding for new personas.

## Contents

- `profile-capturing.md` – Procedure for capturing assistant personas consistently.
- `scripts/assistants/create_persona_scaffold.py` – CLI tool that generates placeholder persona folders (run from any repo that needs a new assistant).

## Usage

```bash
# From a target repository (e.g., assistant/):
python ../../framework/scripts/assistants/create_persona_scaffold.py alana --dest personas
```

Follow the checklist in `profile-capturing.md` to flesh out the generated files before shipping.
