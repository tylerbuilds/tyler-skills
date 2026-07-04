#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

echo "== Public safety audit =="
./scripts/audit-public-safety.sh
echo

run_gitleaks() {
  if command -v gitleaks >/dev/null 2>&1; then
    gitleaks detect --source . --redact --verbose
    return
  fi

  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    docker run --rm -v "$PWD:/repo" ghcr.io/gitleaks/gitleaks:latest detect --source=/repo --redact --verbose
    return
  fi

  echo "Gitleaks not available. Install gitleaks, or start Docker and rerun this script." >&2
  return 127
}

run_trufflehog() {
  if command -v trufflehog >/dev/null 2>&1; then
    trufflehog git "file://$PWD" --results=verified,unknown --fail
    return
  fi

  if command -v docker >/dev/null 2>&1 && docker info >/dev/null 2>&1; then
    docker run --rm -v "$PWD:/repo" trufflesecurity/trufflehog:latest git file:///repo --results=verified,unknown --fail
    return
  fi

  echo "TruffleHog not available. Install trufflehog, or start Docker and rerun this script." >&2
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
  echo "Secret scan did not complete. Install the missing tools or start Docker, then rerun." >&2
  exit 1
fi
