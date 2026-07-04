#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

fail=0

if ! command -v rg >/dev/null 2>&1; then
  echo "ripgrep (rg) is required for the public safety audit." >&2
  exit 69
fi

check() {
  local label="$1"
  local pattern="$2"
  local matches
  echo "-- $label --"
  matches="$(rg -n --hidden --no-ignore -I -e "$pattern" \
    --glob '!.git/**' \
    --glob '!scripts/audit-public-safety.sh' \
    --glob '!docs/PUBLICATION_CHECKLIST.md' \
    . | awk -F: '{print $1 ":" $2}' | sort -u || true)"

  if [[ -n "$matches" ]]; then
    echo "Potential public-safety matches found. Content redacted; inspect locally before publishing:"
    printf '%s\n' "$matches"
    fail=1
  else
    echo "ok"
  fi
  echo
}

check "private machine paths" '(^|[^[:alnum:]_])/(Users|home)/[A-Za-z0-9._-]+/'
check "env files with values" '^[A-Z0-9_]*(TOKEN|SECRET|PASSWORD|API_KEY|PRIVATE_KEY|CLIENT_SECRET)[A-Z0-9_]*=["'\'']?[^"'\'']{8,}'
check "provider token patterns" '(ghp_|github_pat_|sk_live_|rk_live_|whsec_|xox[baprs]-|SG\.[A-Za-z0-9_-]{16,}|AKIA[0-9A-Z]{16}|AIza[0-9A-Za-z_-]{20,}|-----BEGIN (RSA |OPENSSH |EC |DSA )?PRIVATE KEY-----)'
check "cloudflare-like bearer token text" 'cf[a-zA-Z0-9_-]{30,}'
check "non-placeholder cloudflare ids in env examples" 'CLOUDFLARE_(ACCOUNT|ZONE)_ID=[0-9a-fA-F]{16,}'
check "raw bearer auth values" 'Authorization:[[:space:]]*Bearer[[:space:]]+[A-Za-z0-9._~+/=-]{20,}'

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "-- git tracked files --"
  git ls-files
  echo

  echo "-- untracked public files --"
  git ls-files --others --exclude-standard
  echo
else
  echo "-- file list --"
  find . -type f -not -path './.git/*' | sort
  echo
fi

if [[ "$fail" -ne 0 ]]; then
  echo "Public safety audit failed. Review the matches above before publishing." >&2
  exit 1
fi

echo "Public safety audit passed."
