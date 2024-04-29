import os
import pathlib
import shutil
import sys
import subprocess
import zipfile
from python.runfiles import runfiles

try:
    workspace_dir = pathlib.Path(os.environ['BUILD_WORKSPACE_DIRECTORY'])
except KeyError:
    print("this should be run with bazel run", file=sys.stderr)
    sys.exit(1)

dest_dir = workspace_dir / 'go' / 'build' / 'codeql-extractor-go'
installer_or_zip = pathlib.Path(runfiles.Create().Rlocation(sys.argv[1]))

shutil.rmtree(dest_dir, ignore_errors=True)

if installer_or_zip.suffix == '.zip':
    dest_dir.mkdir()
    with zipfile.ZipFile(installer_or_zip) as pack:
        pack.extractall(dest_dir)
else:
    os.environ['DESTDIR'] = str(dest_dir)
    subprocess.check_call([installer_or_zip])
