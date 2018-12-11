import unittest

class T(unittest.TestCase):

    def test_thing(self):
        l = 10
        s = [0]
        with self.assertRaises(TypeError):
            l[1000]
        with self.assertRaises(IndexError):
            s[1]
