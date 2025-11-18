def _impl(repository_ctx):
    version = repository_ctx.attr.version
    url_prefix = "https://github.com/GoogleChrome/ripunzip/releases/download/v%s" % version
    build_file = Label("//misc/ripunzip:BUILD.ripunzip.bazel")
    if repository_ctx.os.name == "linux":
        repository_ctx.download_and_extract(
            url="%s/ripunzip_%s-1_amd64.deb" % (url_prefix, version),
            sha256=repository_ctx.attr.sha256_linux,
            canonical_id="ripunzip-deb",
            output="deb",
        )
        repository_ctx.extract(
            "deb/data.tar.xz",
            strip_prefix="usr",
        )
    elif repository_ctx.os.name == "windows":
        repository_ctx.download_and_extract(
            url="%s/ripunzip_v%s-x86_64-pc-windows-msvc.zip" % (url_prefix, version),
            sha256=repository_ctx.attr.sha256_windows,
            output="bin",
        )
    elif repository_ctx.os.name == "macos":
        arch = repository_ctx.os.arch
        if arch == "x86_64":
            suffix = "x86_64-apple-darwin"
            sha256 = repository_ctx.attr.sha256_macos_intel
        elif arch == "aarch64":
            suffix = "aarch64-apple-darwin"
            sha256 = repository_ctx.attr.sha256_macos_arm
        else:
            fail("Unsupported macOS architecture: %s" % arch)
        repository_ctx.download_and_extract(
            url="%s/ripunzip_v%s-%s.tar.gz" % (url_prefix, version, suffix),
            sha256=sha256,
            output="bin",
        )
    else:
        fail("Unsupported OS: %s" % repository_ctx.os.name)
    repository_ctx.file("WORKSPACE.bazel")
    repository_ctx.symlink(build_file, "BUILD.bazel")

ripunzip_archive = repository_rule(
    implementation=_impl,
    attrs={
        "version": attr.string(mandatory=True),
        "sha256_linux": attr.string(mandatory=True),
        "sha256_windows": attr.string(mandatory=True),
        "sha256_macos_intel": attr.string(mandatory=True),
        "sha256_macos_arm": attr.string(mandatory=True),
    },
)
