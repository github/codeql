import sys
import pathlib
import subprocess
import os
from python.runfiles import runfiles

try:
    workspace_dir = pathlib.Path(os.environ['BUILD_WORKSPACE_DIRECTORY'])
except KeyError:
    print("this should be run with bazel run", file=sys.stderr)
    sys.exit(1)

go_extractor_dir = workspace_dir / "go" / "extractor"
go_dbscheme = workspace_dir / "go" / "ql" / "lib" / "go.dbscheme"
r = runfiles.Create()
go, gazelle, go_gen_dbscheme = map(r.Rlocation, sys.argv[1:])

print("updating vendor")
subprocess.check_call([go, "-C", go_extractor_dir, "work", "vendor"])

print("clearing generated BUILD files")
for build_file in go_extractor_dir.glob("*/**/BUILD.bazel"):
    build_file.unlink()

print("running gazelle")
subprocess.check_call([gazelle])

print("adding header to generated BUILD files")
for build_file in go_extractor_dir.glob("*/**/BUILD.bazel"):
    contents = build_file.read_text()
    build_file.write_text(f"# generated running `bazel run //go/gazelle`, do not edit\n\n{contents}")

subprocess.check_call([go_gen_dbscheme, go_dbscheme])
