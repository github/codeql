load("@bazel_skylib//lib:paths.bzl", "paths")

def forward_binary_from_transition(ctx):
    binary = ctx.attr.dep[0]
    default_info = binary[DefaultInfo]
    original_executable = default_info.files_to_run.executable
    if not original_executable:
        fail("Cannot transition a target that is not executable")

    (_, extension) = paths.split_extension(original_executable.basename)
    new_executable = ctx.actions.declare_file(ctx.label.name + extension)
    inputs = [original_executable]
    command = "cp %s %s" % (original_executable.path, new_executable.path)

    providers = []
    if OutputGroupInfo in binary:
        pdb_file = getattr(binary[OutputGroupInfo], "pdb_file", None)
        if pdb_file:
            (pdb_file,) = pdb_file.to_list()
            linked_pdb_file = ctx.actions.declare_file(ctx.label.name + ".pdb")
            ctx.actions.symlink(target_file = pdb_file, output = linked_pdb_file)
            inputs.append(linked_pdb_file)
        providers.append(binary[OutputGroupInfo])

    ctx.actions.run_shell(
        inputs = inputs,
        outputs = [new_executable],
        command = command,
    )
    files = depset(direct = [new_executable])
    runfiles = default_info.default_runfiles.merge(ctx.runfiles([new_executable]))
    providers.append(
        DefaultInfo(
            files = files,
            runfiles = runfiles,
            executable = new_executable,
        ),
    )
    return providers

def get_transition_attrs(transition_rule):
    return {
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "dep": attr.label(mandatory = True, cfg = transition_rule),
    }
