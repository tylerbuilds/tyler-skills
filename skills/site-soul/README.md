# Site Soul

**Make an existing website feel like somebody made it on purpose.**

Site Soul helps an agent improve a founder-owned product, portfolio or editorial site when it has drifted into familiar template patterns: interchangeable cards, generic hero graphics, decorative motion and vague claims. It protects the choices that already make the site recognisable, then makes the real product, work and judgement easier to see.

It is not a rebrand generator, a copywriting prompt or a component-library installer.

## What it changes

The skill starts by establishing what is already worth keeping: the founder's visual choices, factual product boundaries, direct routes and existing components. It then guides a small, evidence-led change such as:

| Common problem | Site Soul response |
| --- | --- |
| Every page section has the same card layout | Use editorial hierarchy, rules, spacing and a small number of intentional evidence frames. |
| A polished illustration does more work than the real product | Put a real output, capture, project artefact or interaction demonstration first, with an honest caption. |
| Related sites look either cloned or unrelated | Keep a shared foundation but give each property a composition that suits its job. |
| A desktop capture becomes unreadable on mobile | Use genuine crops, retain the full-view route and preserve provenance. |
| A visual fix passes tests but feels broken in use | Run browser checks for focus, overflow, responsive layout and the changed interaction. |

The result should feel more specific and more useful, without making false claims or importing an unrelated visual trend.

## Use it

```text
/site-soul <site, repository or design brief>
```

For a useful first pass, give the agent the public URL or repository and state:

```text
Use $site-soul to audit this site. Preserve the existing palette, logo and offer.
The homepage feels too template-led. Find the strongest truthful evidence already
available, propose the smallest visual changes, and do not alter pricing, copy,
analytics, consent or checkout.
```

For implementation, add the allowed scope and whether a production release is authorised.

## What the agent should deliver

1. A short **preservation/change map** that says what remains, what changes and why.
2. A creative direction tied to the site's actual role: parent index, product dossier, direct utility, portfolio, editorial guide or commerce page.
3. A resource decision for every external UI tool considered: adopted, reference-only or deferred, with a reason.
4. Responsive browser proof alongside functional checks.
5. An honest list of remaining asset, evidence or owner-decision gaps.

## What it will not do by default

- Replace a recognised brand with gradients, glass panels, new fonts or decorative motion merely to look current.
- Invent screenshots, customer results, testimonials, case studies or endorsements.
- Quietly rewrite offers, prices, promotions, consent, analytics, tracking, checkout or product claims.
- Deploy, publish or send messages without separate authorisation.

## External UI resources

Site Soul treats external resources as a way to make a better decision, not as a new design system. Its [resource decisions](references/resource-decisions.md) explain when a fluid type scale, component reference, checklist or small CSS interaction might help, and when to defer a dependency.

## Safety

The public skill uses generic examples only. It does not contain private domains, local paths, screenshots, customer data or secrets. Read [SKILL.md](SKILL.md) for the complete workflow and boundaries.
