import socket
from OpenSSL import SSL

def test_fluent():
    hostname = 'www.python.org'
    context = SSL.Context(SSL.SSLv23_METHOD)

    conn = SSL.Connection(context, socket.socket(socket.AF_INET, socket.SOCK_STREAM))
    r = conn.connect((hostname, 443))
    print(conn.get_protocol_version_name())


def test_fluent_no_TLSv1():
    hostname = 'www.python.org'
    context = SSL.Context(SSL.SSLv23_METHOD)
    context.set_options(SSL.OP_NO_TLSv1)

    conn = SSL.Connection(context, socket.socket(socket.AF_INET, socket.SOCK_STREAM))
    r = conn.connect((hostname, 443))
    print(conn.get_protocol_version_name())


def test_fluent_safe():
    hostname = 'www.python.org'
    context = SSL.Context(SSL.SSLv23_METHOD)
    context.set_options(SSL.OP_NO_SSLv2)
    context.set_options(SSL.OP_NO_SSLv3)
    context.set_options(SSL.OP_NO_TLSv1)
    context.set_options(SSL.OP_NO_TLSv1_1)

    conn = SSL.Connection(context, socket.socket(socket.AF_INET, socket.SOCK_STREAM))
    r = conn.connect((hostname, 443))
    print(r, conn.get_protocol_version_name())
    
def test_safe_by_construction():
    hostname = 'www.python.org'
    context = SSL.Context(SSL.TLSv1_2_METHOD)

    conn = SSL.Connection(context, socket.socket(socket.AF_INET, socket.SOCK_STREAM))
    r = conn.connect((hostname, 443))
    print(conn.get_protocol_version_name())
