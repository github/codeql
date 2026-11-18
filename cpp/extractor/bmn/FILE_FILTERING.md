# File Filtering in C++ Build Mode None (BMN) Runner

The C++ BMN runner provides file and directory filtering capabilities to control which source files
are included in the analysis. This is particularly useful for excluding build artifacts or test
files from CodeQL analysis.

**Note**: The behaviour of this implementation follows that of the JavaScript extractor in
`ql/javascript/extractor/src/com/semmle/js/extractor/AutoBuild.java` for what concerns the
`LGTM_INDEX_INCLUDE`, `LGTM_INDEX_EXCLUDE` and `LGTM_INDEX_FILTERS` environment variables and their
interpretation.
For the pattern matching the logic is based on the Java implementation in the `Rewrite` class in
`util-java7/src/com/semmle/util/projectstructure/ProjectLayout.java`.

## Environment Variables

### LGTM_INDEX_INCLUDE

Specifies directories to include in the analysis. If not specified, the root directory is included by default.

**Format**: Newline-separated list of directory paths

**Default**: Current directory (if not specified)

```bash
export LGTM_INDEX_INCLUDE="src
include
lib"
```

**Key behaviors**:
- Paths are treated as relative to the root directory even if they start with '/'
- Empty lines and leading and trailing whitespace are ignored
- Paths starting with `..` or Windows drive prefixes (e.g., `C:\`) are invalid and will cause an error
- If this variable is set, ONLY the specified directories will be included (replaces the default)

### LGTM_INDEX_EXCLUDE

Specifies directories to exclude from the analysis.

**Format**: Newline-separated list of directory paths

```bash
export LGTM_INDEX_EXCLUDE="build
target
node_modules
third_party"
```

**Key behaviors**:
- Works in combination with include directories
- More specific paths take precedence (e.g., if both `build` and `build/important` are specified, the more specific one wins)
- When include and exclude have equal specificity, include takes precedence

### LGTM_INDEX_FILTERS

Advanced filtering using glob-style patterns. This provides fine-grained control over individual file patterns.

**Format**: Newline-separated list of filter rules
**Rule format**: `include: PATTERN` or `exclude: PATTERN`

```bash
export LGTM_INDEX_FILTERS="include: /**/*.cpp
include: /**/*.h
exclude: /**/test/*
exclude: /**/*.generated.cpp"
```

**Pattern syntax**:
- `*` - Matches any characters except `/` (single directory level)
- `**` - Matches any characters including `/` (recursive directory matching)

**Key behaviors**:
- Later rules take precedence over earlier ones (last matching rule wins)
- If no include filters are specified, everything is included by default (then exclusions apply)
- If include filters are specified, everything is excluded by default (then only matches are included)

## Pattern Examples

### Basic Patterns

| Pattern | Matches | Description |
|---------|---------|-------------|
| `/src/*.c` | `/src/main.c`, `/src/lib.c` | C files directly in src |
| `/src/**/*.c` | `/src/main.c`, `/src/utils/helper.c` | C files in src and subdirectories |
| `/**/test.c` | `/test.c`, `/src/test.c`, `/deep/nested/test.c` | Files named test.c anywhere |


### Complex Filtering Examples

#### Example 1: Include only source files, exclude tests
```bash
export LGTM_INDEX_FILTERS="include: /**/*.cpp
include: /**/*.h
exclude: /**/test/*
exclude: /**/*_test.cpp"
```

#### Example 2: Include everything except build artifacts
```bash
export LGTM_INDEX_FILTERS="include: /**/*
exclude: /build/*
exclude: /target/*
exclude: /**/*.o
exclude: /**/*.obj"
```

#### Example 3: Complex project structure
```bash
export LGTM_INDEX_INCLUDE="src
include"
export LGTM_INDEX_EXCLUDE="src/third_party"
export LGTM_INDEX_FILTERS="exclude: /**/*.generated.cpp
include: /src/important_generated.cpp"
```

## Filter Processing Order

The filtering system processes files in the following order:

1. **Basic Include/Exclude** (LGTM_INDEX_INCLUDE/EXCLUDE):
   - Check if file is in an included directory
   - Check if file is in an excluded directory
   - Apply specificity rules (more specific path wins)

2. **Advanced Filtering** (LGTM_INDEX_FILTERS):
   - Apply filter rules in order
   - Later rules override earlier ones
   - Last matching rule determines the result

## Usage Examples

### Command Line Usage

```bash
# Basic directory filtering
export LGTM_INDEX_INCLUDE="src"
export LGTM_INDEX_EXCLUDE="src/tests"
codeql database create db -l cpp --source-root=. --build-mode=none

# Advanced pattern filtering
export LGTM_INDEX_FILTERS="include: /**/*.cpp
exclude: /**/test_*"
codeql database create db -l cpp --source-root=. --build-mode=none

# Combined approach
export LGTM_INDEX_INCLUDE="src
lib"
export LGTM_INDEX_EXCLUDE="lib/third_party"
export LGTM_INDEX_FILTERS="exclude: /**/*.generated.h"
codeql database create db -l cpp --source-root=. --build-mode=none
```

## Troubleshooting

### Common Issues

1. **No files included**: Check that LGTM_INDEX_INCLUDE paths exist and are spelled correctly
2. **Too many files included**: Use LGTM_INDEX_EXCLUDE or exclude filters to remove unwanted files
3. **Pattern not matching**: Remember that patterns must start with `/` and use `/` as path separator

### Debugging Tips

1. **Test patterns**: Use tools like `find` to test glob patterns before using them in filters
2. **Check paths**: Ensure all paths in LGTM_INDEX_INCLUDE/EXCLUDE actually exist
3. **Order matters**: Remember that in LGTM_INDEX_FILTERS, later rules override earlier ones

### Validation

To verify your filtering configuration:

1. Check the CodeQL database creation logs for file counts
2. Query the database for included files: `from File f select f.getRelativePath()`
3. Use integration tests to verify expected behavior
