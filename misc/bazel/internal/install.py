"""
Helper script for installing `codeql_pack` targets.

This mainly wraps around a `pkg_install` script from `rules_pkg` adding:
* resolving destination directory with respect to a provided `--build-file`
* clean-up of target destination directory before a reinstall
* installing imported zip files using a provided `--ripunzip`

This also allows installing onto multiple targets (sequentially):
* each provided --destdir sets the destination for the following options (which means even in case we install to one
  destination, --destdir must come before other installing options)
* multiple --pkg-install-script and --zip-manifest options can be passed
"""

import argparse
import pathlib
import shutil
import subprocess
import dataclasses
from python.runfiles import runfiles

runfiles = runfiles.Create()
assert runfiles, "Installer should be run with `bazel run`"


def options():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--destdir", type=ChangeDestDir, action="append", dest="actions",
                        help="Desination directory for following actions, relative to `--build-file`")
    parser.add_argument("--pkg-install-script", type=RunPackageScript, action="append", dest="actions",
                        help="The wrapped `pkg_install` installation script rlocation")
    parser.add_argument("--zip-manifest", type=InstallZips, action="append", dest="actions",
                        help="The rlocation of a file containing newline-separated `prefix:zip_file` entries")
    parser.add_argument("--build-file",
                        help="BUILD.bazel rlocation relative to which the installation should take place")
    parser.add_argument("--ripunzip",
                        help="ripunzip executable rlocation. Must be provided if `--zip-manifest` is.")
    parser.add_argument("--cleanup", action=argparse.BooleanOptionalAction, default=True,
                        help="Whether to wipe the destination directories before installing (true by default)")
    return parser.parse_args()


@dataclasses.dataclass
class Context:
    basedir: pathlib.Path | None
    current_destdir: pathlib.Path | None
    ripunzip: str | None
    cleanup: bool


def initial_context(opts):
    return Context(
        basedir=opts.build_file and pathlib.Path(runfiles.Rlocation(opts.build_file)).resolve().parent,
        current_destdir=None,
        ripunzip=opts.ripunzip and runfiles.Rlocation(opts.ripunzip),
        cleanup=opts.cleanup,
    )


class Action:
    def run(self, context: Context) -> None:
        ...


@dataclasses.dataclass
class ChangeDestDir(Action):
    destdir: pathlib.Path

    def __post_init__(self):
        self.destdir = pathlib.Path(self.destdir)

    def run(self, context):
        if context.basedir:
            context.current_destdir = context.basedir / self.destdir
        else:
            assert self.destdir.is_absolute(), "Provide `--build-file` to resolve destination directories"
            context.current_destdir = self.destdir
        if context.current_destdir.exists() and context.cleanup:
            shutil.rmtree(context.current_destdir)
        context.current_destdir.mkdir(parents=True, exist_ok=True)


@dataclasses.dataclass
class RunPackageScript(Action):
    script: str

    def run(self, context):
        assert context.current_destdir, "--destdir must be specified before any install action"
        script = runfiles.Rlocation(self.script)
        subprocess.run([script, "--destdir", context.current_destdir], check=True)


@dataclasses.dataclass
class InstallZips(Action):
    manifest: str

    def run(self, context):
        assert context.current_destdir, "--destdir must be specified before any install action"
        assert context.ripunzip, "--ripunzip must be provided if any --zip-manifest is"
        manifest_file = runfiles.Rlocation(self.manifest)
        with open(manifest_file) as manifest:
            for line in manifest:
                prefix, _, zip = line.partition(":")
                assert zip, f"missing prefix for {prefix}, you should use prefix:zip format"
                zip = zip.strip()
                dest = context.current_destdir / prefix
                dest.mkdir(parents=True, exist_ok=True)
                subprocess.run([context.ripunzip, "unzip-file", zip, "-d", dest], check=True)


def main():
    opts = options()
    context = initial_context(opts)
    for action in opts.actions:
        action.run(context)


if __name__ == '__main__':
    main()
