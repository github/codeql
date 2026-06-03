# Agent instructions

This is a CodeQL extractor based on tree-sitter.

## Building
To build the extractor, run `scripts/create-extractor-pack.sh`

## Editing the Swift grammar
The vendored tree-sitter-swift grammar lives at
`extractor/tree-sitter-swift/`. After editing `grammar.js` (or any other
grammar source), run `scripts/regenerate-grammar.sh` to:
- regenerate `extractor/tree-sitter-swift/src/{parser.c, grammar.json,
  node-types.json}` (and the `src/tree_sitter/*.h` headers) via
  `tree-sitter generate`; and
- refresh `extractor/tree-sitter-swift/node-types.yml`, the
  human-readable companion to `src/node-types.json` produced by yeast's
  `node_types_yaml` binary.

`node-types.yml` is the recommended review surface for grammar changes —
it shows the impact of a grammar tweak on the named node kinds, fields,
and child types in a form much easier to read than the raw JSON.

## Extractor Testing
- To run extractor tests, run `cargo test` in the `extractor` directory.

- Do not edit the printed ASTs in `extractor/test/corpus` directly. To regenerate the ASTs, run `scripts/update-corpus.sh`.

## CodeQL Testing
- If you changed the extractor code, always rebuild it before running CodeQL tests.

- To run all CodeQL tests, run `codeql test run --search-path extractor-pack ql/test`

- Do not edit `.expected` files manually. To update the expected output, pass `--learn` to the `codeql test run` command.

- To run a specific test, pass the specific directory to the `codeql test run` command instead of `ql/test`.
