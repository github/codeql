# swift-syntax-rs

A Rust wrapper around the [swift-syntax](https://github.com/swiftlang/swift-syntax)
package, allowing Swift source code to be parsed from Rust.

Parsing is delegated to a small Swift shim (in [`swift/`](swift/)) that links
against `SwiftSyntax`/`SwiftParser` and exposes a tiny C ABI. This crate provides
safe bindings on top of it.

Bazel builds both halves; there is no `cargo` build (see
[Building & testing](#building--testing)).

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

### Operator folding

Swift's grammar does not encode operator precedence, so the parser represents an
expression like `a + b * c` as a flat `sequenceExpr` (an alternating list of
operands and operators). Before serializing, we fold these sequences into
precedence-correct `infixOperatorExpr` (and `ternaryExpr`) trees — so `1 + 2 * 3`
becomes `1 + (2 * 3)`.

Folding needs to know each operator's precedence group, which comes from
declarations rather than the grammar. We resolve operators from two sources:

- the **Swift standard library** operators (a built-in approximation), and
- operator / precedence-group declarations **in the file being parsed**.

Operators defined anywhere else (for example, imported from another module) are
unknown, so their precedence cannot be determined. Rather than guess — which
would silently produce a wrongly-structured tree — each top-level sequence is
folded independently, and any sequence that uses an unknown operator is left as
a flat `sequenceExpr`. So `a <+> b` (with an undeclared `<+>`) stays flat, while
a neighbouring `1 + 2` in the same file still folds. Supporting operators from
other modules is future work.

Folding is bottom-up, so a *grouped* subexpression still folds even when the
sequence enclosing it uses an unknown operator: in `a *** (b + c)` (with an
unknown `***`) the parenthesised `b + c` is its own sequence and folds, while
the outer `a *** …` stays flat. This only applies when the subexpression is
syntactically isolated (parentheses, call arguments, collection elements, …);
an unparenthesised `a *** b + c` is a single flat sequence whose structure
cannot be determined without knowing `***`'s precedence, so it is left flat in
its entirety.

## Building & testing

Everything is built by Bazel, which downloads a Swift toolchain from swift.org
via the official `rules_swift` standalone toolchain extension (wired up in the
repo-root `MODULE.bazel`) and pulls `swift-syntax` from the Bazel Central
Registry. Nothing has to be installed locally on Linux:

```sh
bazel build //unified/swift-syntax-rs:swift-syntax-parse
bazel test  //unified/swift-syntax-rs:swift_syntax_rs_test
bazel run   //unified/swift-syntax-rs:swift-syntax-parse < some.swift
```

The first build compiles `swift-syntax` and can take several minutes.

`cargo build`/`cargo test` do **not** work: the Swift shim is compiled by a
`swift_library` in [`BUILD.bazel`](BUILD.bazel), so a `cargo` link finds no
`ssr_*` symbols. `cargo check` does work — it does not link — which is all
rust-analyzer needs.

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

Versions are pinned in the root `MODULE.bazel` and nowhere else: the
`swift_version` literal on `swift.toolchain(...)` selects the hermetic swift.org
**Linux** toolchain, and `bazel_dep(name = "swift-syntax", ...)` selects the
`swift-syntax` release. On **macOS** the compiler version is *not* pinned:
`rules_swift` auto-registers the host `xcode_swift_toolchain`, so it follows
whichever Swift ships with the installed Xcode.

## Usage

Library:

```rust
let json = swift_syntax_rs::parse_to_json("let x = 1")?;
println!("{json}");
```

CLI (reads a file argument or stdin, prints the syntax tree as JSON):

```sh
echo 'let x = 1' | bazel run //unified/swift-syntax-rs:swift-syntax-parse
```

## Converting to a yeast AST

The JSON tree is consumed by the CodeQL extractor, which converts it into a
[`yeast::Ast`](../../shared/yeast) — the in-memory format its rewrite rules
operate on. That adapter is a pure-Rust module living in the extractor
(`unified/extractor/src/languages/swift/adapter.rs`); the extractor links this
crate and calls `parse_to_json` in-process.

## Layout

- `swift/` — Swift sources exposing the `ssr_parse_json` / `ssr_string_free` C ABI.
- `BUILD.bazel` — the build (swift_library + rust targets).
- `src/lib.rs` — safe Rust bindings (`parse_to_json`).
- `src/main.rs` — demo CLI.
