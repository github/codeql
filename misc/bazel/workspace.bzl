def _ql_utils_impl(repository_ctx):
    root = repository_ctx.path(Label("//:WORKSPACE.bazel")).realpath.dirname
    repository_ctx.file("BUILD.bazel")
    repository_ctx.template(
        "source_dir.bzl",
        Label("@ql//misc/bazel:source_dir.bzl.tpl"),
        substitutions = {"{root}": str(root)},
    )

_ql_utils = repository_rule(
    implementation = _ql_utils_impl,
)

def ql_workspace():
    _ql_utils(name = "utils")
