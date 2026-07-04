---
name: repo-safety-kit
description: Audit and bootstrap a repository with practical safety defaults: agent instructions, local hooks, secret scanning, CI, Dependabot, CodeQL/Scorecard guidance, env examples, security docs, release checks, and public/private repo hygiene. Use when a user asks to harden a repo, set up a repo safety baseline, prepare a public repo, or standardise agent-safe development workflow.
argument-hint: "<repo-path>"
---

# Repo Safety Kit

Use this skill to make a repository harder to damage by accident, easier for agents to work in, and safer to publish.

The audience is often a non-developer, a non-technical founder, or a vibe coder who needs the repo hygiene an advanced developer would normally set up without being expected to know every tool name first.

The point is not theatre. The point is a repeatable baseline: clear repo instructions, read-only checks first, local pre-push gates, CI proof, dependency/security hygiene, and a small checklist that future agents can actually follow.

## Safety rules

- Start read-only. Audit before changing files.
- Do not copy private examples, paths, domains, email addresses, logs, env values, API keys, or production data into a public repo.
- Ask before changing GitHub repository settings, branch protection, rulesets, secrets, environments, or live deployment settings.
- Do not overwrite an existing `AGENTS.md`, workflow, hook, or config without reading it and merging the useful parts.
- Do not add heavyweight tooling that does not match the repo. A static website does not need the same gate as a regulated SaaS.
- If a scanner reports a possible secret, do not paste the raw value into chat, issues, docs, or logs.
- State `done`, `pending`, and `blocked` separately.

## Inputs

Required:

- Repository path, for example `/path/to/repo`.

Optional:

- Repo type: `public-skill`, `public-package`, `private-app`, `saas`, `website`, `infra`, `content`.
- Preferred package manager and test command if the repo does not make them obvious.
- Whether the repo is already public.

## Workflow

### 1. Read-only audit

Run the bundled audit script:

```bash
skills/repo-safety-kit/scripts/repo-safety-audit.sh /path/to/repo
```

Check for:

- `AGENTS.md` or equivalent agent guidance.
- `README.md`, `LICENSE`, `SECURITY.md`, `.env.example`, `.gitignore`.
- Local hooks and whether `core.hooksPath` is set.
- Secret scanning scripts or workflows.
- CI workflows.
- Dependabot config.
- CodeQL or code scanning setup.
- OpenSSF Scorecard for public repos.
- Release, deploy, rollback, and verification docs where relevant.
- Public-risk patterns: machine paths, env values, bearer tokens, and private-looking IDs.

### 2. Classify the repo

Use the smallest useful baseline:

- Public skill/package: public-safety scan, secret scan, `SECURITY.md`, licence, contribution docs, Scorecard.
- Private app: tests, typecheck, secret scan, env validation, deploy/rollback docs.
- SaaS: app tests, security scan, migration checks, health checks, error/uptime alert notes.
- Website: build proof, link/media checks, deploy proof, Cloudflare/DNS notes if applicable.
- Infra: dry-run first, explicit approvals, backups, rollback, least-privilege tokens.

When choosing the baseline, optimise for the person who inherits the repo. They should be able to run one setup command, one verification command, and understand what is still manual in GitHub settings.

### 3. Propose the patch

Use templates from `templates/` only as starting points. Merge with existing files.

Useful template files:

- `templates/AGENTS.md`
- `templates/SECURITY.md`
- `templates/.env.example`
- `templates/docs/REPO_SAFETY_CHECKLIST.md`
- `templates/.githooks/pre-push`
- `templates/.github/dependabot.yml`
- `templates/.github/workflows/repo-safety.yml`
- `templates/.github/workflows/codeql.yml`
- `templates/.github/workflows/scorecard.yml`
- `templates/scripts/verify.sh`
- `templates/scripts/setup-git-hooks.sh`

### 4. Apply only the right baseline

Do not blindly copy everything. Pick the files that fit the repo.

At minimum for most repos:

- `AGENTS.md`
- `scripts/verify.sh`
- `scripts/setup-git-hooks.sh`
- `.githooks/pre-push`
- `.github/workflows/repo-safety.yml`
- `.env.example`
- `SECURITY.md`
- `.gitignore` rules for `.env`, logs, local tool caches

For GitHub-hosted code repos:

- `.github/dependabot.yml`
- CodeQL default setup through GitHub settings, or `templates/.github/workflows/codeql.yml` when workflow-based setup is preferred.
- OpenSSF Scorecard for public repos.

### 5. Verify

Run the repo's own proof, then the new safety proof:

```bash
./scripts/setup-git-hooks.sh
./scripts/verify.sh
git status --short
```

If the repo has tests/builds, make sure `verify.sh` runs or clearly delegates to them.

### 6. GitHub settings checklist

Some important controls are repository settings, not files. Report them as manual/API steps unless the user explicitly asks you to change GitHub settings:

- Secret scanning and push protection.
- Dependabot alerts and security updates.
- Branch protection or repository rulesets for `main`.
- Required status checks.
- CodeQL default setup if not using a workflow.
- Environments and required reviewers for production deploys.

## Final response shape

- `Added`: files/config created.
- `Changed`: existing files updated.
- `Verified`: commands run and results.
- `Pending GitHub settings`: controls that need dashboard/API setup.
- `Deferred`: items that do not fit this repo yet.
- `Risk`: anything still weak or unproved.
