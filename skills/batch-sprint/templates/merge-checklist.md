# Merge Checklist

Merge only if every required line is true.

- [ ] PR is open and targets the correct base branch.
- [ ] PR is mergeable.
- [ ] Required CI is green.
- [ ] No new commits changed proof unexpectedly.
- [ ] Local replay proof is green or exact blocker is accepted.
- [ ] Diff is scoped to the sprint.
- [ ] No secrets, credentials, private logs, or production data are present.
- [ ] Forbidden side effects did not happen.
- [ ] Linked issues are closed or honestly updated.
- [ ] Rollback path is documented.

After merge:

- [ ] Merge commit confirmed.
- [ ] Base branch refreshed safely.
- [ ] Remote branch deleted if safe.
- [ ] Scratch worktree removed after merged head is on base.
- [ ] Local branch deleted if safe.
- [ ] Closeout sent.
