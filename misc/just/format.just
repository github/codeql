import "build.just"

_ql_formatter := if SEMMLE_CODE != "" { '"$SEMMLE_CODE/target/intree/codeql-nolang/codeql"' } else { "codeql" }

_py_formatter := if SEMMLE_CODE != "" { "uv run black" } else { "black" }

_cpp_formatter := if SEMMLE_CODE != "" { "uv run clang-format" } else { "clang-format" }

# The `buildifier` bazel target always covers the whole workspace, so the binary behind
# it is used instead and given paths. bazel is asked from this repository's own root,
# even when it sits inside the internal one, so that the files being formatted and the
# buildifier formatting them come from the same checkout: each repository then answers
# for its own bazel files, with its own pin and its own list of what is generated. This
# is the opposite of building, where a target needs the enclosing workspace to resolve
# at all, hence `_bazel` in build.just going the other way.
_bazel_workspace := quote(parent_directory(parent_directory(source_dir())))

_bazel_formatter := "bazel run --noshow_progress --ui_event_filters=,+error,+fail @buildifier_prebuilt//:buildifier --"

# bazel files are named rather than suffixed, and buildifier has no exclude option of its
# own, so the generated files skipped by the target above are skipped here too. bazel
# knows `BUILD` and `WORKSPACE` by those names and everything else by the `.bazel`
# extension, so a file named `BUILD.<anything>` else is a template or a generator's input
# rather than a bazel file, and is none of the formatter's business to parse.
#
# As with the QL formatter, buildifier only names what it rewrote if it also accounts for
# every file it did not, so that accounting is dropped. It counts the warnings it could
# not fix there, which are left for linting to report rather than raised on every format.
_bazel_names := "BUILD,WORKSPACE,*.bazel,*.bzl,*.sky"

_bazel_generated := "*misc/bazel/3rdparty/*_deps/*"

_bazel_accounting := ': applied fixes, [0-9]+ warnings left$'

# `codeql query format` and `clang-format` take files rather than directories, so the
# files are collected by `run_on_files.py`. Arguments are passed positionally so that
# paths containing spaces survive, of which this repository has many.
#
# The files that were rewritten are worth reporting, but `codeql query format` only
# names those once it also names every file it leaves alone, which buries them under
# thousands of lines. So it is asked for all of it and the lines about files it did not
# touch are dropped. Only those are dropped, so errors still come through, as does
# anything unforeseen.

[no-cd]
[no-exit-message]
[positional-arguments]
_format_ql +ARGS: (_maybe_build_dist "nolang")
    {{ cmd_sep }}{{ py }} "{{ source_dir() }}/run_on_files.py" --drop '^Formatting ' --drop '^No change for ' "*.ql,*.qll" {{ _ql_formatter }} query format --in-place -v -- "$@"{{ cmd_sep }}

[no-cd]
[no-exit-message]
[positional-arguments]
_format_py *ARGS=".":
    {{ cmd_sep }}{{ _py_formatter }} "$@"{{ cmd_sep }}

[no-cd]
[no-exit-message]
[positional-arguments]
_format_cpp *ARGS=".":
    {{ cmd_sep }}{{ py }} "{{ source_dir() }}/run_on_files.py" "*.h,*.cpp" {{ _cpp_formatter }} -i -- "$@"{{ cmd_sep }}

[no-cd]
[no-exit-message]
[positional-arguments]
_format_bazel *ARGS=".":
    {{ cmd_sep }}export MSYS2_ARG_CONV_EXCL="*"; {{ py }} "{{ source_dir() }}/run_on_files.py" --absolute --chdir {{ _bazel_workspace }} --drop '{{ _bazel_accounting }}' --exclude '{{ _bazel_generated }}' "{{ _bazel_names }}" {{ _bazel_formatter }} -mode=fix -lint=fix -v -- "$@"{{ cmd_sep }}
