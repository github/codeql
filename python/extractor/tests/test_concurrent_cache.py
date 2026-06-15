
import sys
import os.path
import unittest
import multiprocessing

import semmle
from tests import test_utils
from semmle.util import makedirs


ITERATIONS = 100
CONCURRENCY = 20

class ConcurrentCacheTest(test_utils.ExtractorTest):
    '''
    Test the cache under heavy concurrent load.
    '''

    def __init__(self, name):
        super(ConcurrentCacheTest, self).__init__(name)
        self.cachedir = os.path.abspath(os.path.join(self.here, "cache"))

    def setUp(self):
        super(ConcurrentCacheTest, self).setUp()
        makedirs(self.cachedir)
        self.cache = semmle.cache.Cache(self.cachedir)

    def tearDown(self):
        super(ConcurrentCacheTest, self).tearDown()

    def _concurrent_read_and_write(self):
        readers = []
        writers = []
        queue = multiprocessing.Queue(CONCURRENCY+1)
        for i in range(CONCURRENCY):
            readers.append(multiprocessing.Process(target=read_func, args=(self.cache, queue)))
            writers.append(multiprocessing.Process(target=write_func, args=(self.cache, ITERATIONS//4)))
        for read, write in zip(readers, writers):
            read.start()
            write.start()
        for proc in writers:
            proc.join()
        for proc in readers:
            proc.join()
        successes = [ queue.get(False) for i in range(CONCURRENCY) ]
        self.assertNotIn(None, successes)
        # We expect a fairly low success rate here
        # But want to assert that at least one read succeeded.
        self.assertGreater(sum(successes), 0)

    def _concurrent_read_ok(self):
        readers = []
        queue = multiprocessing.Queue(CONCURRENCY+1)
        for i in range(CONCURRENCY):
            readers.append(multiprocessing.Process(target=read_func, args=(self.cache, queue)))
        for proc in readers:
            proc.start()
        for proc in readers:
            proc.join()
        successes = [ queue.get(False) for i in range(CONCURRENCY) ]
        self.assertNotIn(None, successes)
        self.assertEqual(sum(successes), 2*CONCURRENCY*ITERATIONS)

    def test(self):
        #Must run this first as it populates the cache
        self._concurrent_read_and_write()
        #Then this tests that the cache is correctly populated.
        self._concurrent_read_ok()

def key(i):
    return "key%d" % i

def value(i):
    return ("value%d\n" % i).encode("utf-8")*10000

def read_func(cache, queue):
    successes = 0
    for i in range(ITERATIONS):
        val = cache.get(key(i))
        if val is not None:
            successes += 1
            assert val == value(i)
    for i in range(ITERATIONS):
        val = cache.get(key(i))
        if val is not None:
            successes += 1
            assert val == value(i)
    queue.put(successes)

def write_func(cache, offset):
    for i in range(offset, ITERATIONS):
        cache.set(key(i), value(i))
    for i in range(offset-1, -1, -1):
        cache.set(key(i), value(i))
