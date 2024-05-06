"""
Wrappers and helpers around `rules_pkg` to build codeql packs.
"""

load("@rules_pkg//pkg:install.bzl", "pkg_install")
load("@rules_pkg//pkg:mappings.bzl", "pkg_attributes", "pkg_filegroup", "pkg_files", _strip_prefix = "strip_prefix")
load("@rules_pkg//pkg:pkg.bzl", "pkg_zip")
load("@rules_python//python:defs.bzl", "py_binary")
load("//:defs.bzl", "codeql_platform")

def _make_internal(name):
    def internal(suffix):
        return "%s-%s" % (name, suffix)

    return internal

def _get_subrule(label, suffix):
    if ":" in label or "/" not in label:
        return "%s-%s" % (label, suffix)
    path, _, pkg = label.rpartition("/")
    return "%s/%s:%s-%s" % (path, pkg, pkg, suffix)

def codeql_pkg_files(
        *,
        name,
        arch_specific = False,
        srcs = None,
        exes = None,
        renames = None,
        prefix = None,
        visibility = None,
        **kwargs):
    """
    Wrapper around `pkg_files`. Added functionality:
    * `exes` get their file attributes set to be executable. This is important only for POSIX files, there's no need
      to mark windows executables as such
    * `arch_specific` auto-adds the codeql platform specific directory (linux64, osx64 or windows64), and will be
      consumed by a downstream `codeql_pack` to create the arch specific zip.
    This should be consumed by `codeql_pkg_filegroup` and `codeql_pack` only.
    """
    internal = _make_internal(name)
    main_rule = internal("generic")
    empty_rule = internal("arch")
    if arch_specific:
        main_rule, empty_rule = empty_rule, main_rule
        prefix = (prefix + "/" if prefix else "") + codeql_platform
    pkg_files(
        name = empty_rule,
        srcs = [],
        visibility = visibility,
    )
    if not srcs and not exes:
        fail("either srcs or exes should be specified for %s" % name)
    if srcs and exes:
        if renames:
            src_renames = {k: v for k, v in renames.items() if k in srcs}
            exe_renames = {k: v for k, v in renames.items() if k in exes}
        else:
            src_renames = None
            exe_renames = None
        pkg_files(
            name = internal("srcs"),
            srcs = srcs,
            renames = src_renames,
            prefix = prefix,
            visibility = ["//visibility:private"],
            **kwargs
        )
        pkg_files(
            name = internal("exes"),
            srcs = exes,
            renames = exe_renames,
            prefix = prefix,
            visibility = ["//visibility:private"],
            attributes = pkg_attributes(mode = "0755"),
            **kwargs
        )
        pkg_filegroup(
            name = main_rule,
            srcs = [internal("srcs"), internal("exes")],
            visibility = visibility,
        )
    else:
        pkg_files(
            name = main_rule,
            srcs = srcs or exes,
            attributes = pkg_attributes(mode = "0755") if exes else None,
            prefix = prefix,
            visibility = visibility,
            **kwargs
        )
    native.filegroup(
        name = name,
        srcs = [main_rule],
        visibility = visibility,
    )

def codeql_pkg_wrap(*, name, srcs, arch_specific = False, prefix = None, visibility = None, **kwargs):
    """
    Wrap a native `rules_pkg` rule, providing the `arch_specific` functionality and making it consumable by
    `codeql_pkg_filegroup` and `codeql_pack`.
    """
    internal = _make_internal(name)
    main_rule = internal("generic")
    empty_rule = internal("arch")
    if arch_specific:
        main_rule, empty_rule = empty_rule, main_rule
        prefix = (prefix + "/" if prefix else "") + codeql_platform
    pkg_filegroup(
        name = main_rule,
        srcs = srcs,
        prefix = prefix,
        visibility = visibility,
        **kwargs
    )
    pkg_files(
        name = empty_rule,
        srcs = [],
        visibility = visibility,
    )
    native.filegroup(
        name = name,
        srcs = [main_rule],
        visibility = visibility,
    )

def codeql_pkg_filegroup(
        *,
        name,
        srcs,
        srcs_select = None,
        visibility = None,
        **kwargs):
    """
    Combine `codeql_pkg_files` and other `codeql_pkg_filegroup` rules, similar to what `pkg_filegroup` does.
    `srcs` is not selectable, but `srcs_select` accepts the same dictionary that a select would accept.
    """
    internal = _make_internal(name)

    def transform(srcs, suffix):
        return [_get_subrule(src, suffix) for src in srcs]

    pkg_filegroup(
        name = internal("generic"),
        srcs = transform(srcs, "generic") + (select(
            {k: transform(v, "generic") for k, v in srcs_select.items()},
        ) if srcs_select else []),
        visibility = visibility,
        **kwargs
    )
    pkg_filegroup(
        name = internal("arch"),
        srcs = transform(srcs, "arch") + (select(
            {k: transform(v, "arch") for k, v in srcs_select.items()},
        ) if srcs_select else []),
        visibility = visibility,
        **kwargs
    )
    native.filegroup(
        name = name,
        srcs = [internal("generic"), internal("arch")],
        visibility = visibility,
    )

def codeql_pack(*, name, srcs, zip_prefix = None, zip_filename = "extractor", visibility = visibility, install_dest = "extractor-pack", **kwargs):
    """
    Define a codeql pack. This accepts the same arguments as `codeql_pkg_filegroup`, and additionally:
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
    codeql_pkg_filegroup(
        name = internal("zip-contents"),
        srcs = [name],
        prefix = zip_prefix,
        visibility = ["//visibility:private"],
    )
    pkg_zip(
        name = internal("generic-zip"),
        srcs = [internal("zip-contents-generic")],
        package_file_name = zip_filename + "-generic.zip",
        visibility = visibility,
    )
    pkg_zip(
        name = internal("arch-zip"),
        srcs = [internal("zip-contents-arch")],
        package_file_name = zip_filename + "-" + codeql_platform + ".zip",
        visibility = visibility,
    )
    pkg_install(
        name = internal("script"),
        srcs = [internal("generic"), internal("arch")],
        visibility = ["//visibility:private"],
    )
    native.filegroup(
        # used to locate current source directory
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
