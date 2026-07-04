#!/usr/bin/env bash
set -euo pipefail

domain="${1:-}"
if [[ -z "$domain" ]]; then
  echo "usage: $0 example.com" >&2
  exit 64
fi

echo "== Domain baseline: $domain =="
echo

echo "-- Public nameservers via 1.1.1.1 --"
dig +short NS "$domain" @1.1.1.1 || true
echo

echo "-- Public A/AAAA via 1.1.1.1 --"
dig +short A "$domain" @1.1.1.1 || true
dig +short AAAA "$domain" @1.1.1.1 || true
echo

echo "-- HTTPS smoke: apex --"
curl -sSIL --max-time 15 "https://$domain" | sed -n '1,20p' || true
echo

echo "-- HTTPS smoke: www --"
curl -sSIL --max-time 15 "https://www.$domain" | sed -n '1,20p' || true
echo

echo "-- Common probe smoke --"
for path in "/.env" "/wp-login.php" "/xmlrpc.php" "/ghost/"; do
  code="$(curl -sS -o /dev/null -w '%{http_code}' --max-time 15 "https://$domain$path" || true)"
  printf "%-18s %s\n" "$path" "$code"
done

