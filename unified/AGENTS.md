# Agent instructions

This is a CodeQL extractor that maps a language's parse tree onto a shared AST
using the `yeast` desugaring engine. Swift, the only language so far, is parsed
by Apple's swift-syntax rather than by tree-sitter.

Build and test with Bazel, whose Swift toolchain is hermetic on Linux, so
nothing needs to be installed locally. The extractor links `swift-syntax`, so a
`cargo` build additionally needs a local Swift toolchain.

## Building
- To build the extractor pack, run `scripts/create-extractor-pack.sh`.

## Swift Parser
- Swift source is parsed by the `swift-syntax-rs` crate, which wraps Apple's
  swift-syntax and emits the parse tree as JSON. The extractor links it and
  calls it in-process. There is no grammar in this repository to edit.

- `extractor/src/languages/swift/adapter.rs` converts that JSON into a yeast AST.

- The raw parse tree's shape is described by `extractor/swift_node_types.yml`,
  which is maintained by hand.

## AST Mapping
- The target AST shape is described by `extractor/ast_types.yml`.

- The mapping from the parse tree to the target AST is found in `extractor/src/languages/swift/swift.rs`

- To run tests for the parser and mapping, run `bazel test //unified/extractor:all_tests`.

- Extractor test cases are located at `extractor/tests/corpus/swift/*/*.swift`.

- Each test case has a corresponding `.output` file containing its generated output along with a copy of the test case itself.

- Check the output files for correctness but do not edit them manually. Regenerate them with `scripts/update-corpus.sh`.

## CodeQL Testing
- If you changed the extractor code, always rebuild it before running CodeQL tests.

- To run all CodeQL tests, run `codeql test run --search-path extractor-pack ql/test`

- Do not edit `.expected` files manually. To update the expected output, pass `--learn` to the `codeql test run` command.

- To run a specific test, pass the specific directory to the `codeql test run` command instead of `ql/test`.
