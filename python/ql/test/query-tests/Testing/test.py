from unittest import TestCase

class MyTest(TestCase):
    
    def test1(self):
        self.assertTrue(1 == 1)
        self.assertFalse(1 > 2)
        self.assertTrue(1 in [1])
        self.assertFalse(0 is "")
