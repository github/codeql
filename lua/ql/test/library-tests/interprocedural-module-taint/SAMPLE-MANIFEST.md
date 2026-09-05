# Interprocedural module taint sample manifest

These committed Lua 5.1 bytecode fixtures exercise interprocedural and module
semantics without external test data.

| Fixture | Expected boundary |
| --- | --- |
| `same-module-formvalue-execute/input.luac` | Resolved same-artifact argument and return flow. |
| `cross-module-webcmd-popen/{controller,mtkwifi}.luac` | Literal require, module export, cross-module call target, and taint path. |
| `module-return-table-field-call/{controller,library}.luac` | Returned-table field call target. |
| `bc-taint-minimal-path/input.luac` | Minimal same-artifact taint path. |
| `unresolved-callee-negative/input.luac` | Unresolved callee does not create interprocedural flow. |
| `ambiguous-unresolved-dynamic-module-negative/*.luac` | Missing, ambiguous, and dynamic requires remain explicit boundaries. |
| `module-missing-field-negative/{controller,library}.luac` | A missing export field does not create a target. |
| `bc-kill-overwrite/input.luac` | Overwritten values do not reach the sink. |
| `bc-branch-negative/input.luac` | No unproved branch flow is synthesized. |

Reviewer command:

```bash
CODEQL=/absolute/path/to/codeql
"$CODEQL" test run lua/ql/test/library-tests/interprocedural-module-taint \
  --search-path .:lua --threads=0 --verbosity=progress
```

The `.expected` files in this directory are the complete oracle for this
focused test set.
