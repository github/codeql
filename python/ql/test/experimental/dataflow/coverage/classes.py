# User-defined methods, both instance methods and class methods, can be called in many non-standard ways
# i.e. differently from simply `c.f()` or `C.f()`. For example, a user-defined `__await__` method on a
# class `C` will be called by the syntactic construct `await c` when `c` is an instance of `C`.
#
# These tests should cover all the class calls that we hope to support.
# It is based on https://docs.python.org/3/reference/datamodel.html, and headings refer there.
#
# All functions starting with "test_" should run and execute `print("OK")` exactly once.
# This can be checked by running validTest.py.

import sys
import os

sys.path.append(os.path.dirname(os.path.dirname((__file__))))
from testlib import *

import asyncio


def SINK1(x):
    pass


def SINK2(x):
    pass


def SINK3(x):
    pass


def SINK4(x):
    pass


def OK():
    print("OK")


# object.__new__(cls[, ...])
class With_new:
    def __new__(cls):
        SINK1(cls)  # Flow not found
        OK()  # Call not found
        return super().__new__(cls)


def test_new():
    with_new = With_new()


# object.__init__(self[, ...])
class With_init:
    def __init__(self):
        SINK1(self)
        OK()


def test_init():
    with_init = With_init()


# object.__del__(self)
class With_del:
    def __del__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found


def test_del():
    with_del = With_del()
    del with_del


# object.__repr__(self)
class With_repr:
    def __repr__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return "With_repr()"


def test_repr():
    with_repr = With_repr()
    repr(with_repr)


# object.__str__(self)
class With_str:
    def __str__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return "Awesome"


def test_str():
    with_str = With_str()
    str(with_str)


# object.__bytes__(self)
class With_bytes:
    def __bytes__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return b"Awesome"


def test_bytes():
    with_bytes = With_bytes()
    bytes(with_bytes)


# object.__format__(self, format_spec)
class With_format:
    def __format__(self, format_spec):
        SINK2(format_spec)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return "Awesome"


def test_format():
    with_format = With_format()
    arg2 = ""
    format(with_format, arg2)


def test_format_str():
    with_format = With_format()
    "{0}".format(with_format)


def test_format_fstr():
    with_format = With_format()
    f"{with_format}"


# object.__lt__(self, other)
class With_lt:
    def __lt__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return ""


def test_lt():
    with_lt = With_lt()
    arg2 = with_lt
    with_lt < arg2


# object.__le__(self, other)
class With_le:
    def __le__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return ""


def test_le():
    with_le = With_le()
    arg2 = with_le
    with_le <= arg2


# object.__eq__(self, other)
class With_eq:
    def __eq__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return ""


def test_eq():
    with_eq = With_eq()
    with_eq == with_eq


# object.__ne__(self, other)
class With_ne:
    def __ne__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return ""


def test_ne():
    with_ne = With_ne()
    with_ne != with_ne


# object.__gt__(self, other)
class With_gt:
    def __gt__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return ""


def test_gt():
    with_gt = With_gt()
    arg2 = with_gt
    with_gt > arg2


# object.__ge__(self, other)
class With_ge:
    def __ge__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return ""


def test_ge():
    with_ge = With_ge()
    arg2 = with_ge
    with_ge >= arg2


# object.__hash__(self)
class With_hash:
    def __hash__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
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
        SINK1(self)  # Flow not found
        OK()  # Call not found
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
        SINK2(name)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return ""


def test_getattr():
    with_getattr = With_getattr()
    with_getattr.arg2


# object.__getattribute__(self, name)
class With_getattribute:
    def __getattribute__(self, name):
        SINK2(name)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return ""


def test_getattribute():
    with_getattribute = With_getattribute()
    with_getattribute.arg2


# object.__setattr__(self, name, value)
class With_setattr:
    def __setattr__(self, name, value):
        SINK3(value)  # Flow not found
        SINK2(name)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found


def test_setattr():
    with_setattr = With_setattr()
    arg3 = ""
    with_setattr.arg2 = arg3


# object.__delattr__(self, name)
class With_delattr:
    def __delattr__(self, name):
        SINK2(name)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found


def test_delattr():
    with_delattr = With_delattr()
    del with_delattr.arg2


# object.__dir__(self)
class With_dir:
    def __dir__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
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
        SINK3(owner)  # Flow not testsed, use class `Owner` as source to test
        SINK2(instance)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return ""


def test_get():
    class arg3:
        pass

    with_get = With_get()
    arg3.attr = with_get
    arg2 = arg3()
    arg2.attr


# object.__set__(self, instance, value)
class With_set:
    def __set__(self, instance, value):
        SINK3(value)  # Flow not found
        SINK2(instance)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found


def test_set():
    with_set = With_set()
    Owner.attr = with_set
    arg2 = Owner()
    arg3 = ""
    arg2.attr = arg3


# object.__delete__(self, instance)
class With_delete:
    def __delete__(self, instance):
        SINK2(instance)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found


def test_delete():
    with_delete = With_delete()
    Owner.attr = with_delete
    arg2 = Owner()
    del arg2.attr


# object.__set_name__(self, owner, name)
class With_set_name:
    def __set_name__(self, owner, name):
        SINK3(name)  # Flow not found
        SINK2(owner)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found


def test_set_name():
    with_set_name = With_set_name()
    type("arg2", (object,), dict(arg3=with_set_name))


# 3.3.2.4. __slots__   // We are not testing the  suppression of -weakref_ and _dict_ here
# object.__slots__
# __weakref__
# __dict__

# 3.3.3. Customizing class creation
# classmethod object.__init_subclass__(cls)
class With_init_subclass:
    def __init_subclass__(cls):
        SINK1(cls)  # Flow not found
        OK()  # Call not found


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
        SINK3(kwds)  # Flow not tested
        SINK2(bases)  # Flow not tested
        SINK1(name)  # Flow not found
        OK()  # Call not found
        return kwds


def test_prepare():
    class arg1(metaclass=With_prepare):
        pass


# 3.3.4. Customizing instance and subclass checks
# class.__instancecheck__(self, instance)
class With_instancecheck:
    def __instancecheck__(self, instance):
        SINK2(instance)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return True


def test_instancecheck():
    with_instancecheck = With_instancecheck()
    arg2 = ""
    isinstance(arg2, with_instancecheck)


# class.__subclasscheck__(self, subclass)
class With_subclasscheck:
    def __subclasscheck__(self, subclass):
        SINK2(subclass)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return True


def test_subclasscheck():
    with_subclasscheck = With_subclasscheck()
    arg2 = object
    issubclass(arg2, with_subclasscheck)


# 3.3.5. Emulating generic types
# classmethod object.__class_getitem__(cls, key)
class With_class_getitem:
    def __class_getitem__(cls, key):
        SINK2(key)  # Flow not found
        SINK1(cls)  # Flow not found
        OK()  # Call not found
        return object


def test_class_getitem():
    arg2 = int
    with_class_getitem = With_class_getitem[arg2]()


# 3.3.6. Emulating callable objects
# object.__call__(self[, args...])
class With_call:
    def __call__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found


def test_call():
    with_call = With_call()
    with_call()


# 3.3.7. Emulating container types
# object.__len__(self)
class With_len:
    def __len__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
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
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return 0


def test_length_hint():
    import operator

    with_length_hint = With_length_hint()
    operator.length_hint(with_length_hint)


# object.__getitem__(self, key)
class With_getitem:
    def __getitem__(self, key):
        SINK2(key)
        SINK1(self)
        OK()
        return ""


def test_getitem():
    with_getitem = With_getitem()
    arg2 = 0
    with_getitem[arg2]


# object.__setitem__(self, key, value)
class With_setitem:
    def __setitem__(self, key, value):
        SINK3(value)
        SINK2(key)
        SINK1(self)
        OK()


def test_setitem():
    with_setitem = With_setitem()
    arg2 = 0
    arg3 = ""
    with_setitem[arg2] = arg3


# object.__delitem__(self, key)
class With_delitem:
    def __delitem__(self, key):
        SINK2(key)
        SINK1(self)
        OK()


def test_delitem():
    with_delitem = With_delitem()
    arg2 = 0
    del with_delitem[arg2]


# object.__missing__(self, key)
class With_missing(dict):
    def __missing__(self, key):
        SINK2(key)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return ""


def test_missing():
    with_missing = With_missing()
    arg2 = 0
    with_missing[arg2]


# object.__iter__(self)
class With_iter:
    def __iter__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return [].__iter__()


def test_iter():
    with_iter = With_iter()
    [x for x in with_iter]


# object.__reversed__(self)
class With_reversed:
    def __reversed__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return [].__iter__


def test_reversed():
    with_reversed = With_reversed()
    reversed(with_reversed)


# object.__contains__(self, item)
class With_contains:
    def __contains__(self, item):
        SINK2(item)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return True


def test_contains():
    with_contains = With_contains()
    arg2 = 0
    arg2 in with_contains


# 3.3.8. Emulating numeric types
# object.__add__(self, other)
class With_add:
    def __add__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_add():
    with_add = With_add()
    arg2 = with_add
    with_add + arg2


# object.__sub__(self, other)
class With_sub:
    def __sub__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_sub():
    with_sub = With_sub()
    arg2 = with_sub
    with_sub - arg2


# object.__mul__(self, other)
class With_mul:
    def __mul__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_mul():
    with_mul = With_mul()
    arg2 = with_mul
    with_mul * arg2


# object.__matmul__(self, other)
class With_matmul:
    def __matmul__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_matmul():
    with_matmul = With_matmul()
    arg2 = with_matmul
    with_matmul @ arg2


# object.__truediv__(self, other)
class With_truediv:
    def __truediv__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_truediv():
    with_truediv = With_truediv()
    arg2 = with_truediv
    with_truediv / arg2


# object.__floordiv__(self, other)
class With_floordiv:
    def __floordiv__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_floordiv():
    with_floordiv = With_floordiv()
    arg2 = with_floordiv
    with_floordiv // arg2


# object.__mod__(self, other)
class With_mod:
    def __mod__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_mod():
    with_mod = With_mod()
    arg2 = with_mod
    with_mod % arg2


# object.__divmod__(self, other)
class With_divmod:
    def __divmod__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_divmod():
    with_divmod = With_divmod()
    arg2 = With_divmod
    divmod(with_divmod, arg2)


# object.__pow__(self, other[, modulo])
class With_pow:
    def __pow__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_pow():
    with_pow = With_pow()
    arg2 = with_pow
    pow(with_pow, arg2)  # Call not found


def test_pow_op():
    with_pow = With_pow()
    arg2 = with_pow
    with_pow ** arg2


# object.__lshift__(self, other)
class With_lshift:
    def __lshift__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_lshift():
    with_lshift = With_lshift()
    arg2 = with_lshift
    with_lshift << arg2


# object.__rshift__(self, other)
class With_rshift:
    def __rshift__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_rshift():
    with_rshift = With_rshift()
    arg2 = with_rshift
    with_rshift >> arg2


# object.__and__(self, other)
class With_and:
    def __and__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_and():
    with_and = With_and()
    arg2 = with_and
    with_and & arg2


# object.__xor__(self, other)
class With_xor:
    def __xor__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_xor():
    with_xor = With_xor()
    arg2 = with_xor
    with_xor ^ arg2


# object.__or__(self, other)
class With_or:
    def __or__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_or():
    with_or = With_or()
    arg2 = with_or
    with_or | arg2


# object.__radd__(self, other)
class With_radd:
    def __radd__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_radd():
    with_radd = With_radd()
    arg2 = ""
    arg2 + with_radd


# object.__rsub__(self, other)
class With_rsub:
    def __rsub__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rsub():
    with_rsub = With_rsub()
    arg2 = ""
    arg2 - with_rsub


# object.__rmul__(self, other)
class With_rmul:
    def __rmul__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rmul():
    with_rmul = With_rmul()
    arg2 = ""
    arg2 * with_rmul


# object.__rmatmul__(self, other)
class With_rmatmul:
    def __rmatmul__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rmatmul():
    with_rmatmul = With_rmatmul()
    arg2 = ""
    arg2 @ with_rmatmul


# object.__rtruediv__(self, other)
class With_rtruediv:
    def __rtruediv__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rtruediv():
    with_rtruediv = With_rtruediv()
    arg2 = ""
    arg2 / with_rtruediv


# object.__rfloordiv__(self, other)
class With_rfloordiv:
    def __rfloordiv__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rfloordiv():
    with_rfloordiv = With_rfloordiv()
    arg2 = ""
    arg2 // with_rfloordiv


# object.__rmod__(self, other)
class With_rmod:
    def __rmod__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rmod():
    with_rmod = With_rmod()
    arg2 = {}
    arg2 % with_rmod


# object.__rdivmod__(self, other)
class With_rdivmod:
    def __rdivmod__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rdivmod():
    with_rdivmod = With_rdivmod()
    arg2 = ""
    divmod(arg2, with_rdivmod)


# object.__rpow__(self, other[, modulo])
class With_rpow:
    def __rpow__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rpow():
    with_rpow = With_rpow()
    arg2 = ""
    pow(arg2, with_rpow)


def test_rpow_op():
    with_rpow = With_rpow()
    arg2 = ""
    arg2 ** with_rpow


# object.__rlshift__(self, other)
class With_rlshift:
    def __rlshift__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rlshift():
    with_rlshift = With_rlshift()
    arg2 = ""
    arg2 << with_rlshift


# object.__rrshift__(self, other)
class With_rrshift:
    def __rrshift__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rrshift():
    with_rrshift = With_rrshift()
    arg2 = ""
    arg2 >> with_rrshift


# object.__rand__(self, other)
class With_rand:
    def __rand__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rand():
    with_rand = With_rand()
    arg2 = ""
    arg2 & with_rand


# object.__rxor__(self, other)
class With_rxor:
    def __rxor__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_rxor():
    with_rxor = With_rxor()
    arg2 = ""
    arg2 ^ with_rxor


# object.__ror__(self, other)
class With_ror:
    def __ror__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_ror():
    with_ror = With_ror()
    arg2 = ""
    arg2 | with_ror


# object.__iadd__(self, other)
class With_iadd:
    def __iadd__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_iadd():
    with_iadd = With_iadd()
    arg2 = with_iadd
    with_iadd += arg2


# object.__isub__(self, other)
class With_isub:
    def __isub__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_isub():
    with_isub = With_isub()
    arg2 = with_isub
    with_isub -= arg2


# object.__imul__(self, other)
class With_imul:
    def __imul__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_imul():
    with_imul = With_imul()
    arg2 = with_imul
    with_imul *= arg2


# object.__imatmul__(self, other)
class With_imatmul:
    def __imatmul__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_imatmul():
    with_imatmul = With_imatmul()
    arg2 = with_imatmul
    with_imatmul @= arg2


# object.__itruediv__(self, other)
class With_itruediv:
    def __itruediv__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_itruediv():
    with_itruediv = With_itruediv()
    arg2 = with_itruediv
    with_itruediv /= arg2


# object.__ifloordiv__(self, other)
class With_ifloordiv:
    def __ifloordiv__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_ifloordiv():
    with_ifloordiv = With_ifloordiv()
    arg2 = with_ifloordiv
    with_ifloordiv //= arg2


# object.__imod__(self, other)
class With_imod:
    def __imod__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_imod():
    with_imod = With_imod()
    arg2 = with_imod
    with_imod %= arg2


# object.__ipow__(self, other[, modulo])
class With_ipow:
    def __ipow__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_ipow():
    with_ipow = With_ipow()
    arg2 = with_ipow
    with_ipow **= arg2


# object.__ilshift__(self, other)
class With_ilshift:
    def __ilshift__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_ilshift():
    with_ilshift = With_ilshift()
    arg2 = with_ilshift
    with_ilshift <<= arg2


# object.__irshift__(self, other)
class With_irshift:
    def __irshift__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_irshift():
    with_irshift = With_irshift()
    arg2 = with_irshift
    with_irshift >>= arg2


# object.__iand__(self, other)
class With_iand:
    def __iand__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_iand():
    with_iand = With_iand()
    arg2 = with_iand
    with_iand &= arg2


# object.__ixor__(self, other)
class With_ixor:
    def __ixor__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_ixor():
    with_ixor = With_ixor()
    arg2 = with_ixor
    with_ixor ^= arg2


# object.__ior__(self, other)
class With_ior:
    def __ior__(self, other):
        SINK2(other)  # Flow not found
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_ior():
    with_ior = With_ior()
    arg2 = with_ior
    with_ior |= arg2


# object.__neg__(self)
class With_neg:
    def __neg__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_neg():
    with_neg = With_neg()
    -with_neg


# object.__pos__(self)
class With_pos:
    def __pos__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_pos():
    with_pos = With_pos()
    +with_pos


# object.__abs__(self)
class With_abs:
    def __abs__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_abs():
    with_abs = With_abs()
    abs(with_abs)


# object.__invert__(self)
class With_invert:
    def __invert__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return self


def test_invert():
    with_invert = With_invert()
    ~with_invert


# object.__complex__(self)
class With_complex:
    def __complex__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return 0j


def test_complex():
    with_complex = With_complex()
    complex(with_complex)


# object.__int__(self)
class With_int:
    def __int__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return 0


def test_int():
    with_int = With_int()
    int(with_int)


# object.__float__(self)
class With_float:
    def __float__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return 0.0


def test_float():
    with_float = With_float()
    float(with_float)


# object.__index__(self)
class With_index:
    def __index__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
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
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return 0


def test_round():
    with_round = With_round()
    round(with_round)


# object.__trunc__(self)
class With_trunc:
    def __trunc__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return 0


def test_trunc():
    with_trunc = With_trunc()
    import math

    math.trunc(with_trunc)


# object.__floor__(self)
class With_floor:
    def __floor__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return 0


def test_floor():
    with_floor = With_floor()
    import math

    math.floor(with_floor)


# object.__ceil__(self)
class With_ceil:
    def __ceil__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return 0


def test_ceil():
    with_ceil = With_ceil()
    import math

    math.ceil(with_ceil)


# 3.3.9. With Statement Context Managers
# object.__enter__(self)
class With_enter:
    def __enter__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
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
        SINK4(traceback)  # Flow not tested
        SINK3(exc_value)  # Flow not tested
        SINK2(exc_type)  # Flow not tested
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return


def test_exit():
    with With_exit():
        pass


# 3.4.1. Awaitable Objects

# object.__await__(self)
class With_await:
    def __await__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
        return (yield from asyncio.coroutine(lambda: "")())


async def atest_await():
    with_await = With_await()
    await (with_await)


# # 3.4.2. Coroutine Objects   // These should be handled as normal function calls
# # coroutine.send(value)
# # coroutine.throw(type[, value[, traceback]])
# # coroutine.close()

# 3.4.3. Asynchronous Iterators
# object.__aiter__(self)
class With_aiter:
    def __aiter__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found
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
        SINK1(self)  # Flow not found
        OK()  # Call not found
        raise StopAsyncIteration


async def atest_anext():
    with_anext = With_anext()
    async for x in with_anext:
        pass


# 3.4.4. Asynchronous Context Managers
# object.__aenter__(self)
class With_aenter:
    async def __aenter__(self):
        SINK1(self)  # Flow not found
        OK()  # Call not found

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
        SINK4(traceback)  # Flow not tested
        SINK3(exc_value)  # Flow not tested
        SINK2(exc_type)  # Flow not tested
        SINK1(self)  # Flow not found
        OK()  # Call not found


async def atest_aexit():
    with_aexit = With_aexit()
    async with with_aexit:
        pass
