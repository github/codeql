"""
Wrappers and helpers around `rules_pkg` to build codeql packs.
"""

load("@rules_pkg//pkg:install.bzl", "pkg_install")
load("@rules_pkg//pkg:mappings.bzl", "pkg_attributes", "pkg_filegroup", "pkg_files", _strip_prefix = "strip_prefix")
load("@rules_pkg//pkg:pkg.bzl", "pkg_zip")
load("@rules_pkg//pkg:providers.bzl", "PackageFilegroupInfo", "PackageFilesInfo")
load("@rules_python//python:defs.bzl", "py_binary")
load("//misc/bazel:os.bzl", "OS_DETECTION_ATTRS", "os_select")

def _make_internal(name):
    def internal(suffix = "internal", *args):
        args = (name, suffix) + args
        return "-".join(args)

    return internal

_PLAT_PLACEHOLDER = "{CODEQL_PLATFORM}"

def _expand_path(path, platform):
    if _PLAT_PLACEHOLDER in path:
        path = path.replace(_PLAT_PLACEHOLDER, platform)
        return ("arch", path)
    return ("generic", path)

def _detect_platform(ctx = None):
    return os_select(ctx, linux = "linux64", macos = "osx64", windows = "win64")

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
    arch_overrides = ctx.attr.arch_overrides
    platform = _detect_platform(ctx)

    if src.pkg_dirs or src.pkg_symlinks:
        fail("`pkg_dirs` and `pkg_symlinks` are not supported for codeql packaging rules")

    pkg_files = []
    for pfi, origin in src.pkg_files:
        dest_src_map = {}
        for dest, file in pfi.dest_src_map.items():
            file_kind, expanded_dest = _expand_path(dest, platform)
            if file_kind == "generic" and dest in arch_overrides:
                file_kind = "arch"
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
        Files that are arch-specific, but outside of the `CODEQL_PLATFORM` path can be specified in `arch_overrides`.
        No `pkg_dirs` or `pkg_symlink` must have been used for assembling the source mapping information: we could
        easily add support for that, but we don't require it for now.
    """,
    attrs = {
        "src": attr.label(providers = [PackageFilegroupInfo, DefaultInfo]),
        "kind": attr.string(doc = "What part to extract", values = ["generic", "arch"]),
        "arch_overrides": attr.string_list(doc = "A list of files that should be included in the arch package regardless of the path"),
    } | OS_DETECTION_ATTRS,
)

_ZipInfo = provider(fields = {"zips_to_prefixes": "mapping of zip files to prefixes"})

def _zip_info_impl(ctx):
    zips = {}
    for zip_target, prefix in ctx.attr.srcs.items():
        for zip in zip_target.files.to_list():
            zips[zip] = prefix
    return [
        _ZipInfo(zips_to_prefixes = zips),
    ]

_zip_info = rule(
    implementation = _zip_info_impl,
    doc = """
        This internal rule simply instantiates a _ZipInfo provider out of `zips`.
    """,
    attrs = {
        "srcs": attr.label_keyed_string_dict(
            doc = "mapping from zip files to install prefixes",
            allow_files = [".zip"],
        ),
    },
)

def _zip_info_filter_impl(ctx):
    platform = _detect_platform(ctx)
    filtered_zips = {}
    for zip_info in ctx.attr.srcs:
        for zip, prefix in zip_info[_ZipInfo].zips_to_prefixes.items():
            zip_kind, expanded_prefix = _expand_path(prefix, platform)
            if zip_kind == ctx.attr.kind:
                filtered_zips[zip] = expanded_prefix
    return [
        _ZipInfo(zips_to_prefixes = filtered_zips),
    ]

_zip_info_filter = rule(
    implementation = _zip_info_filter_impl,
    doc = """
        This internal rule transforms a _ZipInfo provider so that:
        * only zips matching `kind` are included
        * a kind of a zip is given by its prefix: if it contains {CODEQL_PLATFORM} it is arch, otherwise it's generic
        * in the former case, {CODEQL_PLATFORM} is expanded
    """,
    attrs = {
        "srcs": attr.label_list(doc = "_ZipInfos to transform", providers = [_ZipInfo]),
        "kind": attr.string(doc = "Which zip kind to consider", values = ["generic", "arch"]),
    } | OS_DETECTION_ATTRS,
)

def _imported_zips_manifest_impl(ctx):
    manifest = []
    files = []
    for zip_info in ctx.attr.srcs:
        zip_info = zip_info[_ZipInfo]
        manifest += ["%s:%s" % (p, z.short_path) for z, p in zip_info.zips_to_prefixes.items()]
        files.extend(zip_info.zips_to_prefixes)

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
        "srcs": attr.label_list(
            doc = "mappings from zip files to install prefixes in _ZipInfo format",
            providers = [_ZipInfo],
        ),
    },
)

def _zipmerge_impl(ctx):
    zips = []
    transitive_zips = []
    output = ctx.actions.declare_file(ctx.attr.out)
    args = [output.path]
    for zip_target in ctx.attr.srcs:
        if _ZipInfo in zip_target:
            zip_info = zip_target[_ZipInfo]
            for zip, prefix in zip_info.zips_to_prefixes.items():
                args += [
                    "--prefix=%s/%s" % (ctx.attr.prefix, prefix.rstrip("/")),
                    zip.path,
                ]
                zips.append(zip)
        else:
            zip_files = zip_target.files.to_list()
            for zip in zip_files:
                if zip.extension != "zip":
                    fail("%s file found while expecting a .zip file " % zip.short_path)
            args.append("--prefix=%s" % ctx.attr.prefix)
            args += [z.path for z in zip_files]
            transitive_zips.append(zip_target.files)
    ctx.actions.run(
        outputs = [output],
        executable = ctx.executable._zipmerge,
        inputs = depset(zips, transitive = transitive_zips),
        arguments = args,
    )

    return [
        DefaultInfo(files = depset([output])),
    ]

_zipmerge = rule(
    implementation = _zipmerge_impl,
    doc = """
        This internal rule merges a zip files together
    """,
    attrs = {
        "srcs": attr.label_list(doc = "Zip file to include, either as straight up `.zip` files or `_ZipInfo` data"),
        "out": attr.string(doc = "output file name"),
        "prefix": attr.string(doc = "Prefix posix path to add to the zip contents in the archive"),
        "_zipmerge": attr.label(default = "//misc/bazel/internal/zipmerge", executable = True, cfg = "exec"),
    },
)

def _get_zip_filename(name_prefix, kind):
    if kind == "arch":
        return name_prefix + "-" + _detect_platform() + ".zip"  # using + because there's a select
    else:
        return "%s-generic.zip" % name_prefix

def codeql_pack(
        *,
        name,
        srcs = None,
        zips = None,
        zip_filename = None,
        visibility = None,
        install_dest = "extractor-pack",
        compression_level = None,
        arch_overrides = None,
        zip_prefix = None,
        **kwargs):
    """
    Define a codeql pack. This macro accepts `pkg_files`, `pkg_filegroup` or their `codeql_*` counterparts as `srcs`.
    `zips` is a map from `.zip` files to prefixes to import.
    * defines a `<name>-generic-zip` target creating a `<zip_filename>-generic.zip` archive with the generic bits,
      prefixed with `zip_prefix`
    * defines a `<name>-arch-zip` target creating a `<zip_filename>-<codeql_platform>.zip` archive with the
      arch-specific bits, prefixed with `zip_prefix`
    * defines a runnable `<name>-installer` target that will install the pack in `install_dest`, relative to where the
      rule is used. The install destination can be overridden appending `-- --destdir=...` to the `bazel run`
      invocation. This installation _does not_ prefix the contents with `zip_prefix`.
    The prefix for the zip files can be set with `zip_prefix`, it is `name` by default.

    The distinction between arch-specific and generic contents is made based on whether the paths (including possible
    prefixes added by rules) contain the special `{CODEQL_PLATFORM}` placeholder, which in case it is present will also
    be replaced by the appropriate platform (`linux64`, `win64` or `osx64`).
    Specific file paths can be placed in the arch-specific package by adding them to `arch_overrides`, even if their
    path doesn't contain the `CODEQL_PLATFORM` placeholder.

    `compression_level` can be used to tweak the compression level used when creating archives. Consider that this
    does not affect the contents of `zips`, only `srcs`.
    """
    internal = _make_internal(name)
    zip_filename = zip_filename or name
    zips = zips or {}
    if zip_prefix == None:
        zip_prefix = name
    pkg_filegroup(
        name = internal("all"),
        srcs = srcs,
        visibility = ["//visibility:private"],
        **kwargs
    )
    if zips:
        _zip_info(
            name = internal("zip-info"),
            srcs = zips,
            visibility = ["//visibility:private"],
        )
    for kind in ("generic", "arch"):
        _extract_pkg_filegroup(
            name = internal(kind),
            src = internal("all"),
            kind = kind,
            arch_overrides = arch_overrides,
            visibility = ["//visibility:private"],
        )
        if zips:
            pkg_zip(
                name = internal(kind, "zip-base"),
                srcs = [internal(kind)],
                visibility = ["//visibility:private"],
                compression_level = compression_level,
            )
            _zip_info_filter(
                name = internal(kind, "zip-info"),
                kind = kind,
                srcs = [internal("zip-info")],
                visibility = ["//visibility:private"],
            )
            _zipmerge(
                name = internal(kind, "zip"),
                srcs = [internal(kind, "zip-base"), internal(kind, "zip-info")],
                out = _get_zip_filename(name, kind),
                prefix = zip_prefix,
                visibility = visibility,
            )
        else:
            pkg_zip(
                name = internal(kind, "zip"),
                srcs = [internal(kind)],
                visibility = visibility,
                package_dir = zip_prefix,
                package_file_name = _get_zip_filename(name, kind),
                compression_level = compression_level,
            )
    if zips:
        _imported_zips_manifest(
            name = internal("zip-manifest"),
            srcs = [internal("generic-zip-info"), internal("arch-zip-info")],
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
        srcs = [Label("//misc/bazel/internal:install.py")],
        main = Label("//misc/bazel/internal:install.py"),
        data = [
            internal("build-file"),
            internal("script"),
        ] + ([
            internal("zip-manifest"),
            Label("//misc/ripunzip"),
        ] if zips else []),
        deps = ["@rules_python//python/runfiles"],
        args = [
            "--build-file=$(rlocationpath %s)" % internal("build-file"),
            "--pkg-install-script=$(rlocationpath %s)" % internal("script"),
            "--destdir",
            install_dest,
        ] + ([
            "--ripunzip=$(rlocationpath %s)" % Label("//misc/ripunzip"),
            "--zip-manifest=$(rlocationpath %s)" % internal("zip-manifest"),
        ] if zips else []),
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
