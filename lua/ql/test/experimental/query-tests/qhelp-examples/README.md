# Qhelp example contract

This test runs the public experimental queries over stripped Lua 5.1 bytecode
compiled from the adjacent source files. The source files are byte-identical to
the examples referenced by the two qhelp files.

Regenerate the bytecode from this directory with:

```bash
luac5.1 -s -o CommandInjection.luac CommandInjection.lua
luac5.1 -s -o SanitizedCommandFlow.luac SanitizedCommandFlow.lua
```

The active-query oracle contains only the unsafe sink from
`CommandInjection.lua`; the fixed-command branch is intentionally absent. The
sanitized-query oracle contains the path from `SanitizedCommandFlow.lua`.
