# Bazel Clippy

The `Bazel Clippy` PR workflow lints affected members of the root Cargo workspace
that have Bazel Rust targets. It uses stable Rust 1.100.0, independently of the
default nightly release toolchain. Workspace lint levels and priorities come
from `Cargo.toml`; Clippy also reads the root `clippy.toml`. Warnings are errors.

Run the same selection and checks locally from the repository root:

```sh
python3 misc/bazel/clippy.py --base origin/main
python3 misc/bazel/clippy.py --lint extractor
python3 misc/bazel/clippy.py --lint other
```

The workflow can also be dispatched manually with an explicit base revision.
PR runs always use the PR's actual base, regardless of manual-run inputs.

Selection uses the PR's merge-base diff, not just its most recent commit, and
Bazel's dependency graph, including native and generated inputs. Changes within
a package invalidate that package and its reverse dependencies. Root toolchain,
dependency and lint configuration, and shared Bazel infrastructure changes
invalidate all covered targets. The underlying Rust binaries are selected, not
their universal-binary wrappers. All declared Rust/test targets are passed to
the aspect explicitly, since the Clippy aspect does not traverse dependencies.
Only targets declared by Bazel are linted: Cargo-only targets, configurations
and crates (currently the three crates under `ql/`) are not included.

CI restores a download/action disk cache, keyed by Bazel/dependency configuration
with revision-specific entries. A successful job saves the updated cache.
Stable compilation cannot reuse nightly compiler artifacts. The separate Rust
extractor step makes its cost visible, but on a cold runner it also pays the
initial stable toolchain and shared-dependency compilation cost. Native Swift
dependencies are still built for the unified extractor.
