# Helper recipes

import "build.just"
import "format.just"

# Run language tests. `BASE_FLAGS` are used by default, `ALL_CHECK_FLAGS` are used if
# `--all-checks` or `+` is passed along in `EXTRA_ARGS`
[no-cd, positional-arguments, no-exit-message]
@_codeql_test LANGUAGE BASE_FLAGS ALL_CHECKS_FLAGS EXTRA_ARGS:
    {{ tsx }} "{{ source_dir() }}/codeql-test-run.ts" "$@"

# Run all language tests in ROOTS for a language. This is intended to be called by CI
[no-cd, positional-arguments, no-exit-message]
@_language_tests EXTRA_ARGS SOURCE_DIR +ROOTS: _require_semmle_code
    {{ tsx }} "{{ source_dir() }}/language-tests.ts" "$@"

# Run integration tests. Requires an internal repository checkout
[no-cd, no-exit-message]
_integration_test *ARGS: _require_semmle_code (_run "$SEMMLE_CODE/tools/pytest" ARGS)

# Generic run command recipe that can be used by other recipes, with nice rendering
[no-cd]
_run +ARGS:
    {{ cmd_sep }}{{ ARGS }}{{ cmd_sep }}

# Run a command in a specific directory
[no-cd]
_run_in DIR +ARGS:
    {{ cmd_sep }}cd "{{ DIR }}"; {{ ARGS }}{{ cmd_sep }}

# Run a command in the internal repository checkout
[no-cd]
_run_in_semmle_code +ARGS: _require_semmle_code (_run_in "$SEMMLE_CODE" ARGS)

# Run a just recipe
[no-cd, positional-arguments, no-exit-message]
@_just +ARGS:
    echo "-> just $@"
    "{{ JUST_EXECUTABLE }}" "$@"

# Run a just recipe, but only if we are not on CI
[no-cd, positional-arguments]
@_if_not_on_ci_just +ARGS:
    if [ "${GITHUB_ACTIONS:-}" != "true" ]; then \
        echo "-> just $@"; \
        "$JUST_EXECUTABLE" "$@"; \
    fi
