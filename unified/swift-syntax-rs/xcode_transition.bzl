"""Per-target Xcode configuration for `//unified/swift-syntax-rs` on macOS.

`rules_swift`'s auto-registered `xcode_swift_toolchain` reads
`cc_toolchain.target_gnu_system_name`, which is literally "local" on
Bazel's built-in `local_config_cc`. To make it usable we need:

- `--xcode_version_config=@local_config_xcode//:host_xcodes` — selects
  `apple_support`'s xcode_config (matches `rules_swift`'s `system_sdk` keys).
- `--extra_toolchains=@local_config_apple_cc_toolchains//:all` — forces
  `apple_support`'s CC toolchain ahead of `local_config_cc`.

Applied via an incoming-edge Starlark transition on the `swift_library`
target only (via the `xcode_transition_swift_library` macro), so downstream
Rust targets and the rest of the repo stay on the default CC toolchain and
the `@local_config_*` repos are not materialized otherwise. No-op off macOS.
"""

load("@rules_cc//cc/common:cc_info.bzl", "CcInfo")
load("@rules_swift//swift:swift.bzl", "swift_library")
load("//misc/bazel:os.bzl", "os_select")

_XCODE_VERSION_CONFIG = "//command_line_option:xcode_version_config"
_EXTRA_TOOLCHAINS = "//command_line_option:extra_toolchains"

def _transition_impl(settings, attr):
    if attr.os != "macos":
        # Preserve inputs so the configuration is identical to the incoming one.
        return {
            _XCODE_VERSION_CONFIG: settings[_XCODE_VERSION_CONFIG],
            _EXTRA_TOOLCHAINS: settings[_EXTRA_TOOLCHAINS],
        }
    return {
        _XCODE_VERSION_CONFIG: "@local_config_xcode//:host_xcodes",
        _EXTRA_TOOLCHAINS: (
            list(settings[_EXTRA_TOOLCHAINS]) +
            ["@local_config_apple_cc_toolchains//:all"]
        ),
    }

_xcode_transition = transition(
    implementation = _transition_impl,
    inputs = [_XCODE_VERSION_CONFIG, _EXTRA_TOOLCHAINS],
    outputs = [_XCODE_VERSION_CONFIG, _EXTRA_TOOLCHAINS],
)

def _wrapper_impl(ctx):
    src = ctx.attr.actual[0]
    # Forward the providers a downstream `rust_*` target reads from `deps`:
    # `DefaultInfo`, `CcInfo` (linking info), and `OutputGroupInfo`.
    providers = [src[DefaultInfo]]
    for p in (CcInfo, OutputGroupInfo):
        if p in src:
            providers.append(src[p])
    return providers

_xcode_transition_swift_library_rule = rule(
    implementation = _wrapper_impl,
    attrs = {
        "actual": attr.label(
            mandatory = True,
            cfg = _xcode_transition,
            providers = [CcInfo],
        ),
        "os": attr.string(mandatory = True),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
)

def xcode_transition_swift_library(name, visibility = None, tags = None, target_compatible_with = None, **kwargs):
    """`swift_library` wrapped in the macOS Xcode-config transition.

    Emits a private inner `_impl_<name>` `swift_library` (tagged `manual`)
    and a public `name` that applies the transition on macOS and forwards
    the inner target's providers. Downstream `rust_*` targets depend on
    `name` as usual; only the `swift_library` sub-graph flips toolchain.
    """
    inner_name = "_impl_%s" % name
    swift_library(
        name = inner_name,
        visibility = ["//visibility:private"],
        tags = (tags or []) + ["manual"],
        target_compatible_with = target_compatible_with,
        **kwargs
    )
    _xcode_transition_swift_library_rule(
        name = name,
        visibility = visibility,
        tags = tags,
        target_compatible_with = target_compatible_with,
        actual = ":" + inner_name,
        os = os_select(linux = "linux", macos = "macos", default = "other"),
    )
