#!/usr/bin/env bash
set -euo pipefail

domain="${1:-}"
if [[ -z "$domain" ]]; then
  echo "usage: $0 example.com" >&2
  exit 64
fi

if [[ -z "${CLOUDFLARE_API_TOKEN:-}" ]]; then
  echo "CLOUDFLARE_API_TOKEN is not set." >&2
  exit 78
fi

if ! command -v jq >/dev/null 2>&1; then
  echo "jq is required." >&2
  exit 69
fi

api="https://api.cloudflare.com/client/v4"

cf_get() {
  curl -sS -H "Authorization: Bearer ${CLOUDFLARE_API_TOKEN}" \
    -H "Content-Type: application/json" \
    "$api$1"
}

echo "== Cloudflare readiness: $domain =="
echo

zone_json="$(cf_get "/zones?name=${domain}&per_page=1")"
if [[ "$(jq -r '.success' <<<"$zone_json")" != "true" ]]; then
  echo "Cloudflare zone lookup failed:"
  jq '{success, errors}' <<<"$zone_json"
  exit 1
fi

zone_id="$(jq -r '.result[0].id // empty' <<<"$zone_json")"
if [[ -z "$zone_id" ]]; then
  echo "No Cloudflare zone found for $domain."
  exit 2
fi

jq -r '.result[0] | "zone_id: \(.id)\nstatus: \(.status)\nplan: \(.plan.name // "unknown")\ncloudflare_nameservers: \((.name_servers // []) | join(", "))\noriginal_nameservers: \((.original_name_servers // []) | join(", "))"' <<<"$zone_json"
echo

echo "-- Public nameservers via 1.1.1.1 --"
dig +short NS "$domain" @1.1.1.1 || true
echo

echo "-- DNS records readback --"
dns_json="$(cf_get "/zones/${zone_id}/dns_records?per_page=100")"
if [[ "$(jq -r '.success' <<<"$dns_json")" == "true" ]]; then
  jq -r '.result[] | select(.type == "A" or .type == "AAAA" or .type == "CNAME") | [.type, .name, (.proxied|tostring), .content] | @tsv' <<<"$dns_json" | sed -n '1,40p'
else
  jq '{success, errors}' <<<"$dns_json"
fi
echo

echo "-- Selected zone settings readback --"
for setting in always_use_https automatic_https_rewrites browser_check min_tls_version ssl; do
  setting_json="$(cf_get "/zones/${zone_id}/settings/${setting}")"
  if [[ "$(jq -r '.success' <<<"$setting_json")" == "true" ]]; then
    jq -r '.result | "\(.id): \(.value)"' <<<"$setting_json"
  else
    echo "$setting: unreadable with current token"
  fi
done
