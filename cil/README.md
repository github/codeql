# C# IL Extractor for CodeQL

A CodeQL extractor that analyzes compiled .NET assemblies (DLL/EXE files) at the IL (Intermediate Language) level.

## Overview

This extractor enables CodeQL analysis of compiled C# code without requiring source code. It directly extracts IL instructions from .NET assemblies and creates a queryable database for control flow and call graph analysis.

## Features

- ✅ Extract from any .NET DLL/EXE file
- ✅ Capture complete IL instruction streams
- ✅ Track control flow (branches, loops)
- ✅ Build call graphs across assemblies
- ✅ Analyze exception handlers (try/catch/finally)
- ✅ Support for cross-assembly flow tracing

## Quick Start

### Prerequisites

- .NET 8.0 SDK or later
- Mono.Cecil library (automatically restored via NuGet)

### Build the Extractor

```bash
cd csharp-il
dotnet build extractor/Semmle.Extraction.CSharp.IL
```

### Extract a DLL

```bash
dotnet run --project extractor/Semmle.Extraction.CSharp.IL -- \
  path/to/your/assembly.dll \
  output.trap
```

### Try the Test Example

```bash
# Extract the test assembly
dotnet run --project extractor/Semmle.Extraction.CSharp.IL -- \
  test-inputs/TestAssembly/bin/Debug/net8.0/TestAssembly.dll \
  test-inputs/TestAssembly.trap

# View the results
head -100 test-inputs/TestAssembly.trap
```

## What Gets Extracted

The extractor captures:

1. **Assemblies**: Name, version, file location
2. **Types**: Classes, structs, interfaces, enums
3. **Methods**: Signatures, parameters, return types
4. **IL Instructions**: Opcodes, operands, offsets
5. **Control Flow**: Branch targets, fall-through paths
6. **Call Graph**: Method calls with qualified names
7. **Exception Handlers**: Try/catch/finally blocks

## Database Schema

The extractor creates a CodeQL database with the following structure:

```
assemblies(id, file, name, version)
types(id, full_name, namespace, name)
methods(id, name, signature, type_id)
il_instructions(id, opcode_num, opcode_name, offset, method)
il_branch_target(instruction, target_offset)
il_call_target_unresolved(instruction, target_method_name)
...
```

See `documentation/dbscheme-guide.md` for complete schema documentation.

## Use Cases

### Security Analysis
- Trace data flow through compiled libraries
- Find paths to sensitive API calls
- Analyze third-party dependencies

### Code Understanding
- Build call graphs from compiled code
- Understand control flow in obfuscated assemblies
- Analyze library usage patterns

### Cross-Assembly Analysis
- Trace execution across multiple DLLs
- Find inter-assembly dependencies
- Analyze full application stacks

## Project Status

**Current Phase**: Schema Complete ✅

- ✅ Phase 0: POC with Mono.Cecil
- ✅ Phase 1: TRAP File Extractor
- ✅ Phase 2: Database Schema
- ⬜ Phase 3: QL Library (In Progress)
- ⬜ Phase 4: Call Graph Predicates
- ⬜ Phase 5: Basic Blocks
- ⬜ Phase 6: End-to-End Testing

See `wipStatus/CURRENT-STATUS.md` for detailed progress.

## Directory Structure

```
csharp-il/
├── extractor/              # IL extraction tool
│   └── Semmle.Extraction.CSharp.IL/
├── ql/                     # QL library (coming soon)
│   └── lib/
│       └── semmlecode.csharp.il.dbscheme
├── test-inputs/            # Test assemblies
│   └── TestAssembly/
├── documentation/          # Documentation
│   └── dbscheme-guide.md
└── wipStatus/             # Development notes
    ├── CURRENT-STATUS.md
    ├── PLAN.md
    └── ...
```

## Example: Extracting TestAssembly

The `test-inputs/TestAssembly` project contains example C# code with:
- If/else statements
- Method calls
- Loops
- Arithmetic operations

After extraction, you can see the IL representation:

```trap
types(3, "TestNamespace.SimpleClass", "TestNamespace", "SimpleClass")
methods(4, "SimpleMethod", "Void SimpleMethod()", 3)
il_instructions(13, 43, "brfalse.s", 9, 4)
il_branch_target(13, 26)
il_instructions(16, 39, "call", 17, 4)
il_call_target_unresolved(16, "System.Console.WriteLine")
```

## Design Philosophy

### Simple Extraction, Smart Queries

The extractor follows CodeQL best practices:

- **Extractor**: Simple and fast - just write IL facts to TRAP files
- **QL Library**: Smart analysis - compute CFG, reachability, etc. at query time

This architecture keeps extraction fast while enabling sophisticated analysis.

### Why IL Instead of Decompilation?

1. **Accurate**: IL is the ground truth, no decompiler errors
2. **Fast**: No expensive decompilation step
3. **Reliable**: Works on all .NET code, even obfuscated
4. **Complete**: Exact control flow and calling conventions

## Documentation

- `documentation/dbscheme-guide.md` - Complete schema reference
- `wipStatus/PLAN.md` - Project plan and approach
- `wipStatus/IMPLEMENTATION.md` - Implementation roadmap
- `wipStatus/CURRENT-STATUS.md` - Current progress

## Contributing

This is an experimental extractor under active development. Contributions welcome!

Current focus areas:
- QL library implementation
- Basic block computation
- Call graph predicates
- Test query development

## Technical Details

### Technologies Used

- **Language**: C# (.NET 8.0)
- **IL Parser**: Mono.Cecil
- **Target**: .NET Standard 2.0+ assemblies
- **Output Format**: CodeQL TRAP files

### Limitations

Currently extracts compiled IL only:
- ✅ Class and method names
- ✅ Control flow (branches, calls)
- ✅ Method signatures
- ❌ Local variable names (without PDB files)
- ❌ Source locations (without PDB files)

These are sufficient for control flow and call graph analysis!

## License

Part of the CodeQL project. See LICENSE in repository root.

## Contact

For questions about this extractor, see the wipStatus documents or create an issue.

---

**Quick Links**:
- [Current Status](wipStatus/CURRENT-STATUS.md)
- [Schema Guide](documentation/dbscheme-guide.md)
- [Implementation Plan](wipStatus/IMPLEMENTATION.md)
