---
name: bazel
description: Conventions for editing Bazel files in the github/codeql repository: the shared `misc/bazel` helpers, `codeql_platform_select` and the `{CODEQL_PLATFORM}` packaging placeholder, adding `MODULE.bazel` dependencies, and the `semmle_code` stub that keeps the standalone build working. Use when editing any `BUILD.bazel`, `*.bzl`, `MODULE.bazel` or `.bazelrc` here, and before validating such an edit.
---

# Bazel in the codeql repository

A bzlmod module named `ql`, repo name `@codeql` ([`MODULE.bazel`](../../../MODULE.bazel)). It builds standalone, and is
also consumed by an internal module; standalone builds replace that module with a stub.

## Traps

Things that will waste your time or produce a wrong edit here. Read this section even if you skip the rest.

* **`//...` does not work.** `bazel build //...`, and even `bazel query //...`, fail at the repo root: the patched
  modules under [`misc/bazel/registry`](../../../misc/bazel/registry) are real packages referencing repos that are not
  visible from the main repo, and [`.bazelrc`](../../../.bazelrc) notes separately that transitions break `...` builds.
  The error names a registry directory unrelated to your edit, so it is easy to misdiagnose. **Validate the specific
  target or package you changed**, not a recursive pattern.
* **There is no `MODULE.bazel.lock`, deliberately.** [`.bazelrc`](../../../.bazelrc) sets `--lockfile_mode=off` because
  the workspace-relative module override makes a lockfile unstable. Do not add one, and do not "fix" its absence.
* **`linux_arm64` vs `linux-arm64`.** The keyword argument and config setting use an underscore; the platform *string*
  substituted into paths and zip names uses a hyphen. They are not interchangeable.
* **Do not stub your way out of a missing internal dependency.** See [Building standalone](#building-standalone) for the
  one narrow case where extending the stub is correct.

## Conventions

* **Copy a neighboring target rather than inventing a shape.** Packaging is not uniform: some packages use the
  `codeql_*` wrappers, others still use `pkg_files` directly. Copy the closest *working* neighbor, and prefer the
  wrapper for new code.
* **Pin anything fetched over the network** with `sha256` or `integrity`. Bazel only *warns* on an unpinned download, so
  nothing fails loudly, but the build stops being reproducible and a retagged upstream release silently changes what you
  build. `lfs_archive` is the exception: content is pinned by git object.
* **Format with `bazel run //misc/bazel/buildifier`.** It rewrites in place, so do not hand-tune formatting. Also wired
  as a `pre-commit` hook ([`.pre-commit-config.yaml`](../../../.pre-commit-config.yaml)).

## Where new code goes

Bazel's own macro / rule / repository-rule distinction applies as usual. What is repo-specific:

| Adding | Goes in |
| --- | --- |
| a new packaging shape | extend [`misc/bazel/pkg.bzl`](../../../misc/bazel/pkg.bzl), do not fork `pkg_files` |
| a new OS or arch split | [`misc/bazel/os.bzl`](../../../misc/bazel/os.bzl), do not hand-roll a `select()` over `@platforms//` |
| a fetch of something external | a repository rule ([`lfs.bzl`](../../../misc/bazel/lfs.bzl), [`ripunzip.bzl`](../../../misc/ripunzip/ripunzip.bzl)), not a `genrule` |
| a wrapper used by one language | next to that language ([`swift/rules.bzl`](../../../swift/rules.bzl)) |
| a wrapper used across languages | `misc/bazel/` |

Prefer inline rules in `BUILD.bazel`. A `.bzl` file earns its `load()` only when the shape repeats across packages or a
value must be computed: [`rust.bzl`](../../../misc/bazel/rust.bzl) is worth it because every Rust binary that ships in a
pack must get the same universal-binary wrapper and symbols test, and forgetting either is a release bug. A local
debugging aid opts out and declares a plain `rust_binary`; see `swift-syntax-parse` in
[`unified/swift-syntax-rs/BUILD.bazel`](../../../unified/swift-syntax-rs/BUILD.bazel). The `_gen_binaries` list in
[`go/BUILD.bazel`](../../../go/BUILD.bazel) does not earn a `.bzl`, because it is shared within a single file, where a
local variable does the job.

Macros here are typically a thin public wrapper around a private rule (`codeql_csharp_binary`, `swift_cc_binary`). Keep
the rule narrow and the ergonomics in the macro. Each macro decorates the caller's `name` to mint its helper targets,
for example `internal/<name>` or `single_arch/<name>`. Their visibility is that macro's choice (private, package
default, or the caller's own), so read the macro instead of assuming. When an error names a target you cannot find in
any source file, a macro minted it: grep the suffix under `misc/bazel/`.

## Shared helpers

Frequently-used pieces, so you load the existing one instead of rewriting it. Read the file for its actual exports.

| `load()` path | Covers |
| --- | --- |
| `//misc/bazel:pkg.bzl` | CodeQL packs and packaging |
| `//misc/bazel:os.bzl` | platform and architecture selection |
| `//misc/bazel:lfs.bzl` | on-demand git-LFS repositories |
| `//misc/bazel:rust.bzl` | Rust binary wrapper |
| `//misc/bazel:csharp.bzl` | C# binary/library/test wrappers |
| `//misc/bazel:utils.bzl` | `select_os`; prefer `os.bzl`'s `os_select` in new code |

[`defs.bzl`](../../../defs.bzl) at the root exports `codeql_platform` for *dependent* modules. It is not the way to get
the platform string here; use `os.bzl`.

## Platform selection

[`codeql_platform_select`](../../../misc/bazel/os.bzl) takes one keyword argument per CodeQL platform: `linux64`,
`linux_arm64`, `osx64` and `win64`. `otherwise` supplies the value for whichever of those you leave unset; it is **not**
a `//conditions:default`. **There is deliberately no fallback from `linux_arm64` to `linux64`.** If you only care about
the OS, use `os_select`, which gives Linux the same value on both architectures and has a `posix` shorthand for the
shared Linux/macOS value.

In a macro (no `ctx`) it returns a `select()`:

```python
load("//misc/bazel:os.bzl", "codeql_platform_select")
load("//misc/bazel:pkg.bzl", "codeql_pkg_files")

codeql_pkg_files(
    name = "extractor-arch",
    exes = codeql_platform_select(
        otherwise = ["//unified/extractor"],
        win64 = ["//unified/extractor-unsupported-os:extractor"],
    ),
    prefix = "tools/{CODEQL_PLATFORM}",
)
```

If implementation code needs to *branch* on the value rather than pass it through, pass `ctx` and add
`OS_DETECTION_ATTRS` to the rule's attributes. The value is then resolved eagerly instead of being an opaque `select()`:

```python
load("//misc/bazel:os.bzl", "OS_DETECTION_ATTRS", "os_select")

def _impl(ctx):
    ext = os_select(ctx, windows = ".exe", posix = "")
    ...

my_rule = rule(
    implementation = _impl,
    attrs = {"src": attr.label()} | OS_DETECTION_ATTRS,
)
```

## Packs

`codeql_pack` assembles the files that become an extractor pack. See [`unified/BUILD.bazel`](../../../unified/BUILD.bazel)
for a minimal complete example and [`pkg.bzl`](../../../misc/bazel/pkg.bzl) for the arguments. The non-obvious parts:

* **`{CODEQL_PLATFORM}` in a destination path is the routing mechanism**, not just a substitution. A path containing it
  is *arch-specific* and lands in the per-architecture zip; every other path is *common*. So `prefix =
  "tools/{CODEQL_PLATFORM}"` both places the file and marks it arch-specific. `arch_overrides` forces named
  destinations into the arch-specific part without a placeholder.
* **`codeql_pkg_files` splits `srcs` (plain) from `exes` (mode 755)** and **rejects `attributes =`** with an explicit
  error. Use `exes` rather than hand-rolling `pkg_attributes(mode = "755")`.
* **`pkg_dirs` and `pkg_symlinks` are unsupported** and fail at analysis time.
* `codeql_pack` also generates an installer and an `install` alias, hence `bazel run //unified:install`. Pass
  `installer_alias = None` if one package defines several packs.
* `codeql_pack_group` exists for bundling packs into distribution zips, but nothing in this repo instantiates it.

## Adding a dependency

In order of preference:

1. **A [Bazel Central Registry](https://registry.bazel.build/) module.** Add a `bazel_dep` in
   [`MODULE.bazel`](../../../MODULE.bazel).
2. **A patched upstream module.** Add it under [`misc/bazel/registry`](../../../misc/bazel/registry), which `.bazelrc`
   puts ahead of the BCR. Put patches in `modules/<repo>/<version>/patches`, rename the version with a `-codeql.N`
   suffix, and run [`fix.py`](../../../misc/bazel/registry/fix.py) to realign the metadata.
3. **A raw archive.** Use `http_archive` via `use_repo_rule`, or a repository rule. Copy an adjacent declaration and
   keep its checksum field populated.

Vendored Rust crates under [`misc/bazel/3rdparty`](../../../misc/bazel/3rdparty) are generated. Regenerate with
[`update_cargo_deps.sh`](../../../misc/bazel/3rdparty/update_cargo_deps.sh) rather than editing, and keep the
`use_repo` lists in sync, which `bazel mod tidy` does for module extensions.

## Building standalone

[`MODULE.bazel`](../../../MODULE.bazel) declares `semmle_code` with a `local_path_override` pointing at `..`, which
resolves when this repo is checked out inside the internal module. [`.bazelrc`](../../../.bazelrc), which Bazel reads
when invoked in *this* workspace, overrides that with a stub. This line is the whole reason a standalone build resolves:

```
common --override_module=semmle_code=%workspace%/misc/bazel/semmle_code_stub
```

Do not change either the override path or the `local_path_override`; they work as a pair.

[`misc/bazel/semmle_code_stub`](../../../misc/bazel/semmle_code_stub) is an otherwise empty module supplying no-op
versions of the internal helpers that shared `.bzl` files load *unconditionally*. That is its only job, and it is small
enough to read.

**Extend the stub only when a `.bzl` file every standalone target loads gains a new internal `load()`**, which breaks
package loading outright, for everyone. Prefer not needing one. **Never add a stub so that an internal-only target
appears to build**: some targets depend on internal libraries (`grep -rl @semmle_code --include=*.bazel` finds them) and
are correctly unbuildable here. Unlike a `load()`, such a dependency only fails when that target is actually requested.

[`.bazelrc.internal`](../../../.bazelrc.internal) is **not** read here; it carries settings for the internal build. A
setting needed by both has to be written in both files, with paths differing because this repo sits at a different depth
there.
