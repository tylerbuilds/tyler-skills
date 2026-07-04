# Contributing

This repo is for practical agent skills that can be shared publicly.

The bar is not "does this sound clever?" The bar is "could a sensible agent follow this and avoid the obvious mistakes?"

## Add a skill

1. Copy the template:

```bash
cp -R templates/new-skill skills/my-new-skill
```

2. Rename the skill and update `SKILL.md`.
3. Add helper scripts or templates only when they reduce risk or save repeated work.
4. Update `skills/README.md`.
5. Update the root `README.md` skill table.
6. Run:

```bash
./scripts/audit-public-safety.sh
./scripts/secret-scan.sh
```

## Public safety rules

Do not include:

- API tokens, API keys, passwords, secrets, private keys, or service-token values.
- Real account IDs, zone IDs, customer IDs, project IDs, or database IDs.
- Private domains, private email addresses, internal hostnames, dashboards, or personal machine paths.
- Real user data, customer data, analytics exports, screenshots, logs, or production incident details.
- Provider-specific secret values, even if you think they are expired.

Use `example.com`, `<account-id>`, `<zone-id>`, and empty env vars in `.env.example`.

## Style

Write plainly. Explain the practical job, the risk, the steps, and the proof.

Avoid:

- guru language
- big claims
- fake automation confidence
- "just run this" when the command can change live infrastructure

Prefer:

- read-only proof first
- explicit approval before mutations
- least-privilege credentials
- short checklists
- honest `done`, `pending`, and `blocked` states
