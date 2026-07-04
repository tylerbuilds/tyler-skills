#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
cd "$root"

echo "== Tyler Skills verify =="
./scripts/setup-secret-scanners.sh
./scripts/secret-scan.sh
echo "== Verify passed =="
