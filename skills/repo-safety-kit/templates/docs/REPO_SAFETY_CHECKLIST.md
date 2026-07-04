# Repo Safety Checklist

## Local

- [ ] `AGENTS.md` explains how agents should work in this repo.
- [ ] `scripts/verify.sh` runs the normal local proof.
- [ ] `.githooks/pre-push` runs `scripts/verify.sh`.
- [ ] `scripts/setup-git-hooks.sh` sets `core.hooksPath=.githooks`.
- [ ] `.env.example` exists and contains no real values.
- [ ] `.gitignore` excludes `.env`, logs, build output, and local tool caches.

## GitHub

- [ ] CI runs on push and pull request.
- [ ] Dependabot is configured for package managers used by the repo.
- [ ] Secret scanning is enabled.
- [ ] Push protection is enabled.
- [ ] Branch protection or rulesets protect `main`.
- [ ] CodeQL or another code scanner is enabled where useful.
- [ ] OpenSSF Scorecard is enabled for public repos.

## Release

- [ ] README explains run/test/build/deploy.
- [ ] Release or deploy process is documented.
- [ ] Rollback or recovery path is documented where relevant.
- [ ] Live verification commands are documented for deployed projects.

