import runs_on


# Deselected on linux-arm64: the build also fails there due to the x86_64-only aapt2 gap, which would conflate with the AGP/Gradle-incompatibility failure this test asserts.
@(runs_on.x86_64 or runs_on.macos)
def test(codeql, java, gradle_7_3, android_sdk):
    codeql.database.create(_assert_failure=True)
