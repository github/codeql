import mutable_attr
import unittest

class T(unittest.TestCase):

    def test_foo(self):
        mutable_attr.y = 3
