# This example illustrates that not all valid results are useful.
# The alert in this file should be suppressed.
# see https://github.com/Semmle/ql/issues/3207

def foo(l):
    for (k, v) in l:
        print(k, v)

foo([('a', 42), ('b', 43)])

import unittest

class FooTest(unittest.TestCase):
    def test_valid(self):
        foo([('a', 42), ('b', 43)])

    def test_not_valid(self):
        with six.assertRaises(self, ValueError):
            foo("not valid")
