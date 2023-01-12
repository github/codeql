load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

_swift_prebuilt_version = "swift-5.7.1-RELEASE.44582.104"
_swift_sha_map = {
  "Linux-X64": "8d94f2d75f2aa9ee8e5421318d2f07b27e095127c9be0156794a88d8e9a0f19a",
  "macOS-X64": "5f0550d2924e7071d006a0c9802acbd9a11f0017073e4a1eb27b7ddc4764f3f2",
}

_swift_arch_map = {
    "Linux-X64": "linux",
    "macOS-X64": "darwin_x86_64",
}

def codeql_workspace(repository_name = "codeql"):
    for repo_arch, arch in _swift_arch_map.items():
        sha256 = _swift_sha_map[repo_arch]

        http_archive(
            name = "swift_prebuilt_%s" % arch,
            url = "https://github.com/dsp-testing/codeql-swift-artifacts/releases/download/%s/swift-prebuilt-%s.zip" % (
                _swift_prebuilt_version,
                repo_arch,
            ),
            build_file = "@%s//swift/third_party/swift-llvm-support:BUILD.swift-prebuilt.bazel" % repository_name,
            sha256 = sha256,
        )

    http_archive(
        name = "fishhook",
        url = "https://github.com/facebook/fishhook/archive/aadc161ac3b80db07a9908851839a17ba63a9eb1.zip",
        build_file = "@%s//swift/third_party/fishhook:BUILD.fishhook.bazel" % repository_name,
        strip_prefix = "fishhook-aadc161ac3b80db07a9908851839a17ba63a9eb1",
        sha256 = "9f2cdee6dcc2039d4c47d25ab5141fe0678ce6ed27ef482cab17fe9fa38a30ce",
    )

    http_archive(
        name = "picosha2",
        url = "https://github.com/okdshin/PicoSHA2/archive/27fcf6979298949e8a462e16d09a0351c18fcaf2.zip",
        strip_prefix = "PicoSHA2-27fcf6979298949e8a462e16d09a0351c18fcaf2",
        build_file = "@%s//swift/third_party/picosha2:BUILD.picosha2.bazel" % repository_name,
        sha256 = "d6647ca45a8b7bdaf027ecb68d041b22a899a0218b7206dee755c558a2725abb",
    )

    maybe(
        repo_rule = http_archive,
        name = "rules_pkg",
        sha256 = "62eeb544ff1ef41d786e329e1536c1d541bb9bcad27ae984d57f18f314018e66",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_pkg/releases/download/0.6.0/rules_pkg-0.6.0.tar.gz",
            "https://github.com/bazelbuild/rules_pkg/releases/download/0.6.0/rules_pkg-0.6.0.tar.gz",
        ],
    )

    maybe(
        repo_rule = http_archive,
        name = "platforms",
        sha256 = "460caee0fa583b908c622913334ec3c1b842572b9c23cf0d3da0c2543a1a157d",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/platforms/releases/download/0.0.3/platforms-0.0.3.tar.gz",
            "https://github.com/bazelbuild/platforms/releases/download/0.0.3/platforms-0.0.3.tar.gz",
        ],
    )

    maybe(
        repo_rule = http_archive,
        name = "rules_python",
        sha256 = "cdf6b84084aad8f10bf20b46b77cb48d83c319ebe6458a18e9d2cebf57807cdd",
        strip_prefix = "rules_python-0.8.1",
        urls = [
            "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.8.1.tar.gz",
        ],
    )
