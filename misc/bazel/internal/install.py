import argparse
import pathlib
import shutil
import subprocess
from python.runfiles import runfiles

runfiles = runfiles.Create()
assert runfiles, "Installer should be run with `bazel run`"

parser = argparse.ArgumentParser()
parser.add_argument("--destdir", type=pathlib.Path, required=True)
parser.add_argument("--script", required=True)
parser.add_argument("--build-file", required=True)
parser.add_argument("--ripunzip", required=True)
parser.add_argument("--zip-manifest", action="append", default=[], dest="zip_manifests")
opts = parser.parse_args()

build_file = runfiles.Rlocation(opts.build_file)
script = runfiles.Rlocation(opts.script)
ripunzip = runfiles.Rlocation(opts.ripunzip)
zip_manifests = [runfiles.Rlocation(z) for z in opts.zip_manifests]
destdir = pathlib.Path(build_file).resolve().parent / opts.destdir

if destdir.exists():
    shutil.rmtree(destdir)

destdir.mkdir(parents=True)
subprocess.run([script, "--destdir", destdir], check=True)

for zip_manifest in zip_manifests:
    with open(zip_manifest) as manifest:
        for line in manifest:
            prefix, _, zip = line.partition(":")
            assert zip, f"missing prefix for {prefix}, you should use prefix:zip format"
            dest = destdir / prefix
            dest.mkdir(parents=True, exist_ok=True)
            subprocess.run([ripunzip, "unzip-file", zip, "-d", dest], check=True)
