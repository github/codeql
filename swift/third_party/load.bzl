load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

_swift_prebuilt_version = "swift-5.10-RELEASE.322"
_swift_sha_map = {
    "Linux-X64": "634497779e930a808489e5d472753b604c07085abf411356cae7921bde14130f",
    "macOS-ARM64": "293df92da9a3cc79c595a28b1b4ec881a5fdb248ea7eac34c89943e94deff700",
    "macOS-X64": "813c1746777701d30e716c130b0bb087a9c5b7ab025fd99afc695ec52cd432ad",
}

_swift_arch_map = {
    "Linux-X64": "linux",
    "macOS-X64": "darwin_x86_64",
}

_swift_version = _swift_prebuilt_version.rpartition(".")[0]

_toolchain_info = {
    "linux": struct(
        platform = "ubuntu2004",
        suffix = "ubuntu20.04",
        extension = "tar.gz",
        sha = "935d0b68757d9b1aceb6410fe0b126a28a07e362553ebba0c4bcd1c9a55d0bc5",
    ),
    "macos": struct(
        platform = "xcode",
        suffix = "osx",
        extension = "pkg",
        sha = "ef9bb6b38711324e1b1c89de44a27d9519d0711924c57f4df541734b04aaf6cc",
    ),
}

def _get_toolchain_url(info):
    return "https://download.swift.org/%s/%s/%s/%s-%s.%s" % (
        _swift_version.lower(),
        info.platform,
        _swift_version,
        _swift_version,
        info.suffix,
        info.extension,
    )

def _toolchains():
    rules = {
        "tar.gz": http_archive,
        "pkg": _pkg_archive,
    }
    for arch, info in _toolchain_info.items():
        rule = rules[info.extension]
        rule(
            name = "swift_toolchain_%s" % arch,
            url = _get_toolchain_url(info),
            sha256 = info.sha,
            build_file = _build % "swift-toolchain-%s" % arch,
            strip_prefix = "%s-%s" % (_swift_version, info.suffix),
        )

def _run(repository_ctx, message, cmd, working_directory = "."):
    repository_ctx.report_progress(message)
    res = repository_ctx.execute(
        ["bash", "-c", cmd],
        working_directory = working_directory,
    )
    if res.return_code != 0:
        fail(message)

def _pkg_archive_impl(repository_ctx):
    archive = "file.pkg"
    url = repository_ctx.attr.url
    dir = "%s-package.pkg" % repository_ctx.attr.strip_prefix
    repository_ctx.report_progress("downloading %s" % url)
    res = repository_ctx.download(
        url,
        output = archive,
        sha256 = repository_ctx.attr.sha256,
    )
    if not repository_ctx.attr.sha256:
        print("Rule '%s' indicated that a canonical reproducible form " % repository_ctx.name +
              "can be obtained by modifying arguments sha256 = \"%s\"" % res.sha256)
    _run(repository_ctx, "extracting %s" % dir, "xar -xf %s" % archive)
    repository_ctx.delete(archive)
    _run(
        repository_ctx,
        "extracting Payload from %s" % dir,
        "cat %s/Payload | gunzip -dc | cpio -i" % dir,
    )
    repository_ctx.delete(dir)
    repository_ctx.symlink(repository_ctx.attr.build_file, "BUILD")
    repository_ctx.file("WORKSPACE")

_pkg_archive = repository_rule(
    implementation = _pkg_archive_impl,
    attrs = {
        "url": attr.string(mandatory = True),
        "sha256": attr.string(),
        "strip_prefix": attr.string(),
        "build_file": attr.label(mandatory = True),
    },
)

def _github_archive(*, name, repository, commit, build_file = None, sha256 = None):
    github_name = repository[repository.index("/") + 1:]
    maybe(
        repo_rule = http_archive,
        name = name,
        url = "https://github.com/%s/archive/%s.zip" % (repository, commit),
        strip_prefix = "%s-%s" % (github_name, commit),
        build_file = build_file,
        sha256 = sha256,
    )

_build = "//swift/third_party:BUILD.%s.bazel"

def load_dependencies(module_ctx):
    for repo_arch, arch in _swift_arch_map.items():
        sha256 = _swift_sha_map[repo_arch]

        http_archive(
            name = "swift_prebuilt_%s" % arch,
            url = "https://github.com/dsp-testing/codeql-swift-artifacts/releases/download/%s/swift-prebuilt-%s.zip" % (
                _swift_prebuilt_version,
                repo_arch,
            ),
            build_file = _build % "swift-llvm-support",
            sha256 = sha256,
        )

    _toolchains()

    _github_archive(
        name = "picosha2",
        build_file = _build % "picosha2",
        repository = "okdshin/PicoSHA2",
        commit = "27fcf6979298949e8a462e16d09a0351c18fcaf2",
        sha256 = "d6647ca45a8b7bdaf027ecb68d041b22a899a0218b7206dee755c558a2725abb",
    )

    _github_archive(
        name = "binlog",
        build_file = _build % "binlog",
        repository = "morganstanley/binlog",
        commit = "3fef8846f5ef98e64211e7982c2ead67e0b185a6",
        sha256 = "f5c61d90a6eff341bf91771f2f465be391fd85397023e1b391c17214f9cbd045",
    )

    return module_ctx.extension_metadata(
        root_module_direct_deps = "all",
        root_module_direct_dev_deps = [],
    )

swift_deps = module_extension(load_dependencies)
