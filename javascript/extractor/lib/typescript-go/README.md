# TypeScript Parser Wrapper (Go)

Drop-in replacement for the Node.js TypeScript parser wrapper
(`lib/typescript/src/main.ts`) that uses the TypeScript 7 Go-based
compiler (`tsgo`) for parsing.

## Architecture

The Go wrapper implements the same stdin/stdout JSON protocol as the
Node.js wrapper, making it a transparent replacement from the Java
extractor's perspective.

```
Java Extractor ──stdin/stdout JSON──▶ Go Wrapper ──▶ tsgo (TypeScript 7)
```

### Protocol

Commands are sent as one JSON object per line on stdin:

| Command          | Response Type  | Description                        |
|-----------------|---------------|------------------------------------|
| `get-metadata`  | `metadata`    | Returns syntax kind/flag mappings  |
| `prepare-files` | `ok`          | Hints about upcoming parse order   |
| `parse`         | `ast`         | Parses a file and returns the AST  |
| `reset`         | `reset-done`  | Resets state to fresh              |
| `quit`          | *(exits)*     | Shuts down the process             |

### Package Structure

```
cmd/typescript-parser-wrapper/   Entry point (server + single-file modes)
internal/
  protocol/                      JSON protocol handler
  tsparser/                      Parser backend interface + tsgo impl
  astconv/                       AST property whitelist + conversion
  validation/                    Comparison tests (Node.js vs Go)
scripts/
  validate-output.sh             Shell script for bulk comparison
testdata/                        Sample TypeScript files for testing
```

## Building

```bash
go build -o bin/typescript-parser-wrapper ./cmd/typescript-parser-wrapper/
```

## Testing

```bash
# Unit tests
go test ./...

# Validation against Node.js wrapper
go test ./internal/validation/ -v

# Or via shell script
./scripts/validate-output.sh testdata/sample.ts
```

## Status

This is initial scaffolding. The parser backend communicates with the
`tsgo` binary (from `@typescript/native-preview`) via its `--api --async`
mode, which uses JSON-RPC 2.0 with LSP-style Content-Length framing.

**Validated so far:**
- ✅ Successfully initialize the tsgo API subprocess
- ✅ Open a project via `updateSnapshot` with a tsconfig
- ✅ Retrieve binary-encoded source file data via `getSourceFile`
- ✅ Protocol handler matches the Node.js wrapper's command set
- ✅ Validation framework compares outputs (skips gracefully when Go can't parse yet)

**Key discovery: tsgo API returns binary-encoded ASTs**, not JSON.
The `getSourceFile` response is a custom binary format (base64-encoded
when using JSON protocol). This means the AST conversion layer needs
to decode this binary format rather than transform JSON. See
`microsoft/typescript-go/internal/api/encoder/encoder.go` for the
format specification.

### Next Steps

1. **Decode binary AST format** — Implement a decoder for the tsgo
   encoder format (flat node array with string tables and sibling pointers)
2. **Convert decoded AST to JSON** — Map decoded nodes to the JSON
   format expected by the Java extractor (property whitelist, `$pos`/`$end`,
   `$lineStarts`, `$tokens`, `$declarationKind`, string kind names)
3. **Wire up end-to-end** — Connect the decoded AST through the protocol
   handler so `parse` commands return valid AST JSON
4. **Validate against Node.js wrapper** — Run the comparison tests
5. **Consider alternative: build from source** — Since all typescript-go
   packages are `internal/`, building our wrapper as a cmd inside a fork
   would give direct parser access without binary encoding overhead
