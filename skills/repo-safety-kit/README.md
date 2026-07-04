# Repo Safety Kit

This skill helps an agent audit and bootstrap a repository with practical safety defaults.

It is designed for non-developers, non-technical founders, and vibe coders who want advanced-developer repo hygiene without needing to know every security, CI, and GitHub setting first.

Use it when a repo needs the boring useful things that stop projects becoming fragile:

- agent instructions
- local verification script
- pre-push hook
- secret scanning
- CI
- Dependabot
- CodeQL or code scanning guidance
- OpenSSF Scorecard for public repos
- security policy
- env examples
- release and verification checklist

Start with the audit:

```bash
skills/repo-safety-kit/scripts/repo-safety-audit.sh /path/to/repo
```

Then apply only the templates that fit the repo.
