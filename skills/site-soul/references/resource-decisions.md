# Resource decisions

Use this reference only when an external UI resource is genuinely needed. Verify current licence and compatibility before copying source.

## Smallest useful set

| Resource type | Use | Position |
| --- | --- | --- |
| Repository-first UI audit guidance | Inspect existing components and responsive behaviour before redesigning. | Process reference only. |
| Fluid type and spacing calculator | Generate a controlled `clamp()` scale for an established system. | Generated CSS; no runtime dependency. |
| Design-system checklist | Check semantic colour, type, spacing, component consistency and accessibility foundations. | Review checklist; do not import its frontend. |
| Component gallery | Compare disclosure, tab and control semantics. | Reference; prefer native HTML or the existing primitive. |
| Interface-craft guidance | Inspect small interaction details after the main route works. | Reference only; accessibility and product constraints take priority. |
| CSS button-state examples | Adapt minimal press or state feedback where an existing control lacks it. | Small CSS only, adapted to current tokens and reduced-motion behaviour. |

## Usually defer

Large component libraries, token libraries, icon generators, page-generator prompts, decorative backgrounds and motion kits are normally disproportionate for a focused marketing-site or portfolio change. Consider them only when the current compatible stack has a verified gap that cannot be solved more simply.

## Decision test

Before adding anything, answer all four:

1. Does it solve an observed user, accessibility or maintenance problem?
2. Can the existing codebase solve it with less surface area?
3. Does it preserve the founder's recognised identity and the product's real evidence?
4. Is its licence and runtime cost appropriate for the project?

If any answer is no or unknown, keep it reference-only or defer it.
