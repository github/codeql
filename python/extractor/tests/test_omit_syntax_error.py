
import sys
import os.path
import shutil
import unittest

import semmle.populator
from tests import test_utils

class OmitSyntaxErrorTest(test_utils.ExtractorTest):

    def __init__(self, name):
        super(OmitSyntaxErrorTest, self).__init__(name)
        self.module_path = os.path.abspath(os.path.join(self.here, "syntax-error"))

    def test_omit(self):
        self.run_extractor("--omit-syntax-error", "error")
        self.check_only_traps_exists_and_clear()

    def test_dont_omit(self):
        self.run_extractor("error")
        self.check_only_traps_exists_and_clear("error", "error")
