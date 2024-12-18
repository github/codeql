
import sys
import os.path
import shutil
import unittest

import semmle.populator
from tests import test_utils

class ExtractorExcludeTest(test_utils.ExtractorTest):

    def __init__(self, name):
        super(ExtractorExcludeTest, self).__init__(name)

    def test_simple_exclude(self):
        self.run_extractor("-y", "package.sub", "mod1", "package.x", "package.sub.a")
        self.check_only_traps_exists_and_clear("mod1", "package/", "x")

    def test_simple_exclude_pattern(self):
        self.run_extractor("--exclude-pattern", ".*(a|x)", "mod1", "package.x", "package.sub.a", "package.sub.b")
        self.check_only_traps_exists_and_clear("mod1", "b", "package/", "sub/")

    def test_multiple_exclude(self):
        self.run_extractor("-y", "package.sub.x", "mod1", "-y", "package.sub.y", "package.sub.a")
        self.check_only_traps_exists_and_clear("mod1", "package/", "sub/", "a")
