import json
from copy import copy

def test_json():
    tainted_string = TAINTED
    tainted_json = json.loads(tainted_string)
    a = tainted_json["x"]
    b = a.get("y")
    c = b["z"]

def test_list(x, y, z):
    tainted_list = TAINTED_LIST
    a = tainted_list[0]
    b = tainted_list[x]
    c = tainted_list[y:z]
    d = tainted_list.copy()
    e, f, g = tainted_list # TODO: currently not handled

def test_dict(x):
    tainted_dict = TAINTED_DICT
    a = tainted_dict["name"]
    b = tainted_dict[x]
    c = tainted_dict.copy()
    for d in tainted_dict.values():
        d
    # TODO: currently not recognizing tainted_dict.items()
    for _, e in tainted_dict.items():
        e

def test_str():
    tainted_string = TAINTED
    a = tainted_string.ljust(8)
    b = tainted_string.copy()
    c = tainted_string[:]
    d = tainted_string[::2]
    e = reversed(tainted_string)
    f = copy(tainted_string)
    h = tainted_string.strip()
    tainted_list = [tainted_string]
    tainted_tuple = (tainted_string,)
    tainted_dict = {'key': tainted_string}

def test_const_sanitizer1():
    tainted_string = TAINTED
    if tainted_string == "OK":
        not_tainted(tainted_string)
    else:
        still_tainted(tainted_string)

def test_const_sanitizer2():
    tainted_string = TAINTED
    if tainted_string == "OK" or tainted_string == "ALSO_OK":
        not_tainted(tainted_string)
    else:
        still_tainted(tainted_string)

def test_str2():
    tainted_string = TAINTED
    a = str(tainted_string)
    b = bytes(tainted_string) # This is an error in Python 3
    c = bytes(tainted_string, encoding="utf8") # This is an error in Python 2

def cross_over(func, taint):
    return func(taint)

def test_exc_info():
    info = TAINTED_EXCEPTION_INFO
    res = cross_over(exc_info_call, info)

def exc_info_call(arg):
    return arg

def test_untrusted():
    ext = TAINTED_EXTERNAL_STRING
    res = cross_over(untrusted_call, ext)

def exc_untrusted_call(arg):
    return arg
