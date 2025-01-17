
import os
import json
import subprocess

""" 
run "cargo metadata --format-version=1" 
"""


def get_cargo_metadata():
    metadata = json.loads(subprocess.check_output(
        ["cargo", "metadata", "--format-version=1"]))
    return metadata


CODEQL_EXTRACTOR_RUST_ROOT = os.environ.get("CODEQL_EXTRACTOR_RUST_ROOT")
CODEQL_PLATFORM = os.environ.get("CODEQL_PLATFORM")
database = os.environ.get("CODEQL_EXTRACTOR_RUST_WIP_DATABASE")
scratch_dir = os.environ.get("CODEQL_EXTRACTOR_RUST_SCRATCH_DIR")
metadata = get_cargo_metadata()
metadata_file = os.path.join(scratch_dir, "metadata_file.yaml")
with open(metadata_file, "w") as f:
    f.write("---\n")
    f.write(json.dumps(metadata, indent=4))

subprocess.run(["codeql", "database", "index-files", database,
               "-lyaml", "--working-dir", scratch_dir, "--include", "metadata_file.yaml"])
for package in metadata['packages']:
    for target in package['targets']:
        if 'lib' in target['kind']:
            src_path = target['src_path']
            dir = os.path.dirname(src_path)
            autobuild = "{root}/tools/{platform}/autobuild".format(
                root=CODEQL_EXTRACTOR_RUST_ROOT, platform=CODEQL_PLATFORM)
            subprocess.run([autobuild], cwd=dir)
