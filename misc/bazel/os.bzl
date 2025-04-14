""" Os detection facilities. """

def os_select(
        ctx = None,
        *,
        linux = None,
        windows = None,
        macos = None,
        default = None):
    """
    This can work both in a macro and a rule context to choose something based on the current OS.
    If used in a rule implementation, you need to pass `ctx` and add `OS_DETECTION_ATTRS` to the
    rule attributes.
    """
    choices = {
        "linux": linux or default,
        "windows": windows or default,
        "macos": macos or default,
    }
    if not ctx:
        return select({
            "@platforms//os:%s" % os: v
            for os, v in choices.items()
            if v != None
        })

    for os, v in choices.items():
        if ctx.target_platform_has_constraint(getattr(ctx.attr, "_%s_constraint" % os)[platform_common.ConstraintValueInfo]):
            if v == None:
                fail("%s not supported by %s" % (os, ctx.label))
            return v
    fail("Unknown OS detected")

OS_DETECTION_ATTRS = {
    "_windows_constraint": attr.label(default = "@platforms//os:windows"),
    "_macos_constraint": attr.label(default = "@platforms//os:macos"),
    "_linux_constraint": attr.label(default = "@platforms//os:linux"),
}
