class _ElementTree(object):
    def xpath(self, _path, namespaces=None, extensions=None, smart_strings=True, **_variables):
        pass

    def xslt(self, _xslt, extensions=None, access_control=None, **_kw):
        pass


class ETXPath(object):
    def __init__(self, path, extensions=None, regexp=True, smart_strings=True):
        pass


class XPath(object):
    def __init__(self, path, namespaces=None, extensions=None, regexp=True, smart_strings=True):
        pass


class XSLT(object):
    def __init__(self, xslt_input, extensions=None, regexp=True, access_control=None):
        pass


def parse(self, parser=None, base_url=None):
    return _ElementTree()


def fromstring(self, text, parser=None, base_url=None):
    pass


def fromstringlist(self, strings, parser=None):
    pass


def XML(self, text, parser=None, base_url=None):
    pass
