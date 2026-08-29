load("@rules_rust//rust:defs.bzl", "rust_binary")
load("@semmle_code//buildutils-internal:glibc_symbols_check.bzl", "glibc_symbols_check")
load("@semmle_code//buildutils-internal:lipo.bzl", "universal_binary")
load("//misc/bazel:transitions.bzl", "forward_binary_from_transition", "get_transition_attrs")

def _full_lto_transition_impl(_settings, _attr):
    return {"@rules_rust//rust/settings:lto": "fat"}

_full_lto_transition = transition(
    implementation = _full_lto_transition_impl,
    inputs = [],
    outputs = ["@rules_rust//rust/settings:lto"],
)

_full_lto_binary = rule(
    implementation = forward_binary_from_transition,
    attrs = get_transition_attrs(_full_lto_transition),
)

def codeql_rust_binary(
        name,
        full_lto = False,
        target_compatible_with = None,
        visibility = None,
        symbols_test = True,
        **kwargs):
    rust_label_name = "single_arch/" + name
    binary_dep = ":" + rust_label_name
    if full_lto:
        # rustc must consume the LLVM bitcode because the C++ linker may use an
        # incompatible LLVM version.
        kwargs["experimental_use_cc_common_link"] = 0
        lto_label_name = "full_lto/" + name
        _full_lto_binary(
            name = lto_label_name,
            dep = binary_dep,
        )
        binary_dep = ":" + lto_label_name
    universal_binary(
        name = name,
        dep = binary_dep,
        target_compatible_with = target_compatible_with,
        visibility = visibility,
    )
    rust_binary(
        name = rust_label_name,
        **kwargs
    )
    if symbols_test:
        glibc_symbols_check(name = name + "symbols-test", binary = name)
