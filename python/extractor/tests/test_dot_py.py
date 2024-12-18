
import sys
import os.path
import shutil
import unittest

import semmle.populator
from tests import test_utils

class DotPyPathTest(test_utils.ExtractorTest):

    def __init__(self, name):
      super(DotPyPathTest, self).__init__(name)

    def test_dot_py(self):
        dot_py = os.path.abspath(os.path.join(self.here, "dot-py"))
        self.run_extractor("-R", dot_py, "-p", dot_py)
        self.check_only_traps_exists_and_clear('__init__', 'a')
