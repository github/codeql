import sys
import pathlib
import subprocess
import os
import argparse
import shutil
from python.runfiles import runfiles

def options():
    p = argparse.ArgumentParser(description="Update generated checked in files in the Go pack")
    p.add_argument("--force", "-f", action="store_true", help="Regenerate all files from scratch rather than updating them")
    p.add_argument("generators", nargs=3)
    return p.parse_args()

opts = options()

try:
    workspace_dir = pathlib.Path(os.environ['BUILD_WORKSPACE_DIRECTORY'])
except KeyError:
    print("this should be run with bazel run", file=sys.stderr)
    sys.exit(1)

go_extractor_dir = workspace_dir / "go" / "extractor"
go_dbscheme = workspace_dir / "go" / "ql" / "lib" / "go.dbscheme"
r = runfiles.Create()
go, gazelle, go_gen_dbscheme = map(r.Rlocation, opts.generators)


if opts.force:
    print("clearing vendor directory")
    shutil.rmtree(go_extractor_dir / "vendor")

existing_build_files = set(go_extractor_dir.glob("*/**/BUILD.bazel"))

print("updating vendor directory")
subprocess.check_call([go, "-C", go_extractor_dir, "work", "vendor"])

if opts.force:
    print("clearing generated BUILD files")
    for build_file in existing_build_files:
        build_file.unlink()

print("running gazelle")
subprocess.check_call([gazelle])

build_files_to_update = set(go_extractor_dir.glob("*/**/BUILD.bazel"))
if not opts.force:
    build_files_to_update -= existing_build_files
    # these are always refreshed
    build_files_to_update.update(go_extractor_dir.glob("vendor/**/BUILD.bazel"))

print("adding header to generated BUILD files")
for build_file in build_files_to_update:
    contents = build_file.read_text()
    build_file.write_text(f"# generated running `bazel run //go/gazelle`, do not edit\n\n{contents}")

subprocess.check_call([go_gen_dbscheme, go_dbscheme])
