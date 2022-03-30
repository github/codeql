import sys
PY2 = sys.version_info[0] == 2
PY3 = sys.version_info[0] == 3

if PY2:
    from httplib import HTTPConnection, HTTPSConnection
if PY3:
    from http.client import HTTPConnection, HTTPSConnection


def basic():
    conn = HTTPConnection('example.com')
    conn.request('GET', '/path')


def indirect_caller():
    conn = HTTPSConnection('example.com')
    indirect_callee(conn)


def indirect_callee(conn):
    conn.request('POST', '/path')


def method_not_known(method):
    conn = HTTPConnection('example.com')
    conn.request(method, '/path')


def sneaky_setting_host():
    # We don't handle that the host is overwritten directly.
    # A contrived example; you're not supposed to do this, but you certainly can.
    fake = 'fakehost.com'
    real = 'realhost.com'
    conn = HTTPConnection(fake)
    conn.host = real
    conn.request('GET', '/path')


def tricky_not_attribute_node():
    # A contrived example; you're not supposed to do this, but you certainly can.
    conn = HTTPConnection('example.com')
    req_meth = conn.request
    req_meth('HEAD', '/path')
