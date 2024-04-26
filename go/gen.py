import sys
import pathlib
import subprocess
from python.runfiles import runfiles

this = pathlib.Path(__file__).resolve()
go_extractor_dir = this.parent / "extractor"
go_dbscheme = this.parent / "ql" / "lib" / "go.dbscheme"
r = runfiles.Create()
gazelle, go_gen_dbscheme = map(r.Rlocation, sys.argv[1:])

print("clearing generated BUILD files")
for build_file in go_extractor_dir.glob("*/**/BUILD.bazel"):
    build_file.unlink()

print("running gazelle")
subprocess.check_call([gazelle, "go/extractor"])

print("adding header to generated BUILD files")
for build_file in go_extractor_dir.glob("*/**/BUILD.bazel"):
    contents = build_file.read_text()
    build_file.write_text(f"# generated running `bazel run //go/gazelle`, do not edit\n\n{contents}")

subprocess.check_call([go_gen_dbscheme, go_dbscheme])
