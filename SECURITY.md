# Security Policy

## Reporting security issues

Please report security issues privately rather than opening a public issue with exploit details.

## Secret handling

This repository must not contain:

- API tokens or API keys.
- Cloudflare account IDs or zone IDs from a real account.
- Service-token client IDs or secrets.
- Origin IP addresses.
- Private domains, internal hostnames, private email addresses, or personal infrastructure paths.
- Raw `.env` values.

Use placeholders such as `example.com`, `CLOUDFLARE_API_TOKEN`, and `<account-id>`.

## Cloudflare credential guidance

Use a scoped Cloudflare API token, not the legacy Global API key. Give the token only the permissions needed for the current task and revoke it when the work is complete.

The included helper scripts are read-only. Any mutation to DNS, WAF/rulesets, Access, Turnstile, zone settings, or origin firewall rules should require explicit user confirmation.

