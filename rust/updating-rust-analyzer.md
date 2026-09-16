# Updating rust-analyzer

Here's a rundown of the typical actions to perform to do a rust-analyzer (and other dependencies) update. A one-time setup consists in
installing [`cargo-edit`](https://crates.io/crates/cargo-edit) with `cargo install cargo-edit`. On Ubuntu that also requires
`sudo apt install libssl-dev pkg-config`.

> [!TIP]
> All steps up to and including running `bazel run //rust:install` are (barring
> any errors) caried out by the script `./scripts/update_rust_analyzer.py`.
> Prefer using the script.

1. Update dependencies.
   1. From the root of the `codeql` repo checkout, run a Cargo upgrade:
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

2. Update the fixed Rust toolchain used by the extractor.

   The version should be updated to the latest release that precedes the new
   rust-analyzer version.

   Grepping for `FIXED_RUST_TOOLCHAIN` shows the places where this version is
   written down.

   Commit the changes: `git commit -am 'Rust: Update fixed toolchain'`

3. Regenerate vendored bazel files (these allow faster builds, particularly on
   CI where it has to start from scratch each time), commit the changes:
   ```
   misc/bazel/3rdparty/update_tree_sitter_extractors_deps.sh
   git add .
   git commit -am 'Bazel: regenerate vendored cargo dependencies' --no-verify
   ```
   > [!NOTE]
   > If in step 5 you also bump `rules_rust` or the Rust toolchain used for building the extractor, those changes invalidate _all_ vendored files (including the
   > Python ones under `misc/bazel/3rdparty/py_deps`), not just the tree-sitter ones. In that case run the umbrella script
   > `misc/bazel/3rdparty/update_cargo_deps.sh` instead (it regenerates both `py_deps` and `tree_sitter_extractors_deps`, and runs
   > `bazel mod tidy`), then commit all the regenerated files.

4. Run codegen
   ```
   bazel run //rust/codegen
   ```
   If codegen fails other changes might be neccessary. For instance, adaptions
   to `annotations.py`. Make these changes in separate commits.

   Once codegen succeeds commit only the changes made by codegen with
   ```
   git commit -am 'Rust: Run codegen'
   ```

   Take note whether `rust/schema/ast.py` was changed. That might need tweaks,
   new tests and/or downgrade/upgrade scripts down the line.


5. Try compiling
   ```
   bazel run //rust:install
   ```
   * if it succeeds: good! You can move on to the next step.
   * if it fails while compiling rust-analyzer dependencies, you need to update the Rust toolchain. Sometimes the error will tell you
     so explicitly, but it may happen that the error is more obscure. To update the rust toolchain:
      * you will need to open a PR on the internal repo updating `RUST_VERSION` in `MODULE.bazel`. In general you can have this merged
        independently of the changes in `codeql`.
      * in `codeql`, update both `RUST_VERSION` in `MODULE.bazel` _and_ `rust-toolchain.toml` files. You may want to also update the
        nightly toolchain in `rust/extractor/src/nightly-toolchain/rust-toolchain.toml` to a more recent date while you're at it.
      * a toolchain and/or `rules_rust` bump invalidates the vendored files, so re-run `misc/bazel/3rdparty/update_cargo_deps.sh`
       (see the note in step 4) and commit the regenerated files.
   * if it fails while compiling rust extractor code, you will need to adapt it to the new library version.
      * for example updating annotations in `annotations.py`, adding / removing generated tests.

   If you had to do any changes, commit them. If you updated the rust toolchain, running `rust/lint.py` might reformat or apply new
   lints to the code.

6. Check with CI if everything is in order.

7. Run DCA with database caching disabled. Iterate on the code if needed.

8. If in step 4 the schema was updated, add upgrade/downgrade scripts and a
   change note. This is best done last to reduce the chance of merge conflicts
   (none of the other testing depends on having upgrade and downgrade scripts
   in place). See [Upgrading a language database
   schema](docs/prepare-db-upgrade.md).
