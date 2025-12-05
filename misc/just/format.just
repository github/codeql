import "build.just"

[no-cd, no-exit-message]
_format_ql +ARGS: (_maybe_build_dist "nolang") (
    _if_in_semmle_code
        '"$SEMMLE_CODE/target/intree/codeql-nolang/codeql"'
        'codeql'
    ("query format --in-place -v $(find " + ARGS + " -type f -name '*.ql' -or -name '*.qll')")
)

[no-cd, no-exit-message]
_format_py *ARGS=".": (_if_in_semmle_code "uv run black" "black" ARGS)

[no-cd, no-exit-message]
_format_cpp *ARGS=".": (
    _if_in_semmle_code
        "uv run clang-format"
        "clang-format"
    "-i --verbose $(find " + ARGS + " -type f -name '*.h' -or -name '*.cpp')"
)
