# Rust linting in CI

The Cargo Clippy workflow covers the root Cargo workspace with the stable
toolchain in `rust-toolchain.toml`. Separate workspaces (including the old Python
extractor and Rust QL test fixtures) are not linted.

The selection job compares the pull request's merge commit with its base parent.
It assigns changed files, including deleted files and both sides of renames, to
the deepest matching workspace member. All files in a package count, not just
Rust source: build scripts, templates and native parser sources can affect Rust
compilation. The Python parser sources outside `yeast-python` are mapped
explicitly in `misc/scripts/cargo-clippy/select_packages.py`.
The Bazel module and setup files also affect `ast-generator`, whose injected
rust-analyzer sources are obtained through Bazel.

Selection follows reverse first-party path dependencies transitively, including
build, development and target-specific dependencies. Changing workspace
configuration, the lockfile, toolchain, Clippy configuration or the selection
implementation selects every member. Unrelated changes skip the lint job.
If another build script starts reading files outside its package, add those
inputs to the selector and its tests.

Selected packages are passed together to
`cargo clippy --locked --all-targets --no-deps --package ... -- -D warnings`.
Clippy checks complete affected packages, not individual changed lines.
Dependencies still need compilation, but unrelated workspace packages are not
linted. Cargo's registry, git dependencies and target directory are cached by
platform, toolchain and lockfile, with a new entry per revision. Cargo fingerprints
invalidate changed inputs. Superseded runs on the same PR are cancelled.
Only selection containing `ast-generator` runs its Bazel source-injection step.
Clippy sets `SWIFT_SYNTAX_RS_CHECK_ONLY=1` to avoid building the native Swift shim:
it checks the Rust wrapper and build script but does not link native code.
Normal builds and tests still build and link Swift.

Run the selector tests with:

```sh
python3 -m unittest discover -s misc/scripts/cargo-clippy
```
