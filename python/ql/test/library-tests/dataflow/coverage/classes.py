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
from testlib import expects

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
class With_new:  #$ MISSING: arg1="With_new" func=With_new.__new__
    def __new__(cls):
        SINK1(cls)
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
    with_init = With_init()  #$ MISSING: arg1="with_init" func=With_init.__init__


# object.__del__(self)
class With_del:
    def __del__(self):
        SINK1(self)
        OK()  # Call not found


def test_del():
    with_del = With_del()  #$ MISSING: arg1="with_del" func=With_del.__del__
    del with_del


# object.__repr__(self)
class With_repr:
    def __repr__(self):
        SINK1(self)
        OK()  # Call not found
        return "With_repr()"


def test_repr():
    with_repr = With_repr()  #$ MISSING: arg1="with_repr" func=With_repr.__repr__
    repr(with_repr)


# object.__str__(self)
class With_str:
    def __str__(self):
        SINK1(self)
        OK()  # Call not found
        return "Awesome"


def test_str():
    with_str = With_str()  #$ MISSING: arg1="with_str" func=With_str.__str__
    str(with_str)


# object.__bytes__(self)
class With_bytes:
    def __bytes__(self):
        SINK1(self)
        OK()  # Call not found
        return b"Awesome"


def test_bytes():
    with_bytes = With_bytes()  #$ MISSING: arg1="with_bytes" func=With_bytes.__bytes__
    bytes(with_bytes)


# object.__format__(self, format_spec)
class With_format:
    def __format__(self, format_spec):
        SINK2(format_spec)
        SINK1(self)
        OK()  # Call not found
        return "Awesome"


def test_format():
    with_format = With_format()  #$ MISSING: arg1="with_format" func=With_format.__format__
    arg2 = ""  #$ MISSING: arg2 func=With_format.__format__
    format(with_format, arg2)


def test_format_str():
    with_format = With_format()  #$ MISSING: arg1="with_format" func=With_format.__format__
    "{0}".format(with_format)


def test_format_fstr():
    with_format = With_format()  #$ MISSING: arg1="with_format" func=With_format.__format__
    f"{with_format}"


# object.__lt__(self, other)
class With_lt:
    def __lt__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return ""


def test_lt():
    with_lt = With_lt()  #$ MISSING: arg1="with_lt" func=With_lt.__lt__
    arg2 = with_lt  #$ MISSING: arg2 func=With_lt.__lt__
    with_lt < arg2


# object.__le__(self, other)
class With_le:
    def __le__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return ""


def test_le():
    with_le = With_le()  #$ MISSING: arg1="with_le" func=With_le.__le__
    arg2 = with_le  #$ MISSING: arg2 func=With_le.__le__
    with_le <= arg2


# object.__eq__(self, other)
class With_eq:
    def __eq__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return ""


def test_eq():
    with_eq = With_eq()  #$ MISSING: arg1="with_eq" func=With_eq.__eq__
    with_eq == with_eq  #$ MISSING: arg2="with_eq" func=With_eq.__eq__


# object.__ne__(self, other)
class With_ne:
    def __ne__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return ""


def test_ne():
    with_ne = With_ne()  #$ MISSING: arg1="with_ne" func=With_ne.__ne__
    with_ne != with_ne  #$ MISSING: arg2="with_ne" func=With_ne.__ne__


# object.__gt__(self, other)
class With_gt:
    def __gt__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return ""


def test_gt():
    with_gt = With_gt()  #$ MISSING: arg1="with_gt" func=With_gt.__gt__
    arg2 = with_gt  #$ MISSING: arg2 func=With_gt.__gt__
    with_gt > arg2


# object.__ge__(self, other)
class With_ge:
    def __ge__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return ""


def test_ge():
    with_ge = With_ge()  #$ MISSING: arg1="with_ge" func=With_ge.__ge__
    arg2 = with_ge  #$ MISSING: arg2 func=With_ge.__ge__
    with_ge >= arg2


# object.__hash__(self)
class With_hash:
    def __hash__(self):
        SINK1(self)
        OK()  # Call not found
        return 0


def test_hash():
    with_hash = With_hash()  #$ MISSING: arg1="with_hash" func=With_hash.__hash__
    hash(with_hash)


def test_hash_set():
    with_hash = With_hash()  #$ MISSING: arg1="with_hash" func=With_hash.__hash__
    len(set([with_hash]))


def test_hash_frozenset():
    with_hash = With_hash()  #$ MISSING: arg1="with_hash" func=With_hash.__hash__
    len(frozenset([with_hash]))


def test_hash_dict():
    with_hash = With_hash()  #$ MISSING: arg1="with_hash" func=With_hash.__hash__
    len(dict({with_hash: 0}))


# object.__bool__(self)
class With_bool:
    def __bool__(self):
        SINK1(self)
        OK()  # Call not found
        return True


def test_bool():
    with_bool = With_bool()  #$ MISSING: arg1="with_bool" func=With_bool.__bool__
    bool(with_bool)


def test_bool_if():
    with_bool = With_bool()  #$ MISSING: arg1="with_bool" func=With_bool.__bool__
    if with_bool:
        pass


# 3.3.2. Customizing attribute access
# object.__getattr__(self, name)
class With_getattr:
    def __getattr__(self, name):
        SINK2(name)
        SINK1(self)
        OK()  # Call not found
        return ""


def test_getattr():
    with_getattr = With_getattr()  #$ MISSING: arg1="with_getattr" func=With_getattr.__getattr__
    with_getattr.arg2  #$ MISSING: arg2="with_getattr.arg2" func=With_getattr.__getattr__


# object.__getattribute__(self, name)
class With_getattribute:
    def __getattribute__(self, name):
        SINK2(name)
        SINK1(self)
        OK()  # Call not found
        return ""


def test_getattribute():
    with_getattribute = With_getattribute()  #$ MISSING: arg1="with_getattribute" func=With_getattribute.__getattribute__
    with_getattribute.arg2  #$ MISSING: arg2 func=With_getattribute.__getattribute__


# object.__setattr__(self, name, value)
class With_setattr:
    def __setattr__(self, name, value):
        SINK3(value)
        SINK2(name)
        SINK1(self)
        OK()  # Call not found


def test_setattr():
    with_setattr = With_setattr()  #$ MISSING: arg1="with_setattr" func=With_setattr.__setattr__
    arg3 = ""  #$ MISSING: arg3 func=With_setattr.__setattr__
    with_setattr.arg2 = arg3  #$ MISSING: arg2 func=With_setattr.__setattr__


# object.__delattr__(self, name)
class With_delattr:
    def __delattr__(self, name):
        SINK2(name)
        SINK1(self)
        OK()  # Call not found


def test_delattr():
    with_delattr = With_delattr()  #$ MISSING: arg1="with_delattr" func=With_delattr.__delattr__
    del with_delattr.arg2  #$ MISSING: arg2 func=With_delattr.__delattr__


# object.__dir__(self)
class With_dir:
    def __dir__(self):
        SINK1(self)
        OK()  # Call not found
        return []


def test_dir():
    with_dir = With_dir()  #$ MISSING: arg1="with_dir" func=With_dir.__dir__
    dir(with_dir)


# 3.3.2.2. Implementing Descriptors
class Owner:
    pass


# object.__get__(self, instance, owner=None)
class With_get:
    def __get__(self, instance, owner=None):
        SINK3(owner)  # Flow not testsed, use class `Owner` as source to test
        SINK2(instance)
        SINK1(self)
        OK()  # Call not found
        return ""


def test_get():
    class arg3:
        pass

    with_get = With_get()  #$ MISSING: arg1="with_get" func=With_get.__get__
    arg3.attr = with_get
    arg2 = arg3()  #$ MISSING: arg2 func=With_get.__get__
    arg2.attr


# object.__set__(self, instance, value)
class With_set:
    def __set__(self, instance, value):
        SINK3(value)
        SINK2(instance)
        SINK1(self)
        OK()  # Call not found


def test_set():
    with_set = With_set()  #$ MISSING: arg1="with_set" func=With_set.__set__
    Owner.attr = with_set
    arg2 = Owner()  #$ MISSING: arg2 func=With_set.__set__
    arg3 = ""  #$ MISSING: arg3 func=With_set.__set__
    arg2.attr = arg3


# object.__delete__(self, instance)
class With_delete:
    def __delete__(self, instance):
        SINK2(instance)
        SINK1(self)
        OK()  # Call not found


def test_delete():
    with_delete = With_delete()  #$ MISSING: arg1="with_delete" func=With_delete.__delete__
    Owner.attr = with_delete
    arg2 = Owner()  #$ MISSING: arg2 func=With_delete.__delete__
    del arg2.attr


# object.__set_name__(self, owner, name)
class With_set_name:
    def __set_name__(self, owner, name):
        SINK3(name)
        SINK2(owner)
        SINK1(self)
        OK()  # Call not found


def test_set_name():
    with_set_name = With_set_name()  #$ MISSING: arg1="with_set_name" func=With_set_name.__set_name__
    type("arg2", (object,), dict(arg3=with_set_name))  #$ MISSING: arg2 arg3 func=With_set_name.__set_name__


# 3.3.2.4. __slots__   // We are not testing the  suppression of __weakref__ and __dict__ here
# object.__slots__
# __weakref__
# __dict__

# 3.3.3. Customizing class creation
# classmethod object.__init_subclass__(cls)
class With_init_subclass:
    def __init_subclass__(cls):
        SINK1(cls)  #$ MISSING: arg1="Tuple[0], l:+5 -> cls"
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
        SINK1(name)  #$ MISSING: arg1="arg1, l:+6 -> name"
        OK()  # Call not found
        return kwds


def test_prepare():
    class arg1(metaclass=With_prepare):
        pass


# 3.3.4. Customizing instance and subclass checks
# class.__instancecheck__(self, instance)
class With_instancecheck:
    def __instancecheck__(self, instance):
        SINK2(instance)
        SINK1(self)
        OK()  # Call not found
        return True


def test_instancecheck():
    with_instancecheck = With_instancecheck()  #$ MISSING: arg1="with_instancecheck" func=With_instancecheck.__instancecheck__
    arg2 = ""  #$ MISSING: arg2 func=With_instancecheck.__instancecheck__
    isinstance(arg2, with_instancecheck)


# class.__subclasscheck__(self, subclass)
class With_subclasscheck:
    def __subclasscheck__(self, subclass):
        SINK2(subclass)
        SINK1(self)
        OK()  # Call not found
        return True


def test_subclasscheck():
    with_subclasscheck = With_subclasscheck()  #$ MISSING: arg1="with_subclasscheck" func=With_subclasscheck.__subclasscheck__
    arg2 = object  #$ MISSING: arg2 func=With_subclasscheck.__subclasscheck__
    issubclass(arg2, with_subclasscheck)


# 3.3.5. Emulating generic types
# classmethod object.__class_getitem__(cls, key)
class With_class_getitem:  #$ MISSING: arg1="With_class_getitem" func=With_class_getitem.__class_getitem__
    def __class_getitem__(cls, key):
        SINK2(key)
        SINK1(cls)
        OK()  # Call not found
        return object


def test_class_getitem():
    arg2 = int  #$ MISSING: arg2 func=With_class_getitem.__class_getitem__
    with_class_getitem = With_class_getitem[arg2]()


# 3.3.6. Emulating callable objects
# object.__call__(self[, args...])
class With_call:
    def __call__(self):
        SINK1(self)
        OK()  # Call not found


def test_call():
    with_call = With_call()  #$ arg1="with_call" func=With_call.__call__
    with_call()


# 3.3.7. Emulating container types
# object.__len__(self)
class With_len:
    def __len__(self):
        SINK1(self)
        OK()  # Call not found
        return 0


def test_len():
    with_len = With_len()  #$ MISSING: arg1="with_len" func=With_len.__len__
    len(with_len)


def test_len_bool():
    with_len = With_len()  #$ MISSING: arg1="with_len" func=With_len.__len__
    bool(with_len)


def test_len_if():
    with_len = With_len()  #$ MISSING: arg1="with_len" func=With_len.__len__
    if with_len:
        pass


# object.__getitem__(self, key)
class With_getitem:
    def __getitem__(self, key):
        SINK2(key)
        SINK1(self)
        OK()
        return ""


def test_getitem():
    with_getitem = With_getitem() #$ MISSING: arg1="with_getitem" func=With_getitem.__getitem__
    arg2 = 0
    with_getitem[arg2] #$ MISSING: arg2 func=With_getitem.__getitem__


# object.__setitem__(self, key, value)
class With_setitem:
    def __setitem__(self, key, value):
        SINK3(value)
        SINK2(key)
        SINK1(self)
        OK()


def test_setitem():
    with_setitem = With_setitem()  #$ MISSING: arg1="with_setitem" func=With_setitem.__setitem__
    arg2 = 0
    arg3 = ""
    with_setitem[arg2] = arg3  #$ MISSING: arg2 arg3 func=With_setitem.__setitem__


# object.__delitem__(self, key)
class With_delitem:
    def __delitem__(self, key):
        SINK2(key)
        SINK1(self)
        OK()


def test_delitem():
    with_delitem = With_delitem()  #$ MISSING: arg1="with_delitem" func=With_delitem.__delitem__
    arg2 = 0
    del with_delitem[arg2]  #$ MISSING: arg2 func=With_delitem.__delitem__


# object.__missing__(self, key)
class With_missing(dict):
    def __missing__(self, key):
        SINK2(key)
        SINK1(self)
        OK()  # Call not found
        return ""


def test_missing():
    with_missing = With_missing()  #$ MISSING: arg1="with_missing" func=With_missing.__missing__
    arg2 = 0  #$ MISSING: arg2 func=With_missing.__missing__
    with_missing[arg2]


# object.__iter__(self)
class With_iter:
    def __iter__(self):
        SINK1(self)
        OK()  # Call not found
        return [].__iter__()


def test_iter():
    with_iter = With_iter()  #$ MISSING: arg1="with_iter" func=With_iter.__iter__
    [x for x in with_iter]


# object.__reversed__(self)
class With_reversed:
    def __reversed__(self):
        SINK1(self)
        OK()  # Call not found
        return [].__iter__


def test_reversed():
    with_reversed = With_reversed()  #$ MISSING: arg1="with_reversed" func=With_reversed.__reversed__
    reversed(with_reversed)


# object.__contains__(self, item)
class With_contains:
    def __contains__(self, item):
        SINK2(item)
        SINK1(self)
        OK()  # Call not found
        return True


def test_contains():
    with_contains = With_contains()  #$ MISSING: arg1="with_contains" func=With_contains.__contains__
    arg2 = 0  #$ MISSING: arg2 func=With_contains.__contains__
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
    with_add = With_add()  #$ MISSING: arg1="with_add" func=With_add.__add__
    arg2 = with_add
    with_add + arg2  #$ MISSING: arg2 func=With_add.__add__


# object.__sub__(self, other)
class With_sub:
    def __sub__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_sub():
    with_sub = With_sub()  #$ MISSING: arg1="with_sub" func=With_sub.__sub__
    arg2 = with_sub
    with_sub - arg2  #$ MISSING: arg2 func=With_sub.__sub__


# object.__mul__(self, other)
class With_mul:
    def __mul__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_mul():
    with_mul = With_mul()  #$ MISSING: arg1="with_mul" func=With_mul.__mul__
    arg2 = with_mul
    with_mul * arg2  #$ MISSING: arg2 func=With_mul.__mul__


# object.__matmul__(self, other)
class With_matmul:
    def __matmul__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_matmul():
    with_matmul = With_matmul()  #$ MISSING: arg1="with_matmul" func=With_matmul.__matmul__
    arg2 = with_matmul
    with_matmul @ arg2  #$ MISSING: arg2 func=With_matmul.__matmul__


# object.__truediv__(self, other)
class With_truediv:
    def __truediv__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_truediv():
    with_truediv = With_truediv()  #$ MISSING: arg1="with_truediv" func=With_truediv.__truediv__
    arg2 = with_truediv
    with_truediv / arg2  #$ MISSING: arg2 func=With_truediv.__truediv__


# object.__floordiv__(self, other)
class With_floordiv:
    def __floordiv__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_floordiv():
    with_floordiv = With_floordiv()  #$ MISSING: arg1="with_floordiv" func=With_floordiv.__floordiv__
    arg2 = with_floordiv
    with_floordiv // arg2  #$ MISSING: arg2 func=With_floordiv.__floordiv__


# object.__mod__(self, other)
class With_mod:
    def __mod__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_mod():
    with_mod = With_mod()  #$ MISSING: arg1="with_mod" func=With_mod.__mod__
    arg2 = with_mod
    with_mod % arg2  #$ MISSING: arg2 func=With_mod.__mod__


# object.__divmod__(self, other)
class With_divmod:
    def __divmod__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_divmod():
    with_divmod = With_divmod()  #$ MISSING: arg1="with_divmod" func=With_divmod.__divmod__
    arg2 = With_divmod  #$ MISSING: arg2 func=With_divmod.__divmod__
    divmod(with_divmod, arg2)


# object.__pow__(self, other[, modulo])
class With_pow:
    def __pow__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_pow():
    with_pow = With_pow()  #$ MISSING: arg1="with_pow" func=With_pow.__pow__
    arg2 = with_pow
    pow(with_pow, arg2)  #$ MISSING: arg2 func=With_pow.__pow__


def test_pow_op():
    with_pow = With_pow()  #$ MISSING: arg1="with_pow" func=With_pow.__pow__
    arg2 = with_pow
    with_pow ** arg2  #$ MISSING: arg2 func=With_pow.__pow__


# object.__lshift__(self, other)
class With_lshift:
    def __lshift__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_lshift():
    with_lshift = With_lshift()  #$ MISSING: arg1="with_lshift" func=With_lshift.__lshift__
    arg2 = with_lshift
    with_lshift << arg2  #$ MISSING: arg2 func=With_lshift.__lshift__


# object.__rshift__(self, other)
class With_rshift:
    def __rshift__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_rshift():
    with_rshift = With_rshift()  #$ MISSING: arg1="with_rshift" func=With_rshift.__rshift__
    arg2 = with_rshift
    with_rshift >> arg2  #$ MISSING: arg2 func=With_rshift.__rshift__


# object.__and__(self, other)
class With_and:
    def __and__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_and():
    with_and = With_and()  #$ MISSING: arg1="with_and" func=With_and.__and__
    arg2 = with_and
    with_and & arg2  #$ MISSING: arg2 func=With_and.__and__


# object.__xor__(self, other)
class With_xor:
    def __xor__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_xor():
    with_xor = With_xor()  #$ MISSING: arg1="with_xor" func=With_xor.__xor__
    arg2 = with_xor
    with_xor ^ arg2  #$ MISSING: arg2 func=With_xor.__xor__


# object.__or__(self, other)
class With_or:
    def __or__(self, other):
        SINK2(other)
        SINK1(self)
        OK()
        return self


def test_or():
    with_or = With_or()  #$ MISSING: arg1="with_or" func=With_or.__or__
    arg2 = with_or
    with_or | arg2  #$ MISSING: arg2 func=With_or.__or__


# object.__radd__(self, other)
class With_radd:
    def __radd__(self, other):
        SINK2(other)  #$ MISSING: arg2="arg2, l:+8 -> other"
        SINK1(self)
        OK()  # Call not found
        return self


def test_radd():
    with_radd = With_radd()  #$ MISSING: arg1="with_radd" func=With_radd.__radd__
    arg2 = ""  #$ MISSING: arg2 func=With_radd.__radd__
    arg2 + with_radd


# object.__rsub__(self, other)
class With_rsub:
    def __rsub__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rsub():
    with_rsub = With_rsub()  #$ MISSING: arg1="with_rsub" func=With_rsub.__rsub__
    arg2 = ""  #$ MISSING: arg2 func=With_rsub.__rsub__
    arg2 - with_rsub


# object.__rmul__(self, other)
class With_rmul:
    def __rmul__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rmul():
    with_rmul = With_rmul()  #$ MISSING: arg1="with_rmul" func=With_rmul.__rmul__
    arg2 = ""  #$ MISSING: arg2 func=With_rmul.__rmul__
    arg2 * with_rmul


# object.__rmatmul__(self, other)
class With_rmatmul:
    def __rmatmul__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rmatmul():
    with_rmatmul = With_rmatmul()  #$ MISSING: arg1="with_rmatmul" func=With_rmatmul.__rmatmul__
    arg2 = ""  #$ MISSING: arg2 func=With_rmatmul.__rmatmul__
    arg2 @ with_rmatmul


# object.__rtruediv__(self, other)
class With_rtruediv:
    def __rtruediv__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rtruediv():
    with_rtruediv = With_rtruediv()  #$ MISSING: arg1="with_rtruediv" func=With_rtruediv.__rtruediv__
    arg2 = ""  #$ MISSING: arg2 func=With_rtruediv.__rtruediv__
    arg2 / with_rtruediv


# object.__rfloordiv__(self, other)
class With_rfloordiv:
    def __rfloordiv__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rfloordiv():
    with_rfloordiv = With_rfloordiv()  #$ MISSING: arg1="with_rfloordiv" func=With_rfloordiv.__rfloordiv__
    arg2 = ""  #$ MISSING: arg2 func=With_rfloordiv.__rfloordiv__
    arg2 // with_rfloordiv


# object.__rmod__(self, other)
class With_rmod:
    def __rmod__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rmod():
    with_rmod = With_rmod()  #$ MISSING: arg1="with_rmod" func=With_rmod.__rmod__
    arg2 = {}  #$ MISSING: arg2 func=With_rmod.__rmod__
    arg2 % with_rmod


# object.__rdivmod__(self, other)
class With_rdivmod:
    def __rdivmod__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rdivmod():
    with_rdivmod = With_rdivmod()  #$ MISSING: arg1="with_rdivmod" func=With_rdivmod.__rdivmod__
    arg2 = ""  #$ MISSING: arg2 func=With_rdivmod.__rdivmod__
    divmod(arg2, with_rdivmod)


# object.__rpow__(self, other[, modulo])
class With_rpow:
    def __rpow__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rpow():
    with_rpow = With_rpow()  #$ MISSING: arg1="with_rpow" func=With_rpow.__rpow__
    arg2 = ""  #$ MISSING: arg2 func=With_rpow.__rpow__
    pow(arg2, with_rpow)


def test_rpow_op():
    with_rpow = With_rpow()  #$ MISSING: arg1="with_rpow" func=With_rpow.__rpow__
    arg2 = ""  #$ MISSING: arg2 func=With_rpow.__rpow__
    arg2 ** with_rpow


# object.__rlshift__(self, other)
class With_rlshift:
    def __rlshift__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rlshift():
    with_rlshift = With_rlshift()  #$ MISSING: arg1="with_rlshift" func=With_rlshift.__rlshift__
    arg2 = ""  #$ MISSING: arg2 func=With_rlshift.__rlshift__
    arg2 << with_rlshift


# object.__rrshift__(self, other)
class With_rrshift:
    def __rrshift__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rrshift():
    with_rrshift = With_rrshift()  #$ MISSING: arg1="with_rrshift" func=With_rrshift.__rrshift__
    arg2 = ""  #$ MISSING: arg2 func=With_rrshift.__rrshift__
    arg2 >> with_rrshift


# object.__rand__(self, other)
class With_rand:
    def __rand__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rand():
    with_rand = With_rand()  #$ MISSING: arg1="with_rand" func=With_rand.__rand__
    arg2 = ""  #$ MISSING: arg2 func=With_rand.__rand__
    arg2 & with_rand


# object.__rxor__(self, other)
class With_rxor:
    def __rxor__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_rxor():
    with_rxor = With_rxor()  #$ MISSING: arg1="with_rxor" func=With_rxor.__rxor__
    arg2 = ""  #$ MISSING: arg2 func=With_rxor.__rxor__
    arg2 ^ with_rxor


# object.__ror__(self, other)
class With_ror:
    def __ror__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_ror():
    with_ror = With_ror()  #$ MISSING: arg1="with_ror" func=With_ror.__ror__
    arg2 = ""  #$ MISSING: arg2 func=With_ror.__ror__
    arg2 | with_ror


# object.__iadd__(self, other)
class With_iadd:
    def __iadd__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_iadd():
    with_iadd = With_iadd()  #$ MISSING: arg1="with_iadd" func=With_iadd.__iadd__
    arg2 = with_iadd  #$ MISSING: arg2 func=With_iadd.__iadd__
    with_iadd += arg2


# object.__isub__(self, other)
class With_isub:
    def __isub__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_isub():
    with_isub = With_isub()  #$ MISSING: arg1="with_isub" func=With_isub.__isub__
    arg2 = with_isub  #$ MISSING: arg2 func=With_isub.__isub__
    with_isub -= arg2


# object.__imul__(self, other)
class With_imul:
    def __imul__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_imul():
    with_imul = With_imul()  #$ MISSING: arg1="with_imul" func=With_imul.__imul__
    arg2 = with_imul  #$ MISSING: arg2 func=With_imul.__imul__
    with_imul *= arg2


# object.__imatmul__(self, other)
class With_imatmul:
    def __imatmul__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_imatmul():
    with_imatmul = With_imatmul()  #$ MISSING: arg1="with_imatmul" func=With_imatmul.__imatmul__
    arg2 = with_imatmul  #$ MISSING: arg2 func=With_imatmul.__imatmul__
    with_imatmul @= arg2


# object.__itruediv__(self, other)
class With_itruediv:
    def __itruediv__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_itruediv():
    with_itruediv = With_itruediv()  #$ MISSING: arg1="with_itruediv" func=With_itruediv.__itruediv__
    arg2 = with_itruediv  #$ MISSING: arg2 func=With_itruediv.__itruediv__
    with_itruediv /= arg2


# object.__ifloordiv__(self, other)
class With_ifloordiv:
    def __ifloordiv__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_ifloordiv():
    with_ifloordiv = With_ifloordiv()  #$ MISSING: arg1="with_ifloordiv" func=With_ifloordiv.__ifloordiv__
    arg2 = with_ifloordiv  #$ MISSING: arg2 func=With_ifloordiv.__ifloordiv__
    with_ifloordiv //= arg2


# object.__imod__(self, other)
class With_imod:
    def __imod__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_imod():
    with_imod = With_imod()  #$ MISSING: arg1="with_imod" func=With_imod.__imod__
    arg2 = with_imod  #$ MISSING: arg2 func=With_imod.__imod__
    with_imod %= arg2


# object.__ipow__(self, other[, modulo])
class With_ipow:
    def __ipow__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_ipow():
    with_ipow = With_ipow()  #$ MISSING: arg1="with_ipow" func=With_ipow.__ipow__
    arg2 = with_ipow  #$ MISSING: arg2 func=With_ipow.__ipow__
    with_ipow **= arg2


# object.__ilshift__(self, other)
class With_ilshift:
    def __ilshift__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_ilshift():
    with_ilshift = With_ilshift()  #$ MISSING: arg1="with_ilshift" func=With_ilshift.__ilshift__
    arg2 = with_ilshift  #$ MISSING: arg2 func=With_ilshift.__ilshift__
    with_ilshift <<= arg2


# object.__irshift__(self, other)
class With_irshift:
    def __irshift__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_irshift():
    with_irshift = With_irshift()  #$ MISSING: arg1="with_irshift" func=With_irshift.__irshift__
    arg2 = with_irshift  #$ MISSING: arg2 func=With_irshift.__irshift__
    with_irshift >>= arg2


# object.__iand__(self, other)
class With_iand:
    def __iand__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_iand():
    with_iand = With_iand()  #$ MISSING: arg1="with_iand" func=With_iand.__iand__
    arg2 = with_iand  #$ MISSING: arg2 func=With_iand.__iand__
    with_iand &= arg2


# object.__ixor__(self, other)
class With_ixor:
    def __ixor__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_ixor():
    with_ixor = With_ixor()  #$ MISSING: arg1="with_ixor" func=With_ixor.__ixor__
    arg2 = with_ixor  #$ MISSING: arg2 func=With_ixor.__ixor__
    with_ixor ^= arg2


# object.__ior__(self, other)
class With_ior:
    def __ior__(self, other):
        SINK2(other)
        SINK1(self)
        OK()  # Call not found
        return self


def test_ior():
    with_ior = With_ior()  #$ MISSING: arg1="with_ior" func=With_ior.__ior__
    arg2 = with_ior  #$ MISSING: arg2 func=With_ior.__ior__
    with_ior |= arg2


# object.__neg__(self)
class With_neg:
    def __neg__(self):
        SINK1(self)
        OK()  # Call not found
        return self


def test_neg():
    with_neg = With_neg()  #$ MISSING: arg1="with_neg" func=With_neg.__neg__
    -with_neg


# object.__pos__(self)
class With_pos:
    def __pos__(self):
        SINK1(self)
        OK()  # Call not found
        return self


def test_pos():
    with_pos = With_pos()  #$ MISSING: arg1="with_pos" func=With_pos.__pos__
    +with_pos


# object.__abs__(self)
class With_abs:
    def __abs__(self):
        SINK1(self)
        OK()  # Call not found
        return self


def test_abs():
    with_abs = With_abs()  #$ MISSING: arg1="with_abs" func=With_abs.__abs__
    abs(with_abs)


# object.__invert__(self)
class With_invert:
    def __invert__(self):
        SINK1(self)
        OK()  # Call not found
        return self


def test_invert():
    with_invert = With_invert()  #$ MISSING: arg1="with_invert" func=With_invert.__invert__
    ~with_invert


# object.__complex__(self)
class With_complex:
    def __complex__(self):
        SINK1(self)
        OK()  # Call not found
        return 0j


def test_complex():
    with_complex = With_complex()  #$ MISSING: arg1="with_complex" func=With_complex.__complex__
    complex(with_complex)


# object.__int__(self)
class With_int:
    def __int__(self):
        SINK1(self)
        OK()  # Call not found
        return 0


def test_int():
    with_int = With_int()  #$ MISSING: arg1="with_int" func=With_int.__int__
    int(with_int)


# object.__float__(self)
class With_float:
    def __float__(self):
        SINK1(self)
        OK()  # Call not found
        return 0.0


def test_float():
    with_float = With_float()  #$ MISSING: arg1="with_float" func=With_float.__float__
    float(with_float)


# object.__index__(self)
class With_index:
    def __index__(self):
        SINK1(self)
        OK()  # Call not found
        return 0


def test_index_slicing():
    with_index = With_index()  #$ MISSING: arg1="with_index" func=With_index.__index__
    [0][with_index:1]


def test_index_bin():
    with_index = With_index()  #$ MISSING: arg1="with_index" func=With_index.__index__
    bin(with_index)


def test_index_hex():
    with_index = With_index()  #$ MISSING: arg1="with_index" func=With_index.__index__
    hex(with_index)


def test_index_oct():
    with_index = With_index()  #$ MISSING: arg1="with_index" func=With_index.__index__
    oct(with_index)


def test_index_int():
    with_index = With_index()  #$ MISSING: arg1="with_index" func=With_index.__index__
    int(with_index)


def test_index_float():
    with_index = With_index()  #$ MISSING: arg1="with_index" func=With_index.__index__
    float(with_index)


def test_index_complex():
    with_index = With_index()  #$ MISSING: arg1="with_index" func=With_index.__index__
    complex(with_index)


# object.__round__(self[, ndigits])
class With_round:
    def __round__(self):
        SINK1(self)
        OK()  # Call not found
        return 0


def test_round():
    with_round = With_round()  #$ MISSING: arg1="with_round" func=With_round.__round__
    round(with_round)


# object.__trunc__(self)
class With_trunc:
    def __trunc__(self):
        SINK1(self)
        OK()  # Call not found
        return 0


def test_trunc():
    with_trunc = With_trunc()  #$ MISSING: arg1="with_trunc" func=With_trunc.__trunc__
    import math

    math.trunc(with_trunc)


# object.__floor__(self)
class With_floor:
    def __floor__(self):
        SINK1(self)
        OK()  # Call not found
        return 0


def test_floor():
    with_floor = With_floor()  #$ MISSING: arg1="with_floor" func=With_floor.__floor__
    import math

    math.floor(with_floor)


# object.__ceil__(self)
class With_ceil:
    def __ceil__(self):
        SINK1(self)
        OK()  # Call not found
        return 0


def test_ceil():
    with_ceil = With_ceil()  #$ MISSING: arg1="with_ceil" func=With_ceil.__ceil__
    import math

    math.ceil(with_ceil)


# 3.3.9. With Statement Context Managers
# object.__enter__(self)
class With_enter:
    def __enter__(self):
        SINK1(self)
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
        SINK1(self)
        OK()  # Call not found
        return


def test_exit():
    with With_exit():
        pass


# 3.4.1. Awaitable Objects

# object.__await__(self)
class With_await:
    def __await__(self):
        SINK1(self)
        OK()  # Call not found
        return (yield from [])


async def atest_await():
    with_await = With_await()  #$ MISSING: arg1="with_await" func=With_await.__await__
    await (with_await)


# # 3.4.2. Coroutine Objects   // These should be handled as normal function calls
# # coroutine.send(value)
# # coroutine.throw(type[, value[, traceback]])
# # coroutine.close()

# 3.4.3. Asynchronous Iterators
# object.__aiter__(self)
class With_aiter:
    def __aiter__(self):
        SINK1(self)
        OK()  # Call not found
        return self

    async def __anext__(self):
        raise StopAsyncIteration


async def atest_aiter():
    with_aiter = With_aiter()  #$ MISSING: arg1="with_aiter" func=With_aiter.__aiter__
    async for x in with_aiter:
        pass


# object.__anext__(self)
class With_anext:
    def __aiter__(self):
        return self

    async def __anext__(self):
        SINK1(self)
        OK()  # Call not found
        raise StopAsyncIteration


async def atest_anext():
    with_anext = With_anext()  #$ MISSING: arg1="with_anext" func=With_anext.__anext__
    async for x in with_anext:
        pass


# 3.4.4. Asynchronous Context Managers
# object.__aenter__(self)
class With_aenter:
    async def __aenter__(self):
        SINK1(self)
        OK()  # Call not found

    async def __aexit__(self, exc_type, exc_value, traceback):
        pass


async def atest_aenter():
    with_aenter = With_aenter()  #$ MISSING: arg1="with_aenter" func=With_aenter.__aenter__
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
        SINK1(self)
        OK()  # Call not found


async def atest_aexit():
    with_aexit = With_aexit()  #$ MISSING: arg1="with_aexit" func=With_aexit.__aexit__
    async with with_aexit:
        pass
