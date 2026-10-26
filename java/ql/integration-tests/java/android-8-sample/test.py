import runs_on


# Put Java 11 on the path so as to challenge our version selection logic: Java 11 is unsuitable for Android Gradle Plugin 8+,
# so it will be necessary to notice Java 17 available in the environment and actively select it.
# This Android Gradle Plugin version ships no linux-aarch64 aapt2, so the build fails on linux-arm64 (macOS arm64 works).
@(runs_on.x86_64 or runs_on.macos)
def test(codeql, use_java_11, java, gradle_8_0, android_sdk):
    codeql.database.create()
