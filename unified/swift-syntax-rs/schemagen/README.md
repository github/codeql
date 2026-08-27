# schemagen

Generates [`unified/extractor/swift_node_types.yml`][schema], the schema that
describes the shape of the trees produced by `swift_syntax_rs::parse_to_json`.
The extractor seeds every parse with it, so rule matching never refers to a
node kind or field that swift-syntax can produce but the schema does not know.

Run it through the script, which stages the sources described below:

```console
$ unified/scripts/regenerate-node-types.sh
```

Do this after changing the pinned swift-syntax version, and read the resulting
diff: a new or renamed node kind usually means the mapping in
[`swift.rs`][mapping] needs attention too.

This requires the local Swift toolchain pinned by
[`.swift-version`](../.swift-version).

## Why the sources are copied in

The schema is derived from `SyntaxSupport`, the module that describes
swift-syntax's own syntax tree. This is the same description swift-syntax
generates itself from, and is therefore authoritative in a way that observing
parser output never would be. The runtime `SwiftSyntax` module is not a
substitute: its `SyntaxNodeStructure` exposes layout as key paths, without the
field names, optionality, and base-kind relationships this schema records.

`SyntaxSupport` is awkward to depend on, though. It is a target of
`CodeGeneration`, a package inside the swift-syntax repository that is
separate from swift-syntax itself, and it is not one of that package's
products. SwiftPM can only depend on products, and Bazel's swift-syntax module
does not export the `CodeGeneration` sources, so neither build system can
reach it directly.

The regeneration script therefore copies those sources out of the resolved
swift-syntax checkout into `Sources/SyntaxSupport`, where this package builds
them as its own. That directory is git-ignored and refreshed on every run, so
it always matches the pinned version rather than drifting as a stale vendored
copy would.

For the same reason this package takes swift-syntax as a path dependency on the
checkout the neighbouring FFI package resolved, rather than declaring a second
pinned dependency of its own. The schema must describe exactly the
swift-syntax version linked by `swift-syntax-rs`.

## What is filtered out

The schema describes the JSON the extractor's adapter receives, not
swift-syntax's tree verbatim, so `main.swift` mirrors what
[`adapter.rs`][adapter] does:

- Abstract base kinds become `supertypes:` entries rather than node kinds.
- Collection nodes are dropped, and a collection-typed child is recorded as
  its element kinds, because the adapter elides collections into JSON arrays.
- `unexpectedBeforeX` and `unexpectedBetweenXAndY` error-recovery children are
  dropped; no rule matches them. This filters on the child name:
  `unexpectedCodeDecl` is a real node kind and is retained.
- Token-typed children become the synthetic `_token` kind. Only the varying
  token kinds whose text is not implied by the kind, listed in
  `VARYING_TOKEN_KINDS` in `adapter.rs`, are emitted as kinds of their own.
  Fixed tokens are anonymous and keyed by their text, so no rule can name
  them.

Setting `EMIT_SUPERTYPES=0` omits the `supertypes:` section, which can be useful
when diffing two versions for kind and field changes alone.

[schema]: ../../extractor/swift_node_types.yml
[mapping]: ../../extractor/src/languages/swift/swift.rs
[adapter]: ../../extractor/src/languages/swift/adapter.rs
