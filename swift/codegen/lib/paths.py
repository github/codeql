""" module providing useful filesystem paths """

import pathlib
import sys
import os

try:
    _workspace_dir = pathlib.Path(os.environ['BUILD_WORKSPACE_DIRECTORY'])  # <- means we are using bazel run
    swift_dir = _workspace_dir / 'swift'
    lib_dir = swift_dir / 'codegen' / 'lib'
except KeyError:
    _this_file = pathlib.Path(__file__).resolve()
    swift_dir = _this_file.parents[2]
    lib_dir = _this_file.parent


exe_file = pathlib.Path(sys.argv[0]).resolve()
