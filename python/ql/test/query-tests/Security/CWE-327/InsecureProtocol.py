import ssl
from pyOpenSSL import SSL
from ssl import SSLContext

# true positives
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_SSLv2)
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_SSLv3)
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_TLSv1)

SSLContext(protocol=ssl.PROTOCOL_SSLv2)
SSLContext(protocol=ssl.PROTOCOL_SSLv3)
SSLContext(protocol=ssl.PROTOCOL_TLSv1)

SSL.Context(SSL.SSLv2_METHOD)
SSL.Context(SSL.SSLv23_METHOD)
SSL.Context(SSL.SSLv3_METHOD)
SSL.Context(SSL.TLSv1_METHOD)

# not relevant
wrap_socket(ssl_version=ssl.PROTOCOL_SSLv3)
wrap_socket(ssl_version=ssl.PROTOCOL_TLSv1)
wrap_socket(ssl_version=ssl.PROTOCOL_SSLv2)

Context(SSL.SSLv3_METHOD)
Context(SSL.TLSv1_METHOD)
Context(SSL.SSLv2_METHOD)
Context(SSL.SSLv23_METHOD)

# true positive using flow

METHOD = SSL.SSLv2_METHOD
SSL.Context(METHOD)

# secure versions

ssl.wrap_socket(ssl_version=ssl.PROTOCOL_TLSv1_1)
SSLContext(protocol=ssl.PROTOCOL_TLSv1_1)
SSL.Context(SSL.TLSv1_1_METHOD)

# possibly insecure default
ssl.wrap_socket()
context = SSLContext()

# importing the protocol constant directly

from ssl import PROTOCOL_SSLv2

ssl.wrap_socket(ssl_version=PROTOCOL_SSLv2)
SSLContext(protocol=PROTOCOL_SSLv2)

# FP for insecure default
ssl.SSLContext(ssl.SSLv23_METHOD)
