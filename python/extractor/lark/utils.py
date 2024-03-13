from collections import deque
import sys

class fzset(frozenset):
    def __repr__(self):
        return '{%s}' % ', '.join(map(repr, self))


def classify_bool(seq, pred):
    true_elems = []
    false_elems = []

    for elem in seq:
        if pred(elem):
            true_elems.append(elem)
        else:
            false_elems.append(elem)

    return true_elems, false_elems

def classify(seq, key=None, value=None):
    d = {}
    for item in seq:
        k = key(item) if (key is not None) else item
        v = value(item) if (value is not None) else item
        if k in d:
            d[k].append(v)
        else:
            d[k] = [v]
    return d

def bfs(initial, expand):
    open_q = deque(list(initial))
    visited = set(open_q)
    while open_q:
        node = open_q.popleft()
        yield node
        for next_node in expand(node):
            if next_node not in visited:
                visited.add(next_node)
                open_q.append(next_node)




try:
    STRING_TYPE = basestring
except NameError:   # Python 3
    STRING_TYPE = str

###{standalone

import types
from functools import wraps, partial
from contextlib import contextmanager

Str = type(u'')

def smart_decorator(f, create_decorator):
    if isinstance(f, types.FunctionType):
        return wraps(f)(create_decorator(f, True))

    elif isinstance(f, (type, types.BuiltinFunctionType)):
        return wraps(f)(create_decorator(f, False))

    elif isinstance(f, types.MethodType):
        return wraps(f)(create_decorator(f.__func__, True))

    elif isinstance(f, partial):
        # wraps does not work for partials in 2.7: https://bugs.python.org/issue3445
        return create_decorator(f.__func__, True)

    else:
        return create_decorator(f.__func__.__call__, True)




try:
    from contextlib import suppress     # Python 3
except ImportError:
    @contextmanager
    def suppress(*excs):
        '''Catch and dismiss the provided exception

        >>> x = 'hello'
        >>> with suppress(IndexError):
        ...     x = x[10]
        >>> x
        'hello'
        '''
        try:
            yield
        except excs:
            pass

###}



try:
    compare = cmp
except NameError:
    def compare(a, b):
        if a == b:
            return 0
        elif a > b:
            return 1
        return -1


def get_regexp_width(regexp):
    # in 3.11 sre_parse was replaced with re._parser
    # see implementation in https://github.com/python/cpython/blob/3.11/Lib/sre_parse.py
    if sys.version_info >= (3, 11):
        import re
        try:
            return re._parser.parse(regexp).getwidth()
        except re.error:
            raise ValueError(regexp)
    else:
        import sre_constants
        import sre_parse
        try:
            return sre_parse.parse(regexp).getwidth()
        except sre_constants.error:
            raise ValueError(regexp)
