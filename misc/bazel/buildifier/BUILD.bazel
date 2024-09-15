load("@buildifier_prebuilt//:rules.bzl", "buildifier")

buildifier(
    name = "buildifier",
    exclude_patterns = [
        "./.git/*",
    ],
    lint_mode = "fix",
)
