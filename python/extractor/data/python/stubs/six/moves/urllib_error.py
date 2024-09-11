# six.moves.urllib_error

from six import PY2, PY3

# Generated (six_gen.py) from six version 1.14.0 with Python 2.7.17 (default, Nov 18 2019, 13:12:39)
if PY2:
    import urllib2 as _1
    URLError = _1.URLError
    HTTPError = _1.HTTPError
    import urllib as _2
    ContentTooShortError = _2.ContentTooShortError
    del _1
    del _2

# Generated (six_gen.py) from six version 1.14.0 with Python 3.8.0 (default, Nov 18 2019, 13:17:17)
if PY3:
    import urllib.error as _1
    URLError = _1.URLError
    HTTPError = _1.HTTPError
    ContentTooShortError = _1.ContentTooShortError
    del _1
