"""
Wrappers and helpers around `rules_pkg` to build codeql packs.
"""

load("@rules_pkg//pkg:install.bzl", "pkg_install")
load("@rules_pkg//pkg:mappings.bzl", "pkg_attributes", "pkg_filegroup", "pkg_files", _strip_prefix = "strip_prefix")
load("@rules_pkg//pkg:pkg.bzl", "pkg_zip")
load("@rules_pkg//pkg:providers.bzl", "PackageFilegroupInfo", "PackageFilesInfo")
load("@rules_python//python:defs.bzl", "py_binary")
load("//:defs.bzl", "codeql_platform")

def _make_internal(name):
    def internal(suffix = "internal"):
        return "%s-%s" % (name, suffix)

    return internal

def _get_subrule(label, suffix):
    if ":" in label or "/" not in label:
        return "%s-%s" % (label, suffix)
    path, _, pkg = label.rpartition("/")
    return "%s/%s:%s-%s" % (path, pkg, pkg, suffix)

_PackageFileWrapperInfo = provider(fields = {"pfi": "", "src": "", "arch_specific": ""})

CodeqlFilesInfo = provider(
    doc = """Wrapper around `rules_pkg` `PackageFilesInfo` carrying information about generic and arch-specific files.""",
    fields = {
        "files": "list of `_PackageFileWrapperInfo`.",
    },
)

def _codeql_pkg_filegroup_impl(ctx):
    prefix = ctx.attr.prefix
    if prefix:
        prefix += "/"
    generic_prefix = prefix
    if ctx.attr.arch_specific:
        if ctx.target_platform_has_constraint(ctx.attr._windows[platform_common.ConstraintValueInfo]):
            plat = "windows64"
        elif ctx.target_platform_has_constraint(ctx.attr._macos[platform_common.ConstraintValueInfo]):
            plat = "osx64"
        else:
            plat = "linux64"
        prefix = prefix + plat + "/"

    def transform_pfi(pfi, src, prefix = prefix, arch_specific = ctx.attr.arch_specific):
        return _PackageFileWrapperInfo(
            pfi = PackageFilesInfo(
                attributes = pfi.attributes,
                dest_src_map = {prefix + d: s for d, s in pfi.dest_src_map.items()},
            ),
            src = src,
            arch_specific = arch_specific,
        )

    files = []

    for src in ctx.attr.srcs:
        if PackageFilesInfo in src:
            pfi = src[PackageFilesInfo]
            files.append(transform_pfi(pfi, src.label))
        elif PackageFilegroupInfo in src:
            pfgi = src[PackageFilegroupInfo]
            if pfgi.pkg_dirs or pfgi.pkg_symlinks:
                fail("while assembling %s found %s which contains `pkg_dirs` or `pkg_symlinks` targets" %
                     (ctx.label, src.label) + ", which is not currently supported")
            files += [transform_pfi(pfi, src) for pfi, src in pfgi.pkg_files]
        else:
            cfi = src[CodeqlFilesInfo]
            files += [
                transform_pfi(
                    pfwi.pfi,
                    pfwi.src,
                    # if it was already arch specific the plat prefix was already added
                    generic_prefix if pfwi.arch_specific else prefix,
                    pfwi.arch_specific or ctx.attr.arch_specific,
                )
                for pfwi in cfi.files
            ]

    return [
        CodeqlFilesInfo(
            files = files,
        ),
        DefaultInfo(
            files = depset(transitive = [src[DefaultInfo].files for src in ctx.attr.srcs]),
        ),
    ]

codeql_pkg_filegroup = rule(
    implementation = _codeql_pkg_filegroup_impl,
    doc = """CodeQL specific packaging mapping. No `pkg_mkdirs` or `pkg_symlink` rules are supported, either directly
    or transitively. Only `pkg_files` and `pkg_filegroup` thereof are allowed.""",
    attrs = {
        "srcs": attr.label_list(
            doc = "List of arch-agnostic `pkg_files`, `pkg_filegroup` or `codeql_pkg_filegroup` targets",
            providers = [
                [PackageFilesInfo, DefaultInfo],
                [PackageFilegroupInfo, DefaultInfo],
                [CodeqlFilesInfo, DefaultInfo],
            ],
            default = [],
        ),
        "prefix": attr.string(doc = "Prefix to add to the files", default = ""),
        "arch_specific": attr.bool(doc = "Whether the included files should be treated as arch-specific"),
        "_windows": attr.label(default = "@platforms//os:windows"),
        "_macos": attr.label(default = "@platforms//os:macos"),
    },
)

def codeql_pkg_files(
        *,
        name,
        srcs = None,
        exes = None,
        arch_specific = False,
        prefix = None,
        visibility = None,
        **kwargs):
    """
    Wrapper around `pkg_files`. Added functionality:
    * `exes` will get their file attributes set to be executable. This is important only for POSIX files, there's no
      need to mark windows executables as such
    If `exes` and `srcs` are both used, the resulting rule is a `pkg_filegroup` one.
    """
    internal = _make_internal(name)
    if "attributes" in kwargs:
        fail("codeql_pkg_files does not support `attributes`. Use `exes` to mark executable files.")
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
        internal_srcs = [internal("srcs"), internal("exes")]
    else:
        pkg_files(
            name = internal(),
            srcs = srcs or exes,
            visibility = visibility,
            attributes = pkg_attributes(mode = "755") if exes else None,
            **kwargs
        )
        internal_srcs = [internal()]
    codeql_pkg_filegroup(
        name = name,
        srcs = internal_srcs,
        arch_specific = arch_specific,
        prefix = prefix,
        visibility = visibility,
    )

def _extract_pkg_filegroup_impl(ctx):
    src = ctx.attr.src[CodeqlFilesInfo]
    pfi_lbls = [(pfwi.pfi, pfwi.src) for pfwi in src.files if pfwi.arch_specific == ctx.attr.arch_specific]
    files = [depset(pfi.dest_src_map.values()) for pfi, _ in pfi_lbls]
    return [
        PackageFilegroupInfo(pkg_files = pfi_lbls, pkg_dirs = [], pkg_symlinks = []),
        DefaultInfo(files = depset(transitive = files)),
    ]

_extrac_pkg_filegroup = rule(
    implementation = _extract_pkg_filegroup_impl,
    attrs = {
        "src": attr.label(providers = [CodeqlFilesInfo, DefaultInfo]),
        "arch_specific": attr.bool(),
    },
)

def codeql_pack(
        *,
        name,
        srcs = None,
        zip_prefix = None,
        zip_filename = "extractor",
        visibility = None,
        install_dest = "extractor-pack",
        **kwargs):
    """
    Define a codeql pack. This accepts `pkg_files`, `pkg_filegroup` or their `codeql_*` counterparts as `srcs`.
    * defines a `<name>-generic-zip` target creating a `<zip_filename>-generic.zip` archive with the generic bits,
      prefixed with `zip_prefix` (`name` by default)
    * defines a `<name>-arch-zip` target creating a `<zip_filename>-<codeql_platform>.zip` archive with the
      arch-specific bits, prefixed with `zip_prefix` (`name` by default)
    * defines a runnable `<name>-installer` target that will install the pack in `install_dest`, relative to where the
      rule is used. The install destination can be overridden appending `-- --destdir=...` to the `bazel run`
      invocation. This installation does not use the `zip_prefix`.
    """
    internal = _make_internal(name)
    zip_prefix = zip_prefix or name
    zip_filename = zip_filename or name
    codeql_pkg_filegroup(
        name = name,
        srcs = srcs,
        visibility = visibility,
        **kwargs
    )
    for kind in ("generic", "arch"):
        _extrac_pkg_filegroup(
            name = internal(kind),
            src = name,
            arch_specific = kind == "arch",
            visibility = ["//visibility:private"],
        )
        pkg_filegroup(
            name = internal(kind + "-zip-contents"),
            srcs = [internal(kind)],
            prefix = zip_prefix,
            visibility = ["//visibility:private"],
        )
        pkg_zip(
            name = internal(kind + "-zip"),
            srcs = [internal(kind + "-zip-contents")],
            package_file_name = zip_filename + "-" + (codeql_platform if kind == "arch" else kind) + ".zip",
            visibility = visibility,
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
        data = [internal("build-file"), internal("script")],
        deps = ["@rules_python//python/runfiles"],
        args = [
            "--build-file=$(rlocationpath %s)" % internal("build-file"),
            "--script=$(rlocationpath %s)" % internal("script"),
            "--destdir",
            install_dest,
        ],
        visibility = visibility,
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
