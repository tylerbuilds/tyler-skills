#!/usr/bin/env bash
set -euo pipefail

root="$(git rev-parse --show-toplevel)"
cd "$root"

git config core.hooksPath .githooks

echo "Git hooks installed."
echo "core.hooksPath=$(git config core.hooksPath)"

