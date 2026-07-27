"""Filter the Swift toolchain down to just its Linux runtime shared objects.

The standalone toolchain's `:files` bundles the compiler, host libraries, clang
runtime, plugins, etc. For running a Swift-linked binary we only need the
runtime shared objects in `usr/lib/swift/linux/`.
"""

def _swift_runtime_libs_impl(ctx):
    libs = [
        f
        for f in ctx.files.toolchain
        if "/usr/lib/swift/linux/" in f.path and f.path.endswith(".so")
    ]
    return [DefaultInfo(files = depset(libs))]

swift_runtime_libs = rule(
    implementation = _swift_runtime_libs_impl,
    attrs = {"toolchain": attr.label(allow_files = True)},
)
