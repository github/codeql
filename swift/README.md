## Warning

The Swift codeql package is an experimental and unsupported work in progress.

## Usage

Run `bazel run //swift:create-extractor-pack`, which will install `swift/extractor-pack`.
Using `--search-path=swift/extractor-pack` will then pick up the Swift extractor. You can also use
`--search-path=swift`, as the extractor pack is mentioned in `swift/.codeqlmanifest.json`.
