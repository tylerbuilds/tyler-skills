---
name: cloudflare-website-hardening
description: Review and harden a website on Cloudflare using scoped API tokens, conservative WAF/rate-limit planning, Access for admin routes, Turnstile for forms, origin-firewall readiness checks, and public smoke tests. Use when a user asks to lock down, harden, protect, secure, or audit a Cloudflare-hosted website.
argument-hint: "<domain>"
---

# Cloudflare Website Hardening

Help the user tighten Cloudflare protection around a website without leaking secrets, using a legacy Global API key, or breaking legitimate traffic.

This skill is intentionally conservative. First prove current state, then propose changes, then ask before applying mutations. Do not claim a control is live until the live DNS, Cloudflare API, and public HTTP proof agree.

## Safety rules

- Never print, store, commit, or document API tokens, secret keys, service tokens, origin IPs, or raw environment values.
- Use a scoped Cloudflare API token from `CLOUDFLARE_API_TOKEN`. Do not ask for the legacy Global API key.
- If the token is missing or under-scoped, explain the exact missing permission class and stop.
- Treat read access and write access separately. A token that can list a zone may still fail to edit rules, Access apps, Turnstile widgets, or settings.
- Ask before every mutation: DNS, WAF/rulesets, rate limits, zone settings, Access apps, Turnstile widgets, or origin firewall changes.
- Do not use paid Cloudflare features unless the user explicitly requests and confirms them.
- Do not lock an origin firewall until DNS proxying, certificate renewal, and all webhook/callback bypasses are proved.
- If evidence is incomplete, report `pending` or `blocked`; do not paper over it.

## Inputs

Required:

- Domain, for example `example.com`.

Expected environment:

```bash
CLOUDFLARE_API_TOKEN
```

Optional environment:

```bash
CLOUDFLARE_ACCOUNT_ID
CLOUDFLARE_ZONE_ID
```

Useful token permissions depend on the operation:

- Audit-only: zone read, DNS read, rulesets read, and zone settings read where available.
- WAF/rate limits: zone rulesets edit.
- Zone settings: zone settings edit.
- Turnstile: account Turnstile edit and `CLOUDFLARE_ACCOUNT_ID`.
- Cloudflare Access: account Access apps/policies edit and `CLOUDFLARE_ACCOUNT_ID`.

Cloudflare permission labels can change. If exact names matter, check Cloudflare's current API token permission documentation before instructing the user to create a token.

## Workflow

### 1. Baseline

Run the read-only baseline script:

```bash
./scripts/domain-baseline.sh example.com
```

Collect:

- Public nameservers.
- Apex and `www` HTTP status.
- Basic security headers.
- Common probe-path status for `/.env`, `/wp-login.php`, `/xmlrpc.php`, and `/ghost/`.
- Whether the site appears to be static, WordPress, Ghost, SaaS/app, Worker/Pages, or mixed.

### 2. Cloudflare readiness

Run:

```bash
./scripts/cloudflare-zone-readiness.sh example.com
```

Collect:

- Token presence, without printing the token.
- Zone ID and zone status.
- Cloudflare-assigned nameservers.
- Current authoritative nameservers.
- DNS record proxy status where the token can read DNS.
- Zone settings readback where the token can read settings.

If Cloudflare zone status is not `active`, or authoritative nameservers do not point to Cloudflare, stop and report DNS activation as pending.

### 3. Preserve legitimate traffic

Before proposing controls, identify routes that must not be challenged or blocked:

- Payment webhooks.
- Auth provider callbacks.
- OAuth callbacks.
- Form handlers.
- REST APIs.
- RSS, sitemap, media, and asset paths.
- Webhook endpoints used by automation tools.
- Health checks and uptime monitors.

The default is to protect admin and probe surfaces, not to challenge every request.

### 4. Recommend free Cloudflare controls

Recommend only controls that fit the site and available plan:

- Always Use HTTPS.
- Automatic HTTPS Rewrites.
- Modern minimum TLS, unless old clients are a known requirement.
- Browser Integrity Check, unless it breaks a legitimate integration.
- Conservative WAF custom rules for common exploit probes.
- Rate limits for login, session, and admin endpoints.
- Managed challenge for high-threat traffic on admin/API surfaces, with explicit webhook/callback exclusions.
- Bot Fight Mode only for simple public sites with no fragile automation traffic.

Do not blanket-block `.php` on WordPress. Do not challenge payment webhooks, auth callbacks, OAuth callbacks, machine clients, or automation webhooks without a proved bypass.

### 5. Cloudflare Access

Use Access for private/admin surfaces when it fits the site:

- Ghost admin: `/ghost/*`.
- WordPress login/admin: `/wp-login.php` and `/wp-admin/*`, with care around `admin-ajax.php`, REST, and cron.
- Internal dashboards and private tools.

Before enforcing Access:

- Confirm who should be allowed.
- Confirm any automation client can send Cloudflare Access service-token headers.
- Create service tokens only when the secret can be stored immediately. Service-token secrets are one-time.
- Create exact public bypasses for required webhook paths.

### 6. Turnstile

Add Turnstile to app-owned spam-prone surfaces:

- Contact forms.
- Feedback forms.
- Invite/redeem forms.
- Login-like forms where compatible.

Rules:

- Keep the existing submit handler and backend behaviour.
- Validate the token server-side.
- Check hostname and action when the framework makes it practical.
- Do not wire Turnstile into third-party auth or checkout flows unless the user explicitly asks and the provider supports it.
- Store Turnstile secrets as server-side secrets, not source code.

### 7. Origin firewall readiness

Origin firewall lockdown is optional and higher risk.

Before applying it:

- Fetch current Cloudflare IP ranges from Cloudflare.
- Confirm all intended public traffic reaches the origin through proxied Cloudflare DNS.
- Confirm certificate renewal will still work, using DNS validation or Cloudflare Origin Certificates if HTTP-01 would break.
- Preserve SSH, VPN, monitoring, mail, TURN, and other non-HTTP services.
- Add Cloudflare IPv4/IPv6 allow rules for `80/443`.
- Verify the site through Cloudflare.
- Only then remove broad public `80/443` rules.
- Prove direct-origin HTTP/HTTPS is blocked from a non-Cloudflare network.

If any part is uncertain, mark origin firewall as `deferred`.

### 8. Verification

After any approved mutation, run:

```bash
./scripts/domain-baseline.sh example.com
./scripts/cloudflare-zone-readiness.sh example.com
```

Also check specific paths:

```bash
curl -I https://example.com/
curl -I https://www.example.com/
curl -I https://example.com/.env
curl -I https://example.com/wp-login.php
curl -I https://example.com/ghost/
```

Expected results depend on the stack:

- Public pages return expected `200`, `301`, or `302`.
- Probe paths are blocked or challenged.
- Protected admin paths show Cloudflare Access, challenge, or rate-limit behaviour.
- Webhooks and callbacks still work.

### 9. Report

Create or update a local hardening report using:

```bash
cp templates/hardening-report.md hardening-report-example.com.md
```

The final answer should be short and evidence-led:

- `Applied`: controls live and proved.
- `Pending`: DNS propagation, token scope, user approval, or external setup still needed.
- `Blocked`: exact missing permission or capability.
- `Proof`: commands and key status codes.
- `Risk`: anything still not protected by Cloudflare.

