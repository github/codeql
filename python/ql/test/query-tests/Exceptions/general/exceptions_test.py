
#Empty Except

def ee1(val):
    try:
        val.attr
    except:
        pass

def ee1(val):
    try:
        val.attr()
    except TypeError:
        pass

def ee2(val):
    try:
        val.attr
    except Error:
        #But it is OK if there is a comment
        pass

#OK with an else clause as well...

def ee3(val):
    try:
        val.attr
    except Error:
        pass
    else:
       return 42

class NotException1(object):
    pass

class NotException2(object):
    pass

def illegal_raise_type():
    raise NotException1

def illegal_raise_value1():
    raise "Exception"

def illegal_raise_value2():
    raise NotException2()

def illegal_handler():
    try:
        illegal_raise()
    except NotException1:
        #Must do something
        print("NotException1")
    except NotException2:
        #Must do something
        print("NotException2")


#Incorrect except order
try:
    val.attr
except Exception:
    print (2)
except AttributeError:
    print (3)
    
#Catch BaseException
def catch_base_exception():
    try:
        illegal_raise()
    except BaseException:
        #Consumes KeyboardInterrupt
        pass
    
def catch_base_exception_ok():
    try:
        illegal_raise()
    except BaseException:
        raise
    
def legal_handler1():
    try:
        illegal_raise()
    except (IOError, KeyError):
        print ("Caught exception")

pair = IOError, KeyError
triple = pair, AttributeError

def legal_handler2():
    try:
        illegal_raise()
    except pair:
        print ("Caught exception")
    try:
        illegal_raise()
    except triple:
        print ("Caught exception")

def legal_handler3():
    try:
        illegal_raise()
    except could_be_anything():
        print ("Caught exception")

def a_number():
    return 4.0

def illegal_handler2():
    try:
        illegal_raise()
    except a_number():
        print ("Caught exception")

def stop_iter_ok(seq):
    try:
        next(seq)
    except StopIteration:
        pass

#Guarded None in nested function
def f(x=None):
    def inner(arg):
        if x:
            raise x

#ODASA-4705
def g(cond):
    try:
        if cond:
            return may_raise_io_error()
        else:
            raise KeyError
    except IOError:
        pass # This is OK, as it is just passing to the following statement which handles the exception.
    return 0

def ee4(x):
    try:
        del x.attr
    except AttributeError:
        pass

def ee5(x):
    try:
        x[0]
    except IndexError:
        pass

def ee6(x):
    try:
       del x[0]
    except IndexError:
        pass

def ee7(x):
    try:
        delattr(x, "attr")
    except AttributeError:
        pass

def ee8(x):
    try:
        x.encode("martian-18")
    except UnicodeEncodeError:
        pass

 #These are so common, we  give warnings not errors.
def foo():
    raise NotImplemented

def bar():
    raise NotImplemented()
