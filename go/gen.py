"""
Update generated files related to Go in the repo. Using --force will regenerate all files from scratch.

In particular the script will:
1. update the `vendor` dir with `go mod vendor` (using a go toolchain provided by bazel)
2. update `BUILD.bazel` files using gazelle
3. update `ql/lib/go.dbscheme` using a compiled `go-dbschemegen`
"""

import sys
import pathlib
import subprocess
import os
import argparse
import shutil
from python.runfiles import runfiles

def options():
    p = argparse.ArgumentParser(description="Update generated files related to Go in the repo")
    p.add_argument("--force", "-f", action="store_true", help="Regenerate all files from scratch rather than updating them")
    p.add_argument("executables", nargs=3, help="Internally provided executables")
    return p.parse_args()

opts = options()

try:
    workspace_dir = pathlib.Path(os.environ['BUILD_WORKSPACE_DIRECTORY'])
except KeyError:
    print("this should be run with bazel run", file=sys.stderr)
    sys.exit(1)

go_extractor_dir = workspace_dir / "go" / "extractor"

if not go_extractor_dir.exists():
    # internal repo?
    workspace_dir /= "ql"
    go_extractor_dir = workspace_dir / "go" / "extractor"

go_dbscheme = workspace_dir / "go" / "ql" / "lib" / "go.dbscheme"
r = runfiles.Create()
go, gazelle, go_gen_dbscheme = map(r.Rlocation, opts.executables)


existing_build_files = set(go_extractor_dir.glob("*/**/BUILD.bazel"))

if opts.force:
    print("clearing generated BUILD files")
    for build_file in existing_build_files:
        build_file.unlink()

print("running gazelle", gazelle, go_extractor_dir)
subprocess.check_call([gazelle, "go/extractor"], cwd=workspace_dir)

# we want to stamp all newly generated `BUILD.bazel` files with a header
build_files_to_update = set(go_extractor_dir.glob("*/**/BUILD.bazel"))
# if --force, all files are new
if not opts.force:
    # otherwise, subtract the files that existed at the start
    build_files_to_update -= existing_build_files

print("adding header to newly generated BUILD files")
for build_file in build_files_to_update:
    contents = build_file.read_text()
    build_file.write_text(f"# generated running `bazel run //go/gazelle`, do not edit\n\n{contents}")

subprocess.check_call([go_gen_dbscheme, go_dbscheme])
