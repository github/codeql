# Rust on CodeQL

> [!WARNING]
> Rust support for CodeQL is experimental. No support is offered. QL and database interfaces will change and break without notice or deprecation periods.

## Development

### Dependencies

If you don't have the `semmle-code` repo you may need to install Bazel manually, e.g. from https://github.com/bazelbuild/bazelisk.

### Building the Rust Extractor

This approach uses a released `codeql` version and is simpler to use for QL development. From anywhere under your `semmle-code` or `codeql` directory you can run:
```bash
bazel run @codeql//rust:install
```

You can use shorter versions of the above command:
```bash
bazel run //rust:install  # if under the `codeql` checkout
bazel run rust:install  # if at the root of the `codeql` checkout
bazel run :install  # if at the `rust` directory of the `codeql` checkout
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

If you make changes to either
* `ast-generator/`, or
* `schema/*.py`

you'll need to regenerate code. You can do so running
```sh
bazel run @codeql//rust/codegen
```

Sometimes, especially if resolving conflicts on generated files, you might need to run
```sh
bazel run @codeql//rust/codegen -- --force
```
for code generation to succeed.

### Updating `rust-analyzer`

Here's a rundown of the typical actions to perform to do a rust-analyzer (and other dependencies) update. A one-time setup consists in
installing [`cargo-edit`](https://crates.io/crates/cargo-edit) with `cargo install cargo-edit`. On Ubuntu that also requires
`sudo apt install libssl-dev pkg-config`.

1. from the root of the `codeql` repo checkout, run an upgrade, and commit the changes (skipping `pre-commit` hooks if you have them enabled):
   ```
   cargo upgrade --incompatible --pinned
   ```
2. Look at a diff of the `Cargo.toml` files: if all `ra_ap_` prefixed dependencies have been updated to the same number, go on to the next step.
   Otherwise, it means the latest `rust-analyzer` update has not been fully rolled out to all its crates in `crates.io`.
   _All `ra_ap_` versions must agree!_
   Downgrade by hand to the minimum one you see, and run a `cargo update` after that to fix the `Cargo.lock` file.
3. Commit the changes, skipping `pre-commit` hooks if you have them enabled:
   ```
   git commit -am 'Cargo: upgrade dependencies' --no-verify
   ```
4. Regenerate vendored bazel files, commit the changes:
   ```
   misc/bazel/3rdparty/update_tree_sitter_extractors_deps.sh
   git add .
   git commit -am 'Bazel: regenerate vendored cargo dependencies' --no-verify
   ```
5. Run codegen
   ```
   bazel run //rust/codegen
   ```
   Take note whether `rust/schema/ast.py` was changed. That might need tweaks, new tests and/or downgrade/upgrade scripts down the line
6. Try compiling
   ```
   bazel run //rust:install
   ```
   * if it succeeds: good! You can move on to the next step.
   * if it fails while compiling rust-analyzer dependencies, you need to update the rust toolchain. Sometimes the error will tell you
     so explcitly, but it may happen that the error is more obscure. To update the rust toolchain:
      * you will need to open a PR on the internal repo updating `RUST_VERSION` in `MODULE.bazel`. In general you can have this merged
        independently of the changes in `codeql`.
      * in `codeql`, update both `RUST_VERSION` in `MODULE.bazel` _and_ `rust-toolchain.toml` files. You may want to also update the
        nightly toolchain in `rust/extractor/src/nightly-toolchain/rust-toolchain.toml` to a more recent date while you're at it.
   * if it fails while compiling rust extractor code, you will need to adapt it to the new library version.

   If you had to do any changes, commit them. If you updated the rust toolchain, running `rust/lint.py` might reformat or apply new
   lints to the code.
7. If in step 5 the schema was updated, add upgrade/downgrade scripts and a change note
8. Check with CI if everything is in order.
9. Run DCA. Iterate on the code if needed.
