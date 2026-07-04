#!/usr/bin/env bash
set -euo pipefail

echo "== Repo verify =="

if command -v git >/dev/null 2>&1 && git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  git status --short
fi

if [[ -x ./scripts/audit-public-safety.sh ]]; then
  ./scripts/audit-public-safety.sh
fi

if [[ -x ./scripts/secret-scan.sh ]]; then
  ./scripts/secret-scan.sh
fi

if [[ -f package.json ]]; then
  if command -v pnpm >/dev/null 2>&1 && [[ -f pnpm-lock.yaml ]]; then
    pnpm install --frozen-lockfile
    pnpm test --if-present
    pnpm run build --if-present
  elif command -v npm >/dev/null 2>&1; then
    npm test --if-present
    npm run build --if-present
  fi
fi

echo "== Repo verify passed =="

