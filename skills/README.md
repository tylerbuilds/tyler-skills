# Skills

These are the public skills currently included in this repo.

| Skill | Purpose |
| --- | --- |
| [`batch-sprint`](batch-sprint/SKILL.md) | Helps an agent run a bounded delivery sprint through issue setup, isolated branches, proof, pull requests, approved merge, cleanup, and closeout. |
| [`cloudflare-website-hardening`](cloudflare-website-hardening/SKILL.md) | Helps an agent review and harden a Cloudflare website with scoped credentials, read-only proof, careful mutation gates, and clear verification. |
| [`deepseek-harness-ops`](deepseek-harness-ops/SKILL.md) | Helps an agent run a local-first DeepSeek batch harness through CLI, MCP, fake/dry-run proof, approval-gated live calls, cost ledgers, and no-mock e2e checks. |
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
