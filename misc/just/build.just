import "defs.just"

_build_dist LANGUAGE: _require_semmle_code (_maybe_build_dist LANGUAGE)

[no-exit-message]
_maybe_build_dist LANGUAGE: (_if_in_semmle_code ('cd "$SEMMLE_CODE"; tools/bazel run //language-packs:intree-' + LANGUAGE) '# using codeql from PATH, if any')

[no-cd, no-exit-message]
_bazel COMMAND *ARGS: (_if_in_semmle_code 'cd "$SEMMLE_CODE"; tools/bazel' 'bazel' COMMAND ARGS)

[no-cd, no-exit-message]
_sembuild *ARGS: (_run_in_semmle_code "./build" ARGS)
