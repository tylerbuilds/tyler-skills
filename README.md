# Tyler Skills

Reusable agent skills for practical website and automation work.

The first public skill is `cloudflare-website-hardening`: a safety-first agent workflow for tightening Cloudflare protection around a website without handing an agent a broad, permanent key or blindly breaking legitimate traffic.

## Skill: Cloudflare Website Hardening

Use this when you want an agent to review and harden a site on Cloudflare. It covers:

- DNS and proxy activation checks.
- Cloudflare API token scope checks.
- Conservative WAF and rate-limit planning.
- Cloudflare Access planning for admin/private routes.
- Turnstile planning for forms and login-like surfaces.
- Origin firewall readiness checks.
- Public smoke tests before and after changes.
- A local hardening report so you know what changed and what is still pending.

The skill is deliberately cautious. It tells the agent to prove the current state, propose changes, ask before mutations, and avoid overclaiming protection while DNS, proxying, or token permissions are still pending.

## Install

Copy the skill folder into the skills directory used by your agent environment:

```bash
mkdir -p ~/.agents/skills
cp -R skills/cloudflare-website-hardening ~/.agents/skills/
```

Then invoke it by name if your agent supports skill loading:

```text
/cloudflare-website-hardening example.com
```

If your agent does not support slash skills, paste the contents of `skills/cloudflare-website-hardening/SKILL.md` into the agent context and ask it to follow the workflow.

## Cloudflare API token

Use a scoped Cloudflare API token, not the legacy Global API key.

For a read-only audit, start with the narrowest practical zone-level read permissions for the target zone, such as zone read, DNS read, rulesets read, and zone settings read where available.

For a full hardening pass, add only the permissions required for the specific changes you want the agent to make. Common examples are:

- Zone DNS read.
- Zone settings edit.
- Zone rulesets edit.
- Account Turnstile edit, if creating Turnstile widgets.
- Account Access apps and policies edit, if creating Cloudflare Access apps.

Cloudflare permission names can change, so confirm them in Cloudflare's current API token documentation before creating a token.

Export the token into your shell or use your password manager. Do not commit it:

```bash
export CLOUDFLARE_API_TOKEN="your scoped token"
export CLOUDFLARE_ACCOUNT_ID="optional account id"
export CLOUDFLARE_ZONE_ID="optional zone id"
```

The included `.gitignore` excludes `.env` files. Keep it that way.

## Safety model

The public skill is safe to share because it does not include:

- Real domains.
- Account IDs or zone IDs.
- API tokens, secret keys, service tokens, or env values.
- Private registrar tooling.
- Private note paths, internal dashboards, or personal email addresses.

The skill also tells agents to:

- Prefer API tokens over Global API keys.
- Use short-lived or narrowly-scoped tokens.
- Verify token scope before promising a change.
- Treat read access and write access as separate proof.
- Ask before applying WAF, Access, DNS, or firewall mutations.
- Never lock an origin firewall until certificate renewal and bypass paths are proved.

## Helper scripts

Read-only scripts live inside the skill:

```bash
skills/cloudflare-website-hardening/scripts/domain-baseline.sh example.com
skills/cloudflare-website-hardening/scripts/cloudflare-zone-readiness.sh example.com
```

They print DNS, HTTP, probe-path, and Cloudflare zone readiness information. They do not change Cloudflare or your origin.

## References

- Cloudflare API tokens: https://developers.cloudflare.com/fundamentals/api/get-started/create-token/
- Cloudflare API token permissions: https://developers.cloudflare.com/fundamentals/api/reference/permissions/
- Cloudflare Rulesets API: https://developers.cloudflare.com/ruleset-engine/rulesets-api/create/
- Cloudflare Access applications: https://developers.cloudflare.com/cloudflare-one/access-controls/applications/http-apps/
- Cloudflare Turnstile widgets API: https://developers.cloudflare.com/turnstile/get-started/widget-management/api/
