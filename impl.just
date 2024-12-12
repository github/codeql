#!/usr/bin/env just --justfile

set allow-duplicate-recipes
set allow-duplicate-variables
set unstable
set quiet

_install LANGUAGE:
    bazel run //{{ trim_end_match(LANGUAGE, '/') }}:install

_build LANGUAGE:
    if [ -n "${SEMMLE_CODE:-}" ]; then \
      cd $SEMMLE_CODE; ./build target/intree/codeql-{{ LANGUAGE }}; \
    else \
      just install {{ LANGUAGE }}; \
    fi

build LANGUAGE: (_build LANGUAGE)
install LANGUAGE: (_install LANGUAGE)

[no-cd, script:'python3', positional-arguments, no-exit-message]
test +ARGS:  # TODO: fuzzy test chooser when no arguments are provided!
    import pathlib
    import subprocess
    import os
    import sys
    # avoid infinite recursion: this happens when test args are of different kinds
    # or for different languages, or also if they are across the external/internal
    # repository boundary
    # TODO: allow some degree of mixing maybe?
    if os.environ.get("CODEQL_JUSTFILE_TEST"):
        print("No common test handler found", file=sys.stderr)
        sys.exit(1)
    os.environ["CODEQL_JUSTFILE_TEST"] = "true"

    flags = [arg for arg in sys.argv[1:] if arg.startswith('-')]
    args = [arg for arg in sys.argv[1:] if not arg.startswith('-')]
    common_path = pathlib.Path(os.path.commonpath(args)).resolve()
    if not common_path.is_dir():
        common_path = common_path.parent
    ret = subprocess.run(
        ['{{ just_executable() }}', 'test'] + flags + [pathlib.Path(a).resolve().relative_to(common_path) for a in args],
        cwd=common_path).returncode
    sys.exit(ret)

[no-cd, positional-arguments]
_run_language_tests LANGUAGE *ARGS: (_build LANGUAGE)
    shift; \
    if [ -n "${SEMMLE_CODE:-}" ]; then \
      $SEMMLE_CODE/target/intree/codeql-{{ LANGUAGE }}/codeql test run "$@"; \
    else \
      codeql test run --search-path={{ source_dir() }} "$@"; \
    fi

[no-cd, positional-arguments]
_run_integration_tests *ARGS:
    if [ -n "${SEMMLE_CODE:-}" ]; then \
      $SEMMLE_CODE/tools/pytest "$@"; \
    else \
      echo "integration tests require running from an internal repository working copy" >&2; \
      exit 1; \
    fi
