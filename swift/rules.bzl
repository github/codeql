load("//misc/bazel:os.bzl", "os_select")

# TODO: make a shared library with the internal repos for transitions
# unfortunately github.com/fmeum/rules_meta doesn't work any more with latest bazel

def _transition_impl(settings, attr):
    return {
        "macos": {
            "//command_line_option:copt": [
                "-fno-rtti",
                # we currently cannot built the swift extractor for ARM
                "-arch",
                "x86_64",
            ],
            "//command_line_option:cxxopt": [
                "-std=c++20",
                # we currently cannot built the swift extractor for ARM
                "-arch",
                "x86_64",
            ],
            "//command_line_option:linkopt": [
                # we currently cannot built the swift extractor for ARM
                "-arch",
                "x86_64",
            ],
        },
        "linux": {
            "//command_line_option:copt": [
                "-fno-rtti",
            ],
            "//command_line_option:cxxopt": [
                "-std=c++20",
            ],
            "//command_line_option:linkopt": [],
        },
        "windows": {
            "//command_line_option:copt": [],
            "//command_line_option:cxxopt": [
                "/std:c++20",
                "--cxxopt=/Zc:preprocessor",
            ],
            "//command_line_option:linkopt": [],
        },
    }[attr.os]

_transition = transition(
    implementation = _transition_impl,
    inputs = [],
    outputs = ["//command_line_option:copt", "//command_line_option:cxxopt", "//command_line_option:linkopt"],
)

def _cc_transition_impl(ctx):
    src = ctx.attr.src[0]
    default_info = src[DefaultInfo]
    executable = default_info.files_to_run.executable
    runfiles = default_info.default_runfiles
    direct = []
    if executable:
        original_executable = executable
        executable = ctx.actions.declare_file(original_executable.basename)
        command = "cp %s %s" % (original_executable.path, executable.path)

        ctx.actions.run_shell(
            inputs = [original_executable],
            outputs = [executable],
            command = command,
        )

        # costly, but no other way to remove the internal exe from the runfiles
        files = runfiles.files.to_list()
        files.remove(original_executable)
        files.append(executable)
        runfiles = ctx.runfiles(files)

        direct = [executable]

    providers = [
        DefaultInfo(
            files = depset(direct),
            runfiles = runfiles,
            executable = executable,
        ),
    ]
    for p in (OutputGroupInfo, CcInfo):
        if p in src:
            providers.append(src[p])

    return providers

_cc_transition = rule(
    implementation = _cc_transition_impl,
    attrs = {
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "src": attr.label(mandatory = True, cfg = _transition),
        "os": attr.string(),
    },
)

def _add_args(kwargs, kwarg, value):
    kwargs[kwarg] = kwargs.get(kwarg, []) + value

def _wrap_cc(rule, kwargs):
    name = kwargs.pop("name")
    visibility = kwargs.pop("visibility", None)
    _add_args(kwargs, "features", [
        # temporary, before we do universal merging
        "-universal_binaries",
    ])
    if "target_compatible_with" not in kwargs:
        # Restrict to Linux or macOS by default, but allow overriding
        _add_args(kwargs, "target_compatible_with", select({
            "@platforms//os:linux": [],
            "@platforms//os:macos": [],
            "//conditions:default": ["@platforms//:incompatible"],
        }))
    rule(name = "internal/" + name, visibility = ["//visibility:private"], **kwargs)
    _cc_transition(
        name = name,
        visibility = visibility,
        src = ":internal/" + name,
        os = os_select(linux = "linux", macos = "macos", windows = "windows"),
    )

def swift_cc_binary(**kwargs):
    _wrap_cc(native.cc_binary, kwargs)

def swift_cc_library(**kwargs):
    _wrap_cc(native.cc_library, kwargs)
