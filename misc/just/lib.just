# Helper recipes

import "build.just"
import "format.just"

# Run language tests for LANGUAGE.
#
# `--extra-check=` offers a check without running it, and `--all-checks` or `+` runs the
# offered ones. Per-language justfiles supply the offers, which is how the extra checks
# CI runs stay next to the language they belong to.
[no-cd]
[no-exit-message]
[positional-arguments]
@_codeql_test LANGUAGE *ARGS:
    {{ py }} "{{ source_dir() }}/codeql_test_run.py" "$@"

# Run a whole language test suite. The first argument must be a test root. This is
# intended to be called by CI
[no-cd]
[no-exit-message]
[positional-arguments]
@_language_tests *ARGS: _require_semmle_code
    {{ py }} "{{ source_dir() }}/language_tests.py" "$@"

# Run integration tests. Requires an internal repository checkout
[no-cd]
[no-exit-message]
[positional-arguments]
@_integration_test *ARGS: _require_semmle_code
    echo "$CMD_BEGIN-> $SEMMLE_CODE/tools/pytest --codeql=build-as-test $*$CMD_END" >&2
    "$SEMMLE_CODE/tools/pytest" --codeql=build-as-test "$@"
