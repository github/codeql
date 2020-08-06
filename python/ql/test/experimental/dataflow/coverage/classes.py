# User-defined methods, both instance methods and class methods, can be called in many non-standard ways
# i.e. differently from simply `c.f()` or `C.f()`. For example, a user-defined `__await__` function on a
# class `C` will be called by the syntactic construct `await c` when `c` is an instance of `C`.
#
# These tests should cover all the class calls that we hope to support.
# It is based on https://docs.python.org/3/reference/datamodel.html, and headings refer there.
#
# Intended sources should be the variable `SOURCE` and intended sinks should be
# arguments to the function `SINK` (see python/ql/test/experimental/dataflow/testConfig.qll).
#
# Functions whose name ends with "_with_local_flow" will also be tested for local flow.


# These are included so that we can easily evaluate the test code.
NONSOURCE = "not a source"
SOURCE = "source"
def SINK(x):
    print(x)

def SINK_F(x):
    print("Unexpected flow: ", x)

# Callable types
# These are the types to which the function call operation (see section Calls) can be applied:

# User-defined functions
# A user-defined function object is created by a function definition (see section Function definitions). It should be called with an argument list containing the same number of items as the function's formal parameter list.
def f(a, b):
  return a

SINK(f(SOURCE, 3))

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
SINK(c.method(SOURCE, C))
SINK(C.method(c, SOURCE, C))
SINK(func_obj(c, SOURCE, C))


# When an instance method object is created by retrieving a class method object from a class or instance, its __self__ attribute is the class itself, and its __func__ attribute is the function object underlying the class method.
c_func_obj = C.classmethod.__func__

# When an instance method object is derived from a class method object, the “class instance” stored in __self__ will actually be the class itself, so that calling either x.f(1) or C.f(1) is equivalent to calling f(C,1) where f is the underlying function.
SINK(c.classmethod(SOURCE))
SINK(C.classmethod(SOURCE))
SINK(c_func_obj(C, SOURCE))

# Generator functions
# A function or method which uses the yield statement (see section The yield statement) is called a generator function. Such a function, when called, always returns an iterator object which can be used to execute the body of the function: calling the iterator’s iterator.__next__() method will cause the function to execute until it provides a value using the yield statement. When the function executes a return statement or falls off the end, a StopIteration exception is raised and the iterator will have reached the end of the set of values to be returned.
def gen(x, count):
  n = count
  while n > 0:
    yield x
    n -= 1

iter = gen(SOURCE, 1)
SINK(iter.__next__())
SINK_F(iter.__next__()) # throws StopIteration, FP

oiter = c.gen(SOURCE, 1)
SINK(oiter.__next__())
SINK_F(oiter.__next__()) # throws StopIteration, FP

# Coroutine functions
# A function or method which is defined using async def is called a coroutine function. Such a function, when called, returns a coroutine object. It may contain await expressions, as well as async with and async for statements. See also the Coroutine Objects section.
async def coro(x):
  return x

import asyncio
SINK(asyncio.run(coro(SOURCE)))
SINK(asyncio.run(c.coro(SOURCE)))

class A:

  def __await__(self):
    # yield SOURCE  -- see https://groups.google.com/g/dev-python/c/_lrrc-vp9TI?pli=1
    return (yield from asyncio.coroutine(lambda: SOURCE)())

async def agen(x):
  a = A()
  return await a

SINK(asyncio.run(agen(SOURCE)))

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

# object.__new__(cls[, ...])
# object.__init__(self[, ...])
customized = Customized()
SINK(Customized.a)
SINK_F(Customized.b)
SINK(customized.a)
SINK(customized.b)


# object.__del__(self)
# object.__repr__(self)
# object.__str__(self)¶
# object.__bytes__(self)
# object.__format__(self, format_spec)
# object.__lt__(self, other)
# object.__le__(self, other)
# object.__eq__(self, other)
# object.__ne__(self, other)
# object.__gt__(self, other)
# object.__ge__(self, other)
# object.__hash__(self)
# object.__bool__(self)
# len

# 3.3.2. Customizing attribute access
# object.__getattr__(self, name)
# object.__getattribute__(self, name)
# object.__setattr__(self, name, value)
# object.__delattr__(self, name)
# object.__dir__(self)

# 3.3.2.2. Implementing Descriptors
# object.__get__(self, instance, owner=None)
# object.__set__(self, instance, value)
# object.__delete__(self, instance)
# object.__set_name__(self, owner, name)

# 3.3.2.4. __slots__
# object.__slots__
# __weakref__
# __dict__

# 3.3.3. Customizing class creation
# classmethod object.__init_subclass__(cls)

# 3.3.3.1. Metaclasses
# By default, classes are constructed using type(). The class body is executed in a new namespace and the class name is bound locally to the result of type(name, bases, namespace).

# 3.3.3.2. Resolving MRO entries
# __mro_entries__

# 3.3.3.4. Preparing the class namespace
# metaclass.__prepare__(name, bases, **kwds)

# 3.3.4. Customizing instance and subclass checks
# class.__instancecheck__(self, instance)
# class.__subclasscheck__(self, subclass)

# 3.3.5. Emulating generic types
# classmethod object.__class_getitem__(cls, key)

# 3.3.6. Emulating callable objects
# object.__call__(self[, args...])

# 3.3.7. Emulating container types
# object.__len__(self)
# object.__length_hint__(self)
# object.__getitem__(self, key)
# object.__setitem__(self, key, value)
# object.__delitem__(self, key)
# object.__missing__(self, key)
# object.__iter__(self)
# object.__reversed__(self)
# object.__contains__(self, item)

# 3.3.8. Emulating numeric types
# object.__add__(self, other)
# object.__sub__(self, other)
# object.__mul__(self, other)
# object.__matmul__(self, other)
# object.__truediv__(self, other)
# object.__floordiv__(self, other)
# object.__mod__(self, other)
# object.__divmod__(self, other)
# object.__pow__(self, other[, modulo])
# object.__lshift__(self, other)
# object.__rshift__(self, other)
# object.__and__(self, other)
# object.__xor__(self, other)
# object.__or__(self, other)
# object.__radd__(self, other)
# object.__rsub__(self, other)
# object.__rmul__(self, other)
# object.__rmatmul__(self, other)
# object.__rtruediv__(self, other)
# object.__rfloordiv__(self, other)
# object.__rmod__(self, other)
# object.__rdivmod__(self, other)
# object.__rpow__(self, other[, modulo])
# object.__rlshift__(self, other)
# object.__rrshift__(self, other)
# object.__rand__(self, other)
# object.__rxor__(self, other)
# object.__ror__(self, other)
# object.__iadd__(self, other)
# object.__isub__(self, other)
# object.__imul__(self, other)
# object.__imatmul__(self, other)
# object.__itruediv__(self, other)
# object.__ifloordiv__(self, other)
# object.__imod__(self, other)
# object.__ipow__(self, other[, modulo])
# object.__ilshift__(self, other)
# object.__irshift__(self, other)
# object.__iand__(self, other)
# object.__ixor__(self, other)
# object.__ior__(self, other)
# object.__neg__(self)
# object.__pos__(self)
# object.__abs__(self)
# object.__invert__(self)
# object.__complex__(self)
# object.__int__(self)
# object.__float__(self)
# object.__index__(self)
# object.__round__(self[, ndigits])
# object.__trunc__(self)
# object.__floor__(self)
# object.__ceil__(self)

# 3.3.9. With Statement Context Managers
# object.__enter__(self)
# object.__exit__(self, exc_type, exc_value, traceback)

# 3.4.1. Awaitable Objects
# object.__await__(self)

# 3.4.2. Coroutine Objects
# coroutine.send(value)
# coroutine.throw(type[, value[, traceback]])
# coroutine.close()

# 3.4.3. Asynchronous Iterators
# object.__aiter__(self)
# object.__anext__(self)

# 3.4.4. Asynchronous Context Managers
# object.__aenter__(self)
# object.__aexit__(self, exc_type, exc_value, traceback)
