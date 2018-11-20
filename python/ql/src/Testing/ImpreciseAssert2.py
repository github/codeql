from unittest import TestCase

class MyTest(TestCase):
    
    
    def testInts(self):
        self.assertEqual(1, 1)
        self.assertLessEqual(1, 2)
        self.assertIn(1, []) #This will fail
