load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def codeql_workspace():
    for arch, repo_arch, sha256 in (
        ("linux", "linux", "48e39228e49aa560f0c1e504c4f9d488e28278b31fedc8271ce4cf807d9f7791"),
        ("darwin_x86_64", "macos-x86_64", "8f1e8e9cfb4391b3fbc0b90da548a7e660f302b1a8551e6640e8a944eb377028"),
    ):
        http_archive(
            name = "swift_prebuilt_%s" % arch,
            url = "https://github.com/dsp-testing/codeql-swift-artifacts/releases/download/swift-5.6-RELEASE.42271.49/swift-prebuilt-%s.zip" % repo_arch,
            build_file = "@ql//swift/extractor:BUILD.swift-prebuilt.bazel",
            sha256 = sha256,
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
