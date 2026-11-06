# The first definition of a variable wins, not the last, so this order is what lets the
# internal file set `SEMMLE_CODE` while the stub is the fallback when it is absent.
# Swapped, the stub wins even where the real file exists and that checkout then behaves
# as if it were external. Nothing here can catch that: with the file absent, as it
# always is in this repository, both orders evaluate the same.
import? '../../../semmle-code.just' # internal repo just file, if present
import 'semmle-code-stub.just'

# `set lists` is what lets recipes forward argument lists without encoding them as
# whitespace separated strings. It is still unstable as of just 1.58.
set unstable
set lists
set fallback
set allow-duplicate-recipes
set allow-duplicate-variables

export PATH_SEP := if os() == "windows" { ";" } else { ":" }
export JUST_EXECUTABLE := just_executable()

# MSYS2 rewrites arguments that look like paths as it hands them to a native program,
# which mangles bazel's `//target` labels. Set once here rather than at each bazel call:
# a call that forgets it works everywhere except Windows, which is where nobody looks.
# The price of setting it once is that it covers every command a recipe runs, so a tool
# that wants Windows path conversion has to ask for it back.
export MSYS2_ARG_CONV_EXCL := if os() == "windows" { "*" } else { "" }

error := f'{{ style("error") }}error{{ NORMAL }}: '

# The separator line, sized to the terminal.
#
# `stty` rather than `tput`: it needs no terminfo, so it survives `TERM=dumb`, and reads
# the terminal from stdin, so it answers when stdout is piped. The arithmetic is in the
# shell because just has no integers.
#
# With no terminal the value is non-numeric and this falls back to a fixed 57 columns.
# That is a branch, not a platform test: just runs `sh` everywhere.
#
# `JUST_CMD_RULE` is the whole separator and lands in a shell script, so a hand-set value
# has to be a shell comment, every line of it, or it runs. Left unchecked: setting it at
# all means being able to run commands already, so there is nothing to defend.
#
# Exported and preferred over measuring: `shell()` runs on every parse, so a forwarded
# verb would otherwise re-measure in every child it spawns, and `if` is lazy in its
# branches. Inheritance needs a process, so a `mod` measures for itself; presetting
# `JUST_CMD_RULE` skips measuring entirely.
_given_horizontal_rule := env('JUST_CMD_RULE', '')

_horizontal_rule := if _given_horizontal_rule == '' { shell('''
    w=$(stty size 2>/dev/null | cut -d" " -f2)
    case "$w" in '' | *[!0-9]*) w=57 ;; esac
    printf "%*s" $w "" | tr " " '#'
''') } else { _given_horizontal_rule }

export JUST_CMD_RULE := _horizontal_rule

cmd_sep := "\n" + _horizontal_rule + "\n"
export CMD_BEGIN := style("command") + cmd_sep
export CMD_END := cmd_sep + NORMAL
export JUST_ERROR := error

py := "python3"

default_db_checks := ['--check-databases', '--check-diff-informed', '--fail-on-trap-errors']

[no-exit-message]
@_require_semmle_code:
    {{ if SEMMLE_CODE == "" { f'''
        echo "{{ error }}running this recipe requires doing so from an internal repository checkout" >&2
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

[no-cd]
[no-exit-message]
[positional-arguments]
@_just +ARGS:
    echo "-> just $@"
    "{{ JUST_EXECUTABLE }}" "$@"

[no-cd]
[positional-arguments]
@_if_not_on_ci_just +ARGS:
    if [ "${GITHUB_ACTIONS:-}" != "true" ]; then \
        echo "-> just $@"; \
        "$JUST_EXECUTABLE" "$@"; \
    fi

[no-cd]
[no-exit-message]
_if_in_semmle_code THEN ELSE *ARGS:
    {{ cmd_sep }}{{ if SEMMLE_CODE != "" { THEN } else { ELSE } }} {{ ARGS }}{{ cmd_sep }}
