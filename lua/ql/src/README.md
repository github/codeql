# Lua query interfaces

The Lua query pack exposes one security query, one diagnostic path query, and
one detailed table query. These queries use CodeQL's experimental support
lifecycle for initial upstream adoption. The Lua 5.1 extractor, schema, and
analysis libraries are mature and are not designated experimental.

See [`../../README.md`](../../README.md) for bytecode and source workflows,
database creation, suite execution, and prerequisites.

## `CommandInjection.ql`

Location: `lua/ql/src/experimental/Security/CWE-078/CommandInjection.ql`

This is the active-finding interface over `RulesSanitizerReport.qll`. A decoded
BQRS row has the standard path-problem projection:

| Column | Meaning |
| --- | --- |
| `file` | Sink module path relative to the database source root. |
| `source` | Typed `LuaFlowNode` for the matched source value. |
| `sink` | Typed `LuaFlowNode` for the matched sink value. |
| `col3` | Human-readable classification, reason, and provenance message. |

Its `edges` predicate supplies complete native flow steps for BQRS
interpretation as SARIF. Use this query when a reviewer or adapter needs only
reportable active findings. Source rules currently match final-segment
`formvalue` and `source`; sink rules cover the committed command-execution call
family defined in `RulesSanitizerReport.qll`. The rules use resolved call names
and semantic flow through the generic Lua bytecode model.

## `SanitizedCommandFlow.ql`

Location: `lua/ql/src/experimental/Diagnostics/SanitizedCommandFlow.ql`

This companion path-problem query uses the same `file`, `source`, `sink`, and
`col3` projection, but emits flows classified as `sanitized`. It is review
evidence for suppressed paths, not an active security finding. Its SARIF rule
ID is `lua/diagnostics/sanitized-command-flow`.

## `LuaBytecodeFacts.ql`

Location: `lua/ql/src/experimental/Diagnostics/LuaBytecodeFacts.ql`

This query exports a tagged union with columns `row_kind`, `a` through `i`.
`row_kind` determines the meaning of the remaining columns:

- aggregate model counts;
- instructions, constants, upvalues, closures, and register events;
- local dataflow edges and call-target candidates;
- module identities, literal requires, resolution, and returned exports;
- interprocedural argument/return flow;
- source/sink rule matches.

The current row kinds are `aggregate`, `instruction`, `constant`, `upvalue`,
`closure-value`, `register-event`, `dataflow-edge`, `module-identity`,
`function-identity-candidate`, `call-target-candidate`, `literal-require`,
`module-resolution`, `module-export`, `module-field-call-target`,
`interproc-arg-flow`, `interproc-return-flow`, and `rule-match`. The query
source is the positional schema authority. Empty columns are intentionally
emitted as empty strings so every row has ten columns.

Stable identity conventions are documented in [`../../SCHEMA.md`](../../SCHEMA.md).

Use this interface when an integration needs auditable model evidence. It is
deliberately verbose and is intended for direct, manual execution.

## Execute either query

After creating a Lua database as described in `lua/README.md`:

```bash
CODEQL=/absolute/path/to/codeql
ROOT=$(pwd)
DB=/absolute/path/to/codeql-lua-database
QUERY="$ROOT/lua/ql/src/experimental/Security/CWE-078/CommandInjection.ql"

"$CODEQL" query run "$QUERY" \
  --database="$DB" \
  --search-path="$ROOT:$ROOT/lua" \
  --output=/tmp/lua-results.bqrs

"$CODEQL" bqrs decode /tmp/lua-results.bqrs \
  --format=csv \
  --output=/tmp/lua-results.csv
```

Replace `QUERY` with
`$ROOT/lua/ql/src/experimental/Diagnostics/SanitizedCommandFlow.ql` for
suppressed paths, or
`$ROOT/lua/ql/src/experimental/Diagnostics/LuaBytecodeFacts.ql` for the detailed
export. Use `--format=json` for the facts export when a consumer needs to
preserve the tagged row structure without CSV quoting concerns.
