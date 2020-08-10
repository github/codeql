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
#
# All functions starting with "test_" should run and print `"OK"`.
# This can be checked by running validTest.py.

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
# SINK_F(iter.__next__()) # throws StopIteration, FP

oiter = c.gen(SOURCE, 1)
SINK(oiter.__next__())
# SINK_F(oiter.__next__()) # throws StopIteration, FP

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

# testing __new__ and __init__
customized = Customized()
SINK(Customized.a)
SINK_F(Customized.b)
SINK(customized.a)
SINK(customized.b)

def OK():
  print("OK")

# object.__new__(cls[, ...])
class With_new:

  def __new__(cls):
    OK()
    return super().__new__(cls)

def test_new():
  with_new = With_new()

# object.__init__(self[, ...])
class With_init:

  def __init__(self):
    OK()

def test_init():
  with_init = With_init()

# object.__del__(self)
class With_del:

  def __del__(self):
    OK()

def test_del():
  with_del = With_del()
  del with_del

# object.__repr__(self)
class With_repr:

  def __repr__(self):
    OK()
    return "With_repr()"

def test_repr():
  with_repr = With_repr()
  repr(with_repr)

# object.__str__(self)
class With_str:

  def __str__(self):
    OK()
    return "Awesome"

def test_str():
  with_str = With_str()
  str(with_str)

# object.__bytes__(self)
class With_bytes:

  def __bytes__(self):
    OK()
    return b"Awesome"

def test_bytes():
  with_bytes = With_bytes()
  bytes(with_bytes)

# object.__format__(self, format_spec)
class With_format:

  def __format__(self, format_spec):
    OK()
    return "Awesome"

def test_format():
  with_format = With_format()
  format(with_format)

def test_format_str():
  with_format = With_format()
  "{0}".format(with_format)

def test_format_fstr():
  with_format = With_format()
  f"{with_format}"

# object.__lt__(self, other)
class With_lt:

  def __lt__(self, other):
    OK()
    return ""

def test_lt():
  with_lt = With_lt()
  with_lt < with_lt

# object.__le__(self, other)
class With_le:

  def __le__(self, other):
    OK()
    return ""

def test_le():
  with_le = With_le()
  with_le <= with_le

# object.__eq__(self, other)
class With_eq:

  def __eq__(self, other):
    OK()
    return ""

def test_eq():
  with_eq = With_eq()
  with_eq == with_eq

# object.__ne__(self, other)
class With_ne:

  def __ne__(self, other):
    OK()
    return ""

def test_ne():
  with_ne = With_ne()
  with_ne != with_ne

# object.__gt__(self, other)
class With_gt:

  def __gt__(self, other):
    OK()
    return ""

def test_gt():
  with_gt = With_gt()
  with_gt > with_gt

# object.__ge__(self, other)
class With_ge:

  def __ge__(self, other):
    OK()
    return ""

def test_ge():
  with_ge = With_ge()
  with_ge >= with_ge

# object.__hash__(self)
class With_hash:

  def __hash__(self):
    OK()
    return 0

def test_hash():
  with_hash = With_hash()
  hash(with_hash)

def test_hash_set():
  with_hash = With_hash()
  len(set([with_hash]))

def test_hash_frozenset():
  with_hash = With_hash()
  len(frozenset([with_hash]))

def test_hash_dict():
  with_hash = With_hash()
  len(dict({with_hash: 0}))

# object.__bool__(self)
class With_bool:

  def __bool__(self):
    OK()
    return True

def test_bool():
  with_bool = With_bool()
  bool(with_bool)

def test_bool_if():
  with_bool = With_bool()
  if with_bool:
    pass

# 3.3.2. Customizing attribute access
# object.__getattr__(self, name)
class With_getattr:

  def __getattr__(self, name):
    OK()
    return ""

def test_getattr():
  with_getattr = With_getattr()
  with_getattr.foo

# object.__getattribute__(self, name)
class With_getattribute:

  def __getattribute__(self, name):
    OK()
    return ""

def test_getattribute():
  with_getattribute = With_getattribute()
  with_getattribute.foo

# object.__setattr__(self, name, value)
class With_setattr:

  def __setattr__(self, name, value):
    OK()

def test_setattr():
  with_setattr = With_setattr()
  with_setattr.foo = ""

# object.__delattr__(self, name)
class With_delattr:

  def __delattr__(self, name):
    OK()

def test_delattr():
  with_delattr = With_delattr()
  del with_delattr.foo

# object.__dir__(self)
class With_dir:

  def __dir__(self):
    OK()
    return []

def test_dir():
  with_dir = With_dir()
  dir(with_dir)


# 3.3.2.2. Implementing Descriptors
class Owner:
  pass

# object.__get__(self, instance, owner=None)
class With_get:

  def __get__(self, instance, owner=None):
    OK()
    return ""

def test_get():
  with_get = With_get()
  Owner.attr = with_get
  Owner.attr

# object.__set__(self, instance, value)
class With_set:

  def __set__(self, instance, value):
    OK()

def test_set():
  with_set = With_set()
  Owner.attr = with_set
  owner = Owner()
  owner.attr = ""

# object.__delete__(self, instance)
class With_delete:

  def __delete__(self, instance):
    OK()

def test_delete():
  with_delete = With_delete()
  Owner.attr = with_delete
  owner = Owner()
  del owner.attr

# object.__set_name__(self, owner, name)
class With_set_name:

  def __set_name__(self, owner, name):
    OK()

def test_set_name():
  with_set_name = With_set_name()
  type("Owner", (object,), dict(attr=with_set_name))

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
class With_call:

  def __call__(self):
    OK()

def test_call():
  with_call = With_call()
  with_call()

# 3.3.7. Emulating container types
# object.__len__(self)
class With_len:

  def __len__(self):
    OK()
    return 0

def test_len():
  with_len = With_len()
  len(with_len)

def test_len_bool():
  with_len = With_len()
  bool(with_len)

def test_len_if():
  with_len = With_len()
  if with_len:
    pass

# object.__length_hint__(self)
class With_length_hint:

  def __length_hint__(self):
    OK()
    return 0

def test_length_hint():
  import operator
  with_length_hint = With_length_hint()
  operator.length_hint(with_length_hint)

# object.__getitem__(self, key)
class With_getitem:

  def __getitem__(self, key):
    OK()
    return ""

def test_getitem():
  with_getitem = With_getitem()
  with_getitem[0]

# object.__setitem__(self, key, value)
class With_setitem:

  def __setitem__(self, key, value):
    OK()

def test_setitem():
  with_setitem = With_setitem()
  with_setitem[0] = ""

# object.__delitem__(self, key)
class With_delitem:

  def __delitem__(self, key):
    OK()

def test_delitem():
  with_delitem = With_delitem()
  del with_delitem[0]

# object.__missing__(self, key)
class With_missing(dict):

  def __missing__(self, key):
    OK()
    return ""

def test_missing():
  with_missing = With_missing()
  with_missing[""]

# object.__iter__(self)
class With_iter:

  def __iter__(self):
    OK()
    return [].__iter__()

def test_iter():
  with_iter = With_iter()
  [x for x in with_iter]

# object.__reversed__(self)
class With_reversed:

  def __reversed__(self):
    OK()
    return [].__iter__

def test_reversed():
  with_reversed = With_reversed()
  reversed(with_reversed)

# object.__contains__(self, item)
class With_contains:

  def __contains__(self, item):
    OK()
    return True

def test_contains():
  with_contains = With_contains()
  0 in with_contains


# 3.3.8. Emulating numeric types
# object.__add__(self, other)
class With_add:

  def __add__(self, other):
    OK()
    return self

def test_add():
  with_add = With_add()
  with_add + with_add

# object.__sub__(self, other)
class With_sub:

  def __sub__(self, other):
    OK()
    return self

def test_sub():
  with_sub = With_sub()
  with_sub - with_sub

# object.__mul__(self, other)
class With_mul:

  def __mul__(self, other):
    OK()
    return self

def test_mul():
  with_mul = With_mul()
  with_mul * with_mul

# object.__matmul__(self, other)
class With_matmul:

  def __matmul__(self, other):
    OK()
    return self

def test_matmul():
  with_matmul = With_matmul()
  with_matmul @ with_matmul

# object.__truediv__(self, other)
class With_truediv:

  def __truediv__(self, other):
    OK()
    return self

def test_truediv():
  with_truediv = With_truediv()
  with_truediv / with_truediv

# object.__floordiv__(self, other)
class With_floordiv:

  def __floordiv__(self, other):
    OK()
    return self

def test_floordiv():
  with_floordiv = With_floordiv()
  with_floordiv // with_floordiv

# object.__mod__(self, other)
class With_mod:

  def __mod__(self, other):
    OK()
    return self

def test_mod():
  with_mod = With_mod()
  with_mod % with_mod

# object.__divmod__(self, other)
class With_divmod:

  def __divmod__(self, other):
    OK()
    return self

def test_divmod():
  with_divmod = With_divmod()
  divmod(with_divmod, with_divmod)

# object.__pow__(self, other[, modulo])
class With_pow:

  def __pow__(self, other):
    OK()
    return self

def test_pow():
  with_pow = With_pow()
  pow(with_pow, with_pow)

def test_pow_op():
  with_pow = With_pow()
  with_pow ** with_pow

# object.__lshift__(self, other)
class With_lshift:

  def __lshift__(self, other):
    OK()
    return self

def test_lshift():
  with_lshift = With_lshift()
  with_lshift << with_lshift

# object.__rshift__(self, other)
class With_rshift:

  def __rshift__(self, other):
    OK()
    return self

def test_rshift():
  with_rshift = With_rshift()
  with_rshift >> with_rshift

# object.__and__(self, other)
class With_and:

  def __and__(self, other):
    OK()
    return self

def test_and():
  with_and = With_and()
  with_and & with_and

# object.__xor__(self, other)
class With_xor:

  def __xor__(self, other):
    OK()
    return self

def test_xor():
  with_xor = With_xor()
  with_xor ^ with_xor

# object.__or__(self, other)
class With_or:

  def __or__(self, other):
    OK()
    return self

def test_or():
  with_or = With_or()
  with_or | with_or

# object.__radd__(self, other)
class With_radd:

  def __radd__(self, other):
    OK()
    return self

def test_radd():
  with_radd = With_radd()
  f"" + with_radd

# object.__rsub__(self, other)
class With_rsub:

  def __rsub__(self, other):
    OK()
    return self

def test_rsub():
  with_rsub = With_rsub()
  f"" - with_rsub

# object.__rmul__(self, other)
class With_rmul:

  def __rmul__(self, other):
    OK()
    return self

def test_rmul():
  with_rmul = With_rmul()
  f"" * with_rmul

# object.__rmatmul__(self, other)
class With_rmatmul:

  def __rmatmul__(self, other):
    OK()
    return self

def test_rmatmul():
  with_rmatmul = With_rmatmul()
  f"" @ with_rmatmul

# object.__rtruediv__(self, other)
class With_rtruediv:

  def __rtruediv__(self, other):
    OK()
    return self

def test_rtruediv():
  with_rtruediv = With_rtruediv()
  f"" / with_rtruediv

# object.__rfloordiv__(self, other)
class With_rfloordiv:

  def __rfloordiv__(self, other):
    OK()
    return self

def test_rfloordiv():
  with_rfloordiv = With_rfloordiv()
  f"" // with_rfloordiv

# object.__rmod__(self, other)
class With_rmod:

  def __rmod__(self, other):
    OK()
    return self

def test_rmod():
  with_rmod = With_rmod()
  {} % with_rmod

# object.__rdivmod__(self, other)
class With_rdivmod:

  def __rdivmod__(self, other):
    OK()
    return self

def test_rdivmod():
  with_rdivmod = With_rdivmod()
  divmod(f"", with_rdivmod)

# object.__rpow__(self, other[, modulo])
class With_rpow:

  def __rpow__(self, other):
    OK()
    return self

def test_rpow():
  with_rpow = With_rpow()
  pow(f"", with_rpow)

def test_rpow_op():
  with_rpow = With_rpow()
  f"" ** with_rpow

# object.__rlshift__(self, other)
class With_rlshift:

  def __rlshift__(self, other):
    OK()
    return self

def ftest_rlshift(): # TypeError: unsupported operand type(s) for >>: 'str' and 'With_rlshift'
  with_rlshift = With_rlshift()
  f"" >> with_rlshift

# object.__rrshift__(self, other)
class With_rrshift:

  def __rrshift__(self, other):
    OK()
    return self

def ftest_rrshift(): # TypeError: unsupported operand type(s) for <<: 'str' and 'With_rrshift'
  with_rrshift = With_rrshift()
  f"" << with_rrshift

# object.__rand__(self, other)
class With_rand:

  def __rand__(self, other):
    OK()
    return self

def test_rand():
  with_rand = With_rand()
  f"" & with_rand

# object.__rxor__(self, other)
class With_rxor:

  def __rxor__(self, other):
    OK()
    return self

def test_rxor():
  with_rxor = With_rxor()
  f"" ^ with_rxor

# object.__ror__(self, other)
class With_ror:

  def __ror__(self, other):
    OK()
    return self

def test_ror():
  with_ror = With_ror()
  f"" | with_ror

# object.__iadd__(self, other)
class With_iadd:

  def __iadd__(self, other):
    OK()
    return self

def test_iadd():
  with_iadd = With_iadd()
  with_iadd += with_iadd

# object.__isub__(self, other)
class With_isub:

  def __isub__(self, other):
    OK()
    return self

def test_isub():
  with_isub = With_isub()
  with_isub -= with_isub

# object.__imul__(self, other)
class With_imul:

  def __imul__(self, other):
    OK()
    return self

def test_imul():
  with_imul = With_imul()
  with_imul *= with_imul

# object.__imatmul__(self, other)
class With_imatmul:

  def __imatmul__(self, other):
    OK()
    return self

def test_imatmul():
  with_imatmul = With_imatmul()
  with_imatmul @= with_imatmul

# object.__itruediv__(self, other)
class With_itruediv:

  def __itruediv__(self, other):
    OK()
    return self

def test_itruediv():
  with_itruediv = With_itruediv()
  with_itruediv /= with_itruediv

# object.__ifloordiv__(self, other)
class With_ifloordiv:

  def __ifloordiv__(self, other):
    OK()
    return self

def test_ifloordiv():
  with_ifloordiv = With_ifloordiv()
  with_ifloordiv //= with_ifloordiv

# object.__imod__(self, other)
class With_imod:

  def __imod__(self, other):
    OK()
    return self

def test_imod():
  with_imod = With_imod()
  with_imod %= with_imod

# object.__ipow__(self, other[, modulo])
class With_ipow:

  def __ipow__(self, other):
    OK()
    return self

def test_ipow():
  with_ipow = With_ipow()
  with_ipow **= with_ipow

# object.__ilshift__(self, other)
class With_ilshift:

  def __ilshift__(self, other):
    OK()
    return self

def test_ilshift():
  with_ilshift = With_ilshift()
  with_ilshift <<= with_ilshift

# object.__irshift__(self, other)
class With_irshift:

  def __irshift__(self, other):
    OK()
    return self

def test_irshift():
  with_irshift = With_irshift()
  with_irshift >>= with_irshift

# object.__iand__(self, other)
class With_iand:

  def __iand__(self, other):
    OK()
    return self

def test_iand():
  with_iand = With_iand()
  with_iand &= with_iand

# object.__ixor__(self, other)
class With_ixor:

  def __ixor__(self, other):
    OK()
    return self

def test_ixor():
  with_ixor = With_ixor()
  with_ixor ^= with_ixor

# object.__ior__(self, other)
class With_ior:

  def __ior__(self, other):
    OK()
    return self

def test_ior():
  with_ior = With_ior()
  with_ior |= with_ior

# object.__neg__(self)
class With_neg:

  def __neg__(self):
    OK()
    return self

def test_neg():
  with_neg = With_neg()
  -with_neg

# object.__pos__(self)
class With_pos:

  def __pos__(self):
    OK()
    return self

def test_pos():
  with_pos = With_pos()
  +with_pos

# object.__abs__(self)
class With_abs:

  def __abs__(self):
    OK()
    return self

def test_abs():
  with_abs = With_abs()
  abs(with_abs)

# object.__invert__(self)
class With_invert:

  def __invert__(self):
    OK()
    return self

def test_invert():
  with_invert = With_invert()
  ~with_invert

# object.__complex__(self)
class With_complex:

  def __complex__(self):
    OK()
    return 0j

def test_complex():
  with_complex = With_complex()
  complex(with_complex)

# object.__int__(self)
class With_int:

  def __int__(self):
    OK()
    return 0

def test_int():
  with_int = With_int()
  int(with_int)

# object.__float__(self)
class With_float:

  def __float__(self):
    OK()
    return 0.0

def test_float():
  with_float = With_float()
  float(with_float)

# object.__index__(self)
class With_index:

  def __index__(self):
    OK()
    return 0

def test_index():
  import operator
  with_index = With_index()
  operator.index(with_index)

# make With_index subscriptable to test slicing

def test_index_bin():
  with_index = With_index()
  bin(with_index)

def test_index_hex():
  with_index = With_index()
  hex(with_index)

def test_index_oct():
  with_index = With_index()
  oct(with_index)

def test_index_int():
  with_index = With_index()
  int(with_index)

def test_index_float():
  with_index = With_index()
  float(with_index)

def test_index_complex():
  with_index = With_index()
  complex(with_index)

# object.__round__(self[, ndigits])
class With_round:

  def __round__(self):
    OK()
    return 0

def test_round():
  with_round = With_round()
  round(with_round)

# object.__trunc__(self)
class With_trunc:

  def __trunc__(self):
    OK()
    return 0

def test_trunc():
  with_trunc = With_trunc()
  import math
  math.trunc(with_trunc) # edit to effect call

# object.__floor__(self)
class With_floor:

  def __floor__(self):
    OK()
    return 0

def test_floor():
  with_floor = With_floor()
  import math
  math.floor(with_floor) # edit to effect call

# object.__ceil__(self)
class With_ceil:

  def __ceil__(self):
    OK()
    return 0

def test_ceil():
  with_ceil = With_ceil()
  import math
  math.ceil(with_ceil) # edit to effect call


# 3.3.9. With Statement Context Managers
# object.__enter__(self)
class With_enter:

  def __enter__(self):
    OK()
    return

  def __exit__(self, exc_type, exc_value, traceback):
    return

def test_enter():
  with With_enter():
    pass

# object.__exit__(self, exc_type, exc_value, traceback)
class With_exit:

  def __enter__(self):
    return

  def __exit__(self, exc_type, exc_value, traceback):
    OK()
    return

def test_exit():
  with With_exit():
    pass

# 3.4.1. Awaitable Objects
# object.__await__(self)
class With_await:

  def __await__(self):
    OK()
    return (yield from asyncio.coroutine(lambda: "")())

async def atest_await():
  with_await = With_await()
  await(with_await)


# # 3.4.2. Coroutine Objects
# # coroutine.send(value)
# # coroutine.throw(type[, value[, traceback]])
# # coroutine.close()

# # 3.4.3. Asynchronous Iterators
# # object.__aiter__(self)
# class With_aiter:

#   def __aiter__(self):
#     OK()
#     return "" # edit to match type

# def test_aiter():
#   with_aiter = With_aiter()
#   aiter(with_aiter) # edit to effect call

# # object.__anext__(self)
# class With_anext:

#   def __anext__(self):
#     OK()
#     return "" # edit to match type

# def test_anext():
#   with_anext = With_anext()
#   anext(with_anext) # edit to effect call


# # 3.4.4. Asynchronous Context Managers
# # object.__aenter__(self)
# class With_aenter:

#   def __aenter__(self):
#     OK()
#     return "" # edit to match type

# def test_aenter():
#   with_aenter = With_aenter()
#   aenter(with_aenter) # edit to effect call

# # object.__aexit__(self, exc_type, exc_value, traceback)
# class With_aexit:

#   def __aexit__(self, exc_type, exc_value, traceback):
#     OK()
#     return "" # edit to match type

# def test_aexit():
#   with_aexit = With_aexit()
#   aexit(with_aexit) # edit to effect call
