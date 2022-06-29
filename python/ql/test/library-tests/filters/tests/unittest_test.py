import unittest

class FooTest(unittest.TestCase):
    def test_valid(self):
        pass

class FunctionFooTest(unittest.FunctionTestCase):
    def test_valid(self):
        pass

class AsyncTest(unittest.IsolatedAsyncioTestCase):
    async def test_valid(self):
        pass

# django -- see https://docs.djangoproject.com/en/4.0/topics/testing/overview/
import django.test
class MyDjangoUnitTest(django.test.TestCase):
    def test_valid(self):
        pass

# flask -- see https://pythonhosted.org/Flask-Testing/
import flask_testing
class MyFlaskUnitTest(flask_testing.LiveServerTestCase):
    def test_valid(self):
        pass

# tornado -- see https://www.tornadoweb.org/en/stable/testing.html#tornado.testing.AsyncHTTPTestCase
import tornado.testing
class MyTornadoUnitTest(tornado.testing.AsyncHTTPTestCase):
    def test_valid(self):
        pass
