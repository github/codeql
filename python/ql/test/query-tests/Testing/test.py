from unittest import TestCase

class MyTest(TestCase):
    
    def test1(self):
        self.assertTrue(1 == 1) # $ Alert
        self.assertFalse(1 > 2) # $ Alert
        self.assertTrue(1 in [1]) # $ Alert
        self.assertFalse(0 is "") # $ Alert
