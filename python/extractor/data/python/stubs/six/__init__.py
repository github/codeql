# Stub file for six.
#This should have the same interface as the six module,
#but be much more tractable for static analysis.



"""Utilities for writing code that runs on Python 2 and 3"""

# Copyright (c) 2015 Semmle Limited
# All rights reserved
# Note that the original six module is copyright Benjamin Peterson
#

import operator
import sys
import types

__author__ = "Benjamin Peterson <benjamin@python.org>"
__version__ = "1.14.0"


# Useful for very coarse version differentiation.
PY2 = sys.version_info < (3,)
PY3 = sys.version_info >= (3,)

if PY3:
    string_types = str,
    integer_types = int,
    class_types = type,
    text_type = str
    binary_type = bytes

    MAXSIZE = sys.maxsize
else:
    string_types = basestring,
    integer_types = (int, long)
    class_types = (type, types.ClassType)
    text_type = unicode
    binary_type = str
    #We can't compute MAXSIZE, but it doesn't really matter
    MAXSIZE = int((1 << 63) - 1)


def _add_doc(func, doc):
    """Add documentation to a function."""
    func.__doc__ = doc


def _import_module(name):
    """Import module, returning the module after the last dot."""
    __import__(name)
    return sys.modules[name]

import six.moves as moves


def add_move(move):
    """Add an item to six.moves."""
    setattr(_MovedItems, move.name, move)


def remove_move(name):
    """Remove item from six.moves."""
    try:
        delattr(_MovedItems, name)
    except AttributeError:
        try:
            del moves.__dict__[name]
        except KeyError:
            raise AttributeError("no such move, %r" % (name,))


if PY3:
    _meth_func = "__func__"
    _meth_self = "__self__"

    _func_closure = "__closure__"
    _func_code = "__code__"
    _func_defaults = "__defaults__"
    _func_globals = "__globals__"

    _iterkeys = "keys"
    _itervalues = "values"
    _iteritems = "items"
    _iterlists = "lists"
else:
    _meth_func = "im_func"
    _meth_self = "im_self"

    _func_closure = "func_closure"
    _func_code = "func_code"
    _func_defaults = "func_defaults"
    _func_globals = "func_globals"

    _iterkeys = "iterkeys"
    _itervalues = "itervalues"
    _iteritems = "iteritems"
    _iterlists = "iterlists"


try:
    advance_iterator = next
except NameError:
    def advance_iterator(it):
        return it.next()
next = advance_iterator


try:
    callable = callable
except NameError:
    def callable(obj):
        return any("__call__" in klass.__dict__ for klass in type(obj).__mro__)


if PY3:
    def get_unbound_function(unbound):
        return unbound

    create_bound_method = types.MethodType

    Iterator = object
else:
    def get_unbound_function(unbound):
        return unbound.im_func

    def create_bound_method(func, obj):
        return types.MethodType(func, obj, obj.__class__)

    class Iterator(object):

        def next(self):
            return type(self).__next__(self)

    callable = callable
_add_doc(get_unbound_function,
         """Get the function out of a possibly unbound function""")


get_method_function = operator.attrgetter(_meth_func)
get_method_self = operator.attrgetter(_meth_self)
get_function_closure = operator.attrgetter(_func_closure)
get_function_code = operator.attrgetter(_func_code)
get_function_defaults = operator.attrgetter(_func_defaults)
get_function_globals = operator.attrgetter(_func_globals)


def iterkeys(d, **kw):
    """Return an iterator over the keys of a dictionary."""
    return iter(getattr(d, _iterkeys)(**kw))

def itervalues(d, **kw):
    """Return an iterator over the values of a dictionary."""
    return iter(getattr(d, _itervalues)(**kw))

def iteritems(d, **kw):
    """Return an iterator over the (key, value) pairs of a dictionary."""
    return iter(getattr(d, _iteritems)(**kw))

def iterlists(d, **kw):
    """Return an iterator over the (key, [values]) pairs of a dictionary."""
    return iter(getattr(d, _iterlists)(**kw))

def byte2int(ch): #type bytes -> int
    return int(unknown())

def b(s): #type str -> bytes
    """Byte literal"""
    return bytes(unknown())

def u(s): #type str -> unicode
    """Text literal"""
    if PY3:
        unicode = str
    return unicode(unknown())

if PY3:
    unichr = chr
    def int2byte(i): #type int -> bytes
        return bytes(unknown())
    indexbytes = operator.getitem
    iterbytes = iter
    import io
    StringIO = io.StringIO
    BytesIO = io.BytesIO
else:
    unichr = unichr
    int2byte = chr
    def indexbytes(buf, i):
        return int(unknown())
    def iterbytes(buf):
        return (int(unknown()) for byte in buf)
    import StringIO
    StringIO = BytesIO = StringIO.StringIO


if PY3:
    exec_ = getattr(six.moves.builtins, "exec")

    def reraise(tp, value, tb=None):
        """Reraise an exception."""
        if value.__traceback__ is not tb:
            raise value.with_traceback(tb)
        raise value

else:
    def exec_(_code_, _globs_=None, _locs_=None):
        pass

    def reraise(tp, value, tb=None):
        """Reraise an exception."""
        exc = tp(value)
        exc.__traceback__ = tb
        raise exc


print_ = getattr(moves.builtins, "print", None)
if print_ is None:
    def print_(*args, **kwargs):
        """The new-style print function for Python 2.4 and 2.5."""
        pass

def with_metaclass(meta, *bases):
    """Create a base class with a metaclass."""
    return meta("NewBase", bases, {})

def add_metaclass(metaclass):
    """Class decorator for creating a class with a metaclass."""
    def wrapper(cls):
        orig_vars = cls.__dict__.copy()
        orig_vars.pop('__dict__', None)
        orig_vars.pop('__weakref__', None)
        slots = orig_vars.get('__slots__')
        if slots is not None:
            if isinstance(slots, str):
                slots = [slots]
            for slots_var in slots:
                orig_vars.pop(slots_var)
        return metaclass(cls.__name__, cls.__bases__, orig_vars)
    return wrapper
