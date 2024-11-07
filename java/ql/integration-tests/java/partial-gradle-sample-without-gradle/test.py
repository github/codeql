import tempfile
import runs_on
import pathlib


# The version of gradle used doesn't work on java 17
def test(codeql, use_java_11, java, environment):
    gradle_override_dir = pathlib.Path(tempfile.mkdtemp())
    if runs_on.windows:
        (gradle_override_dir / "gradle.bat").write_text("@echo off\nexit /b 2\n")
    else:
        gradlepath = gradle_override_dir / "gradle"
        gradlepath.write_text("#!/bin/bash\nexit 1\n")
        gradlepath.chmod(0o0755)

    environment.add_path(gradle_override_dir)
    codeql.database.create()
