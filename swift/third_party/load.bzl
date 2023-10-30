load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

# TODO: remove `remove-result-of.patch` once we update to a Swift version containing
# https://github.com/apple/swift/commit/2ed2cea2
# (probably when updating to 5.9)
_swift_prebuilt_version = "swift-5.8.1-RELEASE.214"
_swift_sha_map = {
    "Linux-X64": "009594131d2f6327e0033c4b7b0479a5730427575eb59a81a439fe0e343aa777",
    "macOS-ARM64": "304a918e3699d404f57e967eff79b982388d8c5330c2135272c9f3a825920a39",
    "macOS-X64": "c763c493e5782869b54887dc72df2aad00d59af7272c6d96377f1debb98741f2",
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
        sha = "5fca0c384a1cdf9b3d4f71bcab5ff27aaee25f4bc09a134b16fa7fcf34e34c45",
    ),
    "macos": struct(
        platform = "xcode",
        suffix = "osx",
        extension = "pkg",
        sha = "3cf7a4b2f3efcfcb4fef42b6588a7b1c54f7b0f2d0a479f41c3e1620b045f48e",
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

def _toolchains(workspace_name):
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
            build_file = _build(workspace_name, "swift-toolchain-%s" % arch),
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

def _build(workspace_name, package):
    return "@%s//swift/third_party:BUILD.%s.bazel" % (workspace_name, package)

def load_dependencies(workspace_name):
    for repo_arch, arch in _swift_arch_map.items():
        sha256 = _swift_sha_map[repo_arch]

        http_archive(
            name = "swift_prebuilt_%s" % arch,
            url = "https://github.com/dsp-testing/codeql-swift-artifacts/releases/download/%s/swift-prebuilt-%s.zip" % (
                _swift_prebuilt_version,
                repo_arch,
            ),
            build_file = _build(workspace_name, "swift-llvm-support"),
            sha256 = sha256,
            patch_args = ["-p1"],
            patches = [
                "@%s//swift/third_party/swift-llvm-support:patches/%s.patch" % (workspace_name, patch_name)
                for patch_name in (
                    "remove-result-of",
                    "remove-redundant-operators",
                    "add-constructor-to-Compilation",
                )
            ],
        )

    _toolchains(workspace_name)

    _github_archive(
        name = "picosha2",
        build_file = _build(workspace_name, "picosha2"),
        repository = "okdshin/PicoSHA2",
        commit = "27fcf6979298949e8a462e16d09a0351c18fcaf2",
        sha256 = "d6647ca45a8b7bdaf027ecb68d041b22a899a0218b7206dee755c558a2725abb",
    )

    _github_archive(
        name = "binlog",
        build_file = _build(workspace_name, "binlog"),
        repository = "morganstanley/binlog",
        commit = "3fef8846f5ef98e64211e7982c2ead67e0b185a6",
        sha256 = "f5c61d90a6eff341bf91771f2f465be391fd85397023e1b391c17214f9cbd045",
    )

    _github_archive(
        name = "absl",
        repository = "abseil/abseil-cpp",
        commit = "d2c5297a3c3948de765100cb7e5cccca1210d23c",
        sha256 = "735a9efc673f30b3212bfd57f38d5deb152b543e35cd58b412d1363b15242049",
    )

    _github_archive(
        name = "json",
        repository = "nlohmann/json",
        commit = "6af826d0bdb55e4b69e3ad817576745335f243ca",
        sha256 = "702bb0231a5e21c0374230fed86c8ae3d07ee50f34ffd420e7f8249854b7d85b",
    )

    _github_archive(
        name = "fmt",
        repository = "fmtlib/fmt",
        build_file = _build(workspace_name, "fmt"),
        commit = "a0b8a92e3d1532361c2f7feb63babc5c18d00ef2",
        sha256 = "ccf872fd4aa9ab3d030d62cffcb258ca27f021b2023a0244b2cf476f984be955",
    )
