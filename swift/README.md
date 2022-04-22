## Warning

The Swift codeql package is an experimental and unsupported work in progress.

## Usage

Run

```bash
bazel run //swift:create-extractor-pack
```

which will install `swift/extractor-pack`.

Using `--search-path=swift/extractor-pack` will then pick up the Swift extractor. You can also use
`--search-path=swift`, as the extractor pack is mentioned in `swift/.codeqlmanifest.json`.

Notice you can run `bazel run :create-extractor-pack` if you already are in the `swift` directory.

## Code generation

Make sure to install the [pip requirements](./codegen/requirements.txt) via

```bash
python3 -m pip install -r codegen/requirements.txt
```

Run

```bash
bazel run //swift/codegen
```

to update generated files. This can be shortened to
`bazel run codegen` if you are in the `swift` directory.
