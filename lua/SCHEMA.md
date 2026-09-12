# Lua 5.1 bytecode schema

`lua/lua.dbscheme` is the extractor schema authority. The mirrored schema and
statistics files under `lua/ql/lib` let the QL packs resolve the same relations
and must remain byte-identical to their extractor-package counterparts:

```bash
cmp lua/lua.dbscheme lua/ql/lib/lua.dbscheme
cmp lua/lua.dbscheme.stats lua/ql/lib/lua.dbscheme.stats
```

## Stable identities

- Artifact and module paths are normalized, source-root-relative paths.
- Prototype IDs use `root` followed by ordinal child components such as
  `root.2.1`.
- Instruction sites use `<prototype>@pc<pc>`.
- Register values use `<prototype>@pc<pc>:r<slot>`.
- Callsite IDs use the instruction-site form and are always interpreted with
  caller module and caller prototype ownership.
- Missing debug names remain explicit as unavailable metadata; they are not
  guessed from paths or benchmark results.

These identities describe input evidence. Production rules derive behavior
from extracted relations and resolved API semantics rather than input
identities.

## Relation families

| Family | Relations | Contract |
| --- | --- | --- |
| Files and locations | `files`, `folders`, `containerparent`, `locations_default`, `sourceLocationPrefix` | Minimal entities required for CodeQL result locations. |
| Input inventory | `lua_source_files`, `lua_artifacts`, `lua_profiles`, `lua_diagnostics` | Accepted bytecode and rejected profiles are disjoint. Diagnostic artifacts do not emit partial semantic success facts. |
| Bytecode model | `lua_prototypes`, `lua_instructions`, `lua_constants`, `lua_register_events`, `lua_semantic_steps`, `lua_closure_values`, `lua_call_sites`, `lua_upvalues` | Typed Lua 5.1 structure and register effects. |
| Local semantics | `lua_local_flows`, `lua_control_flow_edges`, `lua_dominator_tree_intervals`, `lua_analysis_boundaries` | Reaching definitions, control flow, dominance, and explicit unsupported boundaries. |
| State carriers | `lua_table_field_flows`, `lua_global_flows`, `lua_upvalue_flows` | Static table fields may be precise; dynamic keys never create precise field flow. Same-table conservative object flow remains available. |
| Resolution | `lua_call_resolutions`, `lua_literal_requires`, `lua_module_resolutions`, `lua_module_exports` | Resolved, ambiguous, and unresolved states remain explicit. No guessed callee or module target is emitted. |
| Interprocedural flow | `lua_interprocedural_flows` | Argument, vararg, return, open-result, and tailcall rows retain caller module, caller prototype, callsite, callee module, and callee prototype ownership. |
| Mapping evidence | `lua_mapping_markers`, `lua_mapping_marker_diagnostics` | Source/bytecode mapping states; not a source AST contract. |

## Analysis invariants

1. An input is either accepted or diagnostic; malformed input cannot contribute
   ordinary bytecode, flow, or report facts.
2. Local reaching definitions reject overwritten values while preserving
   branch and loop alternatives.
3. Static table fields may use field-sensitive flow. Unknown or dynamic keys
   use conservative table-object flow and do not acquire a fabricated field
   name.
4. Interprocedural edges are callsite-balanced. A return from one callsite
   cannot satisfy another callsite's route.
5. Fixed and producer-proven open arguments/results are represented
   structurally. Missing producer evidence is an explicit boundary, not a
   guessed slot range.
6. Sanitizer and report semantics are derived in QL from typed calls and the
   generic flow graph. Extractor relations do not contain final benchmark
   findings.

## Changing the schema

When a relation changes:

1. Update both dbscheme copies and both statistics copies identically.
2. Update the TRAP producer in `lua/tools/index_lua_files.py`.
3. Update the typed QL wrapper in `lua/ql/lib/codeql/lua/`.
4. Add or update a committed positive and negative test at the complete
   behavioral boundary.
5. Run the Python, QL, query-compile, and schema-mirror commands in
   [`README.md`](README.md).

The schema and QL APIs support the repository-local Lua 5.1 bytecode analysis
implementation. Official bundle and CodeQL Action registration are separate
upstream product integration work. Source parsing and non-Lua-5.1 bytecode are
not claimed.
