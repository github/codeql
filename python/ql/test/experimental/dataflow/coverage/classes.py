# User-defined methods, both instance methods and class methods, can be called in many non-standard ways
# i.e. differently from simply `c.f()` or `C.f()`. For example, a user-defined `__await__` method on a
# class `C` will be called by the syntactic construct `await c` when `c` is an instance of `C`.
#
# These tests should cover all the class calls that we hope to support.
# It is based on https://docs.python.org/3/reference/datamodel.html, and headings refer there.
#
# All functions starting with "test_" should run and print `"OK"`.
# This can be checked by running validTest.py.

def OK() # Call not found:
  print("OK")

# object.__new__(cls[, ...])
class With_new:

  def __new__(cls):
    OK() # Call not found
    return super().__new__(cls)

def test_new():
  with_new = With_new()

# object.__init__(self[, ...])
class With_init:

  def __init__(self):
    OK() # Call not found

def test_init():
  with_init = With_init()

# object.__del__(self)
class With_del:

  def __del__(self):
    OK() # Call not found

def test_del():
  with_del = With_del()
  del with_del

# object.__repr__(self)
class With_repr:

  def __repr__(self):
    OK() # Call not found
    return "With_repr()"

def test_repr():
  with_repr = With_repr()
  repr(with_repr)

# object.__str__(self)
class With_str:

  def __str__(self):
    OK() # Call not found
    return "Awesome"

def test_str():
  with_str = With_str()
  str(with_str)

# object.__bytes__(self)
class With_bytes:

  def __bytes__(self):
    OK() # Call not found
    return b"Awesome"

def test_bytes():
  with_bytes = With_bytes()
  bytes(with_bytes)

# object.__format__(self, format_spec)
class With_format:

  def __format__(self, format_spec):
    OK() # Call not found
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
    OK() # Call not found
    return ""

def test_lt():
  with_lt = With_lt()
  with_lt < with_lt

# object.__le__(self, other)
class With_le:

  def __le__(self, other):
    OK() # Call not found
    return ""

def test_le():
  with_le = With_le()
  with_le <= with_le

# object.__eq__(self, other)
class With_eq:

  def __eq__(self, other):
    OK() # Call not found
    return ""

def test_eq():
  with_eq = With_eq()
  with_eq == with_eq

# object.__ne__(self, other)
class With_ne:

  def __ne__(self, other):
    OK() # Call not found
    return ""

def test_ne():
  with_ne = With_ne()
  with_ne != with_ne

# object.__gt__(self, other)
class With_gt:

  def __gt__(self, other):
    OK() # Call not found
    return ""

def test_gt():
  with_gt = With_gt()
  with_gt > with_gt

# object.__ge__(self, other)
class With_ge:

  def __ge__(self, other):
    OK() # Call not found
    return ""

def test_ge():
  with_ge = With_ge()
  with_ge >= with_ge

# object.__hash__(self)
class With_hash:

  def __hash__(self):
    OK() # Call not found
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
    OK() # Call not found
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
    OK() # Call not found
    return ""

def test_getattr():
  with_getattr = With_getattr()
  with_getattr.foo

# object.__getattribute__(self, name)
class With_getattribute:

  def __getattribute__(self, name):
    OK() # Call not found
    return ""

def test_getattribute():
  with_getattribute = With_getattribute()
  with_getattribute.foo

# object.__setattr__(self, name, value)
class With_setattr:

  def __setattr__(self, name, value):
    OK() # Call not found

def test_setattr():
  with_setattr = With_setattr()
  with_setattr.foo = ""

# object.__delattr__(self, name)
class With_delattr:

  def __delattr__(self, name):
    OK() # Call not found

def test_delattr():
  with_delattr = With_delattr()
  del with_delattr.foo

# object.__dir__(self)
class With_dir:

  def __dir__(self):
    OK() # Call not found
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
    OK() # Call not found
    return ""

def test_get():
  with_get = With_get()
  Owner.attr = with_get
  Owner.attr

# object.__set__(self, instance, value)
class With_set:

  def __set__(self, instance, value):
    OK() # Call not found

def test_set():
  with_set = With_set()
  Owner.attr = with_set
  owner = Owner()
  owner.attr = ""

# object.__delete__(self, instance)
class With_delete:

  def __delete__(self, instance):
    OK() # Call not found

def test_delete():
  with_delete = With_delete()
  Owner.attr = with_delete
  owner = Owner()
  del owner.attr

# object.__set_name__(self, owner, name)
class With_set_name:

  def __set_name__(self, owner, name):
    OK() # Call not found

def test_set_name():
  with_set_name = With_set_name()
  type("Owner", (object,), dict(attr=with_set_name))

# 3.3.2.4. __slots__   // We are not testing the  suppression of -weakref_ and _dict_ here
# object.__slots__
# __weakref__
# __dict__

# 3.3.3. Customizing class creation
# classmethod object.__init_subclass__(cls)
class With_init_subclass:

  def __init_subclass__(cls):
    OK() # Call not found

def test_init_subclass():
  type("Subclass", (With_init_subclass,), {})

# 3.3.3.1. Metaclasses
# By default, classes are constructed using type(). The class body is executed in a new namespace and the class name is bound locally to the result of type(name, bases, namespace).

# 3.3.3.2. Resolving MRO entries
# __mro_entries__

# 3.3.3.4. Preparing the class namespace
# metaclass.__prepare__(name, bases, **kwds)
class With_prepare(type):

  def __prepare__(name, bases, **kwds):
    OK() # Call not found
    return kwds


def test_prepare():
  class With_meta(metaclass=With_prepare):
    pass

# 3.3.4. Customizing instance and subclass checks
# class.__instancecheck__(self, instance)
class With_instancecheck:

  def __instancecheck__(self, instance):
    OK() # Call not found
    return True

def test_instancecheck():
  with_instancecheck = With_instancecheck()
  isinstance("", with_instancecheck)

# class.__subclasscheck__(self, subclass)
class With_subclasscheck:

  def __subclasscheck__(self, subclass):
    OK() # Call not found
    return True

def test_subclasscheck():
  with_subclasscheck = With_subclasscheck()
  issubclass(object, with_subclasscheck)


# 3.3.5. Emulating generic types
# classmethod object.__class_getitem__(cls, key)
class With_class_getitem:

  def __class_getitem__(cls, key):
    OK() # Call not found
    return object

def test_class_getitem():
  with_class_getitem = With_class_getitem[int]()


# 3.3.6. Emulating callable objects
# object.__call__(self[, args...])
class With_call:

  def __call__(self):
    OK() # Call not found

def test_call():
  with_call = With_call()
  with_call()

# 3.3.7. Emulating container types
# object.__len__(self)
class With_len:

  def __len__(self):
    OK() # Call not found
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
    OK() # Call not found
    return 0

def test_length_hint():
  import operator
  with_length_hint = With_length_hint()
  operator.length_hint(with_length_hint)

# object.__getitem__(self, key)
class With_getitem:

  def __getitem__(self, key):
    OK() # Call not found
    return ""

def test_getitem():
  with_getitem = With_getitem()
  with_getitem[0]

# object.__setitem__(self, key, value)
class With_setitem:

  def __setitem__(self, key, value):
    OK() # Call not found

def test_setitem():
  with_setitem = With_setitem()
  with_setitem[0] = ""

# object.__delitem__(self, key)
class With_delitem:

  def __delitem__(self, key):
    OK() # Call not found

def test_delitem():
  with_delitem = With_delitem()
  del with_delitem[0]

# object.__missing__(self, key)
class With_missing(dict):

  def __missing__(self, key):
    OK() # Call not found
    return ""

def test_missing():
  with_missing = With_missing()
  with_missing[""]

# object.__iter__(self)
class With_iter:

  def __iter__(self):
    OK() # Call not found
    return [].__iter__()

def test_iter():
  with_iter = With_iter()
  [x for x in with_iter]

# object.__reversed__(self)
class With_reversed:

  def __reversed__(self):
    OK() # Call not found
    return [].__iter__

def test_reversed():
  with_reversed = With_reversed()
  reversed(with_reversed)

# object.__contains__(self, item)
class With_contains:

  def __contains__(self, item):
    OK() # Call not found
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
    OK() # Call not found
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
  pow(with_pow, with_pow) # Call not found

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
    OK() # Call not found
    return self

def test_radd():
  with_radd = With_radd()
  "" + with_radd

# object.__rsub__(self, other)
class With_rsub:

  def __rsub__(self, other):
    OK() # Call not found
    return self

def test_rsub():
  with_rsub = With_rsub()
  "" - with_rsub

# object.__rmul__(self, other)
class With_rmul:

  def __rmul__(self, other):
    OK() # Call not found
    return self

def test_rmul():
  with_rmul = With_rmul()
  "" * with_rmul

# object.__rmatmul__(self, other)
class With_rmatmul:

  def __rmatmul__(self, other):
    OK() # Call not found
    return self

def test_rmatmul():
  with_rmatmul = With_rmatmul()
  "" @ with_rmatmul

# object.__rtruediv__(self, other)
class With_rtruediv:

  def __rtruediv__(self, other):
    OK() # Call not found
    return self

def test_rtruediv():
  with_rtruediv = With_rtruediv()
  "" / with_rtruediv

# object.__rfloordiv__(self, other)
class With_rfloordiv:

  def __rfloordiv__(self, other):
    OK() # Call not found
    return self

def test_rfloordiv():
  with_rfloordiv = With_rfloordiv()
  "" // with_rfloordiv

# object.__rmod__(self, other)
class With_rmod:

  def __rmod__(self, other):
    OK() # Call not found
    return self

def test_rmod():
  with_rmod = With_rmod()
  {} % with_rmod

# object.__rdivmod__(self, other)
class With_rdivmod:

  def __rdivmod__(self, other):
    OK() # Call not found
    return self

def test_rdivmod():
  with_rdivmod = With_rdivmod()
  divmod("", with_rdivmod)

# object.__rpow__(self, other[, modulo])
class With_rpow:

  def __rpow__(self, other):
    OK() # Call not found
    return self

def test_rpow():
  with_rpow = With_rpow()
  pow("", with_rpow)

def test_rpow_op():
  with_rpow = With_rpow()
  "" ** with_rpow

# object.__rlshift__(self, other)
class With_rlshift:

  def __rlshift__(self, other):
    OK() # Call not found
    return self

def test_rlshift():
  with_rlshift = With_rlshift()
  "" << with_rlshift

# object.__rrshift__(self, other)
class With_rrshift:

  def __rrshift__(self, other):
    OK() # Call not found
    return self

def test_rrshift():
  with_rrshift = With_rrshift()
  "" >> with_rrshift

# object.__rand__(self, other)
class With_rand:

  def __rand__(self, other):
    OK() # Call not found
    return self

def test_rand():
  with_rand = With_rand()
  "" & with_rand

# object.__rxor__(self, other)
class With_rxor:

  def __rxor__(self, other):
    OK() # Call not found
    return self

def test_rxor():
  with_rxor = With_rxor()
  "" ^ with_rxor

# object.__ror__(self, other)
class With_ror:

  def __ror__(self, other):
    OK() # Call not found
    return self

def test_ror():
  with_ror = With_ror()
  "" | with_ror

# object.__iadd__(self, other)
class With_iadd:

  def __iadd__(self, other):
    OK() # Call not found
    return self

def test_iadd():
  with_iadd = With_iadd()
  with_iadd += with_iadd

# object.__isub__(self, other)
class With_isub:

  def __isub__(self, other):
    OK() # Call not found
    return self

def test_isub():
  with_isub = With_isub()
  with_isub -= with_isub

# object.__imul__(self, other)
class With_imul:

  def __imul__(self, other):
    OK() # Call not found
    return self

def test_imul():
  with_imul = With_imul()
  with_imul *= with_imul

# object.__imatmul__(self, other)
class With_imatmul:

  def __imatmul__(self, other):
    OK() # Call not found
    return self

def test_imatmul():
  with_imatmul = With_imatmul()
  with_imatmul @= with_imatmul

# object.__itruediv__(self, other)
class With_itruediv:

  def __itruediv__(self, other):
    OK() # Call not found
    return self

def test_itruediv():
  with_itruediv = With_itruediv()
  with_itruediv /= with_itruediv

# object.__ifloordiv__(self, other)
class With_ifloordiv:

  def __ifloordiv__(self, other):
    OK() # Call not found
    return self

def test_ifloordiv():
  with_ifloordiv = With_ifloordiv()
  with_ifloordiv //= with_ifloordiv

# object.__imod__(self, other)
class With_imod:

  def __imod__(self, other):
    OK() # Call not found
    return self

def test_imod():
  with_imod = With_imod()
  with_imod %= with_imod

# object.__ipow__(self, other[, modulo])
class With_ipow:

  def __ipow__(self, other):
    OK() # Call not found
    return self

def test_ipow():
  with_ipow = With_ipow()
  with_ipow **= with_ipow

# object.__ilshift__(self, other)
class With_ilshift:

  def __ilshift__(self, other):
    OK() # Call not found
    return self

def test_ilshift():
  with_ilshift = With_ilshift()
  with_ilshift <<= with_ilshift

# object.__irshift__(self, other)
class With_irshift:

  def __irshift__(self, other):
    OK() # Call not found
    return self

def test_irshift():
  with_irshift = With_irshift()
  with_irshift >>= with_irshift

# object.__iand__(self, other)
class With_iand:

  def __iand__(self, other):
    OK() # Call not found
    return self

def test_iand():
  with_iand = With_iand()
  with_iand &= with_iand

# object.__ixor__(self, other)
class With_ixor:

  def __ixor__(self, other):
    OK() # Call not found
    return self

def test_ixor():
  with_ixor = With_ixor()
  with_ixor ^= with_ixor

# object.__ior__(self, other)
class With_ior:

  def __ior__(self, other):
    OK() # Call not found
    return self

def test_ior():
  with_ior = With_ior()
  with_ior |= with_ior

# object.__neg__(self)
class With_neg:

  def __neg__(self):
    OK() # Call not found
    return self

def test_neg():
  with_neg = With_neg()
  -with_neg

# object.__pos__(self)
class With_pos:

  def __pos__(self):
    OK() # Call not found
    return self

def test_pos():
  with_pos = With_pos()
  +with_pos

# object.__abs__(self)
class With_abs:

  def __abs__(self):
    OK() # Call not found
    return self

def test_abs():
  with_abs = With_abs()
  abs(with_abs)

# object.__invert__(self)
class With_invert:

  def __invert__(self):
    OK() # Call not found
    return self

def test_invert():
  with_invert = With_invert()
  ~with_invert

# object.__complex__(self)
class With_complex:

  def __complex__(self):
    OK() # Call not found
    return 0j

def test_complex():
  with_complex = With_complex()
  complex(with_complex)

# object.__int__(self)
class With_int:

  def __int__(self):
    OK() # Call not found
    return 0

def test_int():
  with_int = With_int()
  int(with_int)

# object.__float__(self)
class With_float:

  def __float__(self):
    OK() # Call not found
    return 0.0

def test_float():
  with_float = With_float()
  float(with_float)

# object.__index__(self)
class With_index:

  def __index__(self):
    OK() # Call not found
    return 0

def test_index():
  import operator
  with_index = With_index()
  operator.index(with_index)

def test_index_slicing():
  with_index = With_index()
  [0][with_index:1]

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
    OK() # Call not found
    return 0

def test_round():
  with_round = With_round()
  round(with_round)

# object.__trunc__(self)
class With_trunc:

  def __trunc__(self):
    OK() # Call not found
    return 0

def test_trunc():
  with_trunc = With_trunc()
  import math
  math.trunc(with_trunc)

# object.__floor__(self)
class With_floor:

  def __floor__(self):
    OK() # Call not found
    return 0

def test_floor():
  with_floor = With_floor()
  import math
  math.floor(with_floor)

# object.__ceil__(self)
class With_ceil:

  def __ceil__(self):
    OK() # Call not found
    return 0

def test_ceil():
  with_ceil = With_ceil()
  import math
  math.ceil(with_ceil)


# 3.3.9. With Statement Context Managers
# object.__enter__(self)
class With_enter:

  def __enter__(self):
    OK() # Call not found
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
    OK() # Call not found
    return

def test_exit():
  with With_exit():
    pass

# 3.4.1. Awaitable Objects
import asyncio

# object.__await__(self)
class With_await:

  def __await__(self):
    OK() # Call not found
    return (yield from asyncio.coroutine(lambda: "")())

async def atest_await():
  with_await = With_await()
  await(with_await)


# # 3.4.2. Coroutine Objects   // These should be handled as normal function calls
# # coroutine.send(value)
# # coroutine.throw(type[, value[, traceback]])
# # coroutine.close()

# 3.4.3. Asynchronous Iterators
# object.__aiter__(self)
class With_aiter:

  def __aiter__(self):
    OK() # Call not found
    return self

  async def __anext__(self):
    raise StopAsyncIteration

async def atest_aiter():
  with_aiter = With_aiter()
  async for x in with_aiter:
    pass

# object.__anext__(self)
class With_anext:

  def __aiter__(self):
    return self

  async def __anext__(self):
    OK() # Call not found
    raise StopAsyncIteration

async def atest_anext():
  with_anext = With_anext()
  async for x in with_anext:
    pass


# 3.4.4. Asynchronous Context Managers
# object.__aenter__(self)
class With_aenter:

  async def __aenter__(self):
    OK() # Call not found

  async def __aexit__(self, exc_type, exc_value, traceback):
    pass

async def atest_aenter():
  with_aenter = With_aenter()
  async with with_aenter:
    pass

# object.__aexit__(self, exc_type, exc_value, traceback)
class With_aexit:

  async def __aenter__(self):
    pass

  async def __aexit__(self, exc_type, exc_value, traceback):
    OK() # Call not found

async def atest_aexit():
  with_aexit = With_aexit()
  async with with_aexit:
    pass
