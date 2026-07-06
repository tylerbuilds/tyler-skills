---
name: deepseek-harness-ops
description: Use a local-first DeepSeek batch harness safely through CLI, MCP, fake/dry-run tests, approval-gated live calls, cost ledgers, and no-mock real-service e2e checks without leaking keys or granting the harness write authority.
argument-hint: "<harness repo or run objective>"
---

# DeepSeek Harness Ops

Use this skill when a user wants to run, install, test, or extend a DeepSeek batch harness for fast parallel inference work.

The harness is an execution tool, not an approval system. Keep the human or parent agent in charge of prompts, review, publication, repo changes, and live side effects.

## Safety rules

- Never print, store, commit, or document API keys, raw environment values, provider responses that may contain private data, or approval secrets.
- Default to fake or dry-run transport.
- Treat live DeepSeek calls as external egress. Run them only with explicit approval, non-sensitive inputs, a cost cap, and the harness live flag.
- Keep `canonical_writes`, repo apply, deploy, publish, sends, GitHub writes, billing/auth changes, and permission changes outside harness authority.
- Store provider keys in the operator's secret manager or OS keychain. Load them into the child process environment only when running an approved live command.
- Use one-item live smoke tests before any scale ramp.
- Report `done`, `pending`, and `blocked` separately. Do not call a missing key, failed live call, or skipped e2e test "green".

## Inputs

Required:

- Harness checkout or installed command.
- Run objective, for example local canary, MCP install check, benchmark, or live micro-smoke.

Optional:

- Approved live run id.
- Cost cap.
- Target concurrency.
- Manifest path.
- MCP client config target.

Expected environment for live calls:

```bash
DEEPSEEK_API_KEY
```

Do not ask the user to paste the key into chat. Ask them to place it in a secret manager or clipboard only long enough for a local keychain import command that does not print the value.

## Workflow

### 1. Inspect the harness

Start read-only:

```bash
git status --short
git branch --show-current
node dist/src/cli.js doctor
```

If `dist/` is missing, build first:

```bash
npm install
npm run build
```

Check whether the harness exposes:

- manifest planning;
- submit/work/status/results commands;
- MCP stdio server;
- fake and dry-run transports;
- live transport gates;
- review packet export;
- cost ledger export;
- real-service e2e script.

### 2. Run local proof first

Run fake or dry-run proof before live provider calls:

```bash
npm run typecheck
npm test
npm run test:e2e
npm run mcp:smoke
```

If available, run local harness macros:

```bash
node dist/src/cli.js agent-canary --output artifacts/agent-canary.json
node dist/src/cli.js workload-benchmark --workload classification --items 12 --concurrency 4 --output artifacts/workload-benchmark.json
node dist/src/cli.js failure-canary --output artifacts/failure-canary.json
node dist/src/cli.js compare-models examples/model-comparison-base.json --output artifacts/model-comparison-plan.json
```

All of these should run without network calls.

### 3. Configure MCP

Generate MCP config from the harness rather than writing it by hand:

```bash
node dist/src/cli.js mcp-config
node dist/src/cli.js mcp-config --format codex-toml
```

Smoke the MCP server:

```bash
npm run mcp:smoke
```

Expected proof:

- MCP server starts over stdio.
- Tool list includes plan, submit, work, status, results, review packet, state, approval packet, and harness canaries.
- Doctor reports live calls disabled by default.

### 4. Prepare live e2e

Before a live call, create or choose a manifest with:

- `egress_class: "non_sensitive_bulk"`;
- `transport: "deepseek"`;
- one or two non-sensitive items;
- low concurrency, usually `1` or `2`;
- low cost cap;
- real approval id;
- `canonical_writes: false`;
- `external_side_effects: false`.

Generate the approval packet:

```bash
node dist/src/cli.js approval-packet path/to/live-manifest.json --output artifacts/live-approval-packet.json
node dist/src/cli.js plan path/to/live-manifest.json --allow-live
```

Stop if the plan reports blockers.

### 5. Run real-service e2e

Prefer a keychain or secret-manager wrapper. The command shape should be:

```bash
REAL_DEEPSEEK_E2E=true npm run test:real:deepseek:keychain -- --approval-id <approved-run-id>
```

If no wrapper exists, run the live command only after the key is loaded into the process environment by a secret manager:

```bash
REAL_DEEPSEEK_E2E=true npm run test:real:deepseek -- --approval-id <approved-run-id>
```

The e2e runner should:

- emit structured JSON-line logs;
- write local state and artefacts only;
- call the real provider once with non-sensitive input;
- export a review packet;
- export a cost ledger;
- report token usage and side effects.

### 6. Scale only after the smoke passes

Use a local scale ramp first:

```bash
node dist/src/cli.js scale-ramp examples/basic-run.json --concurrency 5,10,20 --items 40 --output artifacts/scale-ramp-local.json
```

Run live scale only with a separate explicit approval:

```bash
node dist/src/cli.js scale-ramp path/to/live-manifest.json --concurrency 5,10,20 --items 40 --output artifacts/live-scale-ramp.json --allow-live --allow-live-scale
```

Do not infer live scale approval from a micro-smoke approval.

### 7. Review outputs

Treat outputs as review inventory, not publishable truth.

Check:

- `summary.json`;
- `results.jsonl`;
- `review-packet.json`;
- `cost-ledger.json`;
- failed item count;
- warnings and blockers;
- token usage;
- whether any output needs human or parent-agent review.

## Product readiness judgement

Use this plain grading:

- `usable`: CLI, MCP, fake/dry-run tests, review packets, cost ledgers, and live micro-smoke pass.
- `installable`: wrappers, config snippets, docs, and local install smoke pass.
- `public alpha`: public safety scan, secret scan, CI, README, licence, and no-mock live e2e pass.
- `product`: versioned releases, upgrade path, CI matrix, backwards-compatible schemas, issue templates, security policy, observability, rate-limit/backoff, and support docs exist.

Do not call a harness a finished product just because the happy-path live smoke passed.

## Verification

For local use:

```bash
npm run typecheck
npm test
npm run test:e2e
npm run mcp:smoke
git diff --check
```

For public/reusable repos, also run:

```bash
npm audit --audit-level=high
./scripts/verify.sh
```

If the repo has Rust worker code:

```bash
cargo test
```

## Final response shape

- `Status`: usable, installable, public alpha, product, or blocked.
- `Live e2e`: pass, not run, or exact blocker.
- `Proof`: commands and results.
- `Side effects`: live calls, deploys, sends, provider writes, repo writes.
- `Outputs`: review packet, cost ledger, state path, or MCP config path.
- `Next`: one safe next action.
