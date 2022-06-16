def _add_args(kwargs, kwarg, value):
    kwargs[kwarg] = kwargs.get(kwarg, []) + value

def _wrap_cc(rule, kwargs):
    _add_args(kwargs, "copts", [
        # Required by LLVM/Swift
        "-fno-rtti",
    ] + select({
        # temporary, before we do universal merging and have an arm prebuilt package, we make arm build x86
        "@platforms//os:macos": ["-arch=x86_64"],
        "//conditions:default": [],
    }))
    _add_args(kwargs, "features", [
        # temporary, before we do universal merging
        "-universal_binaries",
    ])
    _add_args(kwargs, "target_compatible_with", select({
        "@platforms//os:linux": [],
        "@platforms//os:macos": [],
        "//conditions:default": ["@platforms//:incompatible"],
    }))
    rule(**kwargs)

def swift_cc_binary(**kwargs):
    _wrap_cc(native.cc_binary, kwargs)

def swift_cc_library(**kwargs):
    _wrap_cc(native.cc_library, kwargs)
