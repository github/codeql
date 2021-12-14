# QL analysis support for CodeQL

- *Part of the May 2021 [code scanning hackathon](https://github.com/github/code-scanning-hackathon/issues/3).*
- *Part of the October 2021 [code scanning hackathon](https://github.com/github/code-scanning-hackathon/issues/61).*

Under development.

## Viewing the alerts from github/codeql and github/codeql-go

**TLDR: View https://github.com/github/codeql-ql/security/code-scanning?query=branch%3Anightly-changes-alerts periodically.**

The [`nightly-changes-alerts` branch](https://github.com/github/codeql-ql/tree/nightly-changes-alerts) contains nightly snapshots of QL related code from [github/codeql](https://github.com/github/codeql) and [github/codeql-go](https://github.com/github/codeql-go). The corresponding [code-scanning alerts](https://github.com/github/codeql-ql/security/code-scanning?query=branch%3Anightly-changes-alerts) are from the [default query suite](https://github.com/github/codeql-ql/blob/main/ql/src/codeql-suites/ql-code-scanning.qls).

The branch and alerts are updated every night by the [`nightly-changes.yml` workflow](https://github.com/github/codeql-ql/actions/workflows/nightly-changes.yml).

Ideally, the scans would happen automatically as part of the PRs. That requires more coordination, and is tracked here: https://github.com/github/codeql-coreql-team/issues/1669.

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

## Running qltests

Run

```bash
codeql test run <test-path> --search-path <repository-root-path>
```

## GitHub Actions

In addition to the above nightly scans of the known CodeQL repositories, the following Actions are of particular interest:

- [`bleeding-codeql-analysis.yml`](https://github.com/github/codeql-ql/actions/workflows/bleeding-codeql-analysis.yml)
  - runs on all PRs, displays how alerts for the known CodeQL repositories change as consequence of the PR
  - the code from the known CodeQL repositories should be updated occasionally by running [`repo-tests/import-repositories.sh`](https://github.com/github/codeql-ql/blob/main/repo-tests/import-repositories.sh) locally, and creating a PR.
  - produces an artifact built `ql` database in
- [`build.yml`](https://github.com/github/codeql-ql/actions/workflows/build.yml)
  - produces an artifact with the `ql` extractor and the `ql` query pack in

