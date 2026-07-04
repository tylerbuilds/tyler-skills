---
name: my-skill
description: Explain what this skill helps an agent do, when to use it, and the main safety boundary.
argument-hint: "<target>"
---

# My Skill

Use this skill when `<plain trigger condition>`.

## Safety rules

- Never print, store, commit, or document secrets.
- Start with read-only inspection.
- Ask before changing live systems.
- State `done`, `pending`, and `blocked` separately.

## Inputs

Required:

- `<input>`

Optional:

- `<optional input>`

## Workflow

### 1. Inspect

Explain the read-only checks first.

### 2. Plan

Explain the smallest safe change.

### 3. Apply

Only apply changes after user approval when the change affects live systems.

### 4. Verify

List the proof required before claiming success.

## Final response shape

- `Applied`: what changed.
- `Pending`: what still needs setup, approval, or propagation.
- `Blocked`: exact blocker.
- `Proof`: commands or checks run.

