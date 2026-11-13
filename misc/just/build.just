# Helper build recipes

import "defs.just"

# Build the given language-specific CLI distribution
_build_dist LANGUAGE: _require_semmle_code (_maybe_build_dist LANGUAGE)

# Build the language-specific distribution if we are in an internal repository checkout
# Otherwise, do nothing
#
# The install log is worth reading only when the install fails, and printing it
# regardless buried whatever was actually asked for underneath it. Note that bazel is
# not quietened any further than that here: unlike an error, a failing test's log is not
# something `--ui_event_filters` can let back through, and a build this long is one to
# see the progress of.
[no-exit-message]
_maybe_build_dist LANGUAGE: (_if_in_semmle_code (f'cd "$SEMMLE_CODE"; tools/bazel test //language-packs:intree-{{ LANGUAGE }}-as-test --test_output=errors') '# using codeql from PATH, if any')

# Call bazel. Uses our official bazel wrapper if we are in an internal repository checkout
[no-cd]
[no-exit-message]
_bazel *ARGS: (_if_in_semmle_code 'cd "$SEMMLE_CODE"; tools/bazel' 'bazel' ARGS)

# Call sembuild (requires an internal repository checkout)
[no-cd]
[no-exit-message]
_sembuild *ARGS: (_run_in_semmle_code (['./build'] ++ ARGS))
