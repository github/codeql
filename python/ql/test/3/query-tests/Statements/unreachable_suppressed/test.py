from contextlib import suppress

def raises_exception():
    raise Exception("This will be suppressed")

def foo():
    test = False
    with suppress(Exception):
        raises_exception()
        test = True
    if test:
        return
    print("An exception was raised") # FP: not reached

foo()

def bar(x):
    test = False
    try:
        if x:
            raise Exception("Bar")
        test = True
    except Exception:
        pass
    if test:
        print("Test was set")
        return
    print("Test was not set")

bar(True)
bar(False)

# False negative

def fn_suppression():
    with suppress(Exception):
        raise Exception()
    return False
    return True
