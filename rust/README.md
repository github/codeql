# Rust on CodeQL

> [!WARNING]
> Rust support for CodeQL is experimental. No support is offered. QL and database interfaces will change and break without notice or deprecation periods.

## Development

### Dependencies

If you don't have the `semmle-code` repo you may need to install Bazel manually, e.g. from https://github.com/bazelbuild/bazelisk.

### Building the Rust Extractor

This approach uses a released `codeql` version and is simpler to use for QL development. From your `semmle-code` directory run:
```bash
bazel run @codeql//rust:install
```
You now need to create a [per-user CodeQL configuration file](https://docs.github.com/en/code-security/codeql-cli/using-the-advanced-functionality-of-the-codeql-cli/specifying-command-options-in-a-codeql-configuration-file#using-a-codeql-configuration-file) and specify the option:
```
--search-path PATH/TO/semmle-code/ql
```
(wherever the `codeql` checkout is on your system)

You can now use the Rust extractor e.g. to run Rust tests from the command line or in VSCode.

### Building the Rust Extractor (as a sembuild target)

This approach allows you to build a Rust extractor with a CLI built from source. From your `semmle-code` directory run:
```bash
./build target/intree/codeql-rust
```
You can now invoke it directly, for example to run some tests:
```bash
./target/intree/codeql-rust/codeql test run ql/rust/ql/test/PATH/TO/TEST/
```

### Building a Database

TODO

### Code Generation

TODO
