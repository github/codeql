def _ripunzip_archive_impl(repository_ctx):
    version = repository_ctx.attr.version
    url_prefix = "https://github.com/GoogleChrome/ripunzip/releases/download/v%s" % version
    build_file = Label("//misc/ripunzip:BUILD.ripunzip.bazel")
    if "linux" in repository_ctx.os.name:
        arch = repository_ctx.os.arch
        if arch == "aarch64":
            deb_arch = "arm64"
            sha256 = repository_ctx.attr.sha256_linux_arm64
            canonical_id = "ripunzip-linux-arm64"
        else:
            deb_arch = "amd64"
            sha256 = repository_ctx.attr.sha256_linux_x64
            canonical_id = "ripunzip-linux-x64"

        # ripunzip only provides a deb package for Linux: we fish the binary out of it
        # a deb archive contains a data.tar.xz one which contains the files to be installed under usr/bin
        repository_ctx.download_and_extract(
            url = "%s/ripunzip_%s-1_%s.deb" % (url_prefix, version, deb_arch),
            sha256 = sha256,
            canonical_id = canonical_id,
            output = "deb",
        )
        repository_ctx.extract(
            "deb/data.tar.xz",
            strip_prefix = "usr/bin",
            output = "bin",
        )
    elif "windows" in repository_ctx.os.name:
        repository_ctx.download_and_extract(
            url = "%s/ripunzip_v%s_x86_64-pc-windows-msvc.zip" % (url_prefix, version),
            canonical_id = "ripunzip-windows-x64",
            sha256 = repository_ctx.attr.sha256_windows_x64,
            output = "bin",
        )
    elif "mac os" in repository_ctx.os.name:
        arch = repository_ctx.os.arch
        if arch == "x86_64":
            suffix = "x86_64-apple-darwin"
            sha256 = repository_ctx.attr.sha256_macos_x64
            canonical_id = "ripunzip-macos-x64"
        elif arch == "aarch64":
            suffix = "aarch64-apple-darwin"
            sha256 = repository_ctx.attr.sha256_macos_arm64
            canonical_id = "ripunzip-macos-arm64"
        else:
            fail("Unsupported macOS architecture: %s" % arch)
        repository_ctx.download_and_extract(
            url = "%s/ripunzip_v%s_%s.tar.gz" % (url_prefix, version, suffix),
            sha256 = sha256,
            canonical_id = canonical_id,
            output = "bin",
        )
    else:
        fail("Unsupported OS: %s" % repository_ctx.os.name)
    repository_ctx.file("WORKSPACE.bazel")
    repository_ctx.symlink(build_file, "BUILD.bazel")

ripunzip_archive = repository_rule(
    implementation = _ripunzip_archive_impl,
    doc = "Downloads a prebuilt ripunzip binary for the host platform from https://github.com/GoogleChrome/ripunzip/releases",
    attrs = {
        "version": attr.string(mandatory = True),
        "sha256_linux_x64": attr.string(mandatory = True),
        "sha256_linux_arm64": attr.string(mandatory = True),
        "sha256_windows_x64": attr.string(mandatory = True),
        "sha256_macos_x64": attr.string(mandatory = True),
        "sha256_macos_arm64": attr.string(mandatory = True),
    },
)
