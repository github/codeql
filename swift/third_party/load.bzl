load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

_swift_prebuilt_version = "swift-5.7.1-RELEASE.44428.89"
_swift_sha_map = {
    "Linux-X64": "1fa0b62b3a87c6528bd21b3f3fa1b32ad00e2b6ff04c20652c93c7d00c4cf517",
    "macOS-X64": "6e1239335874cbde635ae9ca9eeb215efee4988888a75f4eda1abbcf97e4d038",
}

_swift_arch_map = {
    "Linux-X64": "linux",
    "macOS-X64": "darwin_x86_64",
}

def _get_label(repository_name, package, target):
    return "@%s//swift/third_party/%s:%s" % (repository_name, package, target)

def _get_build(repository_name, package):
    return _get_label(repository_name, package, "BUILD.%s.bazel" % package)

def _get_patch(repository_name, package, patch):
    return _get_label(repository_name, package, "patches/%s.patch" % patch)

def load_dependencies(repository_name):
    for repo_arch, arch in _swift_arch_map.items():
        sha256 = _swift_sha_map[repo_arch]

        http_archive(
            name = "swift_prebuilt_%s" % arch,
            url = "https://github.com/dsp-testing/codeql-swift-artifacts/releases/download/%s/swift-prebuilt-%s.zip" % (
                _swift_prebuilt_version,
                repo_arch,
            ),
            build_file = _get_build(repository_name, "swift-llvm-support"),
            sha256 = sha256,
            patch_args = ["-p1"],
            patches = [
                _get_patch(repository_name, "swift-llvm-support", "allow_modfying_output"),
            ],
        )

    http_archive(
        name = "picosha2",
        url = "https://github.com/okdshin/PicoSHA2/archive/27fcf6979298949e8a462e16d09a0351c18fcaf2.zip",
        strip_prefix = "PicoSHA2-27fcf6979298949e8a462e16d09a0351c18fcaf2",
        build_file = _get_build(repository_name, "picosha2"),
        sha256 = "d6647ca45a8b7bdaf027ecb68d041b22a899a0218b7206dee755c558a2725abb",
    )
