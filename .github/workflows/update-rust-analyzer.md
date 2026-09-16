---
name: Update rust-analyzer
emoji: 🦀
description: Update the rust-analyzer version used by the Rust extractor and prepare a pull request.
intent: Keep the Rust extractor on the latest compatible rust-analyzer version with a reviewable, validated pull request.
on:
  workflow_dispatch:
  roles: [admin, maintainer, write]
permissions:
  contents: read
  actions: read
  pull-requests: read
  copilot-requests: write
strict: true
checkout:
  fetch-depth: 0
concurrency:
  group: update-rust-analyzer
  cancel-in-progress: false
timeout-minutes: 180
tools:
  github:
    mode: gh-proxy
    toolsets: [repos, pull_requests, actions]
  bash: ["*"]
  edit: true
network:
  allowed:
    - defaults
    - github
    - github-actions
    - rust
    - bazel
    - python
steps:
  - name: Configure Git
    run: |
      git config user.name "github-actions[bot]"
      git config user.email "41898282+github-actions[bot]@users.noreply.github.com"

  - name: Install cargo-edit
    continue-on-error: true
    run: cargo install cargo-edit --locked

  - name: Run rust-analyzer updater script
    run: |
      mkdir -p /tmp/gh-aw/agent
      set +e
      python3 rust/scripts/update_rust_analyzer.py \
        2>&1 | tee /tmp/gh-aw/agent/rust-analyzer-update.log
      status=${PIPESTATUS[0]}
      set -e

      printf '%s\n' "$status" > /tmp/gh-aw/agent/rust-analyzer-update-status.txt
      if grep -Fxq "No new rust-analyzer version available." \
        /tmp/gh-aw/agent/rust-analyzer-update.log; then
        printf '%s\n' "no-update" > /tmp/gh-aw/agent/rust-analyzer-update-result.txt
      else
        printf '%s\n' "update" > /tmp/gh-aw/agent/rust-analyzer-update-result.txt
      fi
safe-outputs:
  create-pull-request:
    title-prefix: "Rust: "
    branch-prefix: "automation/update-rust-analyzer/"
    draft: true
    protected-files: allowed
    max-patch-size: 10240
    max-patch-files: 1000
    allowed-files:
      - "Cargo.lock"
      - "MODULE.bazel"
      - "MODULE.bazel.lock"
      - "rust-toolchain.toml"
      - "rust/**"
      - "misc/bazel/3rdparty/**"
---

# Update rust-analyzer

## Task

The workflow has already run `rust/scripts/update_rust_analyzer.py`. Read:

- `/tmp/gh-aw/agent/rust-analyzer-update.log` for its complete output.
- `/tmp/gh-aw/agent/rust-analyzer-update-status.txt` for its exit status.
- `/tmp/gh-aw/agent/rust-analyzer-update-result.txt` for the deterministic result classification.

If the result is `no-update`, call `noop` with the reason
`No new rust-analyzer version available.` and stop immediately. Do not inspect
CI, modify files, or create a pull request.

Otherwise, continue the update from the existing working tree and commits:

1. Read `rust/updating-rust-analyzer.md` and all applicable repository
   instructions.
2. Review the updater log, exit status, commits, and working tree. Do not rerun
   the updater script.
3. Complete as much of the documented update as possible. Fix extractor or
   code-generation breakage, keep all `ra_ap_` dependency versions aligned,
   regenerate required files, and add schema upgrade/downgrade scripts, tests,
   and a change note when the schema changed.
4. Run the relevant formatting, linting, code generation, build, and tests,
   including `bazel run //rust:install`. Use `gh` to inspect relevant existing
   CI configuration and prior failures while diagnosing problems.
5. Review the complete diff and commits. Do not include secrets. Do not refer
   to private repositories, internal issues, or internal pull requests in the
   public pull request.
6. Use `create_pull_request` exactly once to create a focused draft pull
   request. Summarize the updater output, changes, and validation. If the
   update cannot be finished, still create a partial draft pull request when
   there are useful changes, and clearly list failures, missing work, and the
   next commands for a maintainer.

The pull request is created after this agent execution, so its newly triggered
CI cannot be awaited in this run. Compensate with the strongest practical
local validation and state this limitation accurately in the pull request.
If the updater did not report `no-update` but no useful patch can be produced,
call `report_incomplete` with the updater failure and exact blocker.

## Safe Outputs

- Use `create_pull_request` for the update or partial update.
- Use `noop` only for the exact no-update result.
- Use `report_incomplete` only when no useful pull request can be created.
