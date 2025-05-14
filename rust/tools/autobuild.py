
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
os.makedirs(scratch_dir, exist_ok=True)
with open(metadata_file, "w") as f:
    f.write("---\n")
    f.write(json.dumps(metadata, indent=4))

subprocess.run(["codeql", "database", "index-files", database,
               "-lyaml", "--working-dir", scratch_dir, "--include", "metadata_file.yaml"])
paths = set()
for package in metadata['packages']:
    for target in package['targets']:
        if 'lib' in target['kind'] or 'bin' in target['kind']:
            src_path = target['src_path']
            paths.add(os.path.dirname(src_path))

autobuild = "{root}/tools/{platform}/autobuild".format(
    root=CODEQL_EXTRACTOR_RUST_ROOT, platform=CODEQL_PLATFORM)

for path in paths:
    if not path.startswith(os.getcwd()):
        env = os.environ.copy()
        env['CODEQL_EXTRACTOR_RUST_OPTION_EXCLUDE_BODIES'] = "true"
    else:
        env = None
    subprocess.run([autobuild], cwd=path, env=env)
