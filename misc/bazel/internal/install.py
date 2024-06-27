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
from python.runfiles import runfiles

runfiles = runfiles.Create()
assert runfiles, "Installer should be run with `bazel run`"

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--destdir", type=pathlib.Path, required=True,
                    help="Desination directory, relative to `--build-file`")
parser.add_argument("--pkg-install-script", required=True,
                    help="The wrapped `pkg_install` installation script rlocation")
parser.add_argument("--build-file",
                    help="BUILD.bazel rlocation relative to which the installation should take place")
parser.add_argument("--ripunzip",
                    help="ripunzip executable rlocation. Must be provided if `--zip-manifest` is.")
parser.add_argument("--zip-manifest",
                    help="The rlocation of a file containing newline-separated `prefix:zip_file` entries")
parser.add_argument("--cleanup", action=argparse.BooleanOptionalAction, default=True,
                    help="Whether to wipe the destination directory before installing (true by default)")
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

if destdir.exists() and opts.cleanup:
    shutil.rmtree(destdir)

destdir.mkdir(parents=True, exist_ok=True)
subprocess.run([script, "--destdir", destdir], check=True)

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
            subprocess.run([ripunzip, "unzip-file", zip, "-d", dest], check=True)
