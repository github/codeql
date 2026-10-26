
import sys
import os.path
import shutil
import unittest

import semmle.populator
from tests import test_utils

class TrapCacheTest(test_utils.ExtractorTest):

    def __init__(self, name):
        super(TrapCacheTest, self).__init__(name)
        self.trap_cache = os.path.abspath(os.path.join(self.here, "cache"))


    def tearDown(self):
        super(TrapCacheTest, self).tearDown()
        shutil.rmtree(self.trap_cache, ignore_errors=True)

    def run_extractor(self, *args):
        super(TrapCacheTest, self).run_extractor(*(["-c", self.trap_cache] + list(args)))

    def create_trap_cache(self):
        try:
            os.makedirs(self.trap_cache)
        except:
            if os.path.exists(self.trap_cache):
                return
            raise

    def test_pre_created(self):
        self.create_trap_cache()
        self.run_extractor("mod1", "package.x", "package.sub.a")
        self.check_only_traps_exists_and_clear("mod1", "package/", "x", "sub/", "a")

    def test_not_pre_created(self):
        self.run_extractor("mod1", "package.x", "package.sub.a")
        self.check_only_traps_exists_and_clear("mod1", "package/", "x", "sub/", "a")
