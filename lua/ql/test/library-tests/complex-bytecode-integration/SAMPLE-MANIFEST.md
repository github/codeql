# Complex Lua 5.1 Bytecode Integration Corpus

This test corpus exercises the Lua extractor, bytecode model, module and
interprocedural analysis, and public command-flow queries over a complex
multi-file layout.

The corpus contains:

- 46 Lua source files;
- 46 corresponding Lua 5.1 bytecode files;
- 42 source/bytecode pairs under `usr/lib/lua`;
- 4 source/bytecode pairs under `lib/wifi`.

The source files retain their original bytes and relative paths. The paired
bytecode files are reproducibly compiled with Lua 5.1 debug metadata stripped;
their instruction streams, constants, and prototype structure are unchanged.
The corpus retains its Git-representable executable classification: 13 files
are executable and 79 are non-executable. `SHA256SUMS` records the complete
input inventory. Generated databases, reports, BQRS, CSV, SARIF, logs, and
profiles are not part of the test corpus.
