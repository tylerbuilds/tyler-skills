#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

repo_bin="$root/.tools/bin"
if [[ -d "$repo_bin" ]]; then
  export PATH="$repo_bin:$PATH"
fi

default_cache_root="${XDG_CACHE_HOME:-${HOME:-$root/.tools}/.cache}"
cache_bin="${SECRET_SCANNER_BIN_DIR:-$default_cache_root/tyler-skills/bin}"
if [[ -d "$cache_bin" ]]; then
  export PATH="$cache_bin:$PATH"
fi

tmp_dir="$(mktemp -d)"
trap 'rm -rf "$tmp_dir"' EXIT

trufflehog_exclude="$tmp_dir/trufflehog-exclude-paths.txt"
cat >"$trufflehog_exclude" <<'EOF'
(^|/)\.git/
(^|/)\.tools/
(^|/)\.scanner-bin/
EOF

if [[ "$cache_bin" == "$root/"* ]]; then
  cache_rel="${cache_bin#$root/}"
  cache_rel_escaped="$(printf '%s' "$cache_rel" | sed 's/[.[\*^$()+?{}|\\]/\\&/g')"
  printf '(^|/)%s/\n' "$cache_rel_escaped" >>"$trufflehog_exclude"
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
  local trufflehog_output="$tmp_dir/trufflehog-output.txt"
  local trufflehog_status=0
  if [[ "${TRUFFLEHOG_VERIFY:-0}" == "1" ]]; then
    trufflehog_args=(--results=verified,unknown --fail)
  fi

  if command -v trufflehog >/dev/null 2>&1; then
    if has_git_repo; then
      trufflehog git "file://$PWD" --exclude-paths="$trufflehog_exclude" "${trufflehog_args[@]}" >"$trufflehog_output" 2>&1 || trufflehog_status=$?
    else
      trufflehog filesystem . --exclude-paths="$trufflehog_exclude" "${trufflehog_args[@]}" >"$trufflehog_output" 2>&1 || trufflehog_status=$?
    fi
    if [[ "$trufflehog_status" -ne 0 ]]; then
      echo "TruffleHog found potential secrets or hit a scan error. Raw output is redacted from logs."
      awk '/Detector Type:|File:|Line:|verified_secrets|unverified_secrets|scan_duration|error reading chunk|finished scanning/ { if ($0 !~ /Raw result/) print }' "$trufflehog_output"
      return "$trufflehog_status"
    fi
    awk '/finished scanning|verified_secrets|unverified_secrets|scan_duration/ { print }' "$trufflehog_output" || true
    echo "TruffleHog completed with no findings."
    return 0
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
