# Go analysis support for CodeQL

This sub-folder contains the extractor, CodeQL libraries, and queries that power Go
support for CodeQL.

It contains two major components:
  - an extractor, itself written in Go, that parses Go source code and converts it into a database
    that can be queried using CodeQL.
  - static analysis libraries and queries written in [CodeQL](https://codeql.github.com/docs/) that can be
    used to analyze such a database to find coding mistakes or security vulnerabilities.

## Usage

To analyze a Go codebase, either use the [CodeQL command-line
interface](https://codeql.github.com/docs/codeql-cli/) to create a database yourself, or
download a pre-built database from [GitHub.com](https://codeql.github.com/docs/codeql-cli/creating-codeql-databases/#downloading-databases-from-github-com). You can then run any of the
queries contained in this repository either on the command line or using the VS Code extension.

## Contributions

Contributions are welcome! Please see our [contribution guidelines](CONTRIBUTING.md) and our
[code of conduct](CODE_OF_CONDUCT.md) for details on how to participate in our community.

## Licensing

The code in this repository is licensed under the [MIT license](LICENSE).

## Resources

- [Writing CodeQL queries](https://codeql.github.com/docs/writing-codeql-queries/codeql-queries/)
- [Learning CodeQL](https://codeql.github.com/docs/writing-codeql-queries/ql-tutorials/)
