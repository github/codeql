# Helper recipes

import "build.just"
import "format.just"

# Run language tests for LANGUAGE.
#
# Arguments tagged with `--all-checks=` are held back and only applied when `--all-checks`
# or `+` is passed along, which is how per-language justfiles express the extra checks CI
# runs on top of the default ones.
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
