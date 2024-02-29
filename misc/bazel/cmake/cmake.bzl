CmakeInfo = provider(
    fields = {
        "name": "",
        "inputs": "",
        "kind": "",
        "modifier": "",
        "hdrs": "",
        "srcs": "",
        "deps": "",
        "system_includes": "",
        "includes": "",
        "quote_includes": "",
        "stripped_includes": "",
        "imported_libs": "",
        "copts": "",
        "linkopts": "",
        "force_cxx_compilation": "",
        "defines": "",
        "local_defines": "",
        "transitive_deps": "",
    },
)

def _cmake_name(label):
    # strip away the bzlmod module version for now
    workspace_name, _, _ = label.workspace_name.partition("~")
    ret = ("%s_%s_%s" % (workspace_name, label.package, label.name)).replace("/", "_")
    internal_transition_suffix = "_INTERNAL_TRANSITION"
    if ret.endswith(internal_transition_suffix):
        ret = ret[:-len(internal_transition_suffix)]
    return ret

def _cmake_file(file):
    if not file.is_source:
        return "${BAZEL_EXEC_ROOT}/" + file.path
    return _cmake_path(file.path)

def _cmake_path(path):
    if path.startswith("external/"):
        return "${BAZEL_OUTPUT_BASE}/" + path
    return "${BAZEL_WORKSPACE}/" + path

def _file_kind(file):
    ext = file.extension
    if ext in ("c", "cc", "cpp"):
        return "src"
    if ext in ("h", "hh", "hpp", "def", "inc"):
        return "hdr"
    if ext in ("a", "so", "dylib"):
        return "lib"
    return None

def _get_includes(includes):
    # see strip prefix comment below to understand why we are skipping virtual includes here
    return [_cmake_path(i) for i in includes.to_list() if "/_virtual_includes/" not in i]

def _cmake_aspect_impl(target, ctx):
    if not ctx.rule.kind.startswith(("cc_", "_cc_add_features")):
        return [CmakeInfo(name = None, transitive_deps = depset())]

    # TODO: remove cc_binary_add_features once we remove it from internal repo
    if ctx.rule.kind in ("cc_binary_add_features", "_cc_add_features_binary", "_cc_add_features_test"):
        dep = ctx.rule.attr.dep[0][CmakeInfo]
        return [CmakeInfo(
            name = None,
            transitive_deps = depset([dep], transitive = [dep.transitive_deps]),
        )]

    name = _cmake_name(ctx.label)

    is_macos = "darwin" in ctx.var["TARGET_CPU"]

    is_binary = ctx.rule.kind in ("cc_binary", "cc_test")
    force_cxx_compilation = "force_cxx_compilation" in ctx.rule.attr.features
    attr = ctx.rule.attr
    srcs = getattr(attr, "srcs", []) + getattr(attr, "hdrs", []) + getattr(attr, "textual_hdrs", [])
    srcs = [f for src in srcs for f in src.files.to_list()]
    inputs = [f for f in srcs if not f.is_source or f.path.startswith("external/")]
    by_kind = {}
    for f in srcs:
        by_kind.setdefault(_file_kind(f), []).append(_cmake_file(f))
    hdrs = by_kind.get("hdr", [])
    srcs = by_kind.get("src", [])
    libs = by_kind.get("lib", [])
    if not srcs and is_binary:
        empty = ctx.actions.declare_file(name + "_empty.cpp")
        ctx.actions.write(empty, "")
        inputs.append(empty)
        srcs = [_cmake_file(empty)]
    deps = ctx.rule.attr.deps if hasattr(ctx.rule.attr, "deps") else []

    cxx_compilation = force_cxx_compilation or any([not src.endswith(".c") for src in srcs])

    copts = ctx.fragments.cpp.copts + (ctx.fragments.cpp.cxxopts if cxx_compilation else ctx.fragments.cpp.conlyopts)
    copts += [ctx.expand_make_variables("copts", o, {}) for o in getattr(ctx.rule.attr, "copts", [])]

    linkopts = ctx.fragments.cpp.linkopts
    linkopts += [ctx.expand_make_variables("linkopts", o, {}) for o in getattr(ctx.rule.attr, "linkopts", [])]

    compilation_ctx = target[CcInfo].compilation_context
    system_includes = _get_includes(compilation_ctx.system_includes)

    # move -I copts to includes
    includes = _get_includes(compilation_ctx.includes) + [_cmake_path(opt[2:]) for opt in copts if opt.startswith("-I")]
    copts = [opt for opt in copts if not opt.startswith("-I")]
    quote_includes = _get_includes(compilation_ctx.quote_includes)

    # strip prefix is special, as in bazel it creates a _virtual_includes directory with symlinks
    # as we want to avoid relying on bazel having done that, we must undo that mechanism
    # also for some reason cmake fails to propagate these with target_include_directories,
    # so we propagate them ourselvels by using the stripped_includes field
    stripped_includes = []
    if getattr(ctx.rule.attr, "strip_include_prefix", ""):
        prefix = ctx.rule.attr.strip_include_prefix.strip("/")
        if ctx.label.workspace_name:
            stripped_includes = [
                "${BAZEL_OUTPUT_BASE}/external/%s/%s" % (ctx.label.workspace_name, prefix),  # source
                "${BAZEL_EXEC_ROOT}/%s/external/%s/%s" % (ctx.var["BINDIR"], ctx.label.workspace_name, prefix),  # generated
            ]
        else:
            stripped_includes = [
                prefix,  # source
                "${BAZEL_EXEC_ROOT}/%s/%s" % (ctx.var["BINDIR"], prefix),  # generated
            ]
    deps = [dep[CmakeInfo] for dep in deps if CmakeInfo in dep]

    # by the book this should be done with depsets, but so far the performance implication is negligible
    for dep in deps:
        if dep.name:
            stripped_includes += dep.stripped_includes
    includes += stripped_includes

    return [
        CmakeInfo(
            name = name,
            inputs = inputs,
            kind = "executable" if is_binary else "library",
            modifier = "INTERFACE" if not srcs and not is_binary else "",
            hdrs = hdrs,
            srcs = srcs,
            deps = [dep for dep in deps if dep.name != None],
            includes = includes,
            system_includes = system_includes,
            quote_includes = quote_includes,
            stripped_includes = stripped_includes,
            imported_libs = libs,
            copts = copts,
            linkopts = linkopts,
            defines = compilation_ctx.defines.to_list(),
            local_defines = [
                d
                for d in compilation_ctx.local_defines.to_list()
                if not d.startswith("BAZEL_CURRENT_REPOSITORY")
            ],
            force_cxx_compilation = force_cxx_compilation,
            transitive_deps = depset(deps, transitive = [dep.transitive_deps for dep in deps]),
        ),
    ]

cmake_aspect = aspect(
    implementation = _cmake_aspect_impl,
    attr_aspects = ["deps", "dep"],
    fragments = ["cpp"],
)

def _map_cmake_info(info, is_windows):
    args = " ".join([info.name, info.modifier] + info.hdrs + info.srcs).strip()
    commands = [
        "add_%s(%s)" % (info.kind, args),
    ]
    if info.imported_libs:
        commands.append(
            "target_link_libraries(%s %s %s)" %
            (info.name, info.modifier or "PUBLIC", " ".join(info.imported_libs)),
        )
    if info.deps:
        libs = {}
        if info.modifier == "INTERFACE":
            libs = {"INTERFACE": [lib.name for lib in info.deps]}
        else:
            for lib in info.deps:
                libs.setdefault(lib.modifier, []).append(lib.name)
        for modifier, names in libs.items():
            commands.append(
                "target_link_libraries(%s %s %s)" % (info.name, modifier or "PUBLIC", " ".join(names)),
            )
    if info.includes:
        commands.append(
            "target_include_directories(%s %s %s)" % (info.name, info.modifier or "PUBLIC", " ".join(info.includes)),
        )
    if info.system_includes:
        commands.append(
            "target_include_directories(%s SYSTEM %s %s)" % (info.name, info.modifier or "PUBLIC", " ".join(info.system_includes)),
        )
    if info.quote_includes:
        if is_windows:
            commands.append(
                "target_include_directories(%s %s %s)" % (info.name, info.modifier or "PUBLIC", " ".join(info.quote_includes)),
            )
        else:
            commands.append(
                "target_compile_options(%s %s %s)" % (info.name, info.modifier or "PUBLIC", " ".join(["-iquote%s" % i for i in info.quote_includes])),
            )
    if info.copts and info.modifier != "INTERFACE":
        commands.append(
            "target_compile_options(%s PRIVATE %s)" % (info.name, " ".join(info.copts)),
        )
    if info.linkopts:
        commands.append(
            "target_link_options(%s %s %s)" % (info.name, info.modifier or "PUBLIC", " ".join(info.linkopts)),
        )
    if info.force_cxx_compilation and any([f.endswith(".c") for f in info.srcs]):
        commands.append(
            "set_source_files_properties(%s PROPERTIES LANGUAGE CXX)" % " ".join([f for f in info.srcs if f.endswith(".c")]),
        )
    if info.defines:
        commands.append(
            "target_compile_definitions(%s %s %s)" % (info.name, info.modifier or "PUBLIC", " ".join(info.defines)),
        )
    if info.local_defines:
        commands.append(
            "target_compile_definitions(%s %s %s)" % (info.name, info.modifier or "PRIVATE", " ".join(info.local_defines)),
        )
    return commands

GeneratedCmakeFiles = provider(
    fields = {
        "targets": "",
    },
)

def _generate_cmake_impl(ctx):
    commands = []
    inputs = []

    infos = {}
    targets = list(ctx.attr.targets)
    for include in ctx.attr.includes:
        targets += include[GeneratedCmakeFiles].targets.to_list()

    for dep in targets:
        for info in [dep[CmakeInfo]] + dep[CmakeInfo].transitive_deps.to_list():
            if info.name != None:
                inputs += info.inputs
                infos[info.name] = info

    is_windows = ctx.target_platform_has_constraint(ctx.attr._windows[platform_common.ConstraintValueInfo])

    for info in infos.values():
        commands += _map_cmake_info(info, is_windows)
        commands.append("")

    # we want to use a run or run_shell action to register a bunch of files like inputs, but we cannot write all
    # in a shell command as we would hit the command size limit. So we first write the file and then copy it with
    # the dummy inputs
    tmp_output = ctx.actions.declare_file(ctx.label.name + ".cmake~")
    output = ctx.actions.declare_file(ctx.label.name + ".cmake")
    ctx.actions.write(tmp_output, "\n".join(commands))
    ctx.actions.run_shell(outputs = [output], inputs = inputs + [tmp_output], command = "cp %s %s" % (tmp_output.path, output.path))

    return [
        DefaultInfo(files = depset([output])),
        GeneratedCmakeFiles(targets = depset(ctx.attr.targets)),
    ]

generate_cmake = rule(
    implementation = _generate_cmake_impl,
    attrs = {
        "targets": attr.label_list(aspects = [cmake_aspect]),
        "includes": attr.label_list(providers = [GeneratedCmakeFiles]),
        "_windows": attr.label(default = "@platforms//os:windows"),
    },
)
