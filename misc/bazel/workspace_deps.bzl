load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
load("@rules_python//python:pip.bzl", "pip_install")

def codeql_workspace_deps(repository_name = "codeql"):
    pip_install(
       name = "swift_codegen_deps",
       requirements = "@%s//swift/codegen:requirements.txt" % repository_name,
    )
    rules_pkg_dependencies()
