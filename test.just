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

[no-cd, script:'python3', positional-arguments, no-exit-message]
_unit_tests *ARGS:
    from pathlib import Path as P
    import subprocess
    import os
    import sys
    import shutil

    def bazel_path(a, cwd):
        return P(a).resolve().joinpath("...").relative_to(cwd)

    semmle_code = os.environ.get("SEMMLE_CODE")
    flags = [arg for arg in sys.argv[1:] if arg.startswith('-')]
    args = [arg for arg in sys.argv[1:] if not arg.startswith('-')]
    if semmle_code:
        cwd = P(semmle_code)
        bazel = shutil.which("bazel", path=cwd / "tools")
        ql = P("ql")
        args[:] = [bazel_path(a, cwd) for a in args]
        args[:] = [f"@codeql//{a.relative_to(ql)}"
                   if a.parts[0] == "ql" else f"//{a}" for a in args]
    else:
        cwd = P("{{ source_dir() }}").resolve()
        bazel = shutil.which("bazel")
        args[:] = [f"//{bazel_path(a, cwd)}" for a in args]
    res = subprocess.run([bazel, "test"] + flags + args, cwd=cwd).returncode
    sys.exit(res)

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
