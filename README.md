# Tyler Skills

Free agent skills I have built for my own work, cleaned up so other people can use them without inheriting my private setup.

The point is simple: small, practical skills that help an agent do one useful job properly. Not magic. Not a giant framework. Just reusable working instructions, helper scripts, and the checks I wish I had written down earlier.

This repo will grow over time. The first public skill is `cloudflare-website-hardening`, which helps an agent tighten up a website running through Cloudflare without handing it a broad permanent key or letting it break legitimate traffic. The second is `repo-safety-kit`, which helps non-developers, non-technical founders, and vibe coders get the same repo hygiene an advanced developer would usually wire in by default.

## Current skills

| Skill | What it does |
| --- | --- |
| [`cloudflare-website-hardening`](skills/cloudflare-website-hardening/SKILL.md) | Reviews and hardens a Cloudflare website using scoped API tokens, conservative WAF planning, Access, Turnstile, origin-firewall readiness checks, and public smoke tests. |
| [`repo-safety-kit`](skills/repo-safety-kit/SKILL.md) | Audits and bootstraps a repository with agent guidance, hooks, verify scripts, CI, Dependabot, CodeQL/Scorecard guidance, security docs, and release hygiene. |

## Repo Safety Kit

Use this when a repo needs a sensible baseline before agents or humans start moving fast. The goal is that someone who is not a professional developer can still end up with the practical guardrails a strong developer would expect:

- agent instructions
- local verify scripts
- tracked pre-push hooks
- secret scanning
- CI
- Dependabot
- CodeQL or code scanning guidance
- OpenSSF Scorecard for public repos
- security policy
- env examples
- release and verification checklists

Start with the read-only audit:

```bash
skills/repo-safety-kit/scripts/repo-safety-audit.sh /path/to/repo
```

Then apply only the templates that fit the repo. The skill is deliberately not a blind copy-paste job, because a content site, a public skill repo, and a live SaaS do not need exactly the same gate.

## Cloudflare Website Hardening

Use this when you want an agent to review and harden a site on Cloudflare. It covers:

- DNS and proxy activation checks.
- Cloudflare API token scope checks.
- Conservative WAF and rate-limit planning.
- Cloudflare Access planning for admin/private routes.
- Turnstile planning for forms and login-like surfaces.
- Origin firewall readiness checks.
- Public smoke tests before and after changes.
- A local hardening report so you know what changed and what is still pending.

The skill is deliberately cautious. It tells the agent to prove the current state, propose changes, ask before mutations, and avoid overclaiming protection while DNS, proxying, or token permissions are still pending.

## Use a skill

Copy the skill folder you want into the skills directory used by your agent environment:

```bash
mkdir -p ~/.agents/skills
cp -R skills/cloudflare-website-hardening ~/.agents/skills/
cp -R skills/repo-safety-kit ~/.agents/skills/
```

Then invoke it by name if your agent supports skill loading:

```text
/cloudflare-website-hardening example.com
/repo-safety-kit /path/to/repo
```

If your agent does not support slash skills, paste the relevant `SKILL.md` into the agent context and ask it to follow the workflow.

## Set up this repo once

After cloning, run:

```bash
./scripts/setup-git-hooks.sh
```

That installs the pinned scanner CLIs if needed and configures Git to use the tracked `pre-push` hook in `.githooks/`. After that, every local push runs the public safety gate automatically.

GitHub Actions runs the same gate again on push and pull request, so the local hook catches mistakes early and CI catches anything that slips through.

## Add a new skill

Future skills should follow the same shape:

- One folder under `skills/<skill-name>/`.
- A `SKILL.md` with clear trigger rules, safety rules, workflow, and verification.
- Optional `scripts/` and `templates/` folders.
- No private domains, keys, internal paths, account IDs, real customer data, or private examples.
- A quick way to prove the skill does not just sound useful, but actually works.

Use the template:

```bash
cp -R templates/new-skill skills/my-new-skill
```

Then run the public safety audit before committing:

```bash
./scripts/audit-public-safety.sh
```

For a stronger pre-public check, run the full secret scan as well:

```bash
./scripts/setup-secret-scanners.sh
./scripts/secret-scan.sh
```

More detail is in [`docs/ADDING_SKILLS.md`](docs/ADDING_SKILLS.md).

## Cloudflare API token

Use a scoped Cloudflare API token, not the legacy Global API key.

For a read-only audit, start with the narrowest practical zone-level read permissions for the target zone, such as zone read, DNS read, rulesets read, and zone settings read where available.

For a full hardening pass, add only the permissions required for the specific changes you want the agent to make. Common examples are:

- Zone DNS read.
- Zone settings edit.
- Zone rulesets edit.
- Account Turnstile edit, if creating Turnstile widgets.
- Account Access apps and policies edit, if creating Cloudflare Access apps.

Cloudflare permission names can change, so confirm them in Cloudflare's current API token documentation before creating a token.

Export the token into your shell or use your password manager. Do not commit it:

```bash
export CLOUDFLARE_API_TOKEN="your scoped token"
export CLOUDFLARE_ACCOUNT_ID="optional account id"
export CLOUDFLARE_ZONE_ID="optional zone id"
```

The included `.gitignore` excludes `.env` files. Keep it that way.

## Safety model

The public skill is safe to share because it does not include:

- Real domains.
- Account IDs or zone IDs.
- API tokens, secret keys, service tokens, or env values.
- Private registrar tooling.
- Private note paths, internal dashboards, or personal email addresses.

The skill also tells agents to:

- Prefer API tokens over Global API keys.
- Use short-lived or narrowly-scoped tokens.
- Verify token scope before promising a change.
- Treat read access and write access as separate proof.
- Ask before applying WAF, Access, DNS, or firewall mutations.
- Never lock an origin firewall until certificate renewal and bypass paths are proved.

Before anything here becomes public, run [`docs/PUBLICATION_CHECKLIST.md`](docs/PUBLICATION_CHECKLIST.md). The checklist exists because deleting a secret from the latest file is not enough if it is still in Git history.

This repo also includes a standard CI gate using:

- the local public-safety audit
- Gitleaks core via the official CLI release
- TruffleHog OSS via the official CLI release

Gitleaks core is MIT licensed. TruffleHog OSS is AGPL-3.0 licensed. That is fine for running them as external scanning tools, but do not copy their code into this repo.

`setup-secret-scanners.sh` installs the scanner binaries into a user cache by default, normally `~/.cache/tyler-skills/bin`. Override with `SECRET_SCANNER_BIN_DIR` if you need a different location.

By default, `secret-scan.sh` runs TruffleHog with verification disabled so it does not make outbound checks against providers for candidate secrets. It also redacts TruffleHog raw output from logs. If you deliberately want live verification, run:

```bash
TRUFFLEHOG_VERIFY=1 ./scripts/secret-scan.sh
```

## Helper scripts

Read-only scripts live inside the skill:

```bash
skills/cloudflare-website-hardening/scripts/domain-baseline.sh example.com
skills/cloudflare-website-hardening/scripts/cloudflare-zone-readiness.sh example.com
```

They print DNS, HTTP, probe-path, and Cloudflare zone readiness information. They do not change Cloudflare or your origin.

## What this is not

This is not a guarantee that a website is secure. It is a practical hardening workflow for obvious mistakes, common abuse paths, and risky agent behaviour. You still need good application security, backups, patching, least-privilege accounts, monitoring, and someone sensible looking at the actual system.

## References

- Cloudflare API tokens: https://developers.cloudflare.com/fundamentals/api/get-started/create-token/
- Cloudflare API token permissions: https://developers.cloudflare.com/fundamentals/api/reference/permissions/
- Cloudflare Rulesets API: https://developers.cloudflare.com/ruleset-engine/rulesets-api/create/
- Cloudflare Access applications: https://developers.cloudflare.com/cloudflare-one/access-controls/applications/http-apps/
- Cloudflare Turnstile widgets API: https://developers.cloudflare.com/turnstile/get-started/widget-management/api/
- Gitleaks: https://github.com/gitleaks/gitleaks
- TruffleHog OSS: https://github.com/trufflesecurity/trufflehog
- GitHub secret scanning: https://docs.github.com/en/code-security/concepts/secret-security/secret-scanning
- Removing sensitive data from Git history: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository
