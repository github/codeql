import os
import subprocess
import filecmp

from tests.test_utils import ExtractorTest, environment

class SourceArchiveUnchangedTest(ExtractorTest):
    """Checks that the files stored in the source archive are exact copies of the originals."""

    def __init__(self, name):
        super(SourceArchiveUnchangedTest, self).__init__(name)
        testfiledir = os.path.abspath(os.path.join(self.here, "source_archive_unchanged"))
        self.src_path = os.path.join(testfiledir, "src")
        self.src_archive = os.path.join(testfiledir, "src_archive")

    def test_source_archive_unchanged(self):
        self.run_extractor(
            "-F", "tests/source_archive_unchanged/src/weird_bytes.py",
            "-F", "tests/source_archive_unchanged/src/no_newline.py"
        )
        source_archive_location = os.path.join(self.src_archive, os.path.relpath(self.src_path, "/"))
        for filename in ("weird_bytes.py", "no_newline.py"):
            orig = os.path.join(self.src_path, filename)
            copy = os.path.join(source_archive_location, filename)
            if not filecmp.cmp(orig, copy):
                self.fail("The source archive version of the following file has changed: " + copy)
            self.check_source_exists_and_clear(os.path.join(source_archive_location, filename))
