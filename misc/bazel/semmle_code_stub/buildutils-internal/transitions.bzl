def forward_binary_from_transition(ctx):
    default_info = ctx.attr.dep[0][DefaultInfo]
    original_executable = default_info.files_to_run.executable
    executable = ctx.actions.declare_file(ctx.label.name)
    ctx.actions.symlink(
        output = executable,
        target_file = original_executable,
        is_executable = True,
    )
    return [DefaultInfo(
        executable = executable,
        runfiles = default_info.default_runfiles,
    )]

def get_transition_attrs(transition_rule):
    return {
        "_allowlist_function_transition": attr.label(
            default = "@bazel_tools//tools/allowlists/function_transition_allowlist",
        ),
        "dep": attr.label(mandatory = True, cfg = transition_rule),
    }
