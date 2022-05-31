## Warning

The Swift codeql package is an experimental and unsupported work in progress.

## Usage

First ensure you have Bazel installed, for example with

```bash
brew install bazelisk
```

then from the `ql` directory run

```bash
bazel run //swift:create-extractor-pack
```

which will install `swift/extractor-pack`.

Using `--search-path=swift/extractor-pack` will then pick up the Swift extractor. You can also use
`--search-path=.`, as the extractor pack is mentioned in the root `codeql-workspace.yml`.

Notice you can run `bazel run :create-extractor-pack` if you already are in the `swift` directory.

## Code generation

Run

```bash
bazel run //swift/codegen
```

to update generated files. This can be shortened to
`bazel run codegen` if you are in the `swift` directory.
