"""Per-target Xcode configuration for `//unified/swift-syntax-rs` on macOS.

On macOS, `rules_swift` auto-registers `xcode_swift_toolchain`, whose
analysis reads `cc_toolchain.target_gnu_system_name` and fails on Bazel's
built-in `local_config_cc` (triple is literally "local"). Working around
this needs two flags:

- `--xcode_version_config=@local_config_xcode//:host_xcodes` — selects
  `apple_support`'s xcode_config, whose version strings match the ones
  `rules_swift`'s `system_sdk` selects are keyed on.
- `--extra_toolchains=@local_config_apple_cc_toolchains//:all` — forces
  `apple_support`'s CC toolchain ahead of `local_config_cc`.

We apply them via an incoming-edge Starlark transition on the public
`//unified/swift-syntax-rs` binary/test wrappers rather than globally in
`.bazelrc`. That keeps every other target on macOS on Bazel's default CC
toolchain (`local_config_cc`) and avoids materializing the
`@local_config_xcode` / `@local_config_apple_cc_toolchains` repos unless
something under `//unified/swift-syntax-rs` is actually being built.

The transition is a no-op on non-macOS platforms.
"""

load("@rules_rust//rust:defs.bzl", "rust_binary", "rust_test")
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
    # `ctx.attr.actual` is a list because of the incoming transition.
    src = ctx.attr.actual[0]
    src_default = src[DefaultInfo]
    src_exe = src_default.files_to_run.executable
    src_runfiles = src_default.default_runfiles

    # Copy (not symlink) the executable so that runfiles lookups via
    # `argv[0]` resolve under this wrapper's runfiles tree. This mirrors
    # the pattern used by `//swift:rules.bzl` `_cc_transition_impl`.
    out = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.run_shell(
        inputs = [src_exe],
        outputs = [out],
        command = "cp {src} {dst}".format(src = src_exe.path, dst = out.path),
    )

    # Rewrite runfiles so the wrapped executable is replaced by the copy.
    files = src_runfiles.files.to_list()
    if src_exe in files:
        files.remove(src_exe)
    files.append(out)
    runfiles = ctx.runfiles(files = files)

    return [DefaultInfo(
        executable = out,
        files = depset([out]),
        runfiles = runfiles,
    )]

_xcode_transition_binary_rule = rule(
    implementation = _wrapper_impl,
    attrs = {
        "actual": attr.label(
            mandatory = True,
            cfg = _xcode_transition,
            executable = True,
        ),
        "os": attr.string(mandatory = True),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
    executable = True,
)

_xcode_transition_test_rule = rule(
    implementation = _wrapper_impl,
    attrs = {
        "actual": attr.label(
            mandatory = True,
            cfg = _xcode_transition,
            executable = True,
        ),
        "os": attr.string(mandatory = True),
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
    },
    test = True,
)

def _wrap(inner_rule, wrapper_rule, name, visibility = None, tags = None, target_compatible_with = None, **kwargs):
    """Wrap a Rust target with the Xcode-config transition.

    Splits `name` into a private inner target `_impl_<name>` (built with
    `inner_rule` and hidden from wildcards via `tags = ["manual"]`) and a
    public `name` (built with `wrapper_rule`, which applies the Xcode
    transition on macOS). The `_impl_` prefix — rather than an `_impl`
    suffix — preserves the caller's original suffix, which Bazel requires
    for test rules (target names must end in `_test`)."""
    inner_name = "_impl_%s" % name
    inner_rule(
        name = inner_name,
        visibility = ["//visibility:private"],
        tags = (tags or []) + ["manual"],
        target_compatible_with = target_compatible_with,
        **kwargs
    )
    wrapper_rule(
        name = name,
        visibility = visibility,
        tags = tags,
        target_compatible_with = target_compatible_with,
        actual = ":" + inner_name,
        os = os_select(linux = "linux", macos = "macos", default = "other"),
    )

def xcode_transition_rust_binary(name, **kwargs):
    """`rust_binary` wrapped in the macOS Xcode-config transition."""
    _wrap(rust_binary, _xcode_transition_binary_rule, name = name, **kwargs)

def xcode_transition_rust_test(name, **kwargs):
    """`rust_test` wrapped in the macOS Xcode-config transition."""
    _wrap(rust_test, _xcode_transition_test_rule, name = name, **kwargs)
