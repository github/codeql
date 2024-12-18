
import ast
import sys
from types import ModuleType, GetSetDescriptorType
import hashlib
import os

from semmle.python import ast
from semmle.python.passes._pass import Pass
from semmle.util import get_analysis_major_version
from semmle.python.passes.ast_pass import iter_fields
from semmle.cmdline import is_legal_module_name


'''
The QL library depends on a reasonable one-to-one correspondence
between DB entities and Python objects. However, since QL has only
one notion of equality, but Python has two (`__eq__` and `is`) we need to be careful.
What we want to do is to treat objects like builtin functions and classes as using
reference equality and numbers and strings as using value equality.

In practice this is impossible as we want to distinguish `True` from `1` from `1.0`
even though all these values are equal. However, we want to get as close as possible.

'''


__all__ = [ 'ObjectPass' ]

OBJECT_TYPES = set([ ast.ClassExpr, ast.Call,
                     ast.FunctionExpr, ast.Tuple,
                     ast.Str, ast.Num, ast.List, ast.ListComp, ast.Module,
                     ast.Dict, ast.Ellipsis, ast.Lambda])

# Types from Python 2.7 onwards
OBJECT_TYPES.add(ast.DictComp)
OBJECT_TYPES.add(ast.SetComp)
OBJECT_TYPES.add(ast.Set)

NUMERIC_TYPES = set([int, float, bool])

BUILTINS_NAME = 'builtins'

LITERALS = (ast.Num, ast.Str)

# A variant of the 'replace' error handler that replaces unencodable characters with U+FFFD
# rather than '?'. Without this, a string like '\uD800' (which is not encodable) would get mapped
# to '?', and potentially clash with the regular string '?' if it appeared elsewhere in the source
# code. Used in 'get_label_for_object' below. Based on code from https://peps.python.org/pep-0293/
def fffd_replace(exc):
     if isinstance(exc, UnicodeEncodeError):
         return ((exc.end-exc.start)*u"\\ufffd", exc.end)
     elif isinstance(exc, UnicodeDecodeError):
         return (u"\\ufffd", exc.end)
     elif isinstance(exc, UnicodeTranslateError):
         return ((exc.end-exc.start)*u"\\ufffd", exc.end)
     else:
         raise TypeError("can't handle %s" % exc.__name__)

import codecs
codecs.register_error("fffdreplace", fffd_replace)

class _CObject(object):
    '''Utility class to wrap arbitrary C objects.
    Treat all objects as unique. Rely on naming in the
    trap files to merge the objects that we want merged.
    '''
    __slots__ = ['obj']

    def __init__(self, obj):
        self.obj = obj

    def __eq__(self, other):
        if isinstance(other, _CObject):
            return self.obj is other.obj
        else:
            return False

    def __ne__(self, other):
        return not self.__eq__(other)

    def __hash__(self):
        return id(self.obj)

class ObjectPass(Pass):
    '''Generates relations for objects. This includes information about
    builtin objects, including their types and members.
    It also generates objects for all literal values present in the Python source.'''

    def extract(self, ast, path, writer):
        self.writer = writer
        try:
            self._extract_py(ast)
            self._extract_possible_module_names(path)
        finally:
            self.writer = None

    def _extract_possible_module_names(self, path):
        maybe_name, _ = os.path.splitext(path)
        maybe_name = maybe_name.replace(os.sep, ".")
        while maybe_name.count(".") > 3:
            _, maybe_name = maybe_name.split(".", 1)
        while True:
            if is_legal_module_name(maybe_name):
                self._write_module_and_package_names(maybe_name)
            if "." not in maybe_name:
                return
            _, maybe_name = maybe_name.split(".", 1)

    def _write_module_and_package_names(self, module_name):
        self._write_c_object(module_name, None, False)
        while "." in module_name:
            module_name, _ = module_name.rsplit(".", 1)
            self._write_c_object(module_name, None, False)

    def extract_builtin(self, module, writer):
        self.writer = writer
        try:
            self._extract_c(module)
        finally:
            self.writer = None

    def _extract_c(self, mod):
        self.next_address_label = 0
        self.address_labels = {}
        self._write_c_object(mod, None, False)
        self.address_labels = None

    def _write_str(self, s):
        assert type(s) is str
        self._write_c_object(s, None, False)

    def _write_c_object(self, obj, label, write_special, string_prefix=""):
        ANALYSIS_MAJOR_VERSION = get_analysis_major_version()
        # If we're extracting Python 2 code using Python 3, we want to treat `str` as `bytes` for
        # the purposes of determining the type, but we still want to treat the _value_ as if it's a `str`.
        obj_type = type(obj)
        if obj_type == str and ANALYSIS_MAJOR_VERSION == 2 and 'u' not in string_prefix:
            obj_type = bytes

        cobj = _CObject(obj)
        if self.writer.has_written(cobj):
            return self.writer.get_node_id(cobj)
        obj_label = self.get_label_for_object(obj, label, obj_type)
        obj_id = self.writer.get_labelled_id(cobj, obj_label)
        #Avoid writing out all the basic types for every C module.
        if not write_special and cobj in SPECIAL_OBJECTS:
            return obj_id
        type_id = self._write_c_object(obj_type, None, write_special)
        self.writer.write_tuple(u'py_cobjects', 'r', obj_id)
        self.writer.write_tuple(u'py_cobjecttypes', 'rr', obj_id, type_id)
        self.writer.write_tuple(u'py_cobject_sources', 'rd', obj_id, 0)
        if isinstance(obj, ModuleType) or isinstance(obj, type):
            for name, value in sorted(obj.__dict__.items()):
                if (obj, name) in SKIPLIST:
                    continue
                val_id = self._write_c_object(value, obj_label + u'$%d' % ANALYSIS_MAJOR_VERSION + name, write_special)
                self.writer.write_tuple(u'py_cmembers_versioned', 'rsrs',
                                        obj_id, name, val_id, ANALYSIS_MAJOR_VERSION)
            if isinstance(obj, type) and obj is not object:
                super_id = self._write_c_object(obj.__mro__[1], None, write_special)
                self.writer.write_tuple(u'py_cmembers_versioned', 'rsrs',
                                        obj_id, u".super.", super_id, ANALYSIS_MAJOR_VERSION)
        if isinstance(obj, (list, tuple)):
            for index, item in enumerate(obj):
                item_id = self._write_c_object(item, obj_label + u'$' + str(index), write_special)
                self.writer.write_tuple(u'py_citems', 'rdr',
                                        obj_id, index, item_id)
        if type(obj) is GetSetDescriptorType:
            for name in type(obj).__dict__:
                if name == '__name__' or not hasattr(obj, name):
                    continue
                val_id = self._write_c_object(getattr(obj, name), obj_label + u'$%d' % ANALYSIS_MAJOR_VERSION + name, write_special)
                self.writer.write_tuple(u'py_cmembers_versioned', 'rsrs',
                                        obj_id, name, val_id, ANALYSIS_MAJOR_VERSION)
        if hasattr(obj, '__name__'):
            #Use qualified names for classes.
            if isinstance(obj, type):
                name = qualified_type_name(obj)
            # https://bugs.python.org/issue18602
            elif isinstance(obj, ModuleType) and obj.__name__ == "io":
                name = "_io"
            elif obj is EXEC:
                name = "exec"
            else:
                name = obj.__name__
            self.writer.write_tuple(u'py_cobjectnames', 'rs',
                                    obj_id, name)
        elif type(obj) in NUMERIC_TYPES:
            self.writer.write_tuple(u'py_cobjectnames', 'rq',
                                    obj_id, obj)
        elif type(obj) is str:
            if 'b' in string_prefix:
                prefix = u"b"
            elif 'u' in string_prefix:
                prefix = u"u"
            else:
                if ANALYSIS_MAJOR_VERSION == 2:
                    prefix = u"b"
                else:
                    prefix = u"u"
            self.writer.write_tuple(u'py_cobjectnames', 'rs',
                                    obj_id, prefix + u"'" + obj + u"'")
        elif type(obj) is bytes:
            #Convert bytes to a unicode characters one-to-one.
            obj_string = u"b'" + obj.decode("latin-1") + u"'"
            self.writer.write_tuple(u'py_cobjectnames', 'rs',
                                    obj_id, obj_string)
        elif type(obj) is type(None):
            self.writer.write_tuple(u'py_cobjectnames', 'rs',
                                    obj_id, u'None')
        else:
            self.writer.write_tuple(u'py_cobjectnames', 'rs',
                                    obj_id, u'object')
        return obj_id

    def write_special_objects(self, writer):
        '''Write important builtin objects to the trap file'''
        self.writer = writer
        self.next_address_label = 0
        self.address_labels = {}

        def write(obj, name, label=None):
            obj_id = self._write_c_object(obj, label, True)
            self.writer.write_tuple(u'py_special_objects', 'rs', obj_id, name)

        for obj, name in SPECIAL_OBJECTS.items():
            write(obj.obj, name)

        ###Artificial objects for use by the type-inferencer - Make sure that they are unique.
        write(object(), u"_semmle_unknown_type", u"$_semmle_unknown_type")
        write(object(), u"_semmle_undefined_value", u"$_semmle_undefined_value")

        self.writer = None
        self.address_labels = None

    def get_label_for_object(self, obj, default_label, obj_type):
        """Gets a label for an object. Attempt to make this as universal as possible.
        The object graph in the database should reflect the real object graph,
        only rarely diverging. This should be true even in highly parallel environments
        including cases where trap files may be overwritten.
        Proviso: Distinct immutable primitive objects may be merged (which should be benign)
        For objects without a unambiguous global name, 'default_label' is used.
        """
        #This code must be robust against (possibly intentionally) incorrect implementations
        #of the object model.
        if obj is None:
            return u"C_None"
        t = type(obj)
        t_name = t.__name__
        if t is tuple and len(obj) == 0:
            return u"C_EmptyTuple"

        if obj_type is str:
            prefix = u"C_unicode$"
        else:
            prefix = u"C_bytes$"
        if t is str:
            obj = obj.encode("utf8", errors='fffdreplace')
            return prefix + hashlib.sha1(obj).hexdigest()
        if t is bytes:
            return prefix + hashlib.sha1(obj).hexdigest()
        if t in NUMERIC_TYPES:
            return u"C_" + t_name + u"$" + repr(obj)
        try:
            if isinstance(obj, type):
                return u"C_" + t_name + u"$" + qualified_type_name(obj)
        except Exception:
            #Misbehaved object.
            return default_label
        if t is ModuleType:
            return u"C_" + t_name + u"$" + obj.__name__
        if t is type(len):
            mod_name = obj.__module__
            if isinstance(mod_name, str):
                if mod_name == BUILTINS_NAME:
                    mod_name = "builtins"
                    return u"C_" + t_name + u"$" + mod_name + "." + obj.__name__
        return default_label

    # Python files -- Extract objects for all numeric and string values.

    def _extract_py(self, ast):
        self._walk_py(ast)

    def _write_literal(self, node):
        if isinstance(node, ast.Num):
            self._write_c_object(node.n, None, False)
        else:
            prefix = getattr(node, "prefix", "")
            # Output both byte and unicode objects if the relevant objects could exist
            # Non-prefixed strings can be either bytes or unicode.
            if 'u' not in prefix:
                try:
                    self._write_c_object(node.s.encode("latin-1"), None, False, string_prefix=prefix)
                except UnicodeEncodeError:
                    #If not encodeable as latin-1 then it cannot be bytes
                    pass
            if 'b' not in prefix:
                self._write_c_object(node.s, None, False, string_prefix=prefix)

    def _walk_py(self, node):
        if isinstance(node, ast.AstBase):
            if isinstance(node, LITERALS):
                self._write_literal(node)
            else:
                for _, _, child_node in iter_fields(node):
                    self._walk_py(child_node)
        elif isinstance(node, list):
            for n in node:
                self._walk_py(n)

def a_function():
    pass

def a_generator_function():
    yield None

class C(object):
    def meth(self):
        pass

#Create an object for 'exec', as parser no longer treats it as statement.
# Use `[].append` as it has the same type as `exec`.
EXEC = [].append

SPECIAL_OBJECTS = {
    type(a_function): u"FunctionType",
    type(len): u"BuiltinFunctionType",
    classmethod: u"ClassMethod",
    staticmethod: u"StaticMethod",
    type(sys): u"ModuleType",
    type(a_generator_function()): u"generator",
    None: u"None",
    type(None): u"NoneType",
    True: u"True",
    False: u"False",
    bool: u"bool",
    sys: u"sys",
    Exception: u"Exception",
    BaseException: u"BaseException",
    TypeError: u"TypeError",
    AttributeError: u"AttributeError",
    KeyError: u"KeyError",
    int: u"int",
    float: u"float",
    object: u"object",
    type: u"type",
    tuple: u"tuple",
    dict: u"dict",
    list: u"list",
    set: u"set",
    locals: u"locals",
    globals: u"globals",
    property: u"property",
    type(list.append): u"MethodDescriptorType",
    super: u"super",
    type(C().meth): u"MethodType",
    #For future enhancements
    object(): u"_1",
    object(): u"_2",
    #Make sure we have all version numbers as single character strings.
    b'2': u'b2',
    b'3': u'b3',
    u'2': u'u2',
    u'3': u'u3',
}

SPECIAL_OBJECTS[__import__(BUILTINS_NAME)] = u"builtin_module"
SPECIAL_OBJECTS[str] = u"unicode"
SPECIAL_OBJECTS[bytes] = u"bytes"

#Store wrapped versions of special objects, so that they compare correctly.
tmp = {}
for obj, name in SPECIAL_OBJECTS.items():
    tmp[_CObject(obj)] = name
SPECIAL_OBJECTS = tmp
del tmp

#List of various attributes VM implementation details we want to skip.
SKIPLIST = set([
    (sys, "exc_value"),
    (sys, "exc_type"),
    (sys, "exc_traceback"),
    (__import__(BUILTINS_NAME), "_"),
])

def qualified_type_name(cls):
    #Special case bytes/str/unicode to make sure they share names across versions
    if cls is bytes:
        return u"bytes"
    if cls is str:
        return u"unicode"
    if cls.__module__ == BUILTINS_NAME or cls.__module__ == "exceptions":
        return cls.__name__
    else:
        return cls.__module__ + "." + cls.__name__
