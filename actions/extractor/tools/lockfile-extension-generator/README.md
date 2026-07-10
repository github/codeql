# lockfile-extension-generator

Turns a repository's GitHub Actions lockfile (`.github/workflows/actions.lock`)
into a CodeQL data extension that populates the `pinnedByLockfileDataModel`
extensible predicate consumed by the `actions/unpinned-tag`
(`js/actions/actions-workflow-unpinned-tag`) query.

## Why

`actions/unpinned-tag` flags `uses:` references pinned to a mutable tag (e.g.
`actions/checkout@v4`) rather than an immutable commit SHA. When a repository
maintains an Actions lockfile, every such tag is already bound to a verified
commit SHA at run time by the lockfile — which is exactly the pinning evidence
the query otherwise lacks. Feeding the lockfile's bindings into
`pinnedByLockfileDataModel` lets the query suppress those references while still
flagging genuinely unpinned ones.

The generator is deliberately **transport-agnostic**. It parses the minimal,
stable core of the lockfile format directly (see `lockfile.go`) and emits the
`[workflow_path, nwo, ref]` rows the query already matches on. It has no
dependency on the `github.com/github/actions-lockfile` module, so it builds
anywhere the Go toolchain is available. Today those rows ship as a
data-extension model pack applied at analysis time via `--model-packs` (the same
mechanism as `codeql/immutable-actions-list`). The same parsing core can later
feed an extractor-native relation without changing the query.

## Extractor integration

The Actions extractor runs this generator automatically during `codeql database
create` (see `../generate-lockfile-extension.sh`, invoked from
`../autobuild.sh`). When the repository has a lockfile, the extractor writes a
self-contained model pack into the database:

```
<database>/lockfile-extension/
  qlpack.yml                        # name: codeql/actions-lockfile-pins
  ext/pinned_by_lockfile.model.yml  # generated pinnedByLockfileDataModel rows
```

CodeQL does not auto-apply extensions carried inside a database, so analysis
must add this pack explicitly:

```
codeql database analyze <db> \
  codeql/actions-queries:Security/CWE-829/UnpinnedActionsTag.ql \
  --additional-packs <db>/lockfile-extension \
  --model-packs codeql/actions-lockfile-pins
```

Wiring that flag into the analysis harness (e.g. the CodeQL Action) is the
remaining integration step and lives outside this repository. Generation is a
clean no-op for repositories without a lockfile, so the extractor step is safe
to run unconditionally.

## Ref normalization

A lockfile records the *resolved* ref for each dependency — the CLI prefers a
full semver tag such as `v4.3.1`. A workflow author, however, usually writes a
shorter, mutable tag such as `v4` or `v4.3` in `uses:`, and the query matches on
the ref exactly as written. For every full-semver resolved ref the generator
therefore also emits its major.minor (`v4.3`) and major-only (`v4`) forms, so a
`uses: owner/action@v4` is recognized as pinned by a lockfile entry that
resolved to `v4.3.1`. Partial tags, pre-release tags, branches, and SHAs pass
through unchanged.

## Usage

```
lockfile-extension-generator <source-root> [output-file]
```

- `<source-root>`: repository root to scan; the lockfile is read from
  `<source-root>/.github/workflows/actions.lock`.
- `[output-file]`: destination for the extension YAML; defaults to stdout.

If the repository has no lockfile the generator exits successfully without
writing anything, so it is safe to run unconditionally.

## Building and testing locally

The generator depends only on `gopkg.in/yaml.v3`, so it builds and tests with a
stock Go toolchain and no special setup:

```
go build ./...
go test ./...
```

The golden test (`testdata/expected.yml`) pins the exact generated output for a
representative lockfile, so any change to parsing or ref normalization must be
reflected there deliberately. The lockfile parsing in `lockfile.go` mirrors the
canonical semantics of `github.com/github/actions-lockfile`; if that format
evolves, update `lockfile.go` and the golden fixture together.

## End-to-end check

```
# A repo whose workflow writes `uses: owner/action@v4` while the lockfile
# resolves it to v4.3.1:
lockfile-extension-generator /path/to/repo /tmp/pack/ext/pinned.yml
codeql database analyze <db> \
  codeql/actions-queries:Security/CWE-829/UnpinnedActionsTag.ql \
  --additional-packs=/tmp/pack --model-packs=<your-pack-name>
```

The lockfile-pinned reference is suppressed; references not covered by the
lockfile are still reported.

## Limitations

- **Composite actions.** A lockfile records each workflow's *transitive* pin
  list keyed by the workflow path. A `uses:` that appears only inside a
  composite action file (`.github/actions/*/action.yml`) is therefore not
  emitted against that action file's own path, so the query does not suppress
  it. This is a completeness gap, not a correctness one: it can only leave a
  reference reported, never wrongly suppress one, because a row is only ever
  emitted for a `(path, nwo, ref)` the lockfile actually pins.
- **Ref forms the lockfile can't cover.** Only the resolved ref and its
  major/major.minor forms are emitted. A `uses:` written with an unrelated tag
  or a moving branch that the lockfile did not resolve from is not matched.
