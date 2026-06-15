load("@rules_go//go:def.bzl", "go_binary", "go_cross_binary")

def codeql_go_binary(*, name, visibility = None, **kwargs):
    def internal(prefix = "internal"):
        return "%s/%s" % (prefix, name)

    go_binary(
        name = internal(),
        visibility = ["//visibility:private"],
        **kwargs
    )
    macos_targets = ("darwin_arm64", "darwin_amd64")
    for target in macos_targets:
        go_cross_binary(
            name = internal(target),
            platform = "@rules_go//go/toolchain:%s" % target,
            target = internal(),
            target_compatible_with = ["@platforms//os:macos"],
            visibility = ["//visibility:private"],
        )
    native.genrule(
        name = internal("universal"),
        outs = [internal("universal_")],
        srcs = [internal(t) for t in macos_targets],
        target_compatible_with = ["@platforms//os:macos"],
        executable = True,
        visibility = ["//visibility:private"],
        cmd = "lipo -create $(SRCS) -output $@",
    )
    native.alias(
        name = name,
        actual = select({
            "@platforms//os:macos": internal("universal"),
            "//conditions:default": internal(),
        }),
        visibility = visibility,
    )
