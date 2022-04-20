load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

def codeql_workspace_deps():
    rules_pkg_dependencies()
