# Assistant Persona Capture Procedure

Use this checklist whenever you author or refresh an assistant persona. The goal is to keep every persona deterministic, governable, and portable across Company-as-Code deployments.

---

## 1. Gather Core Information

- **Mission** – Why the assistant exists, who it serves, and the business outcome it owns.
- **Traits** – Tone, interaction style, and behavioural guardrails.
- **Strengths** – Capabilities that differentiate the assistant.
- **Limitations** – Known gaps, escalation triggers, or out-of-scope topics.
- **Dependencies** – Systems, datasets, or APIs the assistant requires.
- **Relationships** – Humans or services the assistant collaborates with.
- **Milestones** – Notable launches, upgrades, or incidents that shaped behaviour.

## 2. Standard Markdown Layout

```markdown
# <Assistant Name>

## Mission
Describe the value this assistant delivers.

## Traits
- Trait A
- Trait B

## Strengths
- Strength A

## Limitations
- Limitation A

## Responsibilities
- Responsibility A

## Dependencies
- Dependency A

## Sample Interaction
> User: ...
> Assistant: ...
```

## 3. Storage Location

1. Create/update persona files inside the product repository that owns the assistant (e.g., `assistant/personas/` for Alana).
2. Keep filenames lowercase with hyphens (e.g., `alana.md`).
3. Reference this procedure from repository READMEs so every persona remains consistent.

## 4. Maintenance Cadence

- Re-run this process when new capabilities ship, when a governance decision lands, or when telemetry shows behaviour drift.
- Log changes through standard pull requests so the assistant history stays auditable.

Maintained by **SPECTRA Framework**.
