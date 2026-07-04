#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

repo_bin="$root/.tools/bin"
if [[ -d "$repo_bin" ]]; then
  export PATH="$repo_bin:$PATH"
fi

echo "== Public safety audit =="
./scripts/audit-public-safety.sh
echo

has_git_repo() {
  git rev-parse --is-inside-work-tree >/dev/null 2>&1
}

run_gitleaks() {
  if command -v gitleaks >/dev/null 2>&1; then
    if has_git_repo; then
      gitleaks git . --redact --verbose
    else
      gitleaks dir . --redact --verbose
    fi
    return
  fi

  echo "Gitleaks not available. Run ./scripts/setup-secret-scanners.sh or install gitleaks, then rerun this script." >&2
  return 127
}

run_trufflehog() {
  local trufflehog_args=(--no-verification --results=unverified,unknown --fail)
  if [[ "${TRUFFLEHOG_VERIFY:-0}" == "1" ]]; then
    trufflehog_args=(--results=verified,unknown --fail)
  fi

  if command -v trufflehog >/dev/null 2>&1; then
    if has_git_repo; then
      trufflehog git "file://$PWD" "${trufflehog_args[@]}"
    else
      trufflehog filesystem . "${trufflehog_args[@]}"
    fi
    return
  fi

  echo "TruffleHog not available. Run ./scripts/setup-secret-scanners.sh or install trufflehog, then rerun this script." >&2
  return 127
}

echo "== Gitleaks =="
scan_failed=0
run_gitleaks || scan_failed=1
echo

echo "== TruffleHog OSS =="
run_trufflehog || scan_failed=1

if [[ "$scan_failed" -ne 0 ]]; then
  echo
  echo "Secret scan did not complete. Run ./scripts/setup-secret-scanners.sh or install the missing tools, then rerun." >&2
  exit 1
fi
