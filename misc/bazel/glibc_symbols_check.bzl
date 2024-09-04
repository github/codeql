load("@rules_python//python:defs.bzl", "py_test")

def glibc_symbols_check(name, binary):
    """
    Checks that the supplied binary doesn't use symbols that are not available in older glibc versions.
    """
    # Note this accesses system binaries that are not declared anywhere,
    # thus breaking build hermeticity

    py_test(
        name = name,
        srcs = ["@codeql//misc/bazel/internal:check_glibc_symbols.py"],
        main = "@codeql//misc/bazel/internal:check_glibc_symbols.py",
        data = [binary],
        args = ["$(location :%s)" % binary],
        target_compatible_with = ["@platforms//os:linux", "@codeql//misc/bazel/platforms:bundled"],
        size = "medium",
        tags = ["glibc-symbols-check"],
    )
