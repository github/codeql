
import sys
import os.path
import shutil
import unittest

import semmle.populator
from tests import test_utils

class ExtractorOffPathTest(test_utils.ExtractorTest):

    def __init__(self, name):
      super(ExtractorOffPathTest, self).__init__(name)

    def test_off_path(self):
        off_path = os.path.abspath(os.path.join(self.here, "off-path"))
        self.run_extractor("-R", off_path)
        self.check_only_traps_exists_and_clear("nameless", "mod1", "mod2")
