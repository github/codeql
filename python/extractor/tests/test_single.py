
import sys
import os.path
import shutil
import unittest

import semmle.populator
from tests import test_utils

class SingleThreadedTest(test_utils.ExtractorTest):

    def __init__(self, name):
        super(SingleThreadedTest, self).__init__(name)

    def test_simple(self):
        self.run_extractor("-z1", "package.sub.a")
        self.check_only_traps_exists_and_clear("a", "package/", "sub/")

    def test_simple_exclude(self):
        self.run_extractor("-z1", "-y", "package.sub", "mod1", "package.x", "package.sub.a")
        self.check_only_traps_exists_and_clear("mod1", "package/", "x")
