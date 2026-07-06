<div align="center">

# Tyler Skills

Public, stripped-down agent skills for safer repo work, Cloudflare hardening, and bounded delivery.

[![Public safety](https://github.com/tylerbuilds/tyler-skills/actions/workflows/public-safety.yml/badge.svg)](https://github.com/tylerbuilds/tyler-skills/actions/workflows/public-safety.yml)
[![OpenSSF Scorecard](https://github.com/tylerbuilds/tyler-skills/actions/workflows/scorecard.yml/badge.svg)](https://github.com/tylerbuilds/tyler-skills/actions/workflows/scorecard.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

Install all current skills into a local agent skills directory:

```bash
mkdir -p ~/.agents/skills && tmpdir="$(mktemp -d)" && curl -fsSL https://github.com/tylerbuilds/tyler-skills/archive/refs/heads/main.tar.gz | tar -xz -C "$tmpdir" && cp -R "$tmpdir"/tyler-skills-main/skills/* ~/.agents/skills/ && rm -rf "$tmpdir"
```

## TL;DR

### The problem

Agents move quickly, but most repo instructions are vague, private, stale, or unsafe to share. That leads to overconfident changes, leaked local assumptions, and missing proof.

### The solution

This repo contains public-safe skill folders that give an agent a clear operating brief: what to check first, what not to touch, which helper scripts to use, and what proof counts as done.

### Why use this repo?

| Need | What this repo gives you | Concrete example |
| --- | --- | --- |
| Safer agent work in public repos | Public-safety guidance, hooks, scans, and release checks | `repo-safety-kit` can add a secret-scan gate before a push. |
| Bounded delivery instead of loose prompting | Scope lock, issue setup, isolated branches, proof, PR review, and closeout | `batch-sprint` tells an agent how to run a sprint without silently merging. |
| Cloudflare website hardening without reckless mutations | Read-only proof first, scoped tokens, careful mutation gates, and smoke tests | `cloudflare-website-hardening` separates audit evidence from approved changes. |
| Fast DeepSeek batch work without loose API scripts | CLI/MCP proof, fake and dry-run defaults, approval-gated live calls, cost ledgers, and no-mock e2e | `deepseek-harness-ops` keeps live inference bounded and reviewable. |
| Reusable agent instructions | Skills are plain folders with `SKILL.md`, optional scripts, and optional templates | Copy one folder into `~/.agents/skills` and invoke it by name. |

## Quick example

```bash
# 1. Clone the repo.
git clone https://github.com/tylerbuilds/tyler-skills.git
cd tyler-skills

# 2. Run the read-only public-safety audit.
./scripts/audit-public-safety.sh

# 3. Install one skill locally.
mkdir -p ~/.agents/skills
cp -R skills/repo-safety-kit ~/.agents/skills/

# 4. Ask your agent to use it.
# /repo-safety-kit /path/to/repo

# 5. Before publishing changes from this repo, run the full gate.
./scripts/verify.sh
```

## Current skills

| Skill | Use it when | Main proof it asks for |
| --- | --- | --- |
| [`batch-sprint`](skills/batch-sprint/SKILL.md) | A job needs the full delivery loop rather than a one-off edit. | Scope, issue setup, isolated implementation, proof, PR review, approved merge, cleanup, and closeout. |
| [`cloudflare-website-hardening`](skills/cloudflare-website-hardening/SKILL.md) | A Cloudflare-backed website needs review or hardening. | DNS, HTTP, token-scope, ruleset, Access, Turnstile, origin-firewall, and smoke-test evidence before claims. |
| [`deepseek-harness-ops`](skills/deepseek-harness-ops/SKILL.md) | A DeepSeek batch harness needs safe install, MCP, local proof, live micro-smoke, or scale-ramp handling. | Fake/dry-run proof, MCP smoke, approval packet, real-service e2e, review packet, cost ledger, and side-effect report. |
| [`repo-safety-kit`](skills/repo-safety-kit/SKILL.md) | A repo needs practical guardrails before agents or humans move quickly. | Agent guidance, hooks, verify scripts, CI, Dependabot, CodeQL or Scorecard guidance, security docs, and release hygiene. |

## Design philosophy

1. Keep skills public-safe by default.
   Skills should not contain private domains, account IDs, machine paths, logs, screenshots, production data, or secrets.

2. Prove before changing.
   A useful skill tells the agent what to inspect first, then separates read-only evidence from approved mutations.

3. Make authority explicit.
   Skills should say when an agent may edit, when it must ask, and what actions are never allowed without approval.

4. Prefer small reusable workflows.
   A skill should be easier to follow than a long chat transcript and easier to audit than an improvised prompt.

5. Be honest about limits.
   A skill is not a security guarantee, a deployment guarantee, or a substitute for a sensible operator.

## Comparison

| Approach | Strength | Weakness | Where Tyler Skills fits |
| --- | --- | --- | --- |
| Ad hoc prompt | Fast to write once. | Easy to forget safety gates and proof requirements. | Use a skill when the same workflow will run again. |
| Private runbook | Can include exact internal details. | Unsafe to publish and often tied to one machine or project. | Use this repo for the stripped public pattern. |
| Heavy agent framework | Can automate orchestration. | Often too much machinery for a simple repo task. | Skills stay as readable folders and scripts. |
| Generic checklist | Good for human review. | Agents need trigger rules, boundaries, and concrete commands. | `SKILL.md` gives the agent an operating contract. |

## Installation

### Option 1: install all skills from GitHub

```bash
mkdir -p ~/.agents/skills && tmpdir="$(mktemp -d)" && curl -fsSL https://github.com/tylerbuilds/tyler-skills/archive/refs/heads/main.tar.gz | tar -xz -C "$tmpdir" && cp -R "$tmpdir"/tyler-skills-main/skills/* ~/.agents/skills/ && rm -rf "$tmpdir"
```

### Option 2: clone and copy selected skills

```bash
git clone https://github.com/tylerbuilds/tyler-skills.git
mkdir -p ~/.agents/skills
cp -R tyler-skills/skills/cloudflare-website-hardening ~/.agents/skills/
cp -R tyler-skills/skills/deepseek-harness-ops ~/.agents/skills/
cp -R tyler-skills/skills/repo-safety-kit ~/.agents/skills/
cp -R tyler-skills/skills/batch-sprint ~/.agents/skills/
```

### Option 3: work from the repo checkout

```bash
git clone https://github.com/tylerbuilds/tyler-skills.git
cd tyler-skills
./scripts/setup-git-hooks.sh
./scripts/audit-public-safety.sh
```

## Quick start

1. Pick the skill that matches the job.

```text
/repo-safety-kit /path/to/repo
/cloudflare-website-hardening example.com
/deepseek-harness-ops /path/to/deepseek-harness
/batch-sprint "Ship this bounded repo change through issues, PR, proof, and closeout"
```

2. Read the skill's `SKILL.md` before acting.

```bash
sed -n '1,220p' skills/repo-safety-kit/SKILL.md
```

3. Use helper scripts only where the skill tells you to use them.

```bash
skills/repo-safety-kit/scripts/repo-safety-audit.sh /path/to/repo
```

4. Keep public material clean before committing or pushing.

```bash
./scripts/setup-secret-scanners.sh
./scripts/secret-scan.sh
```

5. Use the repo-level verification shortcut before publishing changes.

```bash
./scripts/verify.sh
```

## Command reference

| Command | What it does | Example |
| --- | --- | --- |
| `./scripts/audit-public-safety.sh` | Runs the local public-safety audit and prints redacted file/line matches for risky material. | `./scripts/audit-public-safety.sh` |
| `./scripts/setup-secret-scanners.sh` | Downloads pinned Gitleaks and TruffleHog OSS releases, verifies checksums, and installs them into a user cache. | `./scripts/setup-secret-scanners.sh` |
| `./scripts/secret-scan.sh` | Runs the public-safety audit, Gitleaks, and TruffleHog with raw findings redacted from logs. | `./scripts/secret-scan.sh` |
| `./scripts/verify.sh` | Runs the standard repo proof: scanner setup plus full secret scan. | `./scripts/verify.sh` |
| `./scripts/install-git-hooks.sh` | Sets this checkout's `core.hooksPath` to `.githooks` and installs scanner CLIs. | `./scripts/install-git-hooks.sh` |
| `./scripts/setup-git-hooks.sh` | Convenience wrapper around `install-git-hooks.sh`. | `./scripts/setup-git-hooks.sh` |
| `skills/repo-safety-kit/scripts/repo-safety-audit.sh` | Audits another repo for practical agent and public-release guardrails. | `skills/repo-safety-kit/scripts/repo-safety-audit.sh /path/to/repo` |
| `skills/cloudflare-website-hardening/scripts/domain-baseline.sh` | Prints DNS, HTTP, and probe-path baseline information for a domain. | `skills/cloudflare-website-hardening/scripts/domain-baseline.sh example.com` |
| `skills/cloudflare-website-hardening/scripts/cloudflare-zone-readiness.sh` | Checks Cloudflare zone readiness using scoped credentials where available. | `skills/cloudflare-website-hardening/scripts/cloudflare-zone-readiness.sh example.com` |

## Configuration

Most users do not need config. The scripts work from the repo checkout and use safe defaults.

If you need to override scanner behaviour, use empty placeholders first and fill them only in your shell or secret manager. Do not commit real values.

```bash
# Optional. Leave empty unless you need a custom scanner cache location.
SECRET_SCANNER_BIN_DIR=""

# Optional. Leave empty to use the pinned versions in the setup script.
GITLEAKS_VERSION=""
TRUFFLEHOG_VERSION=""

# Optional. Default behaviour avoids live provider verification.
TRUFFLEHOG_VERIFY=""
```

Cloudflare workflows should use scoped API tokens, not legacy Global API keys. Export any live values only in your shell or password manager, never in this repo.

## Architecture

```text
User request
    |
    v
Agent loads a skill folder
    |
    +--> SKILL.md: trigger rules, authority, workflow, proof
    |
    +--> scripts/: optional helper commands
    |
    +--> templates/: optional reusable files
    |
    v
Agent performs read-only proof first
    |
    v
Agent asks before risky mutations
    |
    v
Public safety gate runs before publication
```

## Troubleshooting

| Problem | Likely cause | Fix |
| --- | --- | --- |
| `rg` is missing. | The public-safety audit depends on ripgrep. | Install `ripgrep`, then rerun `./scripts/audit-public-safety.sh`. |
| `gitleaks` or `trufflehog` is missing. | Scanner CLIs have not been installed in this environment. | Run `./scripts/setup-secret-scanners.sh`, then rerun `./scripts/secret-scan.sh`. |
| The audit reports possible private paths or IDs. | A public file includes local or provider-specific material. | Inspect the named files locally, replace real details with placeholders, then rerun the audit. |
| TruffleHog reports a scan error. | The scanner hit a finding or could not complete cleanly. | Read the redacted file/line summary, fix the source issue, and rerun `./scripts/secret-scan.sh`. |
| A skill sounds useful but does not fit the repo. | Skills are patterns, not blind copy-paste instructions. | Follow the safety model, adapt the commands, and document what changed. |

## Limitations

- This repo does not guarantee a project is secure.
- The Cloudflare skill does not replace application security, backups, monitoring, or patching.
- The repo-safety skill cannot prove that Git history has never contained a secret.
- The batch sprint skill does not authorise merges, deploys, secret changes, or live external side effects by itself.
- The public versions deliberately remove private paths, account details, and project-specific assumptions.

## FAQ

### Is a skill an agent?

No. A skill is a working brief an agent can load. It tells the agent how to approach a specific class of work.

### Can I copy only one skill?

Yes. Copy the folder under `skills/<skill-name>/` into your agent skills directory.

### Are these safe to publish?

They are intended to be public-safe, and this repo includes audit and scanner gates. You still need to review changes before publishing.

### Why not include private examples?

Private examples make a skill less reusable and increase the risk of leaking sensitive context. Use placeholders and public-safe examples instead.

### Do these skills make live changes automatically?

No. The skills are written to prefer read-only proof first and to require explicit approval for risky mutations.

### How do I add another skill?

Use the template, update both skill indexes, and run the public-safety gate.

```bash
cp -R templates/new-skill skills/my-new-skill
./scripts/audit-public-safety.sh
./scripts/setup-secret-scanners.sh
./scripts/secret-scan.sh
```

More detail is in [`docs/ADDING_SKILLS.md`](docs/ADDING_SKILLS.md).

## About Contributions

Please don't take this the wrong way, but I do not accept outside contributions for any of my projects. I simply don't have the mental bandwidth to review anything, and it's my name on the thing, so I'm responsible for any problems it causes; thus, the risk-reward is highly asymmetric from my perspective. I'd also have to worry about other "stakeholders," which seems unwise for tools I mostly make for myself for free. Feel free to submit issues, and even PRs if you want to illustrate a proposed fix, but know I won't merge them directly. Instead, I'll have Claude or Codex review submissions via `gh` and independently decide whether and how to address them. Bug reports in particular are welcome. Sorry if this offends, but I want to avoid wasted time and hurt feelings. I understand this isn't in sync with the prevailing open-source ethos that seeks community contributions, but it's the only way I can move at this velocity and keep my sanity.

## License

MIT. See [`LICENSE`](LICENSE).

## References

- [Cloudflare API tokens](https://developers.cloudflare.com/fundamentals/api/get-started/create-token/)
- [Cloudflare API token permissions](https://developers.cloudflare.com/fundamentals/api/reference/permissions/)
- [Cloudflare Rulesets API](https://developers.cloudflare.com/ruleset-engine/rulesets-api/create/)
- [Cloudflare Access applications](https://developers.cloudflare.com/cloudflare-one/access-controls/applications/http-apps/)
- [Cloudflare Turnstile widgets API](https://developers.cloudflare.com/turnstile/get-started/widget-management/api/)
- [Gitleaks](https://github.com/gitleaks/gitleaks)
- [TruffleHog OSS](https://github.com/trufflesecurity/trufflehog)
- [GitHub secret scanning](https://docs.github.com/en/code-security/concepts/secret-security/secret-scanning)
- [Removing sensitive data from Git history](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)
