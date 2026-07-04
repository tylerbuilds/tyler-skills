# Publication Checklist

Run this before making the repo public or pushing a new public skill.

## 1. Check the working tree

```bash
git status --short
git diff --stat
git diff
```

Make sure every changed file is intended for public release.

## 2. Run the public safety scan

```bash
./scripts/audit-public-safety.sh
```

This catches common mistakes. It will not catch everything.

## 3. Read the history you are about to publish

```bash
git log --oneline --all
git log --all -p -- . ':(exclude).git'
```

If sensitive content ever entered a commit, removing it from the latest file is not enough. Rewrite the local history before publishing, or start from a fresh clean repo.

## 4. Check for accidental private context

Look for:

- personal machine paths
- private project names
- private domains or internal hostnames
- personal or customer email addresses
- account IDs, zone IDs, customer IDs, database IDs, project IDs
- real incident notes, logs, screenshots, or exported data

## 5. Check credential guidance

Public skills should tell users to:

- use scoped tokens rather than broad global keys
- set credentials through env vars or a secret manager
- avoid committing `.env` files
- revoke short-lived tokens after use
- ask before live mutations

## 6. Enable GitHub protections after publishing

In GitHub, enable or confirm:

- secret scanning
- push protection
- branch protection for `main` if you want PR review before future changes

GitHub's protections are useful, but they are a second line of defence. The first line is still not committing sensitive material.

References:

- GitHub secret scanning: https://docs.github.com/en/code-security/concepts/secret-security/secret-scanning
- Removing sensitive data from Git history: https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository

## 7. Final publish command

Only after the checks pass:

```bash
gh repo create <owner>/<repo> --public --source=. --remote=origin --push
```
