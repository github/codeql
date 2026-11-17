# Swift parser

This directory contains a Swift parser implemented in Rust.

## Implementation and specification

The parser should align with `swift-syntax` for syntactially valid Swift source
code.

Source code with syntax errors is not important, but decent error reporting and
error recovery is done when it doesn't add much complication to the
implementation.

The parser implementation lives in `src/parser`. The code in this directory is
agent generated and should be considered disposable.

The parser implementation is a recursive-descent parser with a classic
lexer/parser split. It has no runtime dependencies or Swift toolchain
requirement.

`src/parser/lexer.rs` scans UTF-8 byte ranges and reports comments separately.
The grammar is split into declarations, statements, expressions, and types.
Nodes are written bottom-up directly to `SyntaxSink`; there is no JSON or
intermediate syntax tree. Expression folding uses temporary operand/operator
stacks, with built-in precedences and source-declared operators. Unknown
operators retain SwiftSyntax's unfurled `sequenceExpr` representation.
An initial token pass registers forward operator declarations and precedence
groups, including associativity and ordering relationships. Type-shaped
lookahead disambiguates generic arguments and closure signatures without
emitting speculative nodes.

The current core covers common declarations, generic and function types,
expressions, closures, control flow, attributes, and conditional compilation.
It is not yet a complete Swift grammar: notably regex literals, multiline
string indentation, advanced attributes/macros, and newer language features
still need work. Unsupported syntax is recovered where possible; excessive
nesting returns `ParseError::NestingLimit`.
Else-if chains are parsed iteratively, so their length does not consume the
recursive nesting budget.

The checked-in sink vocabulary, `src/kinds.rs`, is generated from
`swift_node_types.yml` and the pinned SwiftSyntax keyword definitions:

```sh
# Requires the swift-syntax checkout prepared by swift-syntax-rs.
python3 scripts/generate-syntax-kinds.py
```

`Parser` reuses its token allocation between files. Syntax kinds distinguish
layout nodes, named varying tokens, and anonymous fixed tokens; collection
nodes are elided into ordered sink fields.

## Validation and testing

The parser is tested against Apple's
[swift-syntax](https://github.com/swiftlang/swift-syntax) library serving as a
truth oracle on how to parse Swift.

For the tests we have a collection of test fixtures in `test-fixtures/` and a
corpus of projects defined in `test-corpus.toml`.

```sh
# Runs the parser on the test fixtures (but not the corpus)
cargo test
# Test only a specific fixture
cargo test -- --fixture operators

# Test one project from the corpus
cargo run --features test-runner -- --project KrauseFx/MajorKey

# Test every corpus project, (but not the fixtures).
cargo run --features test-runner -- --corpus-only

# Generate missing JSON and check existing JSON against live swift-syntax.
cargo test -- --check-json

# Prepare/check reference JSON without testing the native parser.
cargo test -- --generate-only --check-json
```

`--fixture` takes an exact path relative to `test-fixtures/`, with or without
the `.swift` extension. Both selectors are repeatable and can be combined.
Corpus projects are only visited with `--project` or `--corpus-only`.
`--corpus-only` selects the whole corpus without fixtures. Unknown selectors and
empty selections fail rather than silently testing nothing.

The runner is a binary in this crate. Its optional dependencies are enabled by
`--features test-runner` for binary runs and automatically by `cargo test`.

### Coverage

Install the coverage tools once for the repository's Rust toolchain:

```sh
cargo install cargo-llvm-cov --locked
rustup component add llvm-tools-preview
```

From this directory, run:

```sh
# Run all test-fixtures and require 100% line, region, and function coverage.
bash scripts/coverage.sh

# Also generate an annotated HTML report.
bash scripts/coverage.sh --html
```

The script instruments the same fixture test target used by `cargo test`,
including the child process that runs the parser. Each run starts with fresh
coverage data and only runs `test-fixtures/`, never the corpus. Coverage includes
the parser library under `src/` (including future lexer and parser modules), but
excludes the test runner, extractor adapters, and dependencies.

Uncovered lines are listed in the terminal. The HTML report is written to
`target/llvm-cov/html/index.html` relative to the repository root. Additional
arguments are forwarded to `cargo llvm-cov report`, not to the fixture runner.
Reports are generated even when fixtures fail; either a test failure or uncovered
code makes the command fail.

These are source coverage checks, not branch coverage or a guarantee of
correctness. Add fixtures for uncovered parser paths rather than unit tests.
