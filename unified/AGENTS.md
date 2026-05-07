# Agent instructions

This is a CodeQL extractor based on tree-sitter.

## Building
To build the extractor, run `scripts/create-extractor-pack.sh`

## Extractor Testing
- To run extractor tests, run `cargo test` in the `extractor` directory.

- Do not edit the printed ASTs in `extractor/test/corpus` directly. To regenerate the ASTs, run tests with the environment variable `YEAST_UPDATE_CORPUS=1`.

## CodeQL Testing
- If you changed the extractor code, always rebuild it before running CodeQL tests.

- To run all CodeQL tests, run `codeql test run --search-path extractor-pack ql/test`

- Do not edit `.expected` files manually. To update the expected output, pass `--learn` to the `codeql test run` command.

- To run a specific test, pass the specific directory to the `codeql test run` command instead of `ql/test`.
