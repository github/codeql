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
parser.add_argument("--build-file", required=True,
                    help="BUILD.bazel rlocation relative to which the installation should take place")
parser.add_argument("--ripunzip", required=True,
                    help="ripunzip executable rlocation")
parser.add_argument("--zip-manifest", required=True,
                    help="The rlocation of a file containing newline-separated `prefix:zip_file` entries")
opts = parser.parse_args()

build_file = runfiles.Rlocation(opts.build_file)
script = runfiles.Rlocation(opts.pkg_install_script)
ripunzip = runfiles.Rlocation(opts.ripunzip)
zip_manifest = runfiles.Rlocation(opts.zip_manifest)
destdir = pathlib.Path(build_file).resolve().parent / opts.destdir

if destdir.exists():
    shutil.rmtree(destdir)

destdir.mkdir(parents=True)
subprocess.run([script, "--destdir", destdir], check=True)

with open(zip_manifest) as manifest:
    for line in manifest:
        prefix, _, zip = line.partition(":")
        assert zip, f"missing prefix for {prefix}, you should use prefix:zip format"
        dest = destdir / prefix
        dest.mkdir(parents=True, exist_ok=True)
        subprocess.run([ripunzip, "unzip-file", zip, "-d", dest], check=True)
