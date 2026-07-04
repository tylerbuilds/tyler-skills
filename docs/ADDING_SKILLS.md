# Adding Skills

This repo is meant to grow slowly and cleanly.

Each skill should be useful on its own. If a skill needs five private systems, a specific personal setup, or hidden context to work, it is not ready to be public.

## Folder shape

```text
skills/
  my-skill/
    SKILL.md
    scripts/
    templates/
```

Only `SKILL.md` is required. Add scripts and templates when they make the workflow safer or more repeatable.

## `SKILL.md` shape

Use this structure:

```markdown
---
name: my-skill
description: What this skill helps an agent do and when to use it.
argument-hint: "<optional input>"
---

# My Skill

## Safety rules

## Inputs

## Workflow

## Verification

## Final response shape
```

The skill should tell an agent:

- when to use it
- what to read first
- what not to touch
- what commands are read-only
- what commands are mutations
- what proof is needed before claiming success
- what to say when blocked

## Public-safe examples

Use:

- `example.com`
- `<account-id>`
- `<zone-id>`
- `<api-token>`
- empty env vars in `.env.example`
- fake paths like `/path/to/project`

Avoid:

- real domains
- real email addresses
- real account IDs
- real local paths
- screenshots or logs from live systems
- copied private notes
- customer or user data

## Before committing

Run:

```bash
./scripts/audit-public-safety.sh
```

For a pre-public release check, run:

```bash
./scripts/setup-secret-scanners.sh
./scripts/secret-scan.sh
```

Then manually read:

- the changed skill
- the README updates
- any helper scripts
- any templates
- `git diff --cached`

Automation helps, but it is not a substitute for reading the thing you are about to publish.
