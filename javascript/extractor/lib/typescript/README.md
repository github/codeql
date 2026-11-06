TypeScript parser wrapper
-------------------------

The TypeScript "parser wrapper" is a Node.js program launched from the JavaScript
extractor in order to extract TypeScript code.

The two processes communicate via a command/response protocol via stdin/stdout.

Debugging
---------

To debug the parser script:

1. Launch an extraction process with the environment variable `SEMMLE_TYPESCRIPT_NODE_FLAGS`
   set to `--inspect`, or `--inspect-brk` if you wish to pause on entry.

2. Open VSCode and choose "Debug: Attach to Node process" from the command palette, and
   choose the process that looks like the parser-wrapper.

Building and running
--------------------

The wrapper uses the exact `typescript@7.1.0-beta` package for both
compilation/type checking and the native runtime. Its integrity and those of all
platform-specific optional dependencies are recorded in `package-lock.json`.

```sh
npm ci
npm run build
npm test
node build/main.js --version
```

Node.js 16.20.0 is the minimum supported runtime, matching the pinned TypeScript
package's engine requirement. The existing Bazel toolchain uses Node.js 18.15.0
and does not need an upgrade. Build scripts invoke TypeScript's
`lib/tsc.js` launcher explicitly because these Node.js versions cannot load its
extensionless ESM `bin/tsc` entry point. The installed wrapper must include its
`package.json` to retain the ESM package boundary.

The existing TSLint rules require the legacy JavaScript compiler API, not the
native TypeScript 7 API. If compatible TSLint tooling is not already installed,
run it separately without replacing the wrapper's build/runtime dependency:

```sh
npm exec --yes --package=tslint@6.1.3 --package=typescript@5.9.2 -- tslint --project .
```

The wrapper always uses the bundled TypeScript dependency.
`SEMMLE_TYPESCRIPT_HOME` is no longer supported and is ignored.

Distribution packaging
----------------------

The Bazel build produces two archives: `:typescript` (`javascript.zip`) contains
the compiled ESM wrapper and JavaScript API; `:native` (`native.zip`) contains the
matching native packages for the target CodeQL distribution:

| Distribution  | Native packages                                                               |
| ------------- | ----------------------------------------------------------------------------- |
| `linux64`     | `@typescript/typescript-linux-x64`                                            |
| `linux-arm64` | `@typescript/typescript-linux-arm64`                                          |
| `osx64`       | `@typescript/typescript-darwin-arm64` and `@typescript/typescript-darwin-x64` |
| `win64`       | `@typescript/typescript-win32-x64`                                            |

The build installs the selected packages explicitly with `--force --no-save`,
using the pinned versions and integrities in the lockfile. Merely passing
`--force` to `npm ci` still filters optional dependencies by the build host.
`package-runtime.mjs` verifies the native package versions and marks executables
as `0755` before ZIP creation. The common CodeQL archive contains the wrapper;
the architecture archive installs native packages into
`tools/typescript-parser-wrapper/node_modules/@typescript`. Both archives must
be installed, with executable permissions preserved. No separate TypeScript
installation is needed.

Run the installed-package smoke test with:

```sh
bazel test //javascript/extractor/lib/typescript:package-test
```

It checks all distribution selections, mismatched runtime rejection, common/arch
ZIP separation and executable metadata, then installs the merged archives with
the production `ripunzip` and parses TS, TSX, and malformed source through the
installed JSON protocol. It runs on the host platform and uses Bazel's Node.js
runtime. The Java extractor test suite also installs both ZIPs and restores
executable permissions using their central-directory metadata.

All four distribution runtime ZIPs have been cross-assembled and inspected.
Installed parsing has been verified with Node.js 18.15.0 on macOS arm64 and on
macOS x64 through Rosetta. CI integration tests have also passed on Linux x64,
Linux arm64, and Windows x64, including Windows 2022.

Native lifecycle
----------------

A single native API/process is created lazily and reused across files and
prepare-files batches. Each file still owns a separate program: AST projection
and JSON serialization finish before the program is disposed, including on
failure. Program disposal releases its snapshot and reference-counted source-file
caches without restarting the compiler. Reset closes the API, and the next parse
creates a new one. Quit, EOF, failure, and completion of single-file mode also
close the API.

Native stderr is inherited separately from the JSON stdout protocol. Syntax
diagnostics remain successful AST responses; native, I/O, and protocol failures
are reported on stderr and terminate the wrapper with a nonzero exit status.
Reset, quit, EOF, and failure invalidate queued prefetch work; quit also closes
stdin without requiring the sender to close its pipe.

AST projection and regression tests
-----------------------------------

The wrapper targets the native `typescript/sync` and `typescript/ast` entry
points, using the same pinned dependency in the production ESM build.
`npm test` builds the production wrapper with the pinned compiler and runs
`test/wrapper.test.mjs` and `test/lifecycle.test.mjs` against its compiled output,
copied with its ESM package boundary into temporary installations. No separate
probe installation or legacy compiler is needed for these tests.

AST nodes are explicitly projected into plain objects before their native
program is disposed. Syntax-kind and node-flag metadata are sent unchanged.
Projection checks only the whitelisted properties applicable to each syntax kind,
including optional properties, and falls back to the full whitelist for unknown
kinds. `src/ast_extractor.ts` loads the private
`dist/api/node/protocol.generated.js` metadata once from the locally installed,
pinned TypeScript dependency.
Updating TypeScript may require adapting this internal path or metadata format.
Scalar getters and kind-specific booleans are handled separately.
The Java converter consumes native fields directly, including `postfixToken`,
`defaultType`, and import attributes, and recognizes the native `EndOfFile`
spelling. Namespace classification and variable declaration kinds are derived
in Java without synthetic flags or properties.

The tests cover AST projection, metadata, UTF-16 source positions, syntax
diagnostics, TSX, repeated parses, native process reuse and disposal, the child memory
budget, reset/quit/EOF, cancelled prefetch, the ignored legacy override, and fatal native
failures. Run them with Node.js 16.20.0 to verify the minimum supported runtime.

Compatibility and regression coverage
------------------------------------

Native interface `extends` and class `implements` elements are type references.
The Java converter handles these using its existing type conversion, preserving
generic arguments and qualified names without rewriting their node kinds.

The native parser still produces ASTs for legacy `assert { ... }` import
assertions, but adds diagnostic 2880. The wrapper excludes only that diagnostic
to preserve previously accepted syntax; genuine syntax diagnostics are unchanged.
Import-attribute names and values are explicitly serialized. Their absence
from the old wrapper's JSON was a bug: the old Java converter expected `key`/`value`,
but the old filter exposed neither correctly. Java now reads the native `name`/`value`
fields. The corresponding TRAP expectation was regenerated; existing QL
expectations did not need changes.

Rescanning preserves token text and offsets while retaining the original
pre-rescan token kinds on the wire. In particular, regex and template-tail tokens
keep the classifications expected by existing TRAP tests.

Source-phase imports (`import source wasm from "./module.wasm"`) are accepted.
Their declaration, imported path, and variable bindings use the existing import
representation; the schema does not yet distinguish the source phase. The new
`TypeScript/SourceImports` QL test covers these bindings.

Validation on October 19, 2026 passed the pinned-compiler build/type check,
existing TSLint rules, parser compatibility and lifecycle tests,
500 Java tests, 68 TypeScript QL tests, the syntax-error query test, both extraction
diagnostic integration tests, and the installed-package smoke test. The
internal-error integration test deliberately terminates the native child rather
than relying on the old parser's stack overflow.

All 19 production-output regression tests also pass on Node.js 16.20.0, the
minimum supported runtime.

For QL tests, install the newly built extractor and explicitly select it; otherwise
the CLI may silently exercise an older installed extractor:

```sh
# From the repository root, with the Java extractor build dependencies available:
bazel run //javascript:install
codeql resolve languages --search-path=javascript/extractor-pack:. --format=json
codeql test run -j4 --search-path=javascript/extractor-pack:. \
  javascript/ql/test/library-tests/TypeScript \
  javascript/ql/test/query-tests/LanguageFeatures/SyntaxError
```

Performance comparison
----------------------

The current shared-API implementation was compared with refreshed `main` at
`fb0ba8c8a8a` on October 21, 2026. Both ran on macOS arm64 with Node.js 18.15.0;
`main` was built and run with TypeScript 5.9.2, and this branch used the pinned
7.1 native compiler. These are medians of five fresh-process runs after one
warm-up per variant and workload, alternating variant order:

| Workload | Main time | Branch time | Main combined RSS | Branch combined RSS |
| --- | --- | --- | --- | --- |
| 104 TypeScript fixtures (33,779 bytes) | 0.081 s | 0.120 s | 105.5 MiB | 110.4 MiB |
| Five parses of TypeScript's 588,128-byte declaration file | 0.886 s | 0.992 s | 263.7 MiB | 247.2 MiB |

The branch takes 47.3% more time on the fixtures and 11.9% more on the declaration
workload. Sampled combined RSS is 4.7% higher and 6.3% lower, respectively.
Both variants parse identical inputs. Timing starts after the metadata handshake
and includes prepare-files, AST extraction, serialization, and protocol responses,
including the branch's first native-process startup. It excludes Java conversion
and database import. RSS is the maximum sampled sum of Node and its native
descendants, sampled at a nominal 5 ms interval; short-lived peaks may be missed.
Current `main` includes parser cleanup absent from the older baseline below.

### Historical and API-lifetime comparisons

The initial implementation created a native process per file. On macOS arm64
with Node.js 18.15.0, a comparison against the pre-migration wrapper from
`1971c368e1d` compiled with TypeScript 5.9.2 gave these medians over three runs:

| Workload                                                  | 5.9.2 time | 7.1 time | 5.9.2 combined RSS | 7.1 combined RSS |
| --------------------------------------------------------- | ---------- | -------- | ------------------ | ---------------- |
| 103 TypeScript fixtures (33,589 bytes)                    | 0.237 s    | 1.349 s  | 124.1 MiB          | 113.9 MiB        |
| Five parses of TypeScript's 588,128-byte declaration file | 0.991 s    | 1.116 s  | 269.3 MiB          | 249.1 MiB        |

Timing covers prepare-files, extraction, serialization, and protocol responses
after the metadata handshake, not Java conversion or database import. Combined
RSS is the maximum sampled sum of Node and its native descendants, sampled every
5 ms; short-lived peaks may be missed. The per-file native process costs about
5.7x on tiny files and 1.13x on the declaration workload, while measured memory is
slightly lower.

A follow-up comparison on October 21, 2026, using the same platform and Node.js
version, measured the per-file and shared-API lifetimes directly (medians of three
runs):

| Workload | Per-file API time | Shared API time | Per-file combined RSS | Shared combined RSS |
| --- | --- | --- | --- | --- |
| 104 TypeScript fixtures (33,779 bytes) | 1.017 s | 0.118 s | 115.8 MiB | 109.4 MiB |
| Five parses of the same declaration file | 1.044 s | 0.985 s | 250.2 MiB | 260.2 MiB |

AST responses were byte-identical between lifetimes. A longer shared-API run on
Node.js 26.7.0 processed 50,000 distinct generated TypeScript files: native RSS
was 27.9 MiB after 1,000 files and 30.4 MiB after 50,000, while combined RSS
stabilized around 176 MiB. Another run completed 500 parses of the declaration
file with peak native RSS of 56.5 MiB. These workloads showed no unbounded
per-file retention, so the wrapper reuses the API without a fixed batch limit.
