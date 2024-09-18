import os
import re
import runs_on


# There is no Java 8 build available for OSX Arm, therefore this test fails.
@runs_on.x86_64
def test(codeql, use_java_8, java, cwd, gradle_6_6_1):
    # Use a custom, empty toolchains.xml file so the autobuilder doesn't see any Java versions that may be
    # in a system-level toolchains file
    toolchains_path = cwd / "toolchains.xml"

    # Ensure the autobuilder *doesn't* see newer Java versions, which it could switch to in order to build the project:
    for k in os.environ:
        if re.match(r"^JAVA_HOME_\d\d_", k):
            del os.environ[k]
    codeql.database.create(
        _assert_failure=True,
        _env={"LGTM_INDEX_MAVEN_TOOLCHAINS_FILE": str(toolchains_path)},
    )
