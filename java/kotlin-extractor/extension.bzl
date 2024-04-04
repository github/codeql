load("//java/kotlin-extractor:versions.bzl", "VERSIONS")
load("//misc/bazel:lfs.bzl", "lfs_smudge")

_kotlin_dep_build = """
load("@rules_kotlin//kotlin:jvm.bzl", "kt_jvm_import")

kt_jvm_import(
    name = "{name}",
    jar = "{name}.jar",
    visibility = ["//visibility:public"],
)
"""

def _get_dep(repository_ctx, name):
    return repository_ctx.path(Label("//java/kotlin-extractor/deps:%s" % name))

def _kotlin_dep_impl(repository_ctx):
    _, _, name = repository_ctx.name.rpartition("~")
    lfs_smudge(repository_ctx, [_get_dep(repository_ctx, name + ".jar")])

    # for some reason rules_kotlin warns about these jars missing, this is to silence those warnings
    empty = _get_dep(repository_ctx, "empty.zip")
    for jar in (
        "annotations-13.0.jar",
        "kotlin-stdlib.jar",
        "kotlin-reflect.jar",
        "kotlin-script-runtime.jar",
        "trove4j.jar",
    ):
        repository_ctx.symlink(empty, jar)
    repository_ctx.file("BUILD.bazel", _kotlin_dep_build.format(name = name))

_kotlin_dep = repository_rule(
    implementation = _kotlin_dep_impl,
)

def _kotlin_deps_impl(module_ctx):
    deps = []
    for v in VERSIONS:
        for lib in ("compiler", "compiler-embeddable", "stdlib"):
            dep = "kotlin-%s-%s" % (lib, v)
            _kotlin_dep(name = dep)
            deps.append(dep)
    return module_ctx.extension_metadata(
        root_module_direct_deps = deps,
        root_module_direct_dev_deps = [],
    )

kotlin_extractor_deps = module_extension(implementation = _kotlin_deps_impl)
