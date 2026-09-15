import "build.just"

_ql_formatter := if SEMMLE_CODE != "" { '"$SEMMLE_CODE/target/intree/codeql-nolang/codeql"' } else { "codeql" }

_py_formatter := if SEMMLE_CODE != "" { "uv run black" } else { "black" }

_cpp_formatter := if SEMMLE_CODE != "" { "uv run clang-format" } else { "clang-format" }

# The `buildifier` bazel target always covers the whole workspace, so the binary behind
# it is used instead and given paths. That target is a bazel dev dependency and only
# resolves in a build rooted in this repository, so inside the internal repository this
# is left to the buildifier target there, which covers these files as well.
_bazel_formatter := if SEMMLE_CODE != "" { "" } else { "bazel run @codeql//misc/bazel/buildifier:binary --" }

# bazel files are named rather than suffixed, and buildifier has no exclude option of its
# own, so the generated files skipped by the target above are skipped here too.
_bazel_names := "BUILD,BUILD.*,WORKSPACE,WORKSPACE.*,*.bazel,*.bzl,*.sky"

_bazel_generated := "*misc/bazel/3rdparty/*_deps/*"

# `codeql query format` and `clang-format` take files rather than directories, so the
# files are collected by `run_on_files.py`. Arguments are passed positionally so that
# paths containing spaces survive, of which this repository has many.

[no-cd]
[no-exit-message]
[positional-arguments]
_format_ql +ARGS: (_maybe_build_dist "nolang")
    {{ cmd_sep }}{{ py }} "{{ source_dir() }}/run_on_files.py" "*.ql,*.qll" {{ _ql_formatter }} query format --in-place -v -- "$@"{{ cmd_sep }}

[no-cd]
[no-exit-message]
[positional-arguments]
_format_py *ARGS=".":
    {{ cmd_sep }}{{ _py_formatter }} "$@"{{ cmd_sep }}

[no-cd]
[no-exit-message]
[positional-arguments]
_format_cpp *ARGS=".":
    {{ cmd_sep }}{{ py }} "{{ source_dir() }}/run_on_files.py" "*.h,*.cpp" {{ _cpp_formatter }} -i --verbose -- "$@"{{ cmd_sep }}

[no-cd]
[no-exit-message]
[positional-arguments]
_format_bazel *ARGS=".":
    {{ cmd_sep }}if [ -n '{{ _bazel_formatter }}' ]; then {{ py }} "{{ source_dir() }}/run_on_files.py" --absolute --exclude '{{ _bazel_generated }}' "{{ _bazel_names }}" {{ _bazel_formatter }} -mode=fix -lint=fix -- "$@"; fi{{ cmd_sep }}
