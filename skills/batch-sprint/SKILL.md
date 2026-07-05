---
name: batch-sprint
description: Run a scoped overseer-style delivery sprint: turn a bounded brief into issues, isolated implementation branches, proof, PRs, review, approved merges, cleanup, and closeout without widening scope or leaking private context.
argument-hint: "<sprint brief or project goal>"
---

# Batch Sprint

Use this skill when a user wants an agent to run a bounded implementation sprint across one or more repositories, especially when the work should move through issues, branches, pull requests, proof, review, and merge.

This is not a licence for open-ended autonomy. It is a disciplined delivery loop.

## Safety rules

- Keep the sprint scope locked. Do not add side quests because they are nearby.
- Start with read-only discovery. Prove the current state before changing it.
- Use isolated branches or worktrees. Do not reshape a dirty canonical checkout.
- Never commit secrets, raw env values, credentials, private logs, customer data, screenshots, or internal machine paths.
- Create issues only when the sprint asks for issue tracking or when the user has already approved that workflow.
- Open pull requests only for scoped sprint work.
- Merge only after the merge rule is explicit. If the user has not granted merge authority, stop at `ready_for_review`.
- If merge authority is granted, merge only after local proof and required remote checks are green.
- Do not deploy, publish, send messages, alter billing/auth/permissions, change secrets, or mutate production unless the user explicitly approved that exact action.
- Report `done`, `pending`, and `blocked` separately.

## Inputs

Required:

- Sprint objective.
- Target project or repository.
- Allowed write surfaces, for example `repo branch only`, `GitHub issue/PR`, or `local docs only`.

Optional:

- Exact issue count and titles.
- Branch naming convention.
- Required labels.
- Required proof commands.
- Merge policy.
- Deployment policy.
- Stop conditions.
- Next sprint prompt.

If the input is missing a boundary that changes authority, ask for that boundary before acting. If the missing detail is only naming or formatting, choose a conservative default and continue.

## Workflow

### 1. Lock the brief

Extract:

- goal
- non-goals
- allowed repositories
- allowed external writes
- forbidden actions
- proof commands
- merge rule
- cleanup rule
- final closeout fields

Write this as a short scope lock before implementation starts. Keep it visible through the sprint.

### 2. Discover current state

Read the live source of truth before planning changes:

- repository status and current branch
- existing docs, configs, tests, and route code
- existing issues or PRs that may already cover the sprint
- current service or read-model state when relevant
- project instructions such as `AGENTS.md`, `CONTRIBUTING.md`, or repo runbooks

Prefer existing components, commands, APIs, and docs over creating parallel systems.

Stop if:

- the canonical checkout is dirty and there is no safe isolated worktree path
- local main is unexpectedly ahead of remote main
- the branch base is wrong and cannot be safely repaired
- a required secret or credential is missing
- a live side effect would be needed but not approved

### 3. Create the issue set

If issue creation is in scope:

- Create the exact number of issues requested.
- Use the requested titles, priorities, labels, and acceptance criteria.
- If no exact issue count was given, create the smallest useful set, usually three to eight issues.
- Keep each issue testable.
- Do not create duplicate issues when equivalent open issues already exist.

Each issue should include:

- desired behaviour
- acceptance criteria
- proof command or proof artefact
- forbidden side effects

### 4. Plan the implementation

Choose the smallest safe implementation slice.

For each repo:

- create an isolated branch or worktree from the intended base
- confirm the worktree is clean
- record rollback plan
- list expected changed files
- list focused tests before editing

Use subagents only for bounded inspection, smoke matrices, review, or independent verification. The overseer agent owns final decisions and must personally inspect the relevant code, proof, and PR diff before merge.

### 5. Implement in narrow commits

Work issue by issue.

- Keep commits small and descriptive.
- Prefer existing patterns.
- Avoid unrelated refactors.
- Add tests when the behaviour can regress.
- Do not silently patch around blockers; either prove the fix or record the blocker.

If the sprint touches multiple repos, prefer separate PRs per repo unless the release process requires a single combined branch.

### 6. Prove the work

Run:

- focused tests for touched code
- repo standard verification command
- lint/build when frontend or package files changed
- state/schema validation when read models changed
- public-safety/secret scans when the repo is public or reusable
- `git diff --check`

Capture exact proof. If a test fails, fix it or record the exact blocker. Do not mark the sprint green with failing required proof.

### 7. Open PRs

Each PR body should include:

- summary
- changed files or surfaces
- proof commands and results
- side-effect statement
- rollback plan
- issue links
- known caveats

Before requesting review, check:

- PR targets the correct base branch
- branch contains only scoped changes
- no secrets or private context are in the diff
- CI is running or has passed

### 8. Review as overseer

Before merge:

- inspect PR diff
- replay critical local proof when practical
- confirm remote checks are green
- confirm no new commits changed proof unexpectedly
- confirm side-effect boundaries still hold
- confirm linked issues are ready to close or remain honestly open

Use the merge template in `templates/merge-checklist.md` when the sprint has explicit merge approval.

### 9. Merge and clean up

Only merge when the merge policy says the overseer may merge.

After merge:

- confirm merge commit
- confirm issues closed or updated
- delete remote branch if safe
- remove scratch worktree only after merged head is on the base branch
- delete local branch if safe
- leave unrelated canonical checkouts untouched
- run a small post-merge smoke when the repo supports it

Do not start the next batch until the current batch is merged or explicitly closed as blocked.

### 10. Close out

Close with:

- PR numbers
- merge commits
- final status
- proof run
- side effects
- remaining blockers
- cleanup completed
- next safe batch or recommendation

Keep the closeout short enough that the user can see the truth at a glance.

## Useful templates

- `templates/sprint-plan.md`
- `templates/issue.md`
- `templates/pr-body.md`
- `templates/merge-checklist.md`
- `templates/closeout.md`

Copy them into the sprint notes or PR body as needed. Replace placeholders before use.

## Verification

Before claiming the skill itself is ready in a public skill repo, run:

```bash
./scripts/audit-public-safety.sh
./scripts/setup-secret-scanners.sh
./scripts/secret-scan.sh
git diff --check
```

For a normal sprint run, use the target repo's own proof commands plus any sprint-specific proof.

## Final response shape

- `Status`: implemented, ready for review, merged, or blocked.
- `Issues`: created or reused issue list.
- `PRs`: PR links and states.
- `Proof`: commands and results.
- `Side effects`: sends, deploys, provider calls, external writes, repo applies.
- `Cleanup`: branches, worktrees, temporary files.
- `Remaining blockers`: exact blockers and owner action.
- `Next`: one safe next action.
