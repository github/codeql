load("@bazel_skylib//lib:paths.bzl", "paths")
load("//misc/bazel:transitions.bzl", "forward_binary_from_transition", "get_transition_attrs", "universal_binary_transition")

def _universal_binary_impl(ctx):
    # Two cases: Either we're on macos, and we need to lipo the two binaries that the transition generated
    # together, or we're on another platform, where we just copy along the binary, and forward the DefaultInfo data
    binaries = [dep[DefaultInfo].files_to_run.executable for dep in ctx.attr.dep]
    if len(binaries) == 0:
        fail("No executable inputs found")

    (_, extension) = paths.split_extension(binaries[0].basename)
    new_executable = ctx.actions.declare_file(ctx.label.name + extension)

    # We're using a split transition on the `dep` attribute on macos. If we are on macos, that has the function that
    # a) ctx.split_attr has two entries (if we need to retrieve the per-architecture binaries), and that
    # ctx.addr.dep is a list with two elements - one for each platform.
    # While not using a split transition, ctx.attr.dep is a list with one element, as we just have a single platform.
    # We use this to distinguish whether we should lipo the binaries together, or just forward the binary.
    if len(binaries) == 1:
        return forward_binary_from_transition(ctx)
    else:
        ctx.actions.run_shell(
            inputs = binaries,
            outputs = [new_executable],
            command = "lipo -create %s -output %s" % (" ".join([binary.path for binary in binaries]), new_executable.path),
        )
    files = depset(direct = [new_executable])
    runfiles = ctx.runfiles([new_executable]).merge_all([dep[DefaultInfo].default_runfiles for dep in ctx.attr.dep])

    providers = [
        DefaultInfo(
            files = files,
            runfiles = runfiles,
            executable = new_executable,
        ),
    ]
    return providers

universal_binary = rule(
    implementation = _universal_binary_impl,
    attrs = get_transition_attrs(universal_binary_transition),
    doc = """On macOS: Create a universal (fat) binary from the input rule, by applying two transitions and lipoing the result together.
    No-op on other platforms, just forward the binary.""",
)
