import tempfile
import runs_on
import pathlib


# The version of gradle used doesn't work on java 17
def test(codeql, use_java_11, java, environment, check_diagnostics):
    check_diagnostics.redact += ["attributes.java_vendor"]
    # the JDK build provided by the CI runner image may report any number of version components
    # (e.g. `11.0.32` or `11.0.32.1`), so keep only the feature version
    check_diagnostics.replacements = [(r'"11(\.[0-9]+)+"', '"11"')]
    gradle_override_dir = pathlib.Path(tempfile.mkdtemp())
    if runs_on.windows:
        (gradle_override_dir / "gradle.bat").write_text("@echo off\nexit /b 2\n")
    else:
        gradlepath = gradle_override_dir / "gradle"
        gradlepath.write_text("#!/bin/bash\nexit 1\n")
        gradlepath.chmod(0o0755)

    environment.add_path(gradle_override_dir)
    codeql.database.create(build_mode = "none")
