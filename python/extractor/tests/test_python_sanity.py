import sys
import unittest


class PythonSanityTest(unittest.TestCase):
    """Tests various implicit assumptions we have about Python behavior.

    This is intended to catch changes that may break extraction in future
    versions of Python.
    """

    def __init__(self, name):
      super(PythonSanityTest, self).__init__(name)

    def test_latin_1_encoding(self):
        """Tests whether 'latin-1' acts as a "do nothing" encoding."""

        s = bytes(range(256))
        u = str(s, 'latin-1')
        s_as_tuple = tuple(s)

        u_as_tuple = tuple(map(ord, u))
        assert u_as_tuple == s_as_tuple
