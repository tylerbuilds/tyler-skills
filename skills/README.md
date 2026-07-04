# Skills

These are the public skills currently included in this repo.

| Skill | Purpose |
| --- | --- |
| [`cloudflare-website-hardening`](cloudflare-website-hardening/SKILL.md) | Helps an agent review and harden a Cloudflare website with scoped credentials, read-only proof, careful mutation gates, and clear verification. |

## Add another skill

Copy the template:

```bash
cp -R ../templates/new-skill my-new-skill
```

Then update this index and run:

```bash
../scripts/audit-public-safety.sh
```

