"""
Helper script for installing `codeql_pack` targets.

This mainly wraps around a `pkg_install` script from `rules_pkg` adding:
* resolving destination directory with respect to a provided `--build-file`
* clean-up of target destination directory before a reinstall
* installing imported zip files using a provided `--ripunzip`
"""

import argparse
import pathlib
import shutil
import subprocess
import platform
import time
import sys
from python.runfiles import runfiles

runfiles = runfiles.Create()
assert runfiles, "Installer should be run with `bazel run`"

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument(
    "--destdir",
    type=pathlib.Path,
    required=True,
    help="Desination directory, relative to `--build-file`",
)
parser.add_argument(
    "--pkg-install-script",
    required=True,
    help="The wrapped `pkg_install` installation script rlocation",
)
parser.add_argument(
    "--build-file",
    help="BUILD.bazel rlocation relative to which the installation should take place",
)
parser.add_argument(
    "--ripunzip", help="ripunzip executable rlocation. Must be provided if `--zip-manifest` is."
)
parser.add_argument(
    "--zip-manifest",
    help="The rlocation of a file containing newline-separated `prefix:zip_file` entries",
)
parser.add_argument(
    "--cleanup",
    action=argparse.BooleanOptionalAction,
    default=True,
    help="Whether to wipe the destination directory before installing (true by default)",
)
opts = parser.parse_args()
if opts.zip_manifest and not opts.ripunzip:
    parser.error("Provide `--ripunzip` when specifying `--zip-manifest`")

if opts.build_file:
    build_file = runfiles.Rlocation(opts.build_file)
    destdir = pathlib.Path(build_file).resolve().parent / opts.destdir
else:
    destdir = pathlib.Path(opts.destdir)
    assert destdir.is_absolute(), "Provide `--build-file` to resolve destination directory"
script = runfiles.Rlocation(opts.pkg_install_script)

_WIN_FILE_IN_USE_ERROR_CODE = 32


def rmdir(dir: pathlib.Path):
    if platform.system() == "Windows":
        # On Windows we might have virus scanner still looking at the path so
        # attempt removal a couple of times sleeping between each attempt.
        for retry_delay in [1, 2, 2]:
            try:
                shutil.rmtree(dir)
                break
            except OSError as e:
                if e.winerror == _WIN_FILE_IN_USE_ERROR_CODE:
                    time.sleep(retry_delay)
                else:
                    raise
        else:
            shutil.rmtree(dir)
    else:
        shutil.rmtree(dir)


if destdir.exists() and opts.cleanup:
    rmdir(destdir)


attempts = 0
success = False
while attempts < 3 and not success:
    attempts += 1
    destdir.mkdir(parents=True, exist_ok=True)
    subprocess.run([script, "--destdir", destdir], check=True)
    success = True

    if opts.zip_manifest:
        ripunzip = runfiles.Rlocation(opts.ripunzip)
        zip_manifest = runfiles.Rlocation(opts.zip_manifest)
        with open(zip_manifest) as manifest:
            for line in manifest:
                prefix, _, zip = line.partition(":")
                assert zip, f"missing prefix for {prefix}, you should use prefix:zip format"
                zip = zip.strip()
                dest = destdir / prefix
                dest.mkdir(parents=True, exist_ok=True)
                command = [ripunzip, "unzip-file", zip, "-d", dest]
                print(f"Running ", *command)
                ret = subprocess.run(command)
                success = ret.returncode == 0
                if not success:
                    print(f"Failed to unzip {zip} to {dest}, retrying installation...")
                    rmdir(destdir)
                    break
if not success:
    sys.exit(1)
