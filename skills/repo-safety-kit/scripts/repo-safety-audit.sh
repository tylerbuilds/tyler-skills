#!/usr/bin/env bash
set -euo pipefail

target="${1:-.}"
if [[ ! -d "$target" ]]; then
  echo "usage: $0 /path/to/repo" >&2
  exit 64
fi

cd "$target"

echo "# Repo Safety Audit"
echo
echo "Path: $(pwd)"
echo "Date: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
echo

section() {
  echo
  echo "## $1"
}

exists() {
  if [[ -e "$1" ]]; then
    echo "PASS $1"
  else
    echo "MISS $1"
  fi
}

any_exists() {
  local label="$1"
  shift
  local file
  for file in "$@"; do
    if [[ -e "$file" ]]; then
      echo "PASS $label: $file"
      return 0
    fi
  done
  echo "MISS $label"
}

section "Git"
if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "branch: $(git branch --show-current 2>/dev/null || true)"
  echo "status:"
  git status --short || true
  echo "remotes:"
  git remote -v || true
  echo "hooksPath: $(git config core.hooksPath 2>/dev/null || echo '<not set>')"
else
  echo "MISS not a Git repository"
fi

section "Core Files"
for file in README.md AGENTS.md SECURITY.md LICENSE .gitignore .env.example; do
  exists "$file"
done

section "Automation"
for file in scripts/verify.sh scripts/setup-git-hooks.sh .githooks/pre-push; do
  exists "$file"
done

section "GitHub"
any_exists "CI or safety workflow" .github/workflows/repo-safety.yml .github/workflows/ci.yml .github/workflows/public-safety.yml
exists .github/dependabot.yml
exists .github/workflows/scorecard.yml
any_exists "CodeQL workflow or dashboard default setup to verify manually" .github/workflows/codeql.yml .github/codeql.yml

section "Project Signals"
for file in package.json pnpm-lock.yaml package-lock.json yarn.lock pyproject.toml requirements.txt Cargo.toml go.mod composer.json wrangler.jsonc wrangler.toml; do
  [[ -e "$file" ]] && echo "FOUND $file"
done

section "Public-Risk Pattern Check"
if command -v rg >/dev/null 2>&1; then
  fail=0
  check() {
    local label="$1"
    local pattern="$2"
    local matches
    matches="$(rg -n --with-filename --hidden --no-ignore -I -e "$pattern" \
      --glob '!.git/**' \
      --glob '!node_modules/**' \
      --glob '!.tools/**' \
      --glob '!.scanner-bin/**' \
      --glob '!dist/**' \
      --glob '!build/**' \
      --glob '!.next/**' \
      --glob '!coverage/**' \
      --glob '!scripts/audit-public-safety.sh' \
      --glob '!scripts/secret-scan.sh' \
      --glob '!skills/repo-safety-kit/scripts/repo-safety-audit.sh' \
      . | awk -F: '{print $1 ":" $2}' | sort -u || true)"
    if [[ -n "$matches" ]]; then
      echo "WARN $label"
      echo "Content redacted; inspect locally before publishing:"
      printf '%s\n' "$matches"
      fail=1
    else
      echo "PASS $label"
    fi
  }
  check "private machine paths" '(^|[^[:alnum:]_])/(Users|home)/[A-Za-z0-9._-]+/'
  check "env values with secret-like names" '^[A-Z0-9_]*(TOKEN|SECRET|PASSWORD|API_KEY|PRIVATE_KEY|CLIENT_SECRET)[A-Z0-9_]*=["'\'']?[^"'\'']{8,}'
  check "provider token patterns" '(ghp_|github_pat_|sk_live_|rk_live_|whsec_|xox[baprs]-|SG\.[A-Za-z0-9_-]{16,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{20,}|-----BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY-----)'
  [[ "$fail" -eq 0 ]] && echo "summary: no obvious public-risk patterns found"
else
  echo "SKIP ripgrep not installed"
fi

section "Recommended Next Steps"
echo "- Add or update missing core files."
echo "- Add a repo-local verify script and pre-push hook."
echo "- Add CI that runs the same verify script."
echo "- Add Dependabot for detected package ecosystems."
echo "- Enable GitHub secret scanning, push protection, and branch protection/rulesets in repo settings."
echo "- Use CodeQL default setup or workflow-based CodeQL for supported code repos."
echo "- Use OpenSSF Scorecard for public repos."
