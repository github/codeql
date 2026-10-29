#We don't (yet) follow this import
fail = __import__("odasa%s" % 6418).fail

def foo(x):
    if x:
        var = 0
    else:
        fail('Current version is not numeric')
    return var
