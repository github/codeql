# Go analysis support for CodeQL

This open-source repository contains the extractor, CodeQL libraries, and queries that power Go
support in [LGTM](https://lgtm.com) and the other CodeQL products that [GitHub](https://github.com)
makes available to its customers worldwide.

It contains two major components:
  - an extractor, itself written in Go, that parses Go source code and converts it into a database
    that can be queried using CodeQL.
  - static analysis libraries and queries written in [CodeQL](https://codeql.github.com/docs/) that can be
    used to analyze such a database to find coding mistakes or security vulnerabilities.

The goal of this project is to provide comprehensive static analysis support for Go in CodeQL.

For the queries and libraries that power CodeQL support for other languages, visit [the CodeQL
repository](https://github.com/github/codeql).

## Installation

Clone this repository.

Run `scripts/install-deps.sh`. This will ensure that the necessary external CodeQL packs are
downloaded to your machine. You will need to re-run this script whenever you pull new commits from
the repo.

If you want to use the CodeQL extension for Visual Studio Code, import this repository into your VS
Code workspace.

## Usage

To analyze a Go codebase, either use the [CodeQL command-line
interface](https://codeql.github.com/docs/codeql-cli/) to create a database yourself, or
download a pre-built database from [LGTM.com](https://lgtm.com/). You can then run any of the
queries contained in this repository either on the command line or using the VS Code extension.

Note that the [lgtm.com](https://github.com/github/codeql-go/tree/lgtm.com) branch of this
repository corresponds to the version of the queries that is currently deployed on LGTM.com.
The [main](https://github.com/github/codeql-go/tree/main) branch may contain changes that
have not been deployed yet, so you may need to upgrade databases downloaded from LGTM.com before
running queries on them.

## Contributions

Contributions are welcome! Please see our [contribution guidelines](CONTRIBUTING.md) and our
[code of conduct](CODE_OF_CONDUCT.md) for details on how to participate in our community.

## Licensing

The code in this repository is licensed under the [MIT license](LICENSE).

## Resources

- [Writing CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/codeql-queries/)
- [Learning CodeQL](https://codeql.github.com/docs/writing-codeql-queries/ql-tutorials/)
