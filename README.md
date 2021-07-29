# Ruby analysis support for CodeQL

Under development.

## Building the tools from source

[Install Rust](https://www.rust-lang.org/tools/install), then run:

```bash
cargo build --release
```

## Generating the database schema and QL library

The generated `ql/src/ruby.dbscheme` and `ql/src/codeql_ruby/ast/internal/TreeSitter.qll` files are included in the repository, but they can be re-generated as follows:

```bash
# Run the generator
cargo run --release -p ruby-generator -- --dbscheme ql/src/ruby.dbscheme --library ql/src/codeql_ruby/ast/internal/TreeSitter.qll
# Then auto-format the QL library
codeql query format -i ql/src/codeql_ruby/ast/internal/TreeSitter.qll
```

## Building a CodeQL database for a Ruby program

First, get an extractor pack. There are two options:

1. Either download the latest `codeql-ruby-pack` from Actions and unzip it twice, or
2. Run `./create-extractor-pack.sh` (Linux/Mac) or `.\create-extractor-pack.ps1` (Windows PowerShell) and the pack will be created in the `extractor-pack` directory.

Then run

```bash
codeql database create <database-path> -l ruby -s <project-source-path> --search-path <extractor-pack-path>
```

## Running qltests

Run

```bash
codeql test run <test-path> --search-path <repository-root-path>
```
