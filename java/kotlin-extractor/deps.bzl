load("//java/kotlin-extractor:versions.bzl", "DEFAULT_VERSION", "VERSIONS", "version_less")
load("//misc/bazel:lfs.bzl", "lfs_smudge")

_kotlin_dep_build = """
load("@rules_kotlin//kotlin:jvm.bzl", "kt_jvm_import")

kt_jvm_import(
    name = "{name}",
    jar = "{name}.jar",
    visibility = ["//visibility:public"],
)
"""

_empty_zip = "PK\005\006\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000"

def _get_dep(repository_ctx, name):
    return repository_ctx.path(Label("//java/kotlin-extractor/deps:%s" % name))

def _kotlin_dep_impl(repository_ctx):
    _, _, name = repository_ctx.name.rpartition("~")
    lfs_smudge(repository_ctx, [_get_dep(repository_ctx, name + ".jar")])

    # for some reason rules_kotlin warns about these jars missing, this is to silence those warnings
    repository_ctx.file("empty.zip", _empty_zip)
    for jar in (
        "annotations-13.0.jar",
        "kotlin-stdlib.jar",
        "kotlin-reflect.jar",
        "kotlin-script-runtime.jar",
        "trove4j.jar",
    ):
        repository_ctx.symlink("empty.zip", jar)
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
    repository_ctx.watch_tree(src_dir)
    for src in _walk(src_dir):
        contents = repository_ctx.read(src)
        contents = contents.replace(
            "import com.intellij",
            "import org.jetbrains.kotlin.com.intellij",
        )
        repository_ctx.file(str(src).replace(str(src_dir), "src"), contents)
    repository_ctx.symlink(
        Label("//java/kotlin-extractor:BUILD.bazel"),
        "BUILD.bazel",
    )

_embeddable_source = repository_rule(implementation = _embeddable_source_impl)

def _get_default_version(repository_ctx):
    default_version = repository_ctx.getenv("CODEQL_KOTLIN_SINGLE_VERSION")
    if default_version:
        return default_version
    kotlinc = repository_ctx.which("kotlinc")
    if not kotlinc:
        return DEFAULT_VERSION
    if repository_ctx.os.name == "windows" and not kotlinc.basename.endswith(".exe"):
        # for some reason the result from `which` can fail to have exe
        kotlinc = repository_ctx.path("%s.exe" % kotlinc)
    res = repository_ctx.execute([kotlinc, "-version"])
    if not res:
        fail("kotlinc -version failed: %s" % res.stderr)
    out = (res.stdout or res.stderr).split(" ")
    if "kotlinc-jvm" not in out:
        fail("kotlinc -version output does not contain 'kotlinc-jvm': %s" % out)
    kotlinc_jvm_index = out.index("kotlinc-jvm")
    if kotlinc_jvm_index + 1 >= len(out):
        fail("kotlinc -version output does not contain a version after 'kotlinc-jvm': %s" % out)
    return out[kotlinc_jvm_index + 1]

def _get_available_version(version):
    for available_version in reversed(VERSIONS):
        if not version_less(version, available_version):
            return available_version
    fail("no available version found for version %s among:\n  %s" % (version, " ".join(VERSIONS)))

def _defaults_impl(repository_ctx):
    default_version = _get_default_version(repository_ctx)
    default_variant = "standalone"
    if repository_ctx.getenv("CODEQL_KOTLIN_SINGLE_VERSION_EMBEDDABLE") in ("true", "1"):
        default_variant = "embeddable"
    available_version = _get_available_version(default_version)
    info = struct(
        version = default_version,
        variant = default_variant,
        extractor_version = available_version,
    )
    repository_ctx.file(
        "defaults.bzl",
        "kotlin_extractor_defaults = %s\n" % repr(info),
    )
    repository_ctx.file("BUILD.bazel")

_defaults = repository_rule(implementation = _defaults_impl)

def _kotlin_deps_impl(module_ctx):
    for v in VERSIONS:
        for lib in ("compiler", "compiler-embeddable", "stdlib"):
            _kotlin_dep(name = "kotlin-%s-%s" % (lib, v))
    _embeddable_source(name = "codeql_kotlin_embeddable")
    _defaults(name = "codeql_kotlin_defaults")
    return module_ctx.extension_metadata(
        root_module_direct_deps = "all",
        root_module_direct_dev_deps = [],
    )

kotlin_extractor_deps = module_extension(implementation = _kotlin_deps_impl)
