load("@rules_go//go:def.bzl", "go_binary")
load("//misc/bazel:universal_binary.bzl", "wrap_as_universal_binary")

def codeql_go_binary(**kwargs):
    wrap_as_universal_binary(go_binary, **kwargs)
