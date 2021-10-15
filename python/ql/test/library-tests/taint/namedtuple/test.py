from six.moves.urllib.parse import urlsplit

# Currently we don't have support for namedtuples in general, but do have special support
# for `urlsplit` (and `urlparse`)

def test_basic():
    tainted_string = TAINTED_STRING
    urlsplit_res = urlsplit(tainted_string)
    a = urlsplit_res.netloc # field access
    b = urlsplit_res.hostname # property
    c = urlsplit_res[3] # indexing
    _, _, d, _, _ = urlsplit(tainted_string) # unpacking
    test(a, b, c, d, urlsplit_res)

def test_sanitizer():
    tainted_string = TAINTED_STRING
    urlsplit_res = urlsplit(tainted_string)

    test(urlsplit_res.netloc) # should be tainted

    if urlsplit_res.netloc == "OK":
        test(urlsplit_res.netloc)

    if urlsplit_res[2] == "OK":
        test(urlsplit_res[0])

    if urlsplit_res.netloc == "OK":
        test(urlsplit_res.path) # FN

    if urlsplit_res.netloc in ["OK"]:
        test(urlsplit_res.netloc)

    if urlsplit_res.netloc in ["OK", non_constant()]:
        test(urlsplit_res.netloc) # should be tainted

def test_namedtuple():
    tainted_string = TAINTED_STRING
    Point = namedtuple('Point', ['x', 'y'])
    p = Point('safe', tainted_string)
    a = p.x
    b = p.y
    c = p[0]
    d = p[1]
    test(a, b, c, d) # TODO: FN, at least p.y and p[1] should be tainted
