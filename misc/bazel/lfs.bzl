def lfs_smudge(repository_ctx, srcs, *, extract = False, stripPrefix = None, executable = False):
    python = repository_ctx.which("python3") or repository_ctx.which("python")
    if not python:
        fail("Neither python3 nor python executables found")
    script = repository_ctx.path(Label("//misc/bazel/internal:git_lfs_probe.py"))
    git_lfs_binary = repository_ctx.path(Label("@git-lfs"))

    def probe(srcs, hash_only = False):
        repository_ctx.report_progress("querying LFS url(s) for: %s" % ", ".join([src.basename for src in srcs]))
        cmd = [python, script]
        if hash_only:
            cmd.append("--hash-only")
        else:
            cmd += ["--git-lfs", git_lfs_binary]
        cmd.extend(srcs)
        res = repository_ctx.execute(cmd, quiet = True)
        if res.return_code != 0:
            fail("git LFS probing failed while instantiating @%s:\n%s" % (repository_ctx.name, res.stderr))
        return res.stdout.splitlines()

    for src in srcs:
        repository_ctx.watch(src)
    infos = probe(srcs, hash_only = True)
    remote = []
    for src, info in zip(srcs, infos):
        if info == "local":
            repository_ctx.report_progress("symlinking local %s" % src.basename)
            repository_ctx.symlink(src, src.basename)
        else:
            repository_ctx.report_progress("trying cache for remote %s" % src.basename)
            res = repository_ctx.download([], src.basename, sha256 = info, allow_fail = True, executable = executable)
            if not res.success:
                remote.append(src)
        if remote:
            infos = probe(remote)
            for src, info in zip(remote, infos):
                sha256, _, url = info.partition(" ")
                repository_ctx.report_progress("downloading remote %s" % src.basename)
                repository_ctx.download(url, src.basename, sha256 = sha256, executable = executable)
        if extract:
            for src in srcs:
                repository_ctx.report_progress("extracting %s" % src.basename)
                repository_ctx.extract(src.basename, stripPrefix = stripPrefix)
                repository_ctx.delete(src.basename)

def _download_and_extract_lfs(repository_ctx):
    attr = repository_ctx.attr
    src = repository_ctx.path(attr.src)
    if attr.build_file_content and attr.build_file:
        fail("You should specify only one among build_file_content and build_file for rule @%s" % repository_ctx.name)
    lfs_smudge(repository_ctx, [src], extract = True, stripPrefix = attr.strip_prefix)
    if attr.build_file_content:
        repository_ctx.file("BUILD.bazel", attr.build_file_content)
    elif attr.build_file:
        repository_ctx.symlink(attr.build_file, "BUILD.bazel")

def _download_lfs(repository_ctx):
    attr = repository_ctx.attr
    if int(bool(attr.srcs)) + int(bool(attr.dir)) != 1:
        fail("Exactly one between `srcs` and `dir` must be defined for @%s" % repository_ctx.name)
    if attr.srcs:
        srcs = [repository_ctx.path(src) for src in attr.srcs]
    else:
        dir = repository_ctx.path(attr.dir)
        if not dir.is_dir:
            fail("`dir` not a directory in @%s" % repository_ctx.name)
        srcs = [f for f in dir.readdir() if not f.is_dir]
    lfs_smudge(repository_ctx, srcs, executable = repository_ctx.attr.executable)

    # with bzlmod the name is qualified with `+` separators, and we want the base name here
    name = repository_ctx.name.split("+")[-1]
    basenames = [src.basename for src in srcs]
    build = "exports_files(%s)\n" % repr(basenames)

    # add a main `name` filegroup only if it doesn't conflict with existing exported files
    if name not in basenames:
        build += 'filegroup(name = "%s", srcs = %s, visibility = ["//visibility:public"])\n' % (
            name,
            basenames,
        )
    repository_ctx.file("BUILD.bazel", build)

lfs_archive = repository_rule(
    doc = "Export the contents from an on-demand LFS archive. The corresponding path should be added to be ignored " +
          "in `.lfsconfig`.",
    implementation = _download_and_extract_lfs,
    attrs = {
        "src": attr.label(mandatory = True, doc = "Local path to the LFS archive to extract."),
        "build_file_content": attr.string(doc = "The content for the BUILD file for this repository. " +
                                                "Either build_file or build_file_content can be specified, but not both."),
        "build_file": attr.label(doc = "The file to use as the BUILD file for this repository. " +
                                       "Either build_file or build_file_content can be specified, but not both."),
        "strip_prefix": attr.string(default = "", doc = "A directory prefix to strip from the extracted files. "),
    },
)

lfs_files = repository_rule(
    doc = "Export LFS files for on-demand download. Exactly one between `srcs` and `dir` must be defined. The " +
          "corresponding paths should be added to be ignored in `.lfsconfig`.",
    implementation = _download_lfs,
    attrs = {
        "srcs": attr.label_list(doc = "Local paths to the LFS files to export."),
        "dir": attr.label(doc = "Local path to a directory containing LFS files to export. Only the direct contents " +
                                "of the directory are exported"),
        "executable": attr.bool(doc = "Whether files should be marked as executable"),
    },
)

def _lfs_binary_impl(repository_ctx):
    suffix = ""
    if repository_ctx.os.name.startswith("windows"):
        arch = "windows-amd64"
        sha256 = repository_ctx.attr.sha256_windows
        suffix = ".exe"
    elif repository_ctx.os.name.startswith("mac"):
        if repository_ctx.os.arch == "x86":
            arch = "darwin-amd64"
            sha256 = repository_ctx.attr.sha256_macos_x86
        else:
            arch = "darwin-arm64"
            sha256 = repository_ctx.attr.sha256_macos_arm64
    else:
        arch = "linux-amd64"
        sha256 = repository_ctx.attr.sha256_linux
    url = "https://github.com/dsp-testing/codeql-git-lfs/releases/download/%s/git-lfs-%s%s" % (
        repository_ctx.attr.version,
        arch,
        suffix,
    )
    exe = "git-lfs" + suffix
    repository_ctx.download(
        url = url,
        output = exe,
        sha256 = sha256,
        executable = True,
    )
    name = repository_ctx.name.split("+")[-1]
    if suffix:
        repository_ctx.file("BUILD.bazel", "filegroup(name = %r, srcs = [%r], visibility = ['//visibility:public'])" % (name, exe))
    else:
        repository_ctx.file("BUILD.bazel", "exports_files([%r])" % exe)

git_lfs_binary = repository_rule(
    implementation = _lfs_binary_impl,
    attrs = {
        "version": attr.string(mandatory = True),
        "sha256_linux": attr.string(mandatory = True),
        "sha256_macos_x86": attr.string(mandatory = True),
        "sha256_macos_arm64": attr.string(mandatory = True),
        "sha256_windows": attr.string(mandatory = True),
    },
)
