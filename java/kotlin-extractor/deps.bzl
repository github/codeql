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

def _walk(dir):
    res = []
    next_dirs = [dir]

    # loops must be bounded in starlark
    for i in range(100):
        current_dirs = next_dirs
        next_dirs = []
        for d in current_dirs:
            children = d.readdir()
            next_dirs.extend([c for c in children if c.is_dir])
            res.extend([c for c in children if not c.is_dir])
        if not next_dirs:
            break
    return res

def _embeddable_source_impl(repository_ctx):
    src_dir = repository_ctx.path(Label("//java/kotlin-extractor:src"))
    for src in _walk(src_dir):
        contents = repository_ctx.read(src)
        contents = contents.replace(
            "import com.intellij",
            "import org.jetbrains.kotlin.com.intellij",
        )
        repository_ctx.file(str(src).replace(str(src_dir), "src"), contents)
    repository_ctx.symlink(
        Label("//java/kotlin-extractor:generate_dbscheme.py"),
        "generate_dbscheme.py",
    )
    repository_ctx.symlink(
        Label("//java/kotlin-extractor:BUILD.bazel"),
        "BUILD.bazel",
    )

_embeddable_source = repository_rule(implementation = _embeddable_source_impl)

def _add_rule(rules, rule, *, name, **kwargs):
    rule(name = name, **kwargs)
    rules.append(name)

def _kotlin_deps_impl(module_ctx):
    deps = []
    for v in VERSIONS:
        for lib in ("compiler", "compiler-embeddable", "stdlib"):
            _add_rule(deps, _kotlin_dep, name = "kotlin-%s-%s" % (lib, v))
    _add_rule(deps, _embeddable_source, name = "codeql_kotlin_embeddable")
    return module_ctx.extension_metadata(
        root_module_direct_deps = deps,
        root_module_direct_dev_deps = [],
    )

kotlin_extractor_deps = module_extension(implementation = _kotlin_deps_impl)
