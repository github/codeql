load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
load("@rules_python//python:pip.bzl", "pip_install")
load("@bazel_skylib//:workspace.bzl", "bazel_skylib_workspace")

def codeql_workspace_deps(repository_name = "codeql"):
    pip_install(
       name = "codegen_deps",
       requirements = "@%s//misc/codegen:requirements.txt" % repository_name,
    )
    bazel_skylib_workspace()
    rules_pkg_dependencies()
