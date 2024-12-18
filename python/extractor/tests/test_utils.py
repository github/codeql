import os
import sys
import semmle
import unittest
import shutil
import re
from contextlib import contextmanager

import semmle.populator
import subprocess

BUILTIN_TRAP = "builtins.trap.gz"

PY_PATTERN = re.compile(r"(\w+)\.py.[A-Za-z0-9=_\-]+\.trap\.gz")
FOLDER_PATTERN = re.compile(r"(\w+).[A-Za-z0-9=_\-]+\.trap\.gz")


@contextmanager
def environment(key, value):
    os.environ[key] = value
    try:
        yield
    finally:
        del os.environ[key]


class ExtractorTest(unittest.TestCase):

    def __init__(self, name):
        unittest.TestCase.__init__(self, name)
        self.here = os.path.dirname(__file__)
        self.module_path = os.path.abspath(os.path.join(self.here, "data"))
        self.trap_path = os.path.abspath(os.path.join(self.here, "traps"))
        self.src_archive = None

    def setUp(self):
        try:
            os.makedirs(self.trap_path)
        except:
            if os.path.exists(self.trap_path):
                return
            raise

    def tearDown(self):
        shutil.rmtree(self.trap_path, ignore_errors=True)

    def check_only_traps_exists_and_clear(self, *module_names):
        modules = list(module_names)
        for filename in os.listdir(self.trap_path):
            match = PY_PATTERN.match(filename)
            if match:
                name = match.group(1)
            else:
                match = FOLDER_PATTERN.match(filename)
                if match:
                    name = match.group(1) + "/"
                else:
                    continue
            if name in modules:
                modules.remove(name)
                path = os.path.join(self.trap_path, filename)
                os.remove(path)
        if modules:
            self.fail("No trap file for " + modules.pop())
        for _, _, filenames in os.walk(self.trap_path):
            #Ignore the builtin trap file, any `__init__.py` files, and $file, $interpreter trap files.
            filenames = [ name for name in filenames if not name.startswith("$") and not name.startswith("__init__.py") and name != BUILTIN_TRAP]
            self.assertFalse(filenames, "Some trap files remain: " + ", ".join(filenames))

    def check_source_exists_and_clear(self, path):
        try:
            os.remove(path)
        except OSError:
            self.fail("File '%s' does not exist" % path)

    def run_extractor(self, *args):
        cmd = [sys.executable, os.path.join(os.path.dirname(self.here), "python_tracer.py"), "--quiet" ] + ["-p", self.module_path, "-o", self.trap_path] + list(args)
        with environment("CODEQL_EXTRACTOR_PYTHON_ENABLE_PYTHON2_EXTRACTION", "True"):
            if self.src_archive:
                with environment("CODEQL_EXTRACTOR_PYTHON_SOURCE_ARCHIVE_DIR", self.src_archive):
                        subprocess.check_call(cmd)
            else:
                subprocess.check_call(cmd)
