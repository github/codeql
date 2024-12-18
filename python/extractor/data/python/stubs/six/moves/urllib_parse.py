# six.moves.urllib_parse

from six import PY2, PY3

# Generated (six_gen.py) from six version 1.14.0 with Python 2.7.17 (default, Nov 18 2019, 13:12:39)
if PY2:
    import urlparse as _1
    ParseResult = _1.ParseResult
    SplitResult = _1.SplitResult
    parse_qs = _1.parse_qs
    parse_qsl = _1.parse_qsl
    urldefrag = _1.urldefrag
    urljoin = _1.urljoin
    urlparse = _1.urlparse
    urlsplit = _1.urlsplit
    urlunparse = _1.urlunparse
    urlunsplit = _1.urlunsplit
    import urllib as _2
    quote = _2.quote
    quote_plus = _2.quote_plus
    unquote = _2.unquote
    unquote_plus = _2.unquote_plus
    unquote_to_bytes = _2.unquote
    urlencode = _2.urlencode
    splitquery = _2.splitquery
    splittag = _2.splittag
    splituser = _2.splituser
    splitvalue = _2.splitvalue
    uses_fragment = _1.uses_fragment
    uses_netloc = _1.uses_netloc
    uses_params = _1.uses_params
    uses_query = _1.uses_query
    uses_relative = _1.uses_relative
    del _1
    del _2

# Generated (six_gen.py) from six version 1.14.0 with Python 3.8.0 (default, Nov 18 2019, 13:17:17)
if PY3:
    import urllib.parse as _1
    ParseResult = _1.ParseResult
    SplitResult = _1.SplitResult
    parse_qs = _1.parse_qs
    parse_qsl = _1.parse_qsl
    urldefrag = _1.urldefrag
    urljoin = _1.urljoin
    urlparse = _1.urlparse
    urlsplit = _1.urlsplit
    urlunparse = _1.urlunparse
    urlunsplit = _1.urlunsplit
    quote = _1.quote
    quote_plus = _1.quote_plus
    unquote = _1.unquote
    unquote_plus = _1.unquote_plus
    unquote_to_bytes = _1.unquote_to_bytes
    urlencode = _1.urlencode
    splitquery = _1.splitquery
    splittag = _1.splittag
    splituser = _1.splituser
    splitvalue = _1.splitvalue
    uses_fragment = _1.uses_fragment
    uses_netloc = _1.uses_netloc
    uses_params = _1.uses_params
    uses_query = _1.uses_query
    uses_relative = _1.uses_relative
    del _1
