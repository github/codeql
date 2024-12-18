
import sys
import os.path
import shutil
import unittest
import subprocess

import semmle.populator
from tests import test_utils

class FileOptionTest(test_utils.ExtractorTest):

    def __init__(self, name):
        super(FileOptionTest, self).__init__(name)

    def test_file(self):
        self.run_extractor("-F", "tests/data/mod1.py")
        self.check_only_traps_exists_and_clear("mod1")

    def test_no_file(self):
        try:
            self.run_extractor("-F", "this-file-does-not-exist.py")
        except subprocess.CalledProcessError as ex:
            self.assertEqual(ex.returncode, 1)

    def test_no_module(self):
        try:
            self.run_extractor("this_module_does_not_exist")
        except subprocess.CalledProcessError as ex:
            self.assertEqual(ex.returncode, 1)
