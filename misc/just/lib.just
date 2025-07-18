import "build.just"
import "format.just"

[no-cd, positional-arguments, no-exit-message]
@_codeql_test LANGUAGE BASE_FLAGS ALL_CHECKS_FLAGS EXTRA_ARGS:
    {{ tsx }} "{{ source_dir() }}/codeql-test-run.ts" "$@"

[no-cd, positional-arguments, no-exit-message]
@_language_tests EXTRA_ARGS SOURCE_DIR +ROOTS: _require_semmle_code
    {{ tsx }} "{{ source_dir() }}/language-tests.ts" "$@"



[no-cd, no-exit-message]
_integration_test *ARGS: _require_semmle_code (_run "$SEMMLE_CODE/tools/pytest" ARGS)

[no-cd]
_run +ARGS:
    {{ cmd_sep }}{{ ARGS }}{{ cmd_sep }}

[no-cd]
_run_in DIR +ARGS:
    {{ cmd_sep }}cd "{{ DIR }}"; {{ ARGS }}{{ cmd_sep }}

[no-cd]
_run_in_semmle_code +ARGS: _require_semmle_code (_run_in "$SEMMLE_CODE" ARGS)

[no-cd, positional-arguments, no-exit-message]
@_just +ARGS:
    echo "-> just $@"
    "{{ JUST_EXECUTABLE }}" "$@"

[no-cd, positional-arguments]
@_if_not_on_ci_just +ARGS:
    if [ "${GITHUB_ACTIONS:-}" != "true" ]; then \
        echo "-> just $@"; \
        "$JUST_EXECUTABLE" "$@"; \
    fi
