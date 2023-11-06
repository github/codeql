load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
load("@rules_python//python:repositories.bzl", "py_repositories", "python_register_toolchains")
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")
load(":python_version.bzl", "PYTHON_VERSION")

def codeql_workspace_2(repository_name = "codeql"):
    py_repositories()
    python_register_toolchains(
        name = "python_toolchain",
        python_version = PYTHON_VERSION,
    )
    bazel_skylib_workspace()
    rules_pkg_dependencies()
