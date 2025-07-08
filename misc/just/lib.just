set fallback
set allow-duplicate-recipes
set allow-duplicate-variables
set unstable

export PATH_SEP := if os() == "windows" { ";" } else { ":" }
export JUST_EXECUTABLE := just_executable()

error := style("error") + "error" + NORMAL + ": "
cmd_sep := "\n#--------------------------------------------------------\n"
export CMD_BEGIN := style("command") + cmd_sep
export CMD_END := cmd_sep + NORMAL

tsx := "npx tsx@4.19.0"

import? '../../../semmle-code.just'  # internal repo just file, if present
import 'semmle-code-stub.just'


[no-exit-message]
@_require_semmle_code:
    {{ if SEMMLE_CODE == "" { '''
        echo "''' + error + ''' running this recipe requires doing so from an internal repository checkout" >&2
        exit 1
    ''' } else { "" } }}

_build_dist LANGUAGE: _require_semmle_code (_maybe_build_dist LANGUAGE)

[no-exit-message]
_maybe_build_dist LANGUAGE:
    {{ cmd_sep }}{{ if SEMMLE_CODE == "" { '# using codeql from PATH, if any' } else { 'cd "$SEMMLE_CODE"; ./build target/intree/codeql-' + LANGUAGE } }}{{ cmd_sep }}


default_db_checks := """\
    --check-databases \
    --check-diff-informed \
    --fail-on-trap-errors \
"""

[no-cd, positional-arguments, no-exit-message]
@_codeql_test LANGUAGE BASE_FLAGS ALL_CHECKS_FLAGS EXTRA_ARGS:
    {{ tsx }} "{{ source_dir() }}/codeql-test-run.ts" "$@"

[no-cd, positional-arguments, no-exit-message]
@_language_tests EXTRA_ARGS SOURCE_DIR +ROOTS: _require_semmle_code
    {{ tsx }} "{{ source_dir() }}/language-tests.ts" "$@"

[no-cd, no-exit-message]
_ql_format +ARGS: (_maybe_build_dist "nolang")
    {{ cmd_sep }}{{ if SEMMLE_CODE != "" { '"$SEMMLE_CODE/target/intree/codeql-nolang/codeql"' } else { 'codeql' } }} query format --in-place $(find {{ ARGS }} -type f -name '*.ql' -or -name '*.qll'){{ cmd_sep }}


[no-cd, no-exit-message]
_bazel COMMAND *ARGS:
    {{ cmd_sep }}{{ if SEMMLE_CODE != "" { 'cd "$SEMMLE_CODE"; tools/bazel' } else { 'bazel' } }} {{ COMMAND }} {{ ARGS }}{{ cmd_sep }}

[no-cd, no-exit-message]
_sembuild *ARGS: (_run_in_semmle_code "./build" ARGS)

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
_just +ARGS:
    "{{ JUST_EXECUTABLE }}" "$@"

[no-cd]
_black *ARGS=".": (_run "uv" "run" "black" ARGS)
