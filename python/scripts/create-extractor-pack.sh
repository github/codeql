#!/bin/bash
#
# Build a local Python extractor pack from source.
#
# Usage with the CodeQL CLI (run from the repository root):
#
#   codeql database create <db> -l python -s <src> --search-path .
#   codeql test run --search-path . python/ql/test/<test-dir>
#
set -eux

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  platform="linux64"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  platform="osx64"
else
  echo "Unknown OS"
  exit 1
fi

cd "$(dirname "$0")/.."

# Build the tsg-python Rust binary
(cd extractor/tsg-python && cargo build --release)
tsg_bin="extractor/tsg-python/target/release/tsg-python"

# Generate python3src.zip from the Python extractor source.
# make_zips.py creates the zip in the source directory and then copies it to the
# given output directory. We use a temporary directory to avoid a same-file copy
# error, then move the zip back.
tmpdir=$(mktemp -d)
trap 'rm -rf "$tmpdir"' EXIT
(cd extractor && python3 make_zips.py "$tmpdir")
cp "$tmpdir/python3src.zip" extractor/python3src.zip

# Assemble the extractor pack
rm -rf extractor-pack
mkdir -p extractor-pack/tools/${platform}

# Root-level metadata and schema files
cp codeql-extractor.yml extractor-pack/
cp ql/lib/semmlecode.python.dbscheme extractor-pack/
cp ql/lib/semmlecode.python.dbscheme.stats extractor-pack/

# Python extractor engine files (into tools/)
cp extractor/python_tracer.py extractor-pack/tools/
cp extractor/index.py extractor-pack/tools/
cp extractor/setup.py extractor-pack/tools/
cp extractor/convert_setup.py extractor-pack/tools/
cp extractor/get_venv_lib.py extractor-pack/tools/
cp extractor/imp.py extractor-pack/tools/
cp extractor/LICENSE-PSF.md extractor-pack/tools/
cp extractor/python3src.zip extractor-pack/tools/
cp -r extractor/data extractor-pack/tools/

# Shell tool scripts (autobuild, pre-finalize, lgtm-scripts)
cp tools/autobuild.sh extractor-pack/tools/
cp tools/autobuild.cmd extractor-pack/tools/
cp tools/pre-finalize.sh extractor-pack/tools/
cp tools/pre-finalize.cmd extractor-pack/tools/
cp -r tools/lgtm-scripts extractor-pack/tools/

# Downgrades
cp -r downgrades extractor-pack/

# Platform-specific Rust binary
cp "${tsg_bin}" extractor-pack/tools/${platform}/tsg-python
