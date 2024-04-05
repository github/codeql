# six.moves.urllib_request

from six import PY2, PY3

# Generated (six_gen.py) from six version 1.14.0 with Python 2.7.17 (default, Nov 18 2019, 13:12:39)
if PY2:
    import urllib2 as _1
    urlopen = _1.urlopen
    install_opener = _1.install_opener
    build_opener = _1.build_opener
    import urllib as _2
    pathname2url = _2.pathname2url
    url2pathname = _2.url2pathname
    getproxies = _2.getproxies
    Request = _1.Request
    OpenerDirector = _1.OpenerDirector
    HTTPDefaultErrorHandler = _1.HTTPDefaultErrorHandler
    HTTPRedirectHandler = _1.HTTPRedirectHandler
    HTTPCookieProcessor = _1.HTTPCookieProcessor
    ProxyHandler = _1.ProxyHandler
    BaseHandler = _1.BaseHandler
    HTTPPasswordMgr = _1.HTTPPasswordMgr
    HTTPPasswordMgrWithDefaultRealm = _1.HTTPPasswordMgrWithDefaultRealm
    AbstractBasicAuthHandler = _1.AbstractBasicAuthHandler
    HTTPBasicAuthHandler = _1.HTTPBasicAuthHandler
    ProxyBasicAuthHandler = _1.ProxyBasicAuthHandler
    AbstractDigestAuthHandler = _1.AbstractDigestAuthHandler
    HTTPDigestAuthHandler = _1.HTTPDigestAuthHandler
    ProxyDigestAuthHandler = _1.ProxyDigestAuthHandler
    HTTPHandler = _1.HTTPHandler
    HTTPSHandler = _1.HTTPSHandler
    FileHandler = _1.FileHandler
    FTPHandler = _1.FTPHandler
    CacheFTPHandler = _1.CacheFTPHandler
    UnknownHandler = _1.UnknownHandler
    HTTPErrorProcessor = _1.HTTPErrorProcessor
    urlretrieve = _2.urlretrieve
    urlcleanup = _2.urlcleanup
    URLopener = _2.URLopener
    FancyURLopener = _2.FancyURLopener
    proxy_bypass = _2.proxy_bypass
    parse_http_list = _1.parse_http_list
    parse_keqv_list = _1.parse_keqv_list
    del _1
    del _2

# Generated (six_gen.py) from six version 1.14.0 with Python 3.8.0 (default, Nov 18 2019, 13:17:17)
if PY3:
    import urllib.request as _1
    urlopen = _1.urlopen
    install_opener = _1.install_opener
    build_opener = _1.build_opener
    pathname2url = _1.pathname2url
    url2pathname = _1.url2pathname
    getproxies = _1.getproxies
    Request = _1.Request
    OpenerDirector = _1.OpenerDirector
    HTTPDefaultErrorHandler = _1.HTTPDefaultErrorHandler
    HTTPRedirectHandler = _1.HTTPRedirectHandler
    HTTPCookieProcessor = _1.HTTPCookieProcessor
    ProxyHandler = _1.ProxyHandler
    BaseHandler = _1.BaseHandler
    HTTPPasswordMgr = _1.HTTPPasswordMgr
    HTTPPasswordMgrWithDefaultRealm = _1.HTTPPasswordMgrWithDefaultRealm
    AbstractBasicAuthHandler = _1.AbstractBasicAuthHandler
    HTTPBasicAuthHandler = _1.HTTPBasicAuthHandler
    ProxyBasicAuthHandler = _1.ProxyBasicAuthHandler
    AbstractDigestAuthHandler = _1.AbstractDigestAuthHandler
    HTTPDigestAuthHandler = _1.HTTPDigestAuthHandler
    ProxyDigestAuthHandler = _1.ProxyDigestAuthHandler
    HTTPHandler = _1.HTTPHandler
    HTTPSHandler = _1.HTTPSHandler
    FileHandler = _1.FileHandler
    FTPHandler = _1.FTPHandler
    CacheFTPHandler = _1.CacheFTPHandler
    UnknownHandler = _1.UnknownHandler
    HTTPErrorProcessor = _1.HTTPErrorProcessor
    urlretrieve = _1.urlretrieve
    urlcleanup = _1.urlcleanup
    URLopener = _1.URLopener
    FancyURLopener = _1.FancyURLopener
    proxy_bypass = _1.proxy_bypass
    parse_http_list = _1.parse_http_list
    parse_keqv_list = _1.parse_keqv_list
    del _1
