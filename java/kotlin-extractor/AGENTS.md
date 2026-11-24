# Kotlin extractor development

## Versioned extractor packaging

Extractors ship as `codeql-extractor-kotlin-<variant>-<version>.jar`, with `standalone` and `embeddable` variants. `VERSIONS` in `versions.bzl` lists compiler baselines; the Bazel `many` target builds all variants and versions. The packaged test wrapper selects the newest baseline not newer than `kotlinc` using `pick-kotlin-version.py` and `kotlin-versions.list`, ignoring prerelease suffixes. Compiler and extractor versions need not match exactly; selection alone does not prove compatibility with a newer compiler.

## Compiler compatibility patches

- Patches live in `src/main/kotlin/utils/versions/v_<version>/`, replacing version dots with underscores.
- `get_compatilibity_sources` in `versions.bzl` selects the newest applicable file per filename; earlier files remain active until replaced. Comparisons ignore prerelease suffixes.
- Add same-filename replacements at the first compiler baseline needing them; preserve older implementations. Put shared code outside `utils/versions`.

## Compiler and runtime selection

From the repository root, replace `<version>` with a baseline from `VERSIONS`:

```sh
java/kotlin-extractor/dev/kotlinc --select <version>
export PATH="$PWD/java/kotlin-extractor/dev:$PATH"
CODEQL_KOTLIN_SINGLE_VERSION=<version> bazel build //java/kotlin-extractor
```

- Rebuild the Java extractor pack used by your test environment; building a JAR alone does not refresh it. Use that environment's packaging target, not a stale distribution.
- List available packs with `codeql resolve languages --format=json`, then check which Java pack the test invocation actually uses, including overrides. With `JAVA_ROOT` set to that path, check `kotlinc -version`, run `python3 "$JAVA_ROOT/tools/pick-kotlin-version.py" "@$JAVA_ROOT/tools/kotlin-versions.list"`, and verify the matching JAR exists there. QL tests use the standalone variant.
- Use a runtime JDK supported by the selected compiler; check it separately because the wrapper omits it from version output. Preserve Bazel's configured toolchain.

## Testing

- For extractor changes, cover applicable cases in both `java/ql/test-kotlin1` (K1) and `java/ql/test-kotlin2` (K2); neither substitutes for the other. These sibling suites are validation references, not directories governed by this file.
- Run QL suites with `codeql test run -j<threads> <suite>`, optionally sharding with `--slice=N/M`. Allow modest parallelism, but limit concurrent tests, builds, and memory use to avoid exhausting local resources. Run every shard for full coverage and aggregate failures.
- `java/ql/integration-tests/kotlin` uses the integration-test pytest harness, not `codeql test run`. Run relevant platform cases separately using the configured harness and fixtures.
- All applicable tests must pass when testing is authorised. After runner changes, pass one representative test before a matrix. Respect explicit requests not to run tests and report coverage gaps rather than claiming completion.
- Never disable or weaken tests without human approval. Before accepting expected-output changes, verify compiler/extractor/JDK selection, investigate the cause, and inspect the full diff. Do not use `--learn` for unexplained changes.
