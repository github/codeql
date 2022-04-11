load("@//misc/bazel:toolchain.bzl", "codeql_cli_toolchain")

codeql_cli_toolchain(
    name = "codeql-cli",
    path = "{codeql_cli_path}",
)

toolchain(
    name = "codeql-cli-toolchain",
    toolchain = ":codeql-cli",
    toolchain_type = "@//:toolchain_type",
)
