import json
from copy import copy
import sys

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

if sys.version_info[0] == 2:
    from urlparse import urlsplit, urlparse, parse_qs, parse_qsl
if sys.version_info[0] == 3:
    from urllib.parse import urlsplit, urlparse, parse_qs, parse_qsl

def test_urlsplit_urlparse():
    tainted_string = TAINTED_STRING
    a = urlsplit(tainted_string)
    b = urlparse(tainted_string)
    c = parse_qs(tainted_string)
    d = parse_qsl(tainted_string)
    test(a, b, c, d)

def test_method_reference():
    tainted_string = TAINTED_STRING

    a = tainted_string.title()

    func = tainted_string.title
    b = func()

    test(a, b) # TODO: `b` not tainted

def test_str_methods():
    tainted_string = TAINTED_STRING

    test(
        tainted_string.capitalize(),
        tainted_string.casefold(),
        tainted_string.center(),
        tainted_string.encode('utf-8'),
        tainted_string.encode('utf-8').decode('utf-8'),
        tainted_string.expandtabs(),
        tainted_string.format(foo=42),
        tainted_string.format_map({'foo': 42}),
        tainted_string.ljust(100),
        tainted_string.lower(),
        tainted_string.lstrip(),
        tainted_string.lstrip('w.'),
        tainted_string.partition(';'),
        tainted_string.partition(';')[0],
        tainted_string.replace('/', '', 1),
        tainted_string.rjust(100),
        tainted_string.rpartition(';'),
        tainted_string.rpartition(';')[2],
        tainted_string.rsplit(';', 4),
        tainted_string.rsplit(';', 4)[-1],
        tainted_string.rstrip(),
        tainted_string.split(),
        tainted_string.split()[0],
        tainted_string.splitlines(),
        tainted_string.splitlines()[0],
        tainted_string.strip(),
        tainted_string.swapcase(),
        tainted_string.title(),
        # ignoring, as I have never seen this in practice
        # tainted_string.translate(translation_table),
        tainted_string.upper(),
        tainted_string.zfill(100),
    )

def test_tainted_file():
    tainted_file = TAINTED_FILE
    test(
        tainted_file,
        tainted_file.read(),
        tainted_file.readline(),
        tainted_file.readlines(),
    )
    for line in tainted_file:
        test(line)
