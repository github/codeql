load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//misc/bazel:lfs.bzl", "lfs_archive", "lfs_files")

# these are used to test new artifacts. They must not be merged to main as different from None
_override_resource_dir = {
    "macOS": "ad533e614c3565db17186fa93684bd404d1bd66120b563957a44afc997a82b5e",
    "Linux": "d6f1abbe9c0662ec2418b9a8c0136b1d8399601f556631a7b0910115cef3a38a",
}
_override_prebuilt = {
    "macOS": "8f3c775aa7a62e97046f4dcfbc5b51c317712250396c7a07f7d0f4bd666a59d4",
    "Linux": "5658fe92fe60b01b897757495d455c9fe435037a0973cb5b642e04be00a77ed3",
}

_staging_url = "https://github.com/dsp-testing/codeql-swift-artifacts/releases/download/staging-{file}/{file}"

def _load_resource_dir(plat):
    name = "swift-resource-dir-%s" % plat.lower()
    file = "resource-dir-%s.zip" % plat
    override = _override_resource_dir[plat]
    if override:
        http_file(
            name = name,
            url = _staging_url.format(file = file),
            sha256 = override,
            downloaded_file_path = file,
        )
    else:
        lfs_files(
            name = name,
            srcs = ["//swift/third_party/resources:%s" % file],
        )

def _load_prebuilt(plat):
    name = "swift-prebuilt-%s" % plat.lower()
    file = "swift-prebuilt-%s.tar.zst" % plat
    build = _build % "swift-llvm-support"
    override = _override_prebuilt[plat]
    if override:
        http_archive(
            name = name,
            url = _staging_url.format(file = file),
            sha256 = override,
            build_file = build,
        )
    else:
        lfs_archive(
            name = name,
            src = "//swift/third_party/resources:%s" % file,
            build_file = build,
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
    for plat in ("macOS", "Linux"):
        _load_prebuilt(plat)
        _load_resource_dir(plat)

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

def test_no_override():
    test_body = ["#!/bin/bash", "", "RET=0"]
    for name, definition in (
        ("_override_prebuilt", _override_prebuilt),
        ("_override_resource_dir", _override_resource_dir),
    ):
        for plat in ("macOS", "Linux"):
            if definition[plat]:
                test_body += [
                    'echo %s[\\"%s\\"] overridden in swift/third/party/load.bzl' % (name, plat),
                    "RET=1",
                ]
    test_body += ["", "exit $RET"]
    write_file(
        name = "test-no-override-gen",
        out = "test-no-override.sh",
        content = test_body,
        is_executable = True,
    )
    native.sh_test(
        name = "test-no-override",
        srcs = [":test-no-override-gen"],
        tags = ["override"],
    )
