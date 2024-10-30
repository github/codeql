load("@bazel_skylib//rules:write_file.bzl", "write_file")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")
load("//misc/bazel:lfs.bzl", "lfs_archive", "lfs_files")

_override = {
    # these are used to test new artifacts. Must be empty before merging to main
    "swift-prebuilt-macOS.tar.zst": "a016ed60ee1a534439ed4d55100ecf6b9fc739f629be20942345ac5156cb6296",
    "swift-prebuilt-Linux.tar.zst": "54240eb2da948207862ea8eb9bcbfe4447016534b9a8e6d8ee1af67db2a3e73f",
    "resource-dir-macOS.zip": "fc7ed103d79f9dc61e716a58f221757c33ac2a4358de771d4889e1050f2a5b7a",
    "resource-dir-Linux.zip": "e5323f44e72f446e26e7b1fc4920ca9b924e6b5ef8b22e9cb18a0f2f03732913",
}

_staging_url = "https://github.com/dsp-testing/codeql-swift-artifacts/releases/download/staging-{file}/{file}"

def _load_resource_dir(plat):
    name = "swift-resource-dir-%s" % plat.lower()
    file = "resource-dir-%s.zip" % plat
    if file in _override:
        http_file(
            name = name,
            url = _staging_url.format(file = file),
            sha256 = _override[file],
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
    if file in _override:
        http_archive(
            name = name,
            url = _staging_url.format(file = file),
            sha256 = _override[file],
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
    test_body = ["#!/bin/bash", ""]
    test_body += [
        'echo \\"%s\\" overridden in swift/third/party/load.bzl' % key
        for key in _override
    ]
    if _override:
        test_body.append("exit 1")
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
