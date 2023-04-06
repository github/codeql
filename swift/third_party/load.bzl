load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_swift_prebuilt_version = "swift-5.8-RELEASE.198"
_swift_sha_map = {
    "Linux-X64": "04788a6b9c913b98675df190197025d5b0bfe09a8014dbca4c5db95a7444963c",
    "macOS-ARM64": "89eeda3195782bcc2fb7f974c31fb81d3c9a73bf3b78093b68d01a59b8af0998",
    "macOS-X64": "ae0d84bac241d63f44565ab31a8408a93cb8c5eac112833aff5f79af7fd65ffd",
}

_swift_arch_map = {
    "Linux-X64": "linux",
    "macOS-X64": "darwin_x86_64",
}

def _get_label(workspace_name, package, target):
    return "@%s//swift/third_party/%s:%s" % (workspace_name, package, target)

def _get_build(workspace_name, package):
    return _get_label(workspace_name, package, "BUILD.%s.bazel" % package)

def _get_patch(workspace_name, package, patch):
    return _get_label(workspace_name, package, "patches/%s.patch" % patch)

def _github_archive(*, name, workspace_name, repository, commit, sha256 = None, patches = None):
    github_name = repository[repository.index("/") + 1:]
    patches = [_get_patch(workspace_name, name, p) for p in patches or []]
    http_archive(
        name = name,
        url = "https://github.com/%s/archive/%s.zip" % (repository, commit),
        strip_prefix = "%s-%s" % (github_name, commit),
        build_file = _get_build(workspace_name, name),
        sha256 = sha256,
        patch_args = ["-p1"],
        patches = patches,
    )

def load_dependencies(workspace_name):
    for repo_arch, arch in _swift_arch_map.items():
        sha256 = _swift_sha_map[repo_arch]

        http_archive(
            name = "swift_prebuilt_%s" % arch,
            url = "https://github.com/dsp-testing/codeql-swift-artifacts/releases/download/%s/swift-prebuilt-%s.zip" % (
                _swift_prebuilt_version,
                repo_arch,
            ),
            build_file = _get_build(workspace_name, "swift-llvm-support"),
            sha256 = sha256,
            patch_args = ["-p1"],
            patches = [],
        )

    _github_archive(
        name = "picosha2",
        workspace_name = workspace_name,
        repository = "okdshin/PicoSHA2",
        commit = "27fcf6979298949e8a462e16d09a0351c18fcaf2",
        sha256 = "d6647ca45a8b7bdaf027ecb68d041b22a899a0218b7206dee755c558a2725abb",
    )

    _github_archive(
        name = "binlog",
        workspace_name = workspace_name,
        repository = "morganstanley/binlog",
        commit = "3fef8846f5ef98e64211e7982c2ead67e0b185a6",
        sha256 = "f5c61d90a6eff341bf91771f2f465be391fd85397023e1b391c17214f9cbd045",
    )
