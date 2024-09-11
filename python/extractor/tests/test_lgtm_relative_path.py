import os

from tests import test_utils

class ExtractorPatternsTest(test_utils.ExtractorTest):

    def __init__(self, name):
        super(ExtractorPatternsTest, self).__init__(name)

    def test(self):
        src = os.path.join(self.here, "lgtm_src")
        with test_utils.environment("LGTM_SRC", src):
            self.run_extractor("-R", src, "--filter", "exclude:*.py",  "--filter", "include:x.py")
            self.check_only_traps_exists_and_clear("x")
