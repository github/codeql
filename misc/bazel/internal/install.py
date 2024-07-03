"""
Helper script for installing `codeql_pack` targets.

This mainly wraps around a `pkg_install` script from `rules_pkg` adding:
* resolving destination directory with respect to a provided `--build-file`
* clean-up of target destination directory before a reinstall
* installing imported zip files using a provided `--ripunzip`

This also allows installing onto multiple targets:
* multiple --pkg-install-script and --zip-manifest options can be passed
* --subdir can be used to change installation directory with respect to --destdir (an implicit initial --subdir=. is
  implied)

Install actions are carried out in parallel.
"""

import argparse
import pathlib
import shutil
import subprocess
import concurrent.futures
import dataclasses
import typing
from python.runfiles import runfiles

runfiles = runfiles.Create()
assert runfiles, "Installer should be run with `bazel run`"


def options():
    parser = argparse.ArgumentParser(description=__doc__)
    actions = {pathlib.Path(): []}
    parser.set_defaults(actions=actions, current_destdir_actions=actions[pathlib.Path()])
    parser.add_argument("--destdir", type=pathlib.Path,
                        help="Base desination directory, relative to `--build-file` if provided")
    parser.add_argument("--subdir", action=ChangeDestDir,
                        help="Subdirectory of `--destdir` to use for following install actions")
    parser.add_argument("--pkg-install-script", type=ScriptInstruction, action=AppendInstruction,
                        help="The wrapped `pkg_install` installation script rlocation")
    parser.add_argument("--zip-manifest", type=ZipInstruction, action=AppendInstruction,
                        help="The rlocation of a file containing newline-separated `prefix:zip_file` entries")
    parser.add_argument("--build-file",
                        help="BUILD.bazel rlocation relative to which the installation should take place")
    parser.add_argument("--ripunzip",
                        help="ripunzip executable rlocation. Must be provided if `--zip-manifest` is.")
    parser.add_argument("--cleanup", action=argparse.BooleanOptionalAction, default=True,
                        help="Whether to wipe the destination directories before installing (true by default)")
    return parser.parse_args()


class ChangeDestDir(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        namespace.current_destdir_actions = namespace.actions.setdefault(values, [])


class AppendInstruction(argparse.Action):
    def __call__(self, parser, namespace, values, option_string=None):
        namespace.current_destdir_actions.append(values)


class Task:
    def run(self):
        ...


class Instruction:
    def tasks(self, target: pathlib.Path, ripunzip: str | None) -> typing.Iterable[Task]:
        ...


@dataclasses.dataclass
class ScriptInstruction(Instruction):
    script: str

    def tasks(self, target: pathlib.Path, ripunzip: str | None):
        return (ScriptTask(pathlib.Path(runfiles.Rlocation(self.script)), target),)


@dataclasses.dataclass
class ScriptTask(Task):
    script: pathlib.Path
    target: pathlib.Path

    def run(self):
        subprocess.run([self.script, "--destdir", self.target], check=True)

    def __str__(self):
        return f"run {self.script.name} into {self.target}"


@dataclasses.dataclass
class ZipInstruction(Instruction):
    manifest: str

    def tasks(self, target: pathlib.Path, ripunzip: str | None):
        assert ripunzip, "--ripunzip must be provided when --zip-manifest is"
        manifest_file = runfiles.Rlocation(self.manifest)
        with open(manifest_file) as manifest:
            for line in manifest:
                prefix, _, zip = line.partition(":")
                assert zip, f"missing prefix for {prefix}, you should use prefix:zip format"
                zip = zip.strip()
                yield ZipTask(prefix, pathlib.Path(zip), target, ripunzip)


@dataclasses.dataclass
class ZipTask(Task):
    prefix: str
    zip: pathlib.Path
    target: pathlib.Path
    ripunzip: str

    def run(self):
        dest = self.target / self.prefix
        dest.mkdir(parents=True, exist_ok=True)
        subprocess.run([self.ripunzip, "unzip-file", self.zip, "-d", dest], check=True, stderr=subprocess.DEVNULL)

    def __str__(self):
        return f"extracted {self.zip.name} to {self.target / self.prefix}"


def main():
    opts = options()
    if opts.build_file:
        basedir = pathlib.Path(runfiles.Rlocation(opts.build_file)).resolve().parent / opts.destdir
    else:
        assert opts.destdir.is_absolute(), "Provide `--build-file` to resolve destination directories"
        basedir = opts.destdir
    ripunzip = opts.ripunzip and runfiles.Rlocation(opts.ripunzip)
    with concurrent.futures.ThreadPoolExecutor() as pool:
        tasks = {}
        for dir, actions in opts.actions.items():
            if actions:
                target = basedir / dir
                if target.exists() and opts.cleanup:
                    shutil.rmtree(target)
                target.mkdir(parents=True, exist_ok=True)
                tasks.update((pool.submit(t.run), t)
                             for action in actions
                             for t in action.tasks(target, ripunzip))
        while tasks:
            done, _ = concurrent.futures.wait(tasks, return_when=concurrent.futures.FIRST_COMPLETED)
            for future in done:
                future.result()
                print(tasks.pop(future))


if __name__ == '__main__':
    main()
