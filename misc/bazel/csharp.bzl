load("@rules_dotnet//dotnet:defs.bzl", "csharp_binary", "csharp_library", "csharp_test", "publish_binary")
load("@rules_pkg//pkg:mappings.bzl", "strip_prefix")
load("@semmle_code//:dist.bzl", "pack_zip")
load("//:defs.bzl", "codeql_platform")

TARGET_FRAMEWORK = "net8.0"

def codeql_csharp_library(name, **kwargs):
    nullable = kwargs.pop("nullable", "enable")
    target_frameworks = kwargs.pop("target_frameworks", [TARGET_FRAMEWORK])
    csharp_library(name = name, nullable = nullable, target_frameworks = target_frameworks, **kwargs)

def codeql_xunit_test(name, **kwargs):
    nullable = kwargs.pop("nullable", "enable")
    target_frameworks = kwargs.pop("target_frameworks", [TARGET_FRAMEWORK])

    srcs = kwargs.pop("srcs", []) + [
        "//csharp/extractor/Testrunner:Testrunner.cs",
    ]

    deps = kwargs.pop("deps", []) + [
        "@paket.main//xunit",
        "@paket.main//xunit.runner.utility",
    ]

    tags = kwargs.pop("tags", []) + ["csharp"]

    csharp_test(
        name = name,
        deps = deps,
        srcs = srcs,
        nullable = nullable,
        target_frameworks = target_frameworks,
        tags = tags,
        **kwargs
    )

def codeql_csharp_binary(name, **kwargs):
    nullable = kwargs.pop("nullable", "enable")
    visibility = kwargs.pop("visibility", ["//visibility:public"])
    resources = kwargs.pop("resources", [])

    # the entry assembly always has the git info embedded
    resources.append("@semmle_code//:git_info")

    target_frameworks = kwargs.pop("target_frameworks", [TARGET_FRAMEWORK])
    csharp_binary_target = "bin/" + name
    publish_binary_target = "publish/" + name
    csharp_binary(name = csharp_binary_target, nullable = nullable, target_frameworks = target_frameworks, resources = resources, visibility = visibility, **kwargs)
    publish_binary(
        name = publish_binary_target,
        binary = csharp_binary_target,
        self_contained = True,
        target_framework = TARGET_FRAMEWORK,
        runtime_identifier = select(
            {
                "@platforms//os:macos": "osx-x64",  # always force intel on macos for now, until we build universal binaries
                "//conditions:default": "",
            },
        ),
    )

    # we need to declare individual zip targets for each binary, as `self_contained=True` means that every binary target
    # contributes the same runtime files. Bazel (rightfully) complains about this, so we work around this by creating individual zip files,
    # and using zipmerge to produce the final extractor-arch file. For overlapping files, zipmerge chooses just one.
    pack_zip(
        name = name,
        srcs = [publish_binary_target],
        prefix = "csharp/tools/" + codeql_platform,
        strip_prefix = strip_prefix.files_only(),
        compression_level = 0,
        visibility = visibility,
    )
