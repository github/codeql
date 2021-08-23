# Not OK
def simple(l = []):
    l.append(1)
    return l

# OK
def includes(l = []):
    x = [0]
    x.extend(l)
    x.extend([1])  # FP
    return x

def extends(l):
    l.extend([1])
    return l

# Not OK
def deferred(l = []):
    extends(l)
    return l

# Not OK
def nonempty(l = [5]):
    l.append(1)
    return l

# Not OK
def dict(d = {}):
    d['a'] = 1  # FN
    return d

# Not OK
def dict_nonempty(d = {'a': 1}):
    d['a'] = 2  # FN
    return d

# OK
def dict_nonempty_nochange(d = {'a': 1}):
    d['a'] = 1
    return d

def modifies(d):
    d['a'] = 1  # FN
    return d

# Not OK
def dict_deferred(d = {}):
    modifies(d)
    return d

# Not OK
def dict_method(d = {}):
    d.update({'a': 1})
    return d

# Not OK
def dict_method_nonempty(d = {'a': 1}):
    d.update({'a': 2})
    return d

# OK
def dict_method_nonempty_nochange(d = {'a': 1}):
    d.update({'a': 1})  # FP
    return d

def modifies_method(d):
    d.update({'a': 1})
    return d

# Not OK
def dict_deferred_method(d = {}):
    modifies_method(d)
    return d

# OK
def dict_includes(d = {}):
    x = {}
    x.update(d)
    x.update({'a': 1})  # FP
    return x
