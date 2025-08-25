# six.moves.urllib_response

from six import PY2, PY3

# Generated (six_gen.py) from six version 1.14.0 with Python 2.7.17 (default, Nov 18 2019, 13:12:39)
if PY2:
    import urllib as _1
    addbase = _1.addbase
    addclosehook = _1.addclosehook
    addinfo = _1.addinfo
    addinfourl = _1.addinfourl
    del _1

# Generated (six_gen.py) from six version 1.14.0 with Python 3.8.0 (default, Nov 18 2019, 13:17:17)
if PY3:
    import urllib.response as _1
    addbase = _1.addbase
    addclosehook = _1.addclosehook
    addinfo = _1.addinfo
    addinfourl = _1.addinfourl
    del _1
