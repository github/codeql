load("@bazel_skylib//lib:paths.bzl", "paths")

def _make_platform_transition(impl):
    return transition(
        implementation = impl,
        inputs = ["//command_line_option:platforms"],
        outputs = ["//command_line_option:platforms"],
    )

def _platform_transition_impl(_settings, attr):
    return {
        "//command_line_option:platforms": [attr.platform],
    }

# Transition to attr.platform
platform_transition = _make_platform_transition(_platform_transition_impl)

def _get_platform_for_arch(settings, arch):
    platform = str(settings["//command_line_option:platforms"][0])
    if "host_toolchain" in platform:
        return "//toolchain/platforms:host_toolchain_%s" % arch
    return "//toolchain/platforms:bundled_toolchain_%s" % arch

def _x86_32_transition_impl(settings, _attr):
    return {"//command_line_option:platforms": [_get_platform_for_arch(settings, "x86_32")]}

x86_32_transition = _make_platform_transition(_x86_32_transition_impl)

def _x86_64_transition_impl(settings, _attr):
    return {"//command_line_option:platforms": [_get_platform_for_arch(settings, "x86_64")]}

x86_64_transition = _make_platform_transition(_x86_64_transition_impl)

def _arm64_transition_impl(settings, _attr):
    return {"//command_line_option:platforms": [_get_platform_for_arch(settings, "arm64")]}

arm64_transition = _make_platform_transition(_arm64_transition_impl)

def get_transition_attrs(transition_rule):
    return {
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "dep": attr.label(mandatory = True, cfg = transition_rule),
    }

def _universal_binary_transition_impl(settings, _attr):
    # Create a split transition from any macOS cpu to a list of all macOS cpus
    # Do nothing on other platforms, so that the lipo transition is a no-op
    if settings["//command_line_option:cpu"].startswith("darwin"):
        return {
            "x86_64": {"//command_line_option:platforms": [_get_platform_for_arch(settings, "x86_64")]},
            "arm64": {"//command_line_option:platforms": [_get_platform_for_arch(settings, "arm64")]},
        }
    else:
        return None

universal_binary_transition = transition(
    implementation = _universal_binary_transition_impl,
    inputs = [
        "//command_line_option:cpu",
        "//command_line_option:platforms",
    ],
    outputs = ["//command_line_option:platforms"],
)

def forward_binary_from_transition(ctx):
    # We need to forward the DefaultInfo provider from the underlying rule.
    # However, we can't do so directly, so instead we need to copy the binary over
    binary = ctx.attr.dep[0]
    default_info = binary[DefaultInfo]
    original_executable = default_info.files_to_run.executable
    runfiles = default_info.default_runfiles
    if not original_executable:
        fail("Cannot transition a 'binary' that is not executable")

    (_, extension) = paths.split_extension(original_executable.basename)
    new_executable = ctx.actions.declare_file(ctx.label.name + extension)
    command = "cp %s %s" % (original_executable.path, new_executable.path)

    # when transitioning a dylib, we also need to change the internal name to make it usable by bazel
    if extension == ".dylib":
        command += "\ninstall_name_tool -id %s %s" % (new_executable.path, new_executable.path)

    providers = []
    inputs = [original_executable]
    if OutputGroupInfo in binary:
        pdb_file = getattr(binary[OutputGroupInfo], "pdb_file", None)
        if pdb_file:
            (pdb_file,) = pdb_file.to_list()
            linked_pdb_file = ctx.actions.declare_file(ctx.label.name + ".pdb")
            ctx.actions.symlink(target_file = pdb_file, output = linked_pdb_file)

            # let's put this link into the copy inputs, even if unused
            # this will force the file to be created even if not explicitly included in outputs
            inputs.append(linked_pdb_file)

    ctx.actions.run_shell(
        inputs = inputs,
        outputs = [new_executable],
        command = command,
    )
    files = depset(direct = [new_executable])
    runfiles = runfiles.merge(ctx.runfiles([new_executable]))

    providers.append(
        DefaultInfo(
            files = files,
            runfiles = runfiles,
            executable = new_executable,
        ),
    )

    return providers

cc_compile_as_x86_32 = rule(
    implementation = forward_binary_from_transition,
    attrs = get_transition_attrs(x86_32_transition),
)

# needed to force certain dependencies of 32-bit binaries to be compiled as 64-bit binaries
cc_compile_as_x86_64 = rule(
    implementation = forward_binary_from_transition,
    attrs = get_transition_attrs(x86_64_transition),
)

cc_compile_as_arm64 = rule(
    implementation = forward_binary_from_transition,
    attrs = get_transition_attrs(arm64_transition),
)
