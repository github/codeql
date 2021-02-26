import socket
import ssl

def test_fluent_tls():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_TLS)

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())


def test_fluent_tls_no_TLSv1():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    context.options |= ssl.OP_NO_TLSv1

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_fluent_tls_safe():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    context.options |= ssl.OP_NO_TLSv1
    context.options |= ssl.OP_NO_TLSv1_1

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_fluent_ssl():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())


def test_fluent_ssl_no_TLSv1():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
    context.options |= ssl.OP_NO_TLSv1

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_fluent_ssl_safe():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
    context.options |= ssl.OP_NO_TLSv1
    context.options |= ssl.OP_NO_TLSv1_1

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_fluent_ssl_safe_combined():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)
    context.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

# From Python 3.7
# see https://docs.python.org/3/library/ssl.html#ssl.SSLContext.minimum_version
def test_fluent_ssl_unsafe_version():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    context.minimum_version = ssl.TLSVersion.TLSv1_1

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_fluent_ssl_safe_version():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    context.minimum_version = ssl.TLSVersion.TLSv1_3

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

# Taken from https://docs.python.org/3/library/ssl.html#context-creation
def test_fluent_explicitly_unsafe():
    hostname = 'www.python.org'
    context = ssl.create_default_context(ssl.Purpose.CLIENT_AUTH)
    context.options &= ~ssl.OP_NO_SSLv3  # This not recognized

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:  # SSLv3 not flagged here
            print(ssock.version())
