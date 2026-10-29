# Not OK
def simple(l = [0]):  # $ Source
    l[0] = 1  # $ Alert modification=l
    return l

# Not OK
def slice(l = [0]):  # $ Source
    l[0:1] = 1  # $ Alert modification=l
    return l

# Not OK
def list_del(l = [0]):  # $ Source
    del l[0]  # $ Alert modification=l
    return l

# Not OK
def append_op(l = []):  # $ Source
    l += [1, 2, 3]  # $ Alert modification=l
    return l

# Not OK
def repeat_op(l = [0]):  # $ Source
    l *= 3  # $ Alert modification=l
    return l

# Not OK
def append(l = []):  # $ Source
    l.append(1)  # $ Alert modification=l
    return l

# OK
def includes(l = []):
    x = [0]
    x.extend(l)
    x.extend([1])
    return x

def extends(l):
    l.extend([1])  # $ Alert modification=l
    return l

# Not OK
def deferred(l = []):  # $ Source
    extends(l)
    return l

# Not OK
def nonempty(l = [5]):  # $ Source
    l.append(1)  # $ Alert modification=l
    return l

# Not OK
def dict(d = {}):  # $ Source
    d['a'] = 1  # $ Alert modification=d
    return d

# Not OK
def dict_nonempty(d = {'a': 1}):  # $ Source
    d['a'] = 2  # $ Alert modification=d
    return d

# OK
def dict_nonempty_nochange(d = {'a': 1}):  # $ Source
    d['a'] = 1  # $ SPURIOUS: Alert modification=d
    return d

def modifies(d):
    d['a'] = 1  # $ Alert modification=d
    return d

# Not OK
def dict_deferred(d = {}):  # $ Source
    modifies(d)
    return d

# Not OK
def dict_method(d = {}):  # $ Source
    d.update({'a': 1})  # $ Alert modification=d
    return d

# Not OK
def dict_method_nonempty(d = {'a': 1}):  # $ Source
    d.update({'a': 2})  # $ Alert modification=d
    return d

# OK
def dict_method_nonempty_nochange(d = {'a': 1}):  # $ Source
    d.update({'a': 1})  # $ SPURIOUS: Alert modification=d
    return d

def modifies_method(d):
    d.update({'a': 1})  # $ Alert modification=d
    return d

# Not OK
def dict_deferred_method(d = {}):  # $ Source
    modifies_method(d)
    return d

# OK
def dict_includes(d = {}):
    x = {}
    x.update(d)
    x.update({'a': 1})
    return x

# Not OK
def dict_del(d = {'a': 1}):  # $ Source
    del d['a']  # $ Alert modification=d
    return d

# Not OK
def dict_update_op(d = {}):  # $ Source
    x = {'a': 1}
    d |= x  # $ Alert modification=d
    return d

# OK
def dict_update_op_nochange(d = {}):  # $ Source
    x = {}
    d |= x  # $ SPURIOUS: Alert modification=d
    return d

def sanitizer(l = []):  # $ Source
    if l:
        l.append(1)
    else:
        l.append(1)  # $ Alert modification=l
    return l

def sanitizer_negated(l = [1]):  # $ Source
    if not l:
        l.append(1)
    else:
        l.append(1)  # $ Alert modification=l
    return l

def sanitizer(l = []):  # $ Source
    if not l:
        l.append(1)  # $ Alert modification=l
    else:
        l.append(1)
    return l

def sanitizer_negated(l = [1]):  # $ Source
    if l:
        l.append(1)  # $ Alert modification=l
    else:
        l.append(1)
    return l

# indirect modification of parameter with default
def aug_assign_argument(x):
    x += ['x'] # $ Alert modification=x

def mutate_argument(x):
    x.append('x') # $ Alert modification=x

def indirect_modification(y = []):  # $ Source
    aug_assign_argument(y)
    mutate_argument(y)

def guarded_modification(z=[]):
    if z:
        z.append(0)
    return z

# This function causes a discrepancy between the
# Python 2 and 3 versions of the analysis.
# We comment it out until we have resoved the issue.
#
# def issue1143(expr, param=[]):
#     if not param:
#         return result
#     for i in param:
#         param.remove(i) # Mutation here


# Type guarding of modification of parameter with default:

def do_stuff_based_on_type(x):
    if isinstance(x, str):
        x = x.split()
    elif isinstance(x, dict):
        x.setdefault('foo', 'bar') # $ Alert modification=x
    elif isinstance(x, list):
        x.append(5) # $ Alert modification=x
    elif isinstance(x, tuple):
        x = x.unknown_method()

def str_default(x="hello world"):
    do_stuff_based_on_type(x)

def dict_default(x={'baz':'quux'}):  # $ Source
    do_stuff_based_on_type(x)

def list_default(x=[1,2,3,4]):  # $ Source
    do_stuff_based_on_type(x)

def tuple_default(x=(1,2)):
    do_stuff_based_on_type(x)

# Modification of parameter with default (safe method)

def safe_method(x=[]):
    return x.count(42)

# Use of deepcopy:

from copy import deepcopy

def flow_from_within_deepcopy_fp():
    y = deepcopy([])
    y.append(1)

def flow_through_deepcopy_fp(x=[]):
    y = deepcopy(x)
    y.append(1)

# Use of copy method:

def flow_through_copy_fp(x=[]):
    y = x.copy()
    y.append(1)
