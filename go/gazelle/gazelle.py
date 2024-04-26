import sys
import pathlib
import subprocess
from python.runfiles import runfiles

this = pathlib.Path(__file__).resolve()
go_extractor_dir = this.parents[1] / "extractor"
gazelle = runfiles.Create().Rlocation(sys.argv[1])
for build_file in go_extractor_dir.glob("*/**/BUILD.bazel"):
    build_file.unlink()

subprocess.check_call([gazelle, "go/extractor"])

for build_file in go_extractor_dir.glob("*/**/BUILD.bazel"):
    contents = build_file.read_text()
    build_file.write_text(f"# generated running `bazel run //go/gazelle`, do not edit\n\n{contents}")
