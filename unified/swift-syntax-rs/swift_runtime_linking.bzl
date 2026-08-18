"""Expose the selected Swift toolchain's dynamic runtime to native dependents."""

load("@rules_cc//cc/common:cc_info.bzl", "merge_cc_infos")
load("@rules_swift//swift:swift.bzl", "swift_common")

def _swift_runtime_linking_impl(ctx):
    toolchain = swift_common.get_toolchain(ctx)
    if toolchain.dynamic_runtime_cc_info:
        return [toolchain.dynamic_runtime_cc_info]
    return [merge_cc_infos(
        direct_cc_infos = [],
        cc_infos = toolchain.implicit_deps_providers.cc_infos,
    )]

swift_runtime_linking = rule(
    implementation = _swift_runtime_linking_impl,
    toolchains = swift_common.use_toolchain(),
)
