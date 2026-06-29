# Agent instructions

This is a CodeQL extractor based on tree-sitter.

## Building
- To build the extractor, run `scripts/create-extractor-pack.sh`

## Swift Parser
- The Swift parser is defined by `extractor/tree-sitter-swift/grammar.js` and can be edited if needed.

- After editing the grammar, always run `scripts/regenerate-grammar.sh`.

- The raw parse tree is described by `extractor/tree-sitter-swift/node-types.yml` and should be reviewed after grammar changes.

## AST Mapping
- The target AST shape is described by `extractor/ast_types.yml`.

- The mapping from the parse tree to the target AST is found in `extractor/src/languages/swift/swift.rs`

- To run tests for the parser and mapping, run `cargo test` in the `extractor` directory.

- Do not edit the printed ASTs in `extractor/test/corpus` directly. To regenerate the ASTs, run `scripts/update-corpus.sh`.

## CodeQL Testing
- If you changed the extractor code, always rebuild it before running CodeQL tests.

- To run all CodeQL tests, run `codeql test run --search-path extractor-pack ql/test`

- Do not edit `.expected` files manually. To update the expected output, pass `--learn` to the `codeql test run` command.

- To run a specific test, pass the specific directory to the `codeql test run` command instead of `ql/test`.
