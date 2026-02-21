import? '../../../semmle-code.just'  # internal repo just file, if present
import 'semmle-code-stub.just'

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
export JUST_ERROR := error

tsx := "npx tsx@4.19.0"

default_db_checks := """\
    --check-databases \
    --check-diff-informed \
    --fail-on-trap-errors \
"""

[no-exit-message]
@_require_semmle_code:
    {{ if SEMMLE_CODE == "" { '''
        echo "''' + error + ''' running this recipe requires doing so from an internal repository checkout" >&2
        exit 1
    ''' } else { "" } }}

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

[no-cd, no-exit-message]
_if_in_semmle_code THEN ELSE *ARGS:
    {{ cmd_sep }}{{ if SEMMLE_CODE != "" { THEN } else { ELSE } }} {{ ARGS }}{{ cmd_sep }}
