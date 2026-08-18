"""Expose the selected Swift toolchain's dynamic runtime to native dependents."""

load("@rules_swift//swift:swift.bzl", "swift_common")

def _swift_runtime_linking_impl(ctx):
    return [swift_common.get_toolchain(ctx).dynamic_runtime_cc_info]

swift_runtime_linking = rule(
    implementation = _swift_runtime_linking_impl,
    toolchains = swift_common.use_toolchain(),
)
