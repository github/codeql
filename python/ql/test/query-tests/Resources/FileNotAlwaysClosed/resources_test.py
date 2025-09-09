#File not always closed

def not_close1():
    f1 = open("filename") # $ Alert # not closed on exception
    f1.write("Error could occur")
    f1.close() 

def not_close2():
    f2 = open("filename") # $ Alert 

def closed3():
    f3 = open("filename")
    f3.close()

def closed4():
    with open("filename") as f4:
        f4.write("Error could occur")

def closed5():
    f5 = open("filename")
    try:
        f5.write("Error could occur")
    finally:
        f5.close()

#Correctly guarded close()
def closed6():
    f6 = None
    try:
        f6 = open("filename")
        f6.write("Error could occur")
    finally:
        if f6:
            f6.close()

def closed7():
    f7 = None
    try:
        f7 = open("filename")
        f7.write("Error could occur")
    finally:
        if not f7 is None:
            f7.close()

#Incorrectly guarded close()
def not_closed8():
    f8 = None
    try:
        f8 = open("filename") # $ MISSING:Alert # not closed on exception 
        f8.write("Error could occur")
    finally:
        if f8 is None: # We don't precisely consider this condition, so this result is MISSING. However, this seems uncommon.
            f8.close()

def not_closed9():
    f9 = None
    try:
        f9 = open("filename") # $ MISSING:notAlwaysClosed
        f9.write("Error could occur")
    finally:
        if not f9: # We don't precisely consider this condition, so this result is MISSING.However, this seems uncommon.
            f9.close()

def not_closed_but_cant_tell_locally():
    return open("filename")

#Closed by handling the correct exception
def closed10():
    f10 = open("filename")
    try:
        f10.write("IOError could occur")
        f10.write("IOError could occur")
        f10.close()
    except IOError:
        f10.close()

#Not closed by handling the wrong exception
def not_closed11():
    f11 = open("filename") # $ MISSING:notAlwaysClosed
    try:
        f11.write("IOError could occur")
        f11.write("IOError could occur")
        f11.close()
    except AttributeError: # We don't consider the type of exception handled here, so this result is MISSING.
        f11.close()

def doesnt_raise(*args):
    pass

def mostly_closed12():
    f12 = open("filename") 
    try:
        f12.write("IOError could occur")
        f12.write("IOError could occur")
        doesnt_raise("Potential false positive here")
        f12.close()
    except IOError:
        f12.close()

def opener_func1(name):
    return open(name)

def opener_func2(name):
    t1 = opener_func1(name)
    return t1

def not_closed13(name):
    f13 = open(name) # $ Alert 
    f13.write("Hello")

def may_not_be_closed14(name):
    f14 = opener_func2(name) # $ Alert # not closed on exception
    f14.write("Hello")
    f14.close()

def closer1(t2):
    t2.close()

def closer2(t3):
    closer1(t3)

def closed15():
    f15 = opener_func2() # $ SPURIOUS:Alert 
    closer2(f15) # We don't detect that this call closes the file, so this result is SPURIOUS.


def may_not_be_closed16(name):
    try:
        f16 = open(name) # $ Alert # not closed on exception
        f16.write("Hello")
        f16.close()
    except IOError:
        pass

def may_raise():
    if random():
        raise ValueError()

#Not handling all exceptions, but we'll tolerate the false negative
def not_closed17():
    f17 = open("filename") # $ MISSING:Alert # not closed on exception
    try:
        f17.write("IOError could occur")
        f17.write("IOError could occur")
        may_raise("ValueError could occur") # FN here.
        f17.close()
    except IOError: # We don't detect that a ValueErrror could be raised that isn't handled here, so this result is MISSING.
        f17.close()

#ODASA-3779
#With statement will close the fp
def closed18(path):
    try:
        f18 = open(path) 
    except IOError as ex:
        print(ex)
        raise ex
    with f18: 
        f18.read()

class Closed19(object):

    def __enter__(self):
        self.fd = open("Filename")

    def __exit__(self, *args):
        self.fd.close()

class FileWrapper(object):

    def __init__(self, fp):
        self.fp = fp

def closed20(path):
    f20 = open(path)
    return FileWrapper(f20)

#ODASA-3105
def run(nodes_module):
    use_file = len(sys.argv) > 1
    if use_file:
        out = open(sys.argv[1], 'w', encoding='utf-8')
    else:
        out = sys.stdout
    try:
        out.write("spam")
    finally:
        if use_file:
            out.close()

#ODASA-3515
class GraphVizTrapWriter(object):

    def __init__(self, out):
        if out is None:
            self.out = sys.stdout
        else:
            self.out = open(out, 'w')
        self.pool = GraphVizIdPool(self.out)

    def __del__(self):
        if self.out != sys.stdout:
            self.out.close()

#Returned as part of tuple
def f(name, path):
    try:
        path = path.attr
        file = open(path, 'rb')
    except AttributeError:
        # ExtensionLoader has not attribute get_filename, instead it has a
        # path attribute that we can use to retrieve the module path
        try:
            path = path.other_attr
            file = open(path, 'rb')
        except AttributeError:
            path = name
            file = None

    return file, path


#ODASA-5891
def closed21(path):
    f21 = open(path, "wb")
    try:
        f21.write(b"foo")
        may_raise()
        if foo:
            f21.close()
    finally:
        if not f21.closed:
            f21.close()


def not_closed22(path):
    f22 = open(path, "wb") # $ MISSING:Alert # not closed on exception
    try:
        f22.write(b"foo")
        may_raise()
        if foo:
            f22.close()
    finally:
        if f22.closed: # We don't precisely consider this condition, so this result is MISSING. However, this seems uncommon.
            f22.close()

def not_closed23(path):
    f23 = open(path, "w") # $ Alert 
    wr = FileWrapper(f23)

def closed24(path):
    f24 = open(path, "w")
    try:
        f24.write("hi")
    except:
        pass 
    f24.close()

def closed25(path):
    from django.http import FileResponse 
    return FileResponse(open(path))

import os
def closed26(path):
    fd = os.open(path)
    os.close(fd)

def not_closed27(path):
    fd = os.open(path, "w") # $Alert # not closed on exception
    f27 = os.fdopen(fd, "w")
    f27.write("hi")
    f27.close()

def closed28(path):
    fd = os.open(path, os.O_WRONLY) 
    f28 = os.fdopen(fd, "w")
    try:
        f28.write("hi")
    finally:
        f28.close()

def closed29(path):
    # Due to an approximation in CFG reachability for performance, it is not detected that the `write` call that may raise occurs after the file has already been closed.
    # We presume this case to be uncommon.
    f28 = open(path) # $SPURIOUS:Alert # not closed on exception 
    f28.close()
    f28.write("already closed") 

# False positive in a previous implementation:

class NotWrapper:
    def __init__(self, fp):
        self.data = fp.read()
        fp.close()

    def do_something(self):
        pass 

def closed30(path):
    # Combination of approximations resulted in this FP:
    # - NotWrapper is treated as a wrapper class as a file handle is passed to it 
    # - thing.do_something() is treated as a call that can raise an exception while a file is open
    # - this call is treated as occurring after the open but not as being guarded by the with statement, as it is in the same basic block
    # - - this behavior has been changed fixing the FP

    with open(path) as fp: # No longer spurious alert here.
        thing = NotWrapper(fp)

    thing.do_something() 


def closed31(path):
    with open(path) as fp: 
        data = fp.readline()
        data2 = fp.readline()


class Wrapper():
    def __init__(self, f):
        self.f = f
    def read(self):
        return self.f.read()
    def __enter__(self):
        pass
    def __exit__(self,exc_type, exc_value,traceback):
        self.f.close()

def closed32(path):
    with open(path, "rb") as f: # No longer spurious alert here.
        wrap = Wrapper(f)
        # This resulted in an FP in a previous implementation, 
        # due to a check that an operation is lexically contained within a `with` block (with `expr.getParent*()`)
        # not detecting this case.
        return list(wrap.read())