""" module providing useful filesystem paths """

import pathlib
import sys
import os

try:
    workspace_dir = pathlib.Path(os.environ['BUILD_WORKSPACE_DIRECTORY']).resolve()  # <- means we are using bazel run
    swift_dir = workspace_dir / 'swift'
except KeyError:
    _this_file = pathlib.Path(__file__).resolve()
    swift_dir = _this_file.parents[2]
    workspace_dir = swift_dir.parent

lib_dir = swift_dir / 'codegen' / 'lib'
templates_dir = swift_dir / 'codegen' / 'templates'

exe_file = pathlib.Path(sys.argv[0]).resolve()
