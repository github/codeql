# Rules, sanitizer, and report sample manifest

These committed Lua 5.1 bytecode fixtures exercise the command-flow finding
pipeline without external test data.

| Fixture | Expected boundary |
| --- | --- |
| `bc-taint-minimal-path/input.luac` | Minimal proved path can be consumed by report construction. |
| `formvalue-os-execute-chain/input.luac` | Local `*.formvalue` source to `*.execute` sink finding. |
| `submit-dpp-uri-execute/input.luac` | Nested-prototype source-to-execute finding. |
| `cross-module-webcmd-popen/{controller,mtkwifi}.luac` | Cross-module source propagation to a `*.popen` sink. |
| `sanitizer-on-path/input.luac` | An on-path sanitizer suppresses the finding. |
| `table-field-sanitizer-overwrite/*.luac` | A sanitizer result replacing the same static table field suppresses only that mandatory field path; unrelated fields, optional branches, and dynamic keys remain active. |
| `constant-sink-overmatch-negative/input.luac` | Similar names and fixed-string sink arguments do not overmatch. |
| `sanitizer-same-suffix-off-chain-negative/input.luac` | An off-path sanitizer does not suppress the real path. |
| `no-report-without-path-negative/input.luac` | Source and sink endpoints alone do not synthesize a finding. |
| `bc-kill-overwrite/input.luac` | Killed flow does not produce a finding. |
| `bc-branch-negative/input.luac` | No unproved branch flow is synthesized. |

Reviewer command:

```bash
CODEQL=/absolute/path/to/codeql
"$CODEQL" test run lua/ql/test/library-tests/rules-sanitizer-report \
  --search-path .:lua --threads=0 --verbosity=progress
```

The `.expected` files in this directory are the complete oracle for this
focused test set. For a standalone database/query reproduction using the same
fixtures, follow `lua/README.md` and keep this directory as the common source
root so fixture-relative identities remain stable.
