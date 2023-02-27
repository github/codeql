""" module providing useful filesystem paths """

import pathlib
import sys
import os

_this_file = pathlib.Path(__file__).resolve()

try:
    workspace_dir = pathlib.Path(os.environ['BUILD_WORKSPACE_DIRECTORY']).resolve()  # <- means we are using bazel run
    root_dir = workspace_dir / 'swift'
except KeyError:
    root_dir = _this_file.parents[2]
    workspace_dir = root_dir.parent

lib_dir = _this_file.parents[2] / 'codegen' / 'lib'
templates_dir = _this_file.parents[2] / 'codegen' / 'templates'

exe_file = pathlib.Path(sys.argv[0]).resolve()
