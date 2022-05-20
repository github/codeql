# QL for QL

QL for QL is a CodeQL analysis designed to find common bug patterns in QL code.  
This analysis is mostly used as a PR check in [`github/codeql`](https://github.com/github/codeql).   
QL for QL is experimental technology and not a supported product. 

This directory contains the extractor, CodeQL libraries, and queries that power QL for QL.

Some setup is required to use QL for QL (see the below sections). 

## Building the tools from source

[Install Rust](https://www.rust-lang.org/tools/install) (if using VSCode, you may also want the `rust-analyzer` extension), then run:

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

CodeQL can be configured to remember the extractor by setting the config file `~/.config/codeql/config` to: 
```bash
--search-path /full/path/to/extractor-pack
```

## Running qltests

Run

```bash
codeql test run <test-path> --search-path <repository-root-path>
```
