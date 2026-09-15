# Lua test matrix

All test inputs and exact oracles are committed in their owning directories.
Library tests live under this directory. The
[experimental query tests](../experimental/query-tests) have their own
publication-aligned path. The matrix covers these stable behavior groups:

| Area | Covered boundary |
| --- | --- |
| Source inventory | `.lua` file identity and metadata without a source-AST claim. |
| Bytecode model | Accepted Lua 5.1 profiles plus malformed and unsupported diagnostics. |
| Local semantics | Control flow, reaching definitions, values, calls, tables, globals, and upvalues. |
| Modules and interprocedural flow | Literal modules, exports, arguments, returns, varargs, open results, and balanced calls. |
| Taint and reports | Active paths, sanitizer paths, negative boundaries, and path alternatives. |
| Query publication | Experimental query metadata, direct execution, active findings, and sanitized review paths. |
| Complex integration | 46 unchanged `.lua` files and 46 stripped Lua 5.1 `.luac` files in a multi-file module layout. |

Run the complete matrix from the repository root:

```bash
CODEQL=/absolute/path/to/codeql
ROOT=$(pwd)

"$CODEQL" test run lua/ql/test \
  --search-path="$ROOT:$ROOT/lua"
```

Pass one test directory for a focused review. For example, reproduce the
complex integration oracle with:

```bash
"$CODEQL" test run \
  lua/ql/test/library-tests/complex-bytecode-integration \
  --search-path="$ROOT:$ROOT/lua"
```

The integration [manifest](complex-bytecode-integration/SAMPLE-MANIFEST.md),
[hash inventory](complex-bytecode-integration/SHA256SUMS), and
[compact oracle](complex-bytecode-integration/CorpusAcceptance.expected) are the
complete committed review evidence. Generated databases and reports are not
part of the test corpus.
