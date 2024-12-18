import os
import subprocess

from tests.test_utils import ExtractorTest, environment

class ProjectLayoutUseTest(ExtractorTest):

    def __init__(self, name):
        super(ProjectLayoutUseTest, self).__init__(name)
        self.module_path = os.path.abspath(os.path.join(self.here, "project_layout"))
        self.src_path = os.path.join(self.module_path, "src")
        self.src_archive = os.path.join(self.module_path, "src_archive")

    def test_layout(self):
        with environment("SEMMLE_PATH_TRANSFORMER", "tests/project_layout/project-layout"):
            self.run_extractor("-R", self.src_path)
        self.check_only_traps_exists_and_clear("mod1")
        self.check_source_exists_and_clear(os.path.join(self.src_archive, "target", "src", "mod1.py"))

    def test_invalid_layout(self):
        try:
            with environment("SEMMLE_PATH_TRANSFORMER", "nonsuch/project-layout"):
                self.run_extractor("-R", self.src_path)
        except subprocess.CalledProcessError as ex:
            self.assertEqual(ex.returncode, 2)
        else:
            self.fail("Not cleanly halting on invalid path transformer")
