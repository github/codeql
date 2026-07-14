"""Per-target Xcode configuration for the `swift_library` under
`//unified/swift-syntax-rs` on macOS.

On macOS, `rules_swift` auto-registers `xcode_swift_toolchain`, whose
analysis reads `cc_toolchain.target_gnu_system_name` and fails on Bazel's
built-in `local_config_cc` (whose triple is literally "local"). Working
around this needs two flags:

- `--xcode_version_config=@local_config_xcode//:host_xcodes` — selects
  `apple_support`'s xcode_config, whose version strings match the ones
  `rules_swift`'s `system_sdk` selects are keyed on.
- `--extra_toolchains=@local_config_apple_cc_toolchains//:all` — forces
  `apple_support`'s CC toolchain ahead of `local_config_cc`.

We apply them via an incoming-edge Starlark transition on the
`swift_library` target itself (through the `xcode_transition_swift_library`
macro below), rather than globally in `.bazelrc`. That keeps every other
target on macOS on Bazel's default CC toolchain (`local_config_cc`) and
avoids materializing the `@local_config_xcode` /
`@local_config_apple_cc_toolchains` repos unless something under
`//unified/swift-syntax-rs` is actually being built.

The transition is placed on `swift_library` — not on the downstream Rust
targets — so the Apple CC toolchain is only used for analyzing the Swift
side. The Rust compilation and any other transitive C/C++ deps stay on
Bazel's default CC toolchain, matching how they build elsewhere in the
repository.

The transition is a no-op on non-macOS platforms.
"""

load("@rules_swift//swift:swift.bzl", "swift_library")
load("//misc/bazel:os.bzl", "os_select")

_XCODE_VERSION_CONFIG = "//command_line_option:xcode_version_config"
_EXTRA_TOOLCHAINS = "//command_line_option:extra_toolchains"

def _transition_impl(settings, attr):
    if attr.os != "macos":
        # Preserve input values so the transitioned configuration is
        # identical to the incoming one (no reconfiguration penalty).
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
    providers = [
        # Only forward the providers a downstream `rust_*` target reads
        # from a `deps` entry. `CcInfo` carries the linking info; forward
        # `OutputGroupInfo` too for `bazel build --output_groups=...`.
        src[DefaultInfo],
    ]
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

    Splits `name` into a private inner target `_impl_<name>` (a plain
    `swift_library`, hidden from wildcards via `tags = ["manual"]`) and a
    public `name` that applies the incoming Xcode-config transition on
    macOS and forwards the inner target's `CcInfo` (and other relevant
    providers) to downstream consumers. Downstream `rust_*` targets can
    depend on `name` as an ordinary `deps` entry — they stay in the
    default configuration; only the `swift_library` sub-graph flips to
    the Apple CC toolchain, and only on macOS.
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
