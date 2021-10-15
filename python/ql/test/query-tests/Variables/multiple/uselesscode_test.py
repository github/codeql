
#Multiple declarations

def mult(a):
    x = 1
    y = a
    x = 2
    #Need to use x, otherwise it is ignored
    #(The UnusedLocalVariable query will pick it up)
    return x

def unique():
    pass

def mult(x,y):
    pass

#OK for multiple definition
import M
M = none

def _double_loop(seq):
    for i in seq:
        pass
    for i in seq:
        pass

class Mult(object):

    pass

class C(object):

    def m(self):
        pass

class Mult(object):
    pass

### Tests inspired by real-world false positives
def isStr(s):
        ok = ''
        try:
                ok += s
        except TypeError:
                return 0
        return 1

# 'bad' actually *is* always redefined before being read.
def have_nosmp():
    try:
        bad = os.environ['NPY_NOSMP']
        bad = 1
    except KeyError:
        bad = 0
    return bad

def simple_try(foo):
    try:
        ok = foo.bar
    except AttributeError:
        ok = 'default'
    return ok

def try_with_else(foo):
    try:
        bad = foo.bar
    except AttributeError:
        raise
    else:
        bad = 'overwrite'
    return bad

# This should be fine
def append_all(xs):
    global __doc__
    __doc__ += "all xs:"
    for x in xs:
        __doc__ += x

def append_local(xs):
    doc = ""
    doc += "xs:"
    for x in xs:
        doc += x
    return doc

#ODASA-4100
def odasa4100(name, language, options = ''):
    distro_files = []
    if language == 'distro-cpp':
        distro_files = [ "file" ]
    if distro_files:
        emit_odasa_deps()
    #Flow-graph splitting will make this definition unused on the distro_files is True branch
    env = ''
    if distro_files:
        env = 'env "ODASA_HOME=' + _top + '/' + distro_path + '" '
    emit_cmd(env + "some other stuff")

#ODASA-4166

#This is OK as the first definition is a "declaration"
def odasa4166(cond):
    x = None
    if cond:
        x = some_value()
    else:
        x = default_value()
    return x


#ODASA-5315
def odasa5315():
    x, y = foo() # OK as y is used
    use(y)
    x, y = bar() # Not OK as neither x nor y are used.
    x, y = baz() # OK as both used
    return x + y

@multimethod(int)
def foo(i):
    pass

@multimethod(float)
def foo(f):
    pass

