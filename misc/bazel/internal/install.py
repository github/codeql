import argparse
import pathlib
import shutil
import subprocess
from python.runfiles import runfiles

runfiles = runfiles.Create()
if not runfiles:
    raise Exception("Installer should be run with `bazel run`")

parser = argparse.ArgumentParser()
parser.add_argument("--destdir", type=pathlib.Path, required=True)
parser.add_argument("--script", required=True)
parser.add_argument("--build-file", required=True)
opts = parser.parse_args()

script = runfiles.Rlocation(opts.script)
build_file = runfiles.Rlocation(opts.build_file)
destdir = pathlib.Path(build_file).parent / opts.destdir

if destdir.exists():
    shutil.rmtree(destdir)

destdir.mkdir(parents=True)
subprocess.run([script, "--destdir", destdir], check=True)
