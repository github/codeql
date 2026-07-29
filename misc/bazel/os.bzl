""" Os detection facilities. """

def codeql_platform_select(
        ctx = None,
        *,
        linux64 = None,
        linux_arm64 = None,
        osx64 = None,
        win64 = None,
        otherwise = None):
    """
    Choose a value based on the target CodeQL platform, discriminating the four platforms CodeQL
    knows about: `linux64` (Linux on x86_64), `linux_arm64` (Linux on arm64), `osx64` (macOS, any
    architecture) and `win64` (Windows on x86_64). Any platform left unspecified uses `otherwise`.

    There is deliberately no fallback between `linux64` and `linux_arm64`: if you want the same value
    for both (i.e. you only care about the OS, not the architecture), use `os_select` instead.

    This works both in a macro context (`ctx = None`, returning a `select`) and in a rule context
    (passing `ctx`, which then needs `OS_DETECTION_ATTRS` on the rule attributes).
    """

    def _or_otherwise(value):
        return value if value != None else otherwise

    choices = {
        "//misc/bazel:linux_arm64": _or_otherwise(linux_arm64),
        "@platforms//os:linux": _or_otherwise(linux64),
        "@platforms//os:macos": _or_otherwise(osx64),
        "@platforms//os:windows": _or_otherwise(win64),
    }
    if not ctx:
        return select({
            setting: v
            for setting, v in choices.items()
            if v != None
        })

    def has(constraint):
        return ctx.target_platform_has_constraint(getattr(ctx.attr, "_%s_constraint" % constraint)[platform_common.ConstraintValueInfo])

    if has("linux"):
        result = choices["//misc/bazel:linux_arm64"] if has("arm64") else choices["@platforms//os:linux"]
    elif has("macos"):
        result = choices["@platforms//os:macos"]
    elif has("windows"):
        result = choices["@platforms//os:windows"]
    else:
        fail("Unknown OS detected")
    if result == None:
        fail("platform not supported by %s" % ctx.label)
    return result

def os_select(
        ctx = None,
        *,
        linux = None,
        windows = None,
        macos = None,
        posix = None,
        default = None):
    """
    Choose a value based on the target OS, ignoring the architecture. This is a thin, OS-only wrapper
    around `codeql_platform_select` (Linux gets the same value on both x86_64 and arm64).
    `posix` is a convenience for the value shared by `linux` and `macos`; it is mutually exclusive
    with both. See `codeql_platform_select` for macro vs rule usage.
    """
    if posix != None:
        if linux != None or macos != None:
            fail("`posix` is mutually exclusive with `linux` and `macos`")
        linux = posix
        macos = posix
    return codeql_platform_select(
        ctx,
        linux64 = linux,
        linux_arm64 = linux,
        osx64 = macos,
        win64 = windows,
        otherwise = default,
    )

OS_DETECTION_ATTRS = {
    "_windows_constraint": attr.label(default = "@platforms//os:windows"),
    "_macos_constraint": attr.label(default = "@platforms//os:macos"),
    "_linux_constraint": attr.label(default = "@platforms//os:linux"),
    "_arm64_constraint": attr.label(default = "@platforms//cpu:arm64"),
}
