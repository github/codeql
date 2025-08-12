# Helper build recipes

import "defs.just"

# Build the given language-specific CLI distribution
_build_dist LANGUAGE: _require_semmle_code (_maybe_build_dist LANGUAGE)

# Build the language-specific distribution if we are in an internal repository checkout
# Otherwise, do nothing
[no-exit-message]
_maybe_build_dist LANGUAGE: (_if_in_semmle_code ('cd "$SEMMLE_CODE"; tools/bazel run //language-packs:intree-' + LANGUAGE) '# using codeql from PATH, if any')

# Call bazel. Uses our official bazel wrapper if we are in an internal repository checkout
[no-cd, no-exit-message]
_bazel COMMAND *ARGS: (_if_in_semmle_code 'cd "$SEMMLE_CODE"; tools/bazel' 'bazel' COMMAND ARGS)

# Call sembuild (requires an internal repository checkout)
[no-cd, no-exit-message]
_sembuild *ARGS: (_run_in_semmle_code "./build" ARGS)
