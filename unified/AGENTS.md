# Agent instructions

This is a CodeQL extractor that maps a language's parse tree onto a shared AST
using the `yeast` desugaring engine. Swift, the only language so far, is parsed
by the native Rust `swift-parser` crate.

## Building
- To build the extractor, run `scripts/create-extractor-pack.sh`

## Swift Parser
- The `swift-parser` crate exposes a generic `SyntaxSink` API.
  `extractor/src/languages/swift/parse.rs` builds a `yeast::Ast` directly from
  parser callbacks, without JSON or an intermediate syntax tree. The grammar
  lives in `swift-parser/src/parser`.
- Build with `cargo build -p codeql-extractor-unified` from the repository root.
  Cargo and Bazel always use the native parser; neither needs a Swift toolchain.
- Fixtures and corpus projects compare the native syntax tree and trivia with
  Apple's SwiftSyntax. The optional oracle is a pure Swift executable under
  `swift-parser/oracle`, built lazily by the test runner when reference JSON
  must be generated or checked. Its JSON adapter lives only in
  `swift-parser/test-runner/reference_adapter.rs`.

- The raw parse tree's shape is described by `extractor/swift_node_types.yml`,
  which is generated from swift-syntax by `swift-parser/oracle/schemagen`. Do not
  edit it by hand; regenerate it with `scripts/regenerate-node-types.sh` after
  changing the pinned swift-syntax version, then review the diff alongside the
  mapping in `extractor/src/languages/swift/swift.rs`.

## AST Mapping
- The target AST shape is described by `extractor/ast_types.yml`.

- The mapping from the parse tree to the target AST is found in `extractor/src/languages/swift/swift.rs`

- To run tests for the parser and mapping, run `cargo test` in the `extractor`
  directory. These tests do not require Swift. The tests can also be run under
  Bazel via `bazel test //unified/extractor:all_tests`.

- Extractor test cases are located at `extractor/tests/corpus/swift/*/*.swift`.

- Each test case has a corresponding `.output` file containing its generated output along with a copy of the test case itself.

- Check the output files for correctness but do not edit them manually. Regenerate them with `scripts/update-corpus.sh`.

## CodeQL Testing
- If you changed the extractor code, always rebuild it before running CodeQL tests.

- To run all CodeQL tests, run `codeql test run --search-path extractor-pack ql/test`

- Do not edit `.expected` files manually. To update the expected output, pass `--learn` to the `codeql test run` command.

- To run a specific test, pass the specific directory to the `codeql test run` command instead of `ql/test`.
