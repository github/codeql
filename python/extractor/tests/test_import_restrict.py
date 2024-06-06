
import sys
import os.path
import shutil
import unittest

import semmle.populator
from tests import test_utils

class ExtractorImportRestrictTest(test_utils.ExtractorTest):

    def __init__(self, name):
      super(ExtractorImportRestrictTest, self).__init__(name)
      self.module_path = os.path.abspath(os.path.join(self.here, "data-imports"))

    def test_import_unrestricted(self):
        self.run_extractor("mod1")
        self.check_only_traps_exists_and_clear("mod1", "mod2", "mod3", "mod4", "mod5")

    def test_import_unrestricted_2(self):
        self.run_extractor("mod2")
        self.check_only_traps_exists_and_clear("mod2", "mod3", "mod4", "mod5")

    def test_import_depth(self):
        self.run_extractor("--max-import-depth", "1", "mod1")
        self.check_only_traps_exists_and_clear("mod1", "mod2")

    def test_import_depth_2(self):
        self.run_extractor("--max-import-depth", "2", "mod1")
        self.check_only_traps_exists_and_clear("mod1", "mod2", "mod3", "mod4")
