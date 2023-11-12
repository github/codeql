load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

_swift_prebuilt_version = "swift-5.9.1-RELEASE.255"
_swift_sha_map = {
    "Linux-X64": "0d5682d8acbe3ab81c2a0b8dc0dfadc0240895e28722cca6467d2ab71a69e004",
    "macOS-ARM64": "ee53def6f89f97ce0882375121629d71fd87a673baa194f4c510920720d7bce6",
    "macOS-X64": "61c2879ee89d6796f3b58fada8a5890756f5a8c053597f4faca019d660743d70",
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
        sha = "057f6c0c3c6472b733e4d5bd8f10e83dd8536c1db1d0ec4a1dca414cd023ab0d",
    ),
    "macos": struct(
        platform = "xcode",
        suffix = "osx",
        extension = "pkg",
        sha = "fa4d3a67c4db8d63897e10d52903af40599cc351e8a73d6f5a4eb3cfd07c4605",
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
