import os
import json
import subprocess

import semmle.path_filters
from tests import test_utils

class ExtractorPatternsTest(test_utils.ExtractorTest):

    def __init__(self, name):
        super(ExtractorPatternsTest, self).__init__(name)

    def test(self):
        repo_dir = subprocess.Popen(["git", "rev-parse", "--show-toplevel"], stdout=subprocess.PIPE).communicate()[0].rstrip().decode("utf-8")
        test_file_path = os.path.abspath(os.path.join(repo_dir, "..", "unit-tests", "files", "pattern-matching", "patterns.json"))
        with open(test_file_path) as test_file:
            test_patterns = json.load(test_file)
        for test_pattern in test_patterns:
            pattern = test_pattern["pattern"]
            regex = semmle.path_filters.glob_to_regex(pattern)
            for matching_path in test_pattern["should_match"]:
                self.assertTrue(regex.match(matching_path), "Pattern \"%s\" did not match path \"%s\"." % (pattern, matching_path))
            for matching_path in test_pattern["shouldnt_match"]:
                self.assertFalse(regex.match(matching_path), "Pattern \"%s\" matched path \"%s\"." % (pattern, matching_path))

    def test_escape_prefix(self):
        semmle.path_filters.glob_to_regex("x", prefix="foo\\")
