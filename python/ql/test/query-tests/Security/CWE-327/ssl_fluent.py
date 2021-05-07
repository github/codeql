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

def test_fluent_tls_client_no_TLSv1():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_CLIENT)
    context.options |= ssl.OP_NO_TLSv1

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_fluent_tls_server_no_TLSv1():
    hostname = 'www.python.org'
    context = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
    context.options |= ssl.OP_NO_TLSv1

    with socket.create_server((hostname, 443)) as sock:
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
    # notice that `ssl.PROTOCOL_SSLv23` is just a deprecated alias for `ssl.PROTOCOL_TLS`.
    # Therefore, we only have this one test using PROTOCOL_SSLv23, to show that we handle this alias correctly.
    context = ssl.SSLContext(ssl.PROTOCOL_SSLv23)

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())


def create_relaxed_context():
    return ssl.SSLContext(ssl.PROTOCOL_TLS)

def create_secure_context():
    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    context.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1
    return context

def create_connection(context):
    with socket.create_connection(('www.python.org', 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_delegated_context_unsafe():
    context = create_relaxed_context()
    with socket.create_connection(('www.python.org', 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_delegated_context_safe():
    context = create_secure_context()
    with socket.create_connection(('www.python.org', 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_delegated_context_made_safe():
    context = create_relaxed_context()
    context.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1
    with socket.create_connection(('www.python.org', 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_delegated_context_made_unsafe():
    context = create_secure_context()
    context.options &= ~ssl.OP_NO_TLSv1_1
    with socket.create_connection(('www.python.org', 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

def test_delegated_connection_unsafe():
    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    create_connection(context)

def test_delegated_connection_safe():
    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    context.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1
    create_connection(context)

def test_delegated_connection_made_safe():
    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    context.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1
    create_connection(context)

def test_delegated_connection_made_unsafe():
    context = ssl.SSLContext(ssl.PROTOCOL_TLS)
    context.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1
    context.options &= ~ssl.OP_NO_TLSv1_1
    create_connection(context)

def test_delegated_unsafe():
    context = create_relaxed_context()
    create_connection(context)

def test_delegated_safe():
    context = create_secure_context()
    create_connection(context)

def test_delegated_made_safe():
    context = create_relaxed_context()
    context.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1
    create_connection(context)

def test_delegated_made_unsafe():
    context = create_secure_context()
    context.options &= ~ssl.OP_NO_TLSv1_1
    create_connection(context)

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
    context.options &= ~ssl.OP_NO_SSLv3

    with socket.create_connection((hostname, 443)) as sock:
        with context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())
