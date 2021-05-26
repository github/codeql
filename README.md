# QL analysis support for CodeQL

Under development.

## Building the tools from source

[Install Rust](https://www.rust-lang.org/tools/install), then run:

```bash
cargo build --release
```

## Generating the database schema and QL library

The generated `ql/src/ql.dbscheme` and `ql/src/codeql_ql/ast/internal/TreeSitter.qll` files are included in the repository, but they can be re-generated as follows:

```bash
./create-extractor-pack.sh
```

## Building a CodeQL database for a QL program

First, get an extractor pack:

Run `./create-extractor-pack.sh` (Linux/Mac) or `.\create-extractor-pack.ps1` (Windows PowerShell) and the pack will be created in the `extractor-pack` directory.

Then run

```bash
codeql database create <database-path> -l ql -s <project-source-path> --search-path <extractor-pack-path>
```

## Running qltests

Run

```bash
codeql test run <test-path> --search-path <repository-root-path>
```
