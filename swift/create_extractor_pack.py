import os
import pathlib
import shutil
import sys
from swift._create_extractor_pack_install_script import main

try:
    workspace_dir = pathlib.Path(os.environ['BUILD_WORKSPACE_DIRECTORY'])
except KeyError:
    print("this should be run with bazel run", file=sys.stderr)
    sys.exit(1)

dest_dir = workspace_dir / 'swift' / 'extractor-pack'
shutil.rmtree(dest_dir, ignore_errors=True)
os.environ['DESTDIR'] = str(dest_dir)
main(sys.argv)
