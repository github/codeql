import runs_on


# Deselected on linux-arm64: there the AGP build fails because no linux-aarch64 aapt2 exists, which is unrelated to the AGP/Gradle version incompatibility this test asserts and would otherwise let it pass for the wrong reason.
@(runs_on.x86_64 or runs_on.macos)
def test(codeql, java, gradle_7_3, android_sdk):
    codeql.database.create(_assert_failure=True)
