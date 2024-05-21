load("@rules_pkg//pkg:providers.bzl", "PackageFilegroupInfo", "PackageFilesInfo")

def _pkg_overlay_impl(ctx):
    destinations = {}
    files = []

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
    return [
        PackageFilegroupInfo(
            pkg_files = reversed(files),
            pkg_dirs = [],
            pkg_symlinks = [],
        ),
        DefaultInfo(
            files = depset(transitive = [src[DefaultInfo].files for src in ctx.attr.srcs]),
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
