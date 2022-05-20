load("@rules_pkg//:mappings.bzl", "pkg_attributes", "pkg_files")

def _runfiles_group_impl(ctx):
    files = []
    for src in ctx.attr.srcs:
        rf = src[DefaultInfo].default_runfiles
        if rf != None:
            files.append(rf.files)
    return [
        DefaultInfo(
            files = depset(transitive = files),
        ),
    ]

_runfiles_group = rule(
    implementation = _runfiles_group_impl,
    attrs = {
        "srcs": attr.label_list(),
    },
)

def pkg_runfiles(*, name, srcs, **kwargs):
    internal_name = "_%s_runfiles" % name
    _runfiles_group(
        name = internal_name,
        srcs = srcs,
    )
    kwargs.setdefault("attributes", pkg_attributes(mode = "0755"))
    pkg_files(
        name = name,
        srcs = [internal_name],
        **kwargs
    )
