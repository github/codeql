Run Clippy whenever a unit of Rust changes is done.

Don't make changes to the readme.

Never write Rust unit tests. Only rely on test fixtures in `test-fixtures/`.

Feel free use the source code of the `swift-syntax` parser for reference. It is
at `unified/swift-parser/oracle/.build/checkouts/swift-syntax/` (once the
Swift package is installed. Useful directories within it:

- `Sources/SwiftParser/` - parser and lexer implementation.
- `Sources/SwiftSyntax/` - syntax tree types.
- `Sources/SwiftOperators/` - operator folding.
- `Tests/SwiftParserTest/` - parser tests
