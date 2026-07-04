# Cloudflare Hardening Report

Domain: `<example.com>`
Date: `<YYYY-MM-DD>`
Agent/operator: `<name>`

## Summary

| Control | State | Evidence |
| --- | --- | --- |
| Cloudflare zone active | `<done/pending/blocked>` | `<zone status and nameserver proof>` |
| DNS proxied | `<done/pending/blocked>` | `<apex/www record proof>` |
| HTTPS/TLS settings | `<done/pending/blocked>` | `<settings readback>` |
| WAF probe blocking | `<done/pending/blocked>` | `<rule names and probe status>` |
| Rate limits | `<done/pending/not applicable/blocked>` | `<thresholds and target paths>` |
| Cloudflare Access | `<done/pending/not applicable/blocked>` | `<protected paths and bypasses>` |
| Turnstile | `<done/pending/not applicable/blocked>` | `<forms/widgets and validation proof>` |
| Origin firewall | `<done/deferred/blocked>` | `<Cloudflare IP allowlist and direct-origin proof, or defer reason>` |

## Public paths preserved

- `<payments/auth/webhooks/rss/assets/apis/health>`

## Admin or private paths

- `<paths>`

## Smoke proof

```text
<paste status codes, not secrets>
```

## Remaining risks

- `<risk and next action>`

