# Not OK
def simple(l = [0]):
    l[0] = 1  #$ modification=l
    return l

# Not OK
def slice(l = [0]):
    l[0:1] = 1  #$ modification=l
    return l

# Not OK
def list_del(l = [0]):
    del l[0]  #$ modification=l
    return l

# Not OK
def append_op(l = []):
    l += [1, 2, 3]  #$ modification=l
    return l

# Not OK
def repeat_op(l = [0]):
    l *= 3  #$ modification=l
    return l

# Not OK
def append(l = []):
    l.append(1)  #$ modification=l
    return l

# OK
def includes(l = []):
    x = [0]
    x.extend(l)
    x.extend([1])
    return x

def extends(l):
    l.extend([1])  #$ modification=l
    return l

# Not OK
def deferred(l = []):
    extends(l)
    return l

# Not OK
def nonempty(l = [5]):
    l.append(1)  #$ modification=l
    return l

# Not OK
def dict(d = {}):
    d['a'] = 1  #$ modification=d
    return d

# Not OK
def dict_nonempty(d = {'a': 1}):
    d['a'] = 2  #$ modification=d
    return d

# OK
def dict_nonempty_nochange(d = {'a': 1}):
    d['a'] = 1  #$ SPURIOUS: modification=d
    return d

def modifies(d):
    d['a'] = 1  #$ modification=d
    return d

# Not OK
def dict_deferred(d = {}):
    modifies(d)
    return d

# Not OK
def dict_method(d = {}):
    d.update({'a': 1})  #$ modification=d
    return d

# Not OK
def dict_method_nonempty(d = {'a': 1}):
    d.update({'a': 2})  #$ modification=d
    return d

# OK
def dict_method_nonempty_nochange(d = {'a': 1}):
    d.update({'a': 1})  #$ SPURIOUS:modification=d
    return d

def modifies_method(d):
    d.update({'a': 1})  #$ modification=d
    return d

# Not OK
def dict_deferred_method(d = {}):
    modifies_method(d)
    return d

# OK
def dict_includes(d = {}):
    x = {}
    x.update(d)
    x.update({'a': 1})
    return x

# Not OK
def dict_del(d = {'a': 1}):
    del d['a']  #$ modification=d
    return d

# Not OK
def dict_update_op(d = {}):
    x = {'a': 1}
    d |= x  #$ modification=d
    return d

# OK
def dict_update_op_nochange(d = {}):
    x = {}
    d |= x  #$ SPURIOUS: modification=d
    return d

def sanitizer(l = []):
    if l:
        l.append(1)
    else:
        l.append(1)  #$ modification=l
    return l

def sanitizer_negated(l = [1]):
    if not l:
        l.append(1)
    else:
        l.append(1)  #$ modification=l
    return l

def sanitizer(l = []):
    if not l:
        l.append(1)  #$ modification=l
    else:
        l.append(1)
    return l

def sanitizer_negated(l = [1]):
    if l:
        l.append(1)  #$ modification=l
    else:
        l.append(1)
    return l
