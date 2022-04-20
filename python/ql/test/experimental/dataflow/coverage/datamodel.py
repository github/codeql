# User-defined methods, both instance methods and class methods, can be called in many non-standard ways
# i.e. differently from simply `c.f()` or `C.f()`. For example, a user-defined `__await__` method on a
# class `C` will be called by the syntactic construct `await c` when `c` is an instance of `C`.
#
# These tests are based on the first part of https://docs.python.org/3/reference/datamodel.html.
# A thorough covering of methods in that document is found in classes.py.
#
# Intended sources should be the variable `SOURCE` and intended sinks should be
# arguments to the function `SINK` (see python/ql/test/experimental/dataflow/testConfig.qll).

# These are defined so that we can evaluate the test code.
NONSOURCE = "not a source"
SOURCE = "source"

def is_source(x):
    return x == "source" or x == b"source" or x == 42 or x == 42.0 or x == 42j

def SINK(x):
    if is_source(x):
        print("OK")
    else:
        print("Unexpected flow", x)

def SINK_F(x):
    if is_source(x):
        print("Unexpected flow", x)
    else:
        print("OK")

# Callable types
# These are the types to which the function call operation (see section Calls) can be applied:

# User-defined functions
# A user-defined function object is created by a function definition (see section Function definitions). It should be called with an argument list containing the same number of items as the function's formal parameter list.
def f(a, b):
  return a

SINK(f(SOURCE, 3)) #$ flow="SOURCE -> f(..)"

# Instance methods
# An instance method object combines a class, a class instance and any callable object (normally a user-defined function).
class C(object):

    def method(self, x, cls):
        assert cls is self.__class__
        return x

    @classmethod
    def classmethod(cls, x):
        return x

    @staticmethod
    def staticmethod(x):
        return x

    def gen(self, x, count):
      n = count
      while n > 0:
        yield x
        n -= 1

    async def coro(self, x):
      return x

c = C()

# When an instance method object is created by retrieving a user-defined function object from a class via one of its instances, its __self__ attribute is the instance, and the method object is said to be bound. The new method’s __func__ attribute is the original function object.
func_obj = c.method.__func__

# When an instance method object is called, the underlying function (__func__) is called, inserting the class instance (__self__) in front of the argument list. For instance, when C is a class which contains a definition for a function f(), and x is an instance of C, calling x.f(1) is equivalent to calling C.f(x, 1).
SINK(c.method(SOURCE, C)) #$ flow="SOURCE -> c.method(..)"
SINK(C.method(c, SOURCE, C)) #$ flow="SOURCE -> C.method(..)"
SINK(func_obj(c, SOURCE, C)) #$ MISSING: flow="SOURCE -> func_obj(..)"


# When an instance method object is created by retrieving a class method object from a class or instance, its __self__ attribute is the class itself, and its __func__ attribute is the function object underlying the class method.
c_func_obj = C.classmethod.__func__

# When an instance method object is derived from a class method object, the “class instance” stored in __self__ will actually be the class itself, so that calling either x.f(1) or C.f(1) is equivalent to calling f(C,1) where f is the underlying function.
SINK(c.classmethod(SOURCE)) #$ flow="SOURCE -> c.classmethod(..)"
SINK(C.classmethod(SOURCE)) #$ flow="SOURCE -> C.classmethod(..)"
SINK(c_func_obj(C, SOURCE)) #$ MISSING: flow="SOURCE -> c_func_obj(..)"

# Generator functions
# A function or method which uses the yield statement (see section The yield statement) is called a generator function. Such a function, when called, always returns an iterator object which can be used to execute the body of the function: calling the iterator’s iterator.__next__() method will cause the function to execute until it provides a value using the yield statement. When the function executes a return statement or falls off the end, a StopIteration exception is raised and the iterator will have reached the end of the set of values to be returned.
def gen(x, count):
  n = count
  while n > 0:
    yield x
    n -= 1

iter = gen(SOURCE, 1)
SINK(iter.__next__()) # $ MISSING: flow
# SINK_F(iter.__next__()) # throws StopIteration, FP

oiter = c.gen(SOURCE, 1)
SINK(oiter.__next__()) # $ MISSING: flow
# SINK_F(oiter.__next__()) # throws StopIteration, FP

# Coroutine functions
# A function or method which is defined using async def is called a coroutine function. Such a function, when called, returns a coroutine object. It may contain await expressions, as well as async with and async for statements. See also the Coroutine Objects section.
async def coro(x):
  return x

import asyncio
SINK(asyncio.run(coro(SOURCE))) # $ MISSING: flow
SINK(asyncio.run(c.coro(SOURCE))) # $ MISSING: flow

class A:

  def __await__(self):
    # yield SOURCE  -- see https://groups.google.com/g/dev-python/c/_lrrc-vp9TI?pli=1
    return (yield from asyncio.coroutine(lambda: SOURCE)())

async def agen(x):
  a = A()
  return await a

SINK(asyncio.run(agen(SOURCE))) # $ MISSING: flow

# Asynchronous generator functions
# A function or method which is defined using async def and which uses the yield statement is called a asynchronous generator function. Such a function, when called, returns an asynchronous iterator object which can be used in an async for statement to execute the body of the function.

# Calling the asynchronous iterator’s aiterator.__anext__() method will return an awaitable which when awaited will execute until it provides a value using the yield expression. When the function executes an empty return statement or falls off the end, a StopAsyncIteration exception is raised and the asynchronous iterator will have reached the end of the set of values to be yielded.

# Built-in functions
# A built-in function object is a wrapper around a C function. Examples of built-in functions are len() and math.sin() (math is a standard built-in module). The number and type of the arguments are determined by the C function. Special read-only attributes: __doc__ is the function’s documentation string, or None if unavailable; __name__ is the function’s name; __self__ is set to None (but see the next item); __module__ is the name of the module the function was defined in or None if unavailable.

# Built-in methods
# This is really a different disguise of a built-in function, this time containing an object passed to the C function as an implicit extra argument. An example of a built-in method is alist.append(), assuming alist is a list object. In this case, the special read-only attribute __self__ is set to the object denoted by alist.

# Classes
# Classes are callable. These objects normally act as factories for new instances of themselves, but variations are possible for class types that override __new__(). The arguments of the call are passed to __new__() and, in the typical case, to __init__() to initialize the new instance.

# Class Instances
# Instances of arbitrary classes can be made callable by defining a __call__() method in their class.

# If a class sets __iter__() to None, calling iter() on its instances will raise a TypeError (without falling back to __getitem__()).

# 3.3.1. Basic customization

class Customized:

  a = NONSOURCE
  b = NONSOURCE

  def __new__(cls):
    cls.a = SOURCE
    return super().__new__(cls)

  def __init__(self):
    self.b = SOURCE

# testing __new__ and __init__
customized = Customized()
SINK(Customized.a)  #$ MISSING:flow="SOURCE, l:-8 -> customized.a"
SINK_F(Customized.b)
SINK(customized.a)  #$ MISSING:flow="SOURCE, l:-10 -> customized.a"
SINK(customized.b)  #$ flow="SOURCE, l:-7 -> customized.b"
