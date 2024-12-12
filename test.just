import 'build.just'

[no-cd, positional-arguments, no-exit-message]
@_language_tests LANGUAGE *ARGS: (_build LANGUAGE)
    shift; \
    if [ -n "${SEMMLE_CODE:-}" ]; then \
      CODEQL_CONFIG_FILE= $SEMMLE_CODE/target/intree/codeql-{{ LANGUAGE }}/codeql test run -j0 "$@"; \
    else \
      codeql test run --search-path={{ source_dir() }} -j0 "$@"; \
    fi

[no-cd, positional-arguments, no-exit-message]
@_integration_tests *ARGS: (_require_semmle_code "integration tests")
    $SEMMLE_CODE/tools/pytest "$@"

[group('test'), no-cd, script:'python3', positional-arguments, no-exit-message]
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

alias t := test
