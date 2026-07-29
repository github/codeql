load("//misc/bazel:os.bzl", "codeql_platform_select")

codeql_platform = codeql_platform_select(
    linux64 = "linux64",
    linux_arm64 = "linux-arm64",
    osx64 = "osx64",
    win64 = "win64",
)
