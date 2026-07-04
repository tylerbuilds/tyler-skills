# Agent Guidance

This repository may be edited by agents. Treat every change as something a future human or agent must be able to verify.

## Before Editing

Run:

```bash
git branch --show-current
git status --short
```

Do not overwrite user changes. If the tree is dirty, understand why before editing.

## Before Commit Or Push

Run:

```bash
./scripts/verify.sh
```

If hooks are not installed, run:

```bash
./scripts/setup-git-hooks.sh
```

## Safety Rules

- Do not commit secrets, API tokens, env values, private domains, private paths, logs, screenshots, account IDs, or production data.
- Keep `.env` files local and untracked.
- Prefer small, reversible changes.
- State what was verified before claiming done.
- If a scanner finds a possible secret, do not paste the raw value into chat, issues, docs, or logs.

