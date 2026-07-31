# schemagen

Generates [`unified/extractor/swift_node_types.yml`][schema], the schema that
describes the shape of the trees `swift-syntax-parse` produces. The extractor
seeds every parse with it, so that rule matching never refers to a node kind or
field that swift-syntax cannot produce.

Run it through the script, which stages the sources described below:

```console
$ unified/scripts/regenerate-node-types.sh
```

Do this after changing the pinned swift-syntax version, and read the resulting
diff: a new or renamed node kind usually means the mapping in
[`swift.rs`][mapping] needs attention too.

Unlike `swift-syntax-parse`, this needs a local Swift toolchain — see
[`.swift-version`](../.swift-version) for the pinned version.

## Why the sources are copied in

The schema is derived from `SyntaxSupport`, the module that describes
swift-syntax's own syntax tree — the same description swift-syntax generates
itself from, and so authoritative in a way that reading the parser's output
never would be. The runtime `SwiftSyntax` module is not a substitute: its
`SyntaxNodeStructure` exposes layout as key paths, without the field names,
optionality and base-kind relationships this schema records.

`SyntaxSupport` is awkward to depend on, though. It is a *target* of
`CodeGeneration`, a package that sits inside the swift-syntax repository and is
separate from swift-syntax itself, and it is not one of that package's products.
SwiftPM can only depend on products, and Bazel's swift-syntax module does not
export the `CodeGeneration` sources at all, so neither build system can reach it.

The regeneration script therefore copies those sources out of the resolved
swift-syntax checkout into `Sources/SyntaxSupport`, where this package builds
them as its own. That directory is git-ignored: the sources are swift-syntax's,
and are re-copied on every run, so they always match the pinned version rather
than drifting as a stale vendored copy would.

For the same reason this package takes swift-syntax as a *path* dependency on
the checkout the neighbouring FFI package resolved, rather than declaring a
second pinned dependency of its own. The schema has to describe exactly the
swift-syntax that `swift-syntax-parse` links, and a single pin cannot drift from
itself.

## What is filtered out

The schema describes the JSON the extractor's adapter actually receives, not
swift-syntax's tree verbatim, so `main.swift` mirrors what
[`adapter.rs`][adapter] does:

- Abstract base kinds become `supertypes:` entries rather than node kinds.
- Collection nodes are dropped, and a collection-typed child is recorded as its
  element kinds, because the adapter elides collections into JSON arrays.
- `unexpectedBeforeX` / `unexpectedBetweenXAndY` error-recovery children are
  dropped; no rule matches them. (Note this filters on the *child* name: the
  `unexpectedCodeDecl` node kind is real, and is kept.)
- Token-typed children become the synthetic `_token` kind, and only the
  "varying" token kinds — those whose text is not implied by the kind, listed in
  `VARYING_TOKEN_KINDS` in `adapter.rs` — are emitted as kinds of their own.
  Fixed tokens are anonymous and keyed by their text, so no rule can name them.

Setting `EMIT_SUPERTYPES=0` omits the `supertypes:` section, which is
occasionally useful when diffing two versions for kind and field changes alone.

[schema]: ../../extractor/swift_node_types.yml
[mapping]: ../../extractor/src/languages/swift/swift.rs
[adapter]: ../../extractor/src/languages/swift/adapter.rs
