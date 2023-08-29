load("@io_bazel_rules_go//go:def.bzl", "go_library", "go_test")
load("@bazel_gazelle//:def.bzl", "gazelle")

# gazelle:prefix github.com/lestrrat-go/jwx/v2
# gazelle:go_naming_convention import_alias

gazelle(name = "gazelle")

gazelle(
    name = "gazelle-update-repos",
    args = [
        "-from_file=go.mod",
        "-to_macro=deps.bzl%go_dependencies",
        "-prune",
        "-build_file_proto_mode=disable_global",
    ],
    command = "update-repos",
)

go_library(
    name = "jwx",
    srcs = [
        "format.go",
        "formatkind_string_gen.go",
        "jwx.go",
        "options.go",
    ],
    importpath = "github.com/lestrrat-go/jwx/v2",
    visibility = ["//visibility:public"],
    deps = [
        "//internal/json",
        "@com_github_lestrrat_go_option//:option",
    ],
)

go_test(
    name = "jwx_test",
    srcs = ["jwx_test.go"],
    deps = [
        ":jwx",
        "//internal/ecutil",
        "//internal/jose",
        "//internal/json",
        "//internal/jwxtest",
        "//jwa",
        "//jwe",
        "//jwk",
        "//jws",
        "@com_github_stretchr_testify//assert",
        "@com_github_stretchr_testify//require",
    ],
)

alias(
    name = "go_default_library",
    actual = ":jwx",
    visibility = ["//visibility:public"],
)
