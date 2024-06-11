load("@rules_rust//rust:defs.bzl", "rust_binary")

def codeql_rust_binary(
        name,
        target_compatible_with = None,
        visibility = None,
        symbols_test = True,
        **kwargs):
    # rust_label_name = name + "_single_arch"
    # universal_binary(
    #     name = name,
    #     dep = ":" + rust_label_name,
    #     target_compatible_with = target_compatible_with,
    #     visibility = visibility,
    # )
    rust_binary(
        name = name,
        target_compatible_with = target_compatible_with,
        visibility = visibility,
        **kwargs
    )
    # if symbols_test:
    #     glibc_symbols_check(name = name + "symbols-test", binary = name)
