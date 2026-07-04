#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

if [[ ! -d .git ]]; then
  echo "This command must be run from a Git checkout." >&2
  exit 1
fi

git config core.hooksPath .githooks
./scripts/setup-secret-scanners.sh

echo
echo "Git hooks installed for this checkout."
echo "core.hooksPath=$(git config core.hooksPath)"
echo "pre-push will run ./scripts/secret-scan.sh before anything leaves this repo."
