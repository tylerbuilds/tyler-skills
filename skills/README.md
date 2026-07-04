# Skills

These are the public skills currently included in this repo.

| Skill | Purpose |
| --- | --- |
| [`cloudflare-website-hardening`](cloudflare-website-hardening/SKILL.md) | Helps an agent review and harden a Cloudflare website with scoped credentials, read-only proof, careful mutation gates, and clear verification. |
| [`repo-safety-kit`](repo-safety-kit/SKILL.md) | Helps an agent audit and bootstrap a repo with practical development, security, CI, dependency, and public-release safety defaults. |

## Add another skill

Copy the template:

```bash
cp -R ../templates/new-skill my-new-skill
```

Then update this index and run:

```bash
../scripts/audit-public-safety.sh
```
