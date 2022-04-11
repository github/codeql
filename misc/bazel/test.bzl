def _test_script_impl(ctx):
    output = ctx.actions.declare_file("%s.py" % ctx.label.name)
    codeql_cli_path = ctx.toolchains["//:toolchain_type"].codeql_cli.path
    ctx.actions.expand_template(
        template = ctx.file._template,
        output = output,
        substitutions = {
            "{codeql_cli_path}": codeql_cli_path,
            "{test_sources}": str([f.path for f in ctx.files.srcs]),
        },
    )
    return DefaultInfo(
        files = depset([output]),
    )

_test_script = rule(
    implementation = _test_script_impl,
    attrs = {
        "srcs": attr.label_list(allow_files = True),
        "_template": attr.label(default = "//misc/bazel:test.template.py", allow_single_file = True),
    },
    toolchains = ["//:toolchain_type"],
)

def codeql_test(*, name, srcs, deps):
    srcs = native.glob(["test/**/*.ql", "test/**/*.qlref"])
    data = srcs + deps
    script = name + "-script"
    _test_script(
        name = script,
        srcs = srcs,
    )
    native.py_test(
        name = name,
        main = script + ".py",
        srcs = [script],
        data = data,
    )
