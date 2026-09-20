---
name: site-soul
description: Audit or improve an existing founder-owned product, portfolio or editorial website so it feels deliberately authored, evidence-led and product-specific without an unnecessary rebrand, copy rewrite or generic template redesign.
---

# Site Soul

Use this skill when an existing founder-owned website feels generic, template-led or insufficiently specific, but the owner wants to retain its product, offer and recognised visual identity.

The goal is to make the real work easier to see. Do not make every site look different for its own sake.

## Safety rules

- Start with read-only inspection of the repository, rendered site and owner brief.
- Preserve founder-approved branding, product facts, useful routes and factual claims unless the user explicitly requests a change.
- Never invent product screens, customer outcomes, testimonials, case studies or endorsements.
- Do not change pricing, promotions, consent, analytics, tracking, checkout, authentication or direct-action routes without explicit approval.
- Do not deploy, publish or send messages unless the user has separately authorised that action.
- Never include secrets, customer data, private URLs, internal hostnames, local paths or private screenshots in public outputs.
- State `done`, `pending` and `blocked` separately.

## Inputs

Required:

- Site URL, repository, screenshots or a clear description of the current surface.
- The founder's preservation constraints: visual choices, product facts and routes that must remain intact.

Useful:

- Real product output, captures, recordings, projects or documents that can be shown with accurate provenance.
- A known user or business problem, such as an unclear primary route, repetitive card layout, weak evidence, unreadable mobile content or an interaction failure.

## Workflow

### 1. Establish current truth

Before proposing changes, identify:

1. **Preserve:** palette, marks, type, surfaces, voice, routes and commercial/product facts the founder values.
2. **Evidence:** authentic output, captures, recordings, projects or working examples that may appear with factual captions.
3. **Site job:** parent index, product dossier, direct utility, portfolio, editorial guide or commerce page.
4. **Source ownership:** current components, tokens, assets, responsive rules and deployment source. Do not assume an old branch or receipt is current.
5. **Actual issue:** hierarchy, evidence, route clarity, responsive layout or a defined interaction. Visual style alone cannot establish how a site was made.

Inspect rendered desktop and mobile views before treating a research claim as current. Produce a short preservation/change map before editing.

### 2. Choose a creative direction

Use hierarchy before decoration.

- Separate editorial explanation, product evidence, navigation and action through type, spacing, rules and surface contrast. Do not give every content group identical card treatment.
- Put the strongest truthful evidence early. A real output, working capture, physical interaction demonstration or project artefact is usually more persuasive than an abstract benefit panel.
- Caption evidence honestly. Label illustrations, examples and founder-owned work plainly.
- Let related products share a design foundation while varying composition by their job: a parent site can be spacious and editorial; a product can be a dense evidence-led dossier; a utility can take a short route to use or download.
- Treat confirmed founder choices as assets. Do not replace a recognised colour, type or surface system just to introduce novelty.
- Use motion only to confirm interaction: press, active state, disclosure, selected tab or media play. Respect reduced-motion preferences.

Do not introduce a new font, palette, glass effect, texture, gradient or motion system merely to signal that a redesign occurred.

### 3. Make the smallest useful change

Prioritise changes supported by the current evidence:

1. Replace a generic hero visual with authentic product evidence, or make a labelled diagram clearly secondary to the real artefact.
2. Replace repetitive card grids with a deliberate mix of editorial sections, ruled rows, concise lists and a few evidence frames.
3. Clarify the primary route and any real availability/status distinction without rewriting the offer.
4. Use responsive composition rather than shrinking desktop evidence until it becomes illegible. Use genuine crops and retain a full-view route where needed.
5. Add restrained feedback only when it makes an existing interaction clearer.

Reuse the existing token and component system before adding a dependency. Read [resource decisions](references/resource-decisions.md) before introducing an external component, motion or token library.

### 4. Verify

For a scoped implementation:

- test the changed route on a narrow phone, tablet and wide desktop viewport, plus any intermediate layout where grid or evidence behaviour changes;
- observe the changed interaction in a browser;
- check keyboard focus, touch usability, overflow, contrast and reduced-motion behaviour where relevant;
- inspect computed styles after media sizing changes; and
- verify that sample, download, contact, booking and purchase routes still work.

Treat functional checks and visual proof as separate gates. Record the source revision and public route before saying a production change is live.

## Final response shape

- `Preserved`: identity and product facts retained.
- `Applied`: changes and the authentic evidence they foreground.
- `Resource decisions`: adopted, reference-only or deferred resources with reasons.
- `Proof`: browser and code checks run.
- `Pending`: asset, evidence or owner-decision gaps.
- `Blocked`: exact blocker, if any.
