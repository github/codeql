
def f(a, x):
    try:
        a[x]
        a.b
        a(x)
        raise Exception()
    except AttributeError:
        pass
    except IndexError:
        pass
    except KeyError:
        pass
    except:
        pass

def g(a, x):
    try:
        a[x]
        a.b
        a(x)
        raise Exception()
    except AttributeError:
        pass
    except IndexError:
        pass
    except KeyError:
        pass
    finally:
        pass

def h(a, x):
    try:
        a[x]
        a.b
        a(x)
        raise Exception()
    except AttributeError:
        pass
    except IndexError:
        pass
    except KeyError:
        pass

#I/O stuff.
 
def doesnt_raise():
    pass

def io():
    f12 = open("filename")
    try:
        f12.read("IOError could occur")
        f12.write("IOError could occur")
        doesnt_raise("Potential false positive here")
        f12.close()
    except IOError:
        f12.close()

