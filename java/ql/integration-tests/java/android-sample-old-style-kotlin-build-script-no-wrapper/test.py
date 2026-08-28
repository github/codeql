import runs_on


# This Android Gradle Plugin version ships no linux-aarch64 aapt2, so the build fails on linux-arm64 (macOS arm64 works).
@(runs_on.x86_64 or runs_on.macos)
def test(codeql, use_java_17, java, android_sdk, actions_toolchains_file):
    codeql.database.create(_env={"LGTM_INDEX_MAVEN_TOOLCHAINS_FILE": str(actions_toolchains_file)})
