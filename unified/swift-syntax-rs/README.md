# swift-syntax-rs

A Rust wrapper around the [swift-syntax](https://github.com/swiftlang/swift-syntax)
package, allowing Swift source code to be parsed from Rust.

Parsing is delegated to a small Swift shim (in [`swift/`](swift/)) that links
against `SwiftSyntax`/`SwiftParser` and exposes a tiny C ABI. The Rust crate
builds that shim (via `build.rs`) and provides safe bindings on top of it.

## Output format

The emitted JSON tree preserves the AST's named structure. Every node has a
`kind` and a `range` with `start`/`end` positions (UTF-8 `offset` plus 1-based
`line`/`column`). Beyond that:

- **Tokens** carry `text`, `tokenKind`, and — only when non-empty —
  `leadingTrivia`/`trailingTrivia` arrays of `{ kind, text }` pieces.
- **Layout nodes** (e.g. `functionDecl`) embed their children directly as
  members keyed by the child's name in the parent (`name`, `signature`,
  `body`, …), alongside `kind`/`range`. Absent optional children are omitted.
- **Collection nodes** (e.g. `codeBlockItemList`) are elided: a list-valued
  field is simply a JSON array of its elements (e.g. `parameters`, `statements`).
  This drops the collection node's own `kind`/`range`.

Only meaningful trivia is kept — the four comment kinds (`lineComment`,
`blockComment`, `docLineComment`, `docBlockComment`) and `unexpectedText`
(source the parser skipped). Whitespace trivia is dropped, since node ranges
already encode positions.

### Example

Parsing `let x = 1 // c` produces the following (each `range` object is
abbreviated here as `…`):

```jsonc
{
  "kind": "sourceFile",
  "range": …,
  "statements": [                       // collection node elided to an array
    {
      "kind": "codeBlockItem",
      "range": …,
      "item": {
        "kind": "variableDecl",
        "range": …,
        "attributes": [],               // empty collection → empty array
        "modifiers": [],
        "bindingSpecifier": {           // a token
          "kind": "token",
          "text": "let",
          "tokenKind": "keyword(SwiftSyntax.Keyword.let)",
          "range": …
        },
        "bindings": [
          {
            "kind": "patternBinding",
            "range": …,
            "pattern": {
              "kind": "identifierPattern",
              "range": …,
              "identifier": { "kind": "token", "text": "x", "tokenKind": "identifier(\"x\")", "range": … }
            },
            "initializer": {
              "kind": "initializerClause",
              "range": …,
              "equal": { "kind": "token", "text": "=", "tokenKind": "equal", "range": … },
              "value": {
                "kind": "integerLiteralExpr",
                "range": …,
                "literal": {
                  "kind": "token",
                  "text": "1",
                  "tokenKind": "integerLiteral(\"1\")",
                  "range": …,
                  "trailingTrivia": [ { "kind": "lineComment", "text": "// c" } ]
                }
              }
            }
          }
        ]
      }
    }
  ],
  "endOfFileToken": { "kind": "token", "text": "", "tokenKind": "endOfFile", "range": … }
}
```

Note how `statements`, `bindings`, `attributes`, and `modifiers` are plain
arrays (their collection nodes are elided), layout children such as
`bindingSpecifier` and `initializer` are embedded by name, and the `// c`
comment rides along as `trailingTrivia` on the token it follows. Tokens without
trivia (most of them) simply omit the `leadingTrivia`/`trailingTrivia` keys.

## Prerequisites

The build does not depend on any particular version manager. You need:

- **Rust** — pinned to `1.88` by the repo-root [`rust-toolchain.toml`](../../rust-toolchain.toml),
  which `rustup` picks up automatically.
- **Swift** — pinned to the version in [`.swift-version`](.swift-version)
  (currently `6.3.2`), used to build `swift-syntax` `603.0.2`. Install it any way
  you like — [swift.org](https://www.swift.org/install/) or
  [swiftly](https://www.swift.org/swiftly/) (which reads `.swift-version`), or a
  system package. Just make sure `swift` is on your `PATH` (or point `build.rs`
  at it with the `SWIFT` environment variable).

On Debian/Ubuntu the Swift runtime also needs `libncurses6` (and related libs)
available on the system.

## Building & testing

With `cargo` and `swift` on `PATH`:

```sh
cargo build
cargo test
```

If your `swift`/`swiftc` are not on `PATH`, point the build at them explicitly:

```sh
SWIFT=/path/to/swift SWIFTC=/path/to/swiftc cargo build
```

The first build compiles `swift-syntax` and can take several minutes.

## Building with Bazel (CI)

CI builds this crate hermetically with Bazel. A Swift toolchain is downloaded
from swift.org by the official `rules_swift` standalone toolchain extension
(wired up in the repo-root `MODULE.bazel`), `swift-syntax` is pulled from the
Bazel Central Registry, and the FFI shim is compiled as a `swift_library` that
the Rust targets link against. `build.rs` is not used under Bazel; it only
builds the Swift shim for the local `cargo` workflow.

```sh
bazel build //unified/swift-syntax-rs:swift-syntax-parse
bazel test  //unified/swift-syntax-rs:swift_syntax_rs_test
bazel run   //unified/swift-syntax-rs:swift-syntax-parse < some.swift
```

Requirements:

- **`clang`** must be installed on the runner. `rules_swift` requires the Bazel
  CC toolchain to use clang; the repo's `.bazelrc` already sets
  `--repo_env=CC=clang`, so no extra flags are needed.
- The registered Swift toolchains cover **ubuntu24.04 / x86_64** and
  **macOS / `xcode`** (Apple Silicon and Intel). Bazel selects the toolchain
  matching the host. Targets are marked `target_compatible_with` these two
  OSes, so on Windows Bazel skips them cleanly.
- **macOS only:** the Swift toolchain comes from the host Xcode installation
  (`rules_swift` auto-registers `xcode_swift_toolchain`), which also needs
  Xcode's CC toolchain and xcode_config; these are applied to the Swift
  target via an incoming-edge Starlark transition (see
  [`xcode_transition.bzl`](xcode_transition.bzl)), so other targets on macOS
  keep using Bazel's default CC toolchain.

The Swift compiler version is kept in sync across three places: the
[`.swift-version`](.swift-version) file (read by the local `cargo`/`swift build`
and by [swiftly](https://www.swift.org/swiftly/)), the literal `swift_version`
pinned on `swift.toolchain(...)` in the root `MODULE.bazel` (the hermetic
swift.org **Linux** Bazel toolchain), and the `swift-syntax` release in
`swift/Package.swift`. On **macOS** the version is *not* pinned by the Bazel
build: `rules_swift` auto-registers the host `xcode_swift_toolchain`, which uses
whichever Swift ships with the installed Xcode. So the pin governs Linux (and
local) builds, while the macOS compiler version depends on the host Xcode.

(The Bazel toolchain pins a literal rather than reading `.swift-version` via
`swift_version_file`, because the latter makes the module extension read a
`//unified/...` label, which fails when this repo is consumed as a dependency
module.)

## Usage

Library:

```rust
let json = swift_syntax_rs::parse_to_json("let x = 1")?;
println!("{json}");
```

CLI (reads a file argument or stdin, prints the syntax tree as JSON):

```sh
echo 'let x = 1' | cargo run --bin swift-syntax-parse
```

## Converting to a yeast AST

The JSON tree is consumed by the CodeQL extractor, which converts it into a
[`yeast::Ast`](../../shared/yeast) — the in-memory format its rewrite rules
operate on. That adapter is a pure-Rust module living in the extractor
(`unified/extractor/src/languages/swift/adapter.rs`), so the extractor never
needs the Swift toolchain: it consumes the JSON produced out-of-process by this
crate's `parse_to_json` / the `swift-syntax-parse` binary.

## Layout

- `swift/` — Swift package exposing the `ssr_parse_json` / `ssr_string_free` C ABI.
- `build.rs` — builds the Swift package and emits link/rpath flags (local `cargo` only).
- `BUILD.bazel` — Bazel targets for the hermetic CI build (swift_library + rust targets).
- `src/lib.rs` — safe Rust bindings (`parse_to_json`).
- `src/main.rs` — demo CLI.
