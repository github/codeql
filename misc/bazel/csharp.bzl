load("@rules_dotnet//dotnet:defs.bzl", "csharp_binary", "csharp_library", "csharp_test", "publish_binary")
load("@rules_pkg//pkg:mappings.bzl", "strip_prefix")
load("@semmle_code//:dist.bzl", "pack_zip")
load("//:defs.bzl", "codeql_platform")

TARGET_FRAMEWORK = "net8.0"

def codeql_csharp_library(name, **kwargs):
    kwargs.setdefault("nullable", "enable")
    kwargs.setdefault("target_frameworks", [TARGET_FRAMEWORK])
    csharp_library(name = name, **kwargs)

def codeql_xunit_test(name, **kwargs):
    kwargs.setdefault("nullable", "enable")
    kwargs.setdefault("target_frameworks", [TARGET_FRAMEWORK])

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
        tags = tags,
        **kwargs
    )

def codeql_csharp_binary(name, language_prefix = "csharp", **kwargs):
    kwargs.setdefault("nullable", "enable")
    kwargs.setdefault("target_frameworks", [TARGET_FRAMEWORK])

    visibility = kwargs.pop("visibility", ["//visibility:public"])
    resources = kwargs.pop("resources", [])
    srcs = kwargs.pop("srcs", [])

    # always add the assembly info file that sets the AssemblyInformationalVersion attribute to the extractor version
    srcs.append("//csharp/scripts:assembly-info-src")

    csharp_binary_target = "bin/" + name
    publish_binary_target = "publish/" + name
    csharp_binary(name = csharp_binary_target, srcs = srcs, resources = resources, visibility = visibility, **kwargs)
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

    pack_zip(
        name = name,
        srcs = [publish_binary_target],
        prefix = language_prefix + "/tools/" + codeql_platform,
        strip_prefix = strip_prefix.files_only(),
        visibility = visibility,
    )
