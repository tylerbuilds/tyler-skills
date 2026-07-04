# Tyler Skills - Agent Guidance

This is a public skills repository. Treat anything committed here as public internet material.

## Before Commit Or Push

Run the public safety gate before committing or pushing:

```bash
./scripts/setup-secret-scanners.sh
./scripts/secret-scan.sh
```

For this local checkout, the tracked Git hook should already enforce the same gate before push. If hooks are not active, run:

```bash
./scripts/install-git-hooks.sh
```

## Public Safety Rules

- Do not commit secrets, API tokens, env values, private domains, private email addresses, local machine paths, account IDs, zone IDs, logs, screenshots, or production data.
- Use placeholders such as `example.com`, `<account-id>`, `<zone-id>`, and empty env vars.
- Keep helper scripts read-only unless a skill explicitly states that a live mutation requires user approval.
- If a scan fails, stop. Do not bypass the hook or push anyway.
- If a scanner reports a possible secret, do not paste the raw value into chat, issues, docs, or logs.

## Adding Skills

Use `templates/new-skill/` and update `skills/README.md` plus the root `README.md`.

The standard final proof is:

```bash
./scripts/setup-secret-scanners.sh
./scripts/secret-scan.sh
git status --short
```
