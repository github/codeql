codeql_platform = select({
    "@platforms//os:linux": "linux64",
    "@platforms//os:macos": "osx64",
    "@platforms//os:windows": "win64",
})

_paths_bzl = """
def source_dir():
    return '%s/' + native.package_name()
"""

def _ql_utils_impl(repository_ctx):
    root = repository_ctx.path(Label("@ql//:WORKSPACE.bazel")).realpath.dirname
    repository_ctx.file("BUILD.bazel")
    repository_ctx.file("paths.bzl", content = _paths_bzl % root)

ql_utils = repository_rule(
    implementation = _ql_utils_impl,
)
