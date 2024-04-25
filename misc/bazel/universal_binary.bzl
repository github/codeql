load("@apple_support//rules:universal_binary.bzl", _universal_binary = "universal_binary")

def wrap_as_universal_binary(rule, *, name, visibility = None, **kwargs):
    internal_name = "internal/%s" % name
    universal_name = "universal/%s" % name
    rule(
        name = internal_name,
        visibility = ["//visibility:private"],
        **kwargs
    )
    _universal_binary(
        name = universal_name,
        target_compatible_with = ["@platforms//os:macos"],
        binary = internal_name,
        visibility = ["//visibility:private"],
    )
    native.alias(
        name = name,
        actual = select({
            "@platforms//os:macos": universal_name,
            "//conditions:default": internal_name,
        }),
        visibility = visibility,
    )
