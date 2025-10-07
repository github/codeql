"""
Wrappers and helpers around `rules_pkg` to build codeql packs.
"""

load("@bazel_skylib//lib:paths.bzl", "paths")
load("@bazel_skylib//rules:native_binary.bzl", "native_test")
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
    return ("common", path)

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

_ZipInfo = provider(fields = {"zips_to_prefixes": "mapping of zip files to prefixes"})

CodeQLPackInfo = provider(
    "A provider that encapsulates all the information needed to build a codeql pack.",
    fields = {
        "pack_prefix": "A prefix to add to all paths, IF the user requests so. We omit it for local installation targets of single packs (but not pack groups)",
        "files": "PackageFilegroupInfo provider with list of all files in this pack (CODEQL_PLATFORM in paths unresolved)",
        "zips": "A _ZipInfo provider to include in the pack, (CODEQL_PLATFORM unresolved).",
        "arch_overrides": "A list of files that should be included in the arch-specific bit, even though the path doesn't contain CODEQL_PLATFORM.",
    },
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
        # Disable remote caching for zipmerge:
        # * One of the inputs to zipmerge (often the larger one) comes from a lazy-lfs rule.
        #   Those are retrieved by bazel even in the presence of a build cache, so downloading the whole zipmerged
        #   artifact is slower than downloading the smaller bazel-produced zip and rerunning zipmerge on that
        #   and the (already-present) LFS artifact.
        # * This prevents unnecessary cache usage - every change to the Swift extractor would otherwise
        #   trigger a build of a >500MB zip file that'd quickly fill up the cache.
        execution_requirements = {
            "no-remote-cache": "1",
        },
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
        return "%s-common.zip" % name_prefix

def _codeql_pack_info_impl(ctx):
    zips_to_prefixes = {}
    for zip_target, prefix in ctx.attr.extra_zips.items():
        for zip in zip_target.files.to_list():
            zips_to_prefixes[zip] = prefix
    return [
        DefaultInfo(files = depset(
            zips_to_prefixes.keys(),
            transitive = [ctx.attr.src[DefaultInfo].files],
        )),
        CodeQLPackInfo(
            arch_overrides = ctx.attr.arch_overrides,
            files = ctx.attr.src[PackageFilegroupInfo],
            zips = _ZipInfo(zips_to_prefixes = zips_to_prefixes),
            pack_prefix = ctx.attr.prefix,
        ),
    ]

_codeql_pack_info = rule(
    implementation = _codeql_pack_info_impl,
    doc = """
        This internal rule is a bit of a catch-all forwarder for the various information we need to forward to allow
        building pack groups.
        We have conflicting requirements for this data:
        To build installer targets, we need to resolve all files, as directly as possible (no intermediate zip step),
        and potentially omit the `prefix`.
        To provide production distribution zips, we need to expose zip targets that distinguish between common and per-platform
        files, and that do contain `prefix` in their path.
        In both cases, we need to pull in the correct extra_zips for some packs.
        Therefore, we preserve the input data from the pack declaration fairly directly,
        and only massage it into the right form once we use it.
    """,
    attrs = {
        "src": attr.label(providers = [PackageFilegroupInfo], mandatory = True, doc = "The files to include in the pack, with unresolved CODEQL_PLATFORM paths (a pkg_filegroup rule instance)."),
        "extra_zips": attr.label_keyed_string_dict(
            doc = "Mapping from zip files to install prefixes.",
            allow_files = [".zip"],
        ),
        "prefix": attr.string(doc = "Prefix to add to all files."),
        "arch_overrides": attr.string_list(doc = "A list of files that should be included in the arch package regardless of the path, specify the path _without_ `prefix`."),
    },
    provides = [CodeQLPackInfo],
)

_CODEQL_PACK_GROUP_EXTRACT_ATTRS = {
    "srcs": attr.label_list(providers = [CodeQLPackInfo], mandatory = True, doc = "List of `_codeql_pack_info` rules (generated by `codeql_pack`)."),
    "apply_pack_prefix": attr.bool(doc = "Set to `False` to skip adding the per-pack prefix to all file paths.", default = True),
    "kind": attr.string(doc = "Extract only the commmon, arch-specific, or all files from the pack group.", values = ["common", "arch", "all"]),
    "prefix": attr.string(doc = "Prefix to add to all files, is prefixed after the per-pack prefix has been applied.", default = ""),
} | OS_DETECTION_ATTRS

# common option parsing for _codeql_pack_group_extract_* rules
def _codeql_pack_group_extract_options(ctx):
    platform = _detect_platform(ctx)
    apply_pack_prefix = ctx.attr.apply_pack_prefix
    include_all_files = ctx.attr.kind == "all"
    return platform, apply_pack_prefix, include_all_files

def _codeql_pack_group_extract_files_impl(ctx):
    pkg_files = []

    platform, apply_pack_prefix, include_all_files = _codeql_pack_group_extract_options(ctx)
    for src in ctx.attr.srcs:
        src = src[CodeQLPackInfo]
        if src.files.pkg_dirs or src.files.pkg_symlinks:
            fail("`pkg_dirs` and `pkg_symlinks` are not supported for codeql packaging rules")
        prefix = paths.join(ctx.attr.prefix, src.pack_prefix) if apply_pack_prefix else ctx.attr.prefix

        arch_overrides = src.arch_overrides

        # for each file, resolve whether it's filtered out or not by the current kind, and add the pack prefix
        for pfi, origin in src.files.pkg_files:
            dest_src_map = {}
            for dest, file in pfi.dest_src_map.items():
                pack_dest = paths.join(prefix, dest)
                file_kind, expanded_dest = _expand_path(pack_dest, platform)
                if file_kind == "common" and dest in arch_overrides:
                    file_kind = "arch"
                if include_all_files or file_kind == ctx.attr.kind:
                    dest_src_map[expanded_dest] = file

            if dest_src_map:
                pkg_files.append((PackageFilesInfo(dest_src_map = dest_src_map, attributes = pfi.attributes), origin))

    files = [depset(pfi.dest_src_map.values()) for pfi, _ in pkg_files]

    return [
        DefaultInfo(files = depset(transitive = files)),
        PackageFilegroupInfo(pkg_files = pkg_files, pkg_dirs = [], pkg_symlinks = []),
    ]

_codeql_pack_group_extract_files = rule(
    implementation = _codeql_pack_group_extract_files_impl,
    doc = """
    Extract the files from a list of codeql packs (i.e. a pack group), and filter to the requested `kind`.
    See also `_codeql_pack_group_extract_zips`.
    """,
    attrs = _CODEQL_PACK_GROUP_EXTRACT_ATTRS,
    provides = [PackageFilegroupInfo],
)

def _codeql_pack_group_extract_zips_impl(ctx):
    zips_to_prefixes = {}

    platform, apply_pack_prefix, include_all_files = _codeql_pack_group_extract_options(ctx)
    for src in ctx.attr.srcs:
        src = src[CodeQLPackInfo]
        prefix = paths.join(ctx.attr.prefix, src.pack_prefix) if apply_pack_prefix else ctx.attr.prefix

        # for each zip file, resolve whether it's filtered out or not by the current kind, and add the pack prefix
        for zip, zip_prefix in src.zips.zips_to_prefixes.items():
            zip_kind, expanded_prefix = _expand_path(paths.join(prefix, zip_prefix), platform)
            if include_all_files or zip_kind == ctx.attr.kind:
                zips_to_prefixes[zip] = expanded_prefix

    return [
        DefaultInfo(files = depset(zips_to_prefixes.keys())),
        _ZipInfo(zips_to_prefixes = zips_to_prefixes),
    ]

_codeql_pack_group_extract_zips = rule(
    implementation = _codeql_pack_group_extract_zips_impl,
    doc = """
    Extract the zip files from a list of codeql packs (i.e. a pack group), and filter to the requested `kind`.
    See also `_codeql_pack_group_extract_files`.
    """,
    attrs = _CODEQL_PACK_GROUP_EXTRACT_ATTRS,
    provides = [_ZipInfo],
)

def _codeql_pack_install(name, srcs, install_dest = None, build_file_label = None, prefix = "", apply_pack_prefix = True):
    """
    Create a runnable target `name` that installs the list of codeql packs given in `srcs` in `install_dest`,
    relative to the directory where the rule is used.
    The base directory can be overwritten by `build_file_label`.
    At run time, you can pass `--destdir` to change the installation directory.

    If `apply_pack_prefix` is set to `True`, the pack prefix will be added to all paths.
    We skip applying the pack prefix for the single-pack installations in the source tree, and include it when
    installing packs as part of a pack group.
    """
    internal = _make_internal(name)
    _codeql_pack_group_extract_files(
        name = internal("all-files"),
        srcs = srcs,
        prefix = prefix,
        kind = "all",
        apply_pack_prefix = apply_pack_prefix,
        visibility = ["//visibility:private"],
    )
    _codeql_pack_group_extract_zips(
        name = internal("all-extra-zips"),
        kind = "all",
        srcs = srcs,
        prefix = prefix,
        apply_pack_prefix = apply_pack_prefix,
        visibility = ["//visibility:private"],
    )
    _imported_zips_manifest(
        name = internal("zip-manifest"),
        srcs = [internal("all-extra-zips")],
        visibility = ["//visibility:private"],
    )
    pkg_install(
        name = internal("script"),
        srcs = [internal("all-files")],
        visibility = ["//visibility:private"],
    )
    if build_file_label == None:
        native.filegroup(
            # used to locate current src directory
            name = internal("build-file"),
            srcs = ["BUILD.bazel"],
            visibility = ["//visibility:private"],
        )
        build_file_label = internal("build-file")
    data = [
        internal("script"),
        internal("zip-manifest"),
        Label("//misc/ripunzip"),
    ] + ([build_file_label] if build_file_label else [])
    args = [
        "--pkg-install-script=$(rlocationpath %s)" % internal("script"),
        "--ripunzip=$(rlocationpath %s)" % Label("//misc/ripunzip"),
        "--zip-manifest=$(rlocationpath %s)" % internal("zip-manifest"),
    ] + ([
        "--build-file=$(rlocationpath %s)" % build_file_label,
    ] if build_file_label else []) + (
        ["--destdir", "\"%s\"" % install_dest] if install_dest else []
    )
    py_binary(
        name = name,
        srcs = [Label("//misc/bazel/internal:install.py")],
        main = Label("//misc/bazel/internal:install.py"),
        deps = ["@rules_python//python/runfiles"],
        data = data,
        args = args,
    )

    # this hack is meant to be an optimization when using install for tests, where
    # the install step is skipped if nothing changed. If the installation directory
    # is somehow messed up, `bazel run` can be used to force install
    native_test(
        name = internal("as", "test"),
        src = name,
        tags = [
            "manual",  # avoid having this picked up by `...`, `:all` or `:*`
            "local",  # make sure installation does not run sandboxed
        ],
        data = data,
        args = args,
        size = "small",
    )

def codeql_pack_group(name, srcs, visibility = None, skip_installer = False, prefix = "", install_dest = None, build_file_label = None, compression_level = 6):
    """
    Create a group of codeql packs of name `name`.
    Accepts a list of `codeql_pack`s in `srcs` (essentially, `_codeql_pack_info` instantiations).
    A pack group declares the following:
    * a `<name>-common-zip` target creating a `<name>-common.zip` archive with the common parts of the pack group
    * a `<name>-arch-zip` target creating a `<name>-<codeql_platform>.zip` archive with the arch-specific parts of the pack group
    * a `<name>-installer` target that will install the pack group in `install_dest`, relative to where the rule is used.
      The base directory can be overwritten by `build_file_label`, see `codeql_pack_install`.
      The install destination can be overridden appending `-- --destdir=...` to the `bazel run` invocation.
    The installer target will be omitted if `skip_installer` is set to `True`.

    Prefixes all paths in the pack group with `prefix`.

    The compression level of the generated zip files can be set with `compression_level`. Note that this doesn't affect the compression
    level of extra zip files that are added to a pack, as these files will not be re-compressed.
    """
    internal = _make_internal(name)

    for kind in ("common", "arch"):
        _codeql_pack_group_extract_files(
            name = internal(kind),
            srcs = srcs,
            kind = kind,
            prefix = prefix,
            visibility = ["//visibility:private"],
        )
        pkg_zip(
            name = internal(kind, "zip-base"),
            srcs = [internal(kind)],
            visibility = ["//visibility:private"],
            compression_level = compression_level,
        )
        _codeql_pack_group_extract_zips(
            name = internal(kind, "extra-zips"),
            kind = kind,
            srcs = srcs,
            prefix = prefix,
            visibility = ["//visibility:private"],
        )
        _zipmerge(
            name = internal(kind, "zip"),
            srcs = [internal(kind, "zip-base"), internal(kind, "extra-zips")],
            out = _get_zip_filename(name, kind),
            visibility = visibility,
        )
    if not skip_installer:
        _codeql_pack_install(name, srcs, build_file_label = build_file_label, install_dest = install_dest, prefix = prefix, apply_pack_prefix = True)

def codeql_pack(
        *,
        name,
        srcs = None,
        zips = None,
        arch_overrides = None,
        pack_prefix = None,
        install_dest = "extractor-pack",
        installer_alias = "install",
        experimental = False,
        **kwargs):
    """
    Define a codeql pack.
    Packs are used as input to `codeql_pack_group`, which allows convenient building and bundling of packs.

    This macro accepts `pkg_files`, `pkg_filegroup` or their `codeql_*` counterparts as `srcs`.
    `zips` is a map from `.zip` files to prefixes to import.
    The distinction between arch-specific and common contents is made based on whether the paths (including possible
    prefixes added by rules) contain the special `{CODEQL_PLATFORM}` placeholder, which in case it is present will also
    be replaced by the appropriate platform (`linux64`, `win64` or `osx64`).
    Specific file paths can be placed in the arch-specific package by adding them to `arch_overrides`, even if their
    path doesn't contain the `CODEQL_PLATFORM` placeholder.

    The codeql pack rules will expand the `{CODEQL_PLATFORM}` marker in paths, and use that to split the files into a common and an arch-specific part.
    This placeholder will be replaced by the appropriate platform (`linux64`, `win64` or `osx64`).
    `arch_overrides` is a list of files that should be included in the arch-specific bits of the pack, even if their path doesn't
    contain the `{CODEQL_PLATFORM}` marker.
    All files in the pack will be prefixed with `name`, unless `pack_prefix` is set, then is used instead.

    This rule also provides a convenient installer target named `<name>-installer`, with a path governed by `install_dest`,
    unless `install_dest == None`. This installer is used for installing this pack into the source-tree, relative to the
    directory where the rule is used. See `codeql_pack_install` for more details. If present, `installer_alias` is used
    to define a shorthand alias for `<name>-installer`. Be sure to change `installer_alias` or set it to `None` if a
    bazel package defines multiple `codeql_pack`s.

    If `experimental = True`, a second `codeql_pack` named `<name>-experimental` is defined alongside the primary one with
    an `experimental` pack prefix and no installer, intended to be used when packaging the full distribution.

    This function does not accept `visibility`, as packs are always public to make it easy to define pack groups.
    """
    if pack_prefix == None:
        pack_prefix = name
    _codeql_pack_impl(
        name,
        srcs,
        zips,
        arch_overrides,
        pack_prefix,
        install_dest,
        installer_alias,
        pkg_filegroup_kwargs = kwargs,
    )
    if experimental:
        _codeql_pack_impl(
            "%s-experimental" % name,
            srcs,
            zips,
            arch_overrides,
            pack_prefix = "experimental/%s" % pack_prefix,
            install_dest = None,
            installer_alias = None,
            pkg_filegroup_kwargs = kwargs,
        )

        # TODO: remove this after internal repo update
        native.alias(
            name = "experimental-%s" % name,
            actual = "%s-experimental" % name,
            visibility = ["//visibility:public"],
        )

def _codeql_pack_impl(
        name,
        srcs,
        zips,
        arch_overrides,
        pack_prefix,
        install_dest,
        installer_alias,
        pkg_filegroup_kwargs):
    internal = _make_internal(name)
    zips = zips or {}
    pkg_filegroup(
        name = internal("all"),
        srcs = srcs,
        visibility = ["//visibility:private"],
        **pkg_filegroup_kwargs
    )
    _codeql_pack_info(
        name = name,
        src = internal("all"),
        extra_zips = zips,
        prefix = pack_prefix,
        arch_overrides = arch_overrides,
        # packs are always public, so that we can easily bundle them into groups
        visibility = ["//visibility:public"],
    )
    if install_dest:
        _codeql_pack_install(internal("installer"), [name], install_dest = install_dest, apply_pack_prefix = False)

        # TODO: remove deprecated `native.existing_rule(installer_alias)` after internal repo update
        if installer_alias and not native.existing_rule(installer_alias):
            native.alias(name = installer_alias, actual = internal("installer"))

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
