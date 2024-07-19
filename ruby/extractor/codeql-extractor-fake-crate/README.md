We're presenting a fake crate in this workspace that ensures that the correct crate dependencies from the shared tree sitter
extractor can be parsed by Bazel (which doesn't resolve path dependencies outside of the cargo workspace unfortunately).

The sync-identical-files script keeps this up-to-date.
For local development and IDEs, we override the path to `codeql-extractor` using the `.cargo/config.toml` mechanism.
Bazel doesn't actually do anything with path dependencies except to pull in their dependency tree, so we manually
specify the dependency from the ruby extractor to the shared extractor in `BUILD.bazel`.
