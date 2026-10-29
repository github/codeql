
import sys
import os.path
import shutil
import unittest
from contextlib import contextmanager

import semmle.populator
from tests import test_utils
import subprocess
if sys.version_info < (3,0):
    from StringIO import StringIO
else:
    from io import StringIO

ALL_ACCESS = int("777", base=8)


@contextmanager
def discard_output():
    new_out, new_err = StringIO(), StringIO()
    old_out, old_err = sys.stdout, sys.stderr
    try:
        sys.stdout, sys.stderr = new_out, new_err
        yield
    finally:
        sys.stdout, sys.stderr = old_out, old_err

class SingleThreadedTest(test_utils.ExtractorTest):

    def __init__(self, name):
        super(SingleThreadedTest, self).__init__(name)

    def test_ioerror(self):
        if os.name == "nt":
            return
        try:
            os.chmod(self.trap_path, 0)
            with discard_output():
                try:
                    self.run_extractor("-z1", "-y", "package.sub", "mod1", "package.x", "package.sub.a")
                except subprocess.CalledProcessError as ex:
                    self.assertEqual(ex.returncode, 1)
        finally:
            os.chmod(self.trap_path, ALL_ACCESS)
