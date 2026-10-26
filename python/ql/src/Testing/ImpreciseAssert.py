from unittest import TestCase

class MyTest(TestCase):
    
    
    def testInts(self):
        self.assertTrue(1 == 1)
        self.assertFalse(1 > 2)
        self.assertTrue(1 in []) #This will fail
