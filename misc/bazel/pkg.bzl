"""
Wrappers and helpers around `rules_pkg` to build codeql packs.
"""

load("@rules_pkg//pkg:install.bzl", "pkg_install")
load("@rules_pkg//pkg:mappings.bzl", "pkg_attributes", "pkg_filegroup", "pkg_files", _strip_prefix = "strip_prefix")
load("@rules_pkg//pkg:pkg.bzl", "pkg_zip")
load("@rules_pkg//pkg:providers.bzl", "PackageFilegroupInfo", "PackageFilesInfo")
load("@rules_python//python:defs.bzl", "py_binary")

def _make_internal(name):
    def internal(suffix = "internal"):
        return "%s-%s" % (name, suffix)

    return internal

_PLAT_DETECTION_ATTRS = {
    "_windows": attr.label(default = "@platforms//os:windows"),
    "_macos": attr.label(default = "@platforms//os:macos"),
}

_PLAT_PLACEHOLDER = "{CODEQL_PLATFORM}"

def _expand_path(path, platform):
    if _PLAT_PLACEHOLDER in path:
        path = path.replace(_PLAT_PLACEHOLDER, platform)
        return ("arch", path)
    return ("generic", path)

def _detect_platform(ctx):
    if ctx.target_platform_has_constraint(ctx.attr._windows[platform_common.ConstraintValueInfo]):
        return "win64"
    elif ctx.target_platform_has_constraint(ctx.attr._macos[platform_common.ConstraintValueInfo]):
        return "osx64"
    else:
        return "linux64"

def codeql_pkg_files(
        *,
        name,
        srcs = None,
        exes = None,
        visibility = None,
        **kwargs):
    """ Wrapper around `pkg_files` adding a distinction between `srcs` and `exes`, where the
    latter will get executable permissions.
    """

    internal = _make_internal(name)
    if "attributes" in kwargs:
        fail("do not use attributes with codeql_pkg_* rules. Use `exes` to mark executable files.")
    internal_srcs = []
    if srcs and exes:
        pkg_files(
            name = internal("srcs"),
            srcs = srcs,
            visibility = ["//visibility:private"],
            **kwargs
        )
        pkg_files(
            name = internal("exes"),
            srcs = exes,
            visibility = ["//visibility:private"],
            attributes = pkg_attributes(mode = "755"),
            **kwargs
        )
        pkg_filegroup(
            name = name,
            srcs = [internal("srcs"), internal("exes")],
            visibility = visibility,
        )
    else:
        pkg_files(
            name = name,
            srcs = srcs or exes,
            visibility = visibility,
            attributes = pkg_attributes(mode = "755") if exes else None,
            **kwargs
        )

def _extract_pkg_filegroup_impl(ctx):
    src = ctx.attr.src[PackageFilegroupInfo]
    platform = _detect_platform(ctx)

    if src.pkg_dirs or src.pkg_symlinks:
        fail("`pkg_dirs` and `pkg_symlinks` are not supported for codeql packaging rules")

    pkg_files = []
    for pfi, origin in src.pkg_files:
        dest_src_map = {}
        for dest, file in pfi.dest_src_map.items():
            file_kind, expanded_dest = _expand_path(dest, platform)
            if file_kind == ctx.attr.kind:
                dest_src_map[expanded_dest] = file
        if dest_src_map:
            pkg_files.append((PackageFilesInfo(dest_src_map = dest_src_map, attributes = pfi.attributes), origin))

    files = [depset(pfi.dest_src_map.values()) for pfi, _ in pkg_files]
    return [
        PackageFilegroupInfo(pkg_files = pkg_files, pkg_dirs = [], pkg_symlinks = []),
        DefaultInfo(files = depset(transitive = files)),
    ]

_extract_pkg_filegroup = rule(
    implementation = _extract_pkg_filegroup_impl,
    doc = """
        This internal rule extracts the arch or generic part of a `PackageFilegroupInfo` source, returning a
        `PackageFilegroupInfo` that is a subset of the provided `src`, while expanding `{CODEQL_PLATFORM}` in
        destination paths to the relevant codeql platform (linux64, win64 or osx64).
        The distinction between generic and arch contents is given on a per-file basis depending on the install path
        containing {CODEQL_PLATFORM}, which will typically have been added by a `prefix` attribute to a `pkg_*` rule.
        No `pkg_dirs` or `pkg_symlink` must have been used for assembling the source mapping information: we could
        easily add support for that, but we don't require it for now.
    """,
    attrs = {
        "src": attr.label(providers = [PackageFilegroupInfo, DefaultInfo]),
        "kind": attr.string(doc = "What part to extract", values = ["generic", "arch"]),
    } | _PLAT_DETECTION_ATTRS,
)

def _imported_zips_manifest_impl(ctx):
    platform = _detect_platform(ctx)

    manifest = []
    files = []
    for zip, prefix in ctx.attr.zips.items():
        # we don't care about the kind here, as we're taking all zips together
        _, expanded_prefix = _expand_path(prefix, platform)
        zip_files = zip.files.to_list()
        manifest += ["%s:%s" % (expanded_prefix, f.short_path) for f in zip_files]
        files += zip_files

    output = ctx.actions.declare_file(ctx.label.name + ".params")
    ctx.actions.write(
        output,
        "\n".join(manifest),
    )
    return DefaultInfo(
        files = depset([output]),
        runfiles = ctx.runfiles(files),
    )

_imported_zips_manifest = rule(
    implementation = _imported_zips_manifest_impl,
    doc = """
        This internal rule prints a zip manifest file that `misc/bazel/internal/install.py` understands.
        {CODEQL_PLATFORM} can be used as zip prefixes and will be expanded to the relevant codeql platform.
    """,
    attrs = {
        "zips": attr.label_keyed_string_dict(
            doc = "mapping from zip files to install prefixes",
            allow_files = [".zip"],
        ),
    } | _PLAT_DETECTION_ATTRS,
)

def _zipmerge_impl(ctx):
    zips = []
    filename = ctx.attr.zip_name + "-"
    platform = _detect_platform(ctx)
    filename = "%s-%s.zip" % (ctx.attr.zip_name, platform if ctx.attr.kind == "arch" else "generic")
    output = ctx.actions.declare_file(filename)
    args = [output.path, "--prefix=%s" % ctx.attr.zip_prefix, ctx.file.base.path]
    for zip, prefix in ctx.attr.zips.items():
        zip_kind, expanded_prefix = _expand_path(prefix, platform)
        if zip_kind == ctx.attr.kind:
            args.append("--prefix=%s/%s" % (ctx.attr.zip_prefix, expanded_prefix.rstrip("/")))
            args += [f.path for f in zip.files.to_list()]
            zips.append(zip.files)
    ctx.actions.run(
        outputs = [output],
        executable = ctx.executable._zipmerge,
        inputs = depset([ctx.file.base], transitive = zips),
        arguments = args,
    )

    return [
        DefaultInfo(files = depset([output])),
    ]

_zipmerge = rule(
    implementation = _zipmerge_impl,
    doc = """
        This internal rule merges a `base` zip file with the ones indicated by the `zips` mapping where the prefix
        indicates a matching kind between arch and generic. An imported zip file will be considered arch-specific
        if its prefix contains `{CODEQL_PLATFORM}` (and this prefix will have that expanded to the appropriate
        platform).

        The output filename will be either `{zip_name}-generic.zip` or `{zip_name}-{CODEQL_PLATFORM}.zip`, depending on
        the requested `kind`.
    """,
    attrs = {
        "base": attr.label(
            doc = "Base zip file to which zips from `zips` will be merged with",
            allow_single_file = [".zip"],
        ),
        "zips": attr.label_keyed_string_dict(
            doc = "mapping from zip files to install prefixes",
            allow_files = [".zip"],
        ),
        "zip_name": attr.string(doc = "Prefix to use for the output file name"),
        "kind": attr.string(doc = "Which zip kind to consider", values = ["generic", "arch"]),
        "zip_prefix": attr.string(doc = "Prefix posix path to add to the zip contents in the archive"),
        "_zipmerge": attr.label(default = "//misc/bazel/internal/zipmerge", executable = True, cfg = "exec"),
    } | _PLAT_DETECTION_ATTRS,
)

def codeql_pack(
        *,
        name,
        srcs = None,
        zips = None,
        zip_filename = None,
        visibility = None,
        install_dest = "extractor-pack",
        **kwargs):
    """
    Define a codeql pack. This macro accepts `pkg_files`, `pkg_filegroup` or their `codeql_*` counterparts as `srcs`.
    `zips` is a map from prefixes to `.zip` files to import.
    * defines a `<name>-generic-zip` target creating a `<zip_filename>-generic.zip` archive with the generic bits,
      prefixed with `name`
    * defines a `<name>-arch-zip` target creating a `<zip_filename>-<codeql_platform>.zip` archive with the
      arch-specific bits, prefixed with `name`
    * defines a runnable `<name>-installer` target that will install the pack in `install_dest`, relative to where the
      rule is used. The install destination can be overridden appending `-- --destdir=...` to the `bazel run`
      invocation. This installation _does not_ prefix the contents with `name`.

    The distinction between arch-specific and generic contents is made based on whether the paths (including possible
    prefixes added by rules) contain the special `{CODEQL_PLATFORM}` placeholder, which in case it is present will also
    be replaced by the appropriate platform (`linux64`, `win64` or `osx64`).
    """
    internal = _make_internal(name)
    zip_filename = zip_filename or name
    zips = zips or {}
    pkg_filegroup(
        name = internal("base"),
        srcs = srcs,
        visibility = ["//visibility:private"],
        **kwargs
    )
    for kind in ("generic", "arch"):
        _extract_pkg_filegroup(
            name = internal(kind),
            src = internal("base"),
            kind = kind,
            visibility = ["//visibility:private"],
        )
        pkg_zip(
            name = internal(kind + "-zip-base"),
            srcs = [internal(kind)],
            visibility = ["//visibility:private"],
        )
        _zipmerge(
            name = internal(kind + "-zip"),
            base = internal(kind + "-zip-base"),
            zips = zips,
            zip_name = zip_filename,
            zip_prefix = name,  # this is prefixing the zip contents with the pack name
            kind = kind,
            visibility = visibility,
        )
    _imported_zips_manifest(
        name = internal("zip-manifest"),
        zips = zips,
        visibility = ["//visibility:private"],
    )

    pkg_install(
        name = internal("script"),
        srcs = [internal("generic"), internal("arch")],
        visibility = ["//visibility:private"],
    )
    native.filegroup(
        # used to locate current src directory
        name = internal("build-file"),
        srcs = ["BUILD.bazel"],
        visibility = ["//visibility:private"],
    )
    py_binary(
        name = internal("installer"),
        srcs = ["//misc/bazel/internal:install.py"],
        main = "//misc/bazel/internal:install.py",
        data = [
            internal("build-file"),
            internal("script"),
            internal("zip-manifest"),
            "//misc/bazel/internal/ripunzip",
        ],
        deps = ["@rules_python//python/runfiles"],
        args = [
            "--build-file=$(rlocationpath %s)" % internal("build-file"),
            "--pkg-install-script=$(rlocationpath %s)" % internal("script"),
            "--destdir",
            install_dest,
            "--ripunzip=$(rlocationpath //misc/bazel/internal/ripunzip)",
            "--zip-manifest=$(rlocationpath %s)" % internal("zip-manifest"),
        ],
        visibility = visibility,
    )
    native.filegroup(
        name = name,
        srcs = [internal("generic-zip"), internal("arch-zip")],
    )

strip_prefix = _strip_prefix

def _runfiles_group_impl(ctx):
    files = []
    for src in ctx.attr.srcs:
        rf = src[DefaultInfo].default_runfiles
        if rf != None:
            files.append(rf.files)
    return [
        DefaultInfo(
            files = depset(transitive = files),
        ),
    ]

_runfiles_group = rule(
    implementation = _runfiles_group_impl,
    attrs = {
        "srcs": attr.label_list(),
    },
)

def codeql_pkg_runfiles(*, name, exes, **kwargs):
    """
    Create a `codeql_pkg_files` with all runfiles from files in `exes`, flattened together.
    """
    internal = _make_internal(name)
    _runfiles_group(
        name = internal("runfiles"),
        srcs = exes,
        visibility = ["//visibility:private"],
    )
    codeql_pkg_files(
        name = name,
        exes = [internal("runfiles")],
        **kwargs
    )

def _pkg_overlay_impl(ctx):
    destinations = {}
    files = []
    depsets = []

    for src in reversed(ctx.attr.srcs):
        pfi = src[PackageFilesInfo]
        dest_src_map = {k: v for k, v in pfi.dest_src_map.items() if k not in destinations}
        destinations.update({k: True for k in dest_src_map})
        if dest_src_map:
            new_pfi = PackageFilesInfo(
                dest_src_map = dest_src_map,
                attributes = pfi.attributes,
            )
            files.append((new_pfi, src.label))
            depsets.append(depset(dest_src_map.values()))
    return [
        PackageFilegroupInfo(
            pkg_files = reversed(files),
            pkg_dirs = [],
            pkg_symlinks = [],
        ),
        DefaultInfo(
            files = depset(transitive = reversed(depsets)),
        ),
    ]

codeql_pkg_files_overlay = rule(
    implementation = _pkg_overlay_impl,
    doc = "Combine `pkg_files` targets so that later targets overwrite earlier ones without warnings",
    attrs = {
        # this could be updated to handle PackageFilegroupInfo as well if we ever need it
        "srcs": attr.label_list(providers = [PackageFilesInfo, DefaultInfo]),
    },
)
