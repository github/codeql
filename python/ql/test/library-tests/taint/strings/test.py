import json
from copy import copy

def test_json():
    tainted_string = TAINTED_STRING
    tainted_json = json.loads(tainted_string)
    a = tainted_json["x"]
    b = a.get("y")
    c = b["z"]
    test(a, b, c)

def test_str():
    tainted_string = TAINTED_STRING
    a = tainted_string.ljust(8)
    b = tainted_string.copy()
    c = tainted_string[:]
    d = tainted_string[::2]
    e = reversed(tainted_string)
    f = copy(tainted_string)
    g = tainted_string.strip()
    test(a, b, c, d, e, f, g)

def test_const_sanitizer1():
    tainted_string = TAINTED_STRING
    if tainted_string == "OK":
        test(tainted_string) # not tainted
    else:
        test(tainted_string) # still tainted

def test_const_sanitizer2():
    tainted_string = TAINTED_STRING
    if tainted_string == "OK" or tainted_string == "ALSO_OK":
        test(tainted_string) # not tainted
    else:
        test(tainted_string) # still tainted

def test_str2():
    tainted_string = TAINTED_STRING
    a = str(tainted_string)
    b = bytes(tainted_string) # This is an error in Python 3
    c = bytes(tainted_string, encoding="utf8") # This is an error in Python 2
    test(a, b, c)

def cross_over(func, taint):
    return func(taint)

def test_exc_info():
    info = TAINTED_EXCEPTION_INFO
    res = cross_over(exc_info_call, info)
    test(res)

def exc_info_call(arg):
    return arg

def test_untrusted():
    ext = TAINTED_STRING
    res = cross_over(untrusted_call, ext)
    test(res)

def exc_untrusted_call(arg):
    return arg

from six.moves.urllib.parse import urlsplit, urlparse

def test_urlsplit_urlparse():
    tainted_string = TAINTED_STRING
    urlsplit_res = urlsplit(tainted_string)
    urlparse_res = urlparse(tainted_string)
    test(urlsplit_res, urlparse_res)
