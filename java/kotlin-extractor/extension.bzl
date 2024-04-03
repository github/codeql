load("//java/kotlin-extractor:versions.bzl", "VERSIONS")
load("//misc/bazel:lfs.bzl", "lfs_smudge")

_kotlin_dep_build = """
load("@rules_kotlin//kotlin:jvm.bzl", "kt_jvm_import")

package(default_visibility = ["//visibility:public"])

kt_jvm_import(
    name = "kotlin-compiler",
    jar = "kotlin-compiler-{version}.jar",
)

kt_jvm_import(
    name = "kotlin-compiler-embeddable",
    jar = "kotlin-compiler-embeddable-{version}.jar",
)

kt_jvm_import(
    name = "kotlin-stdlib",
    jar = "kotlin-stdlib-{version}.jar",
)
"""

def _kotlin_dep_impl(repository_ctx):
    _, sep, version = repository_ctx.name.rpartition("_")
    if not sep:
        fail("rule @%s malformed, name should be <prefix>_<kotlin version>")

    sources = [
        #        "empty.jar",
        "kotlin-compiler-%s.jar" % version,
        "kotlin-compiler-embeddable-%s.jar" % version,
        "kotlin-stdlib-%s.jar" % version,
    ]
    sources = [repository_ctx.path(Label("//java/kotlin-extractor/deps:%s" % p)) for p in sources]
    lfs_smudge(repository_ctx, sources)

    # for some reason rules_kotlin warns about these jars missing, this is to silence those warnings
    for jar in (
        "annotations-13.0.jar",
        "kotlin-stdlib.jar",
        "kotlin-reflect.jar",
        "kotlin-script-runtime.jar",
        "trove4j.jar",
    ):
        repository_ctx.symlink("empty.jar", jar)
    repository_ctx.file("BUILD.bazel", _kotlin_dep_build.format(version = version))

_kotlin_dep = repository_rule(implementation = _kotlin_dep_impl)

def _kotlin_deps_impl(module_ctx):
    deps = []
    for v in VERSIONS:
        dep = "kotlin_extractor_dep_%s" % v
        _kotlin_dep(name = dep)
        deps.append(dep)
    return module_ctx.extension_metadata(
        root_module_direct_deps = deps,
        root_module_direct_dev_deps = [],
    )

kotlin_extractor_deps = module_extension(implementation = _kotlin_deps_impl)
