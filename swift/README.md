# Swift on CodeQL

## Warning

The Swift CodeQL package is an experimental and unsupported work in progress.

## Building the Swift extractor

First ensure you have Bazel installed, for example with

```bash
brew install bazelisk
```

then from the `ql` directory run

```bash
bazel run //swift:create-extractor-pack    # --cpu=darwin_x86_64 # Uncomment on Arm-based Macs
```

which will install `swift/extractor-pack`.

Notice you can run `bazel run :create-extractor-pack` if you already are in the `swift` directory.

Using `codeql ... --search-path=swift/extractor-pack` will then pick up the Swift extractor. You can also use
`--search-path=.`, as the extractor pack is mentioned in the root `codeql-workspace.yml`. Alternatively, you can
set up the search path in [the per-user CodeQL configuration file](https://codeql.github.com/docs/codeql-cli/specifying-command-options-in-a-codeql-configuration-file/#using-a-codeql-configuration-file).

## Code generation

Run

```bash
bazel run //swift/codegen
```

to update generated files. This can be shortened to
`bazel run codegen` if you are in the `swift` directory.
