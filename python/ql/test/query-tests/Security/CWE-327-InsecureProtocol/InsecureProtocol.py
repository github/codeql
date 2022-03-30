import ssl
from OpenSSL import SSL
from ssl import SSLContext

# insecure versions specified
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_SSLv2)
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_SSLv3)
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_TLSv1)

SSLContext(protocol=ssl.PROTOCOL_SSLv2)
SSLContext(protocol=ssl.PROTOCOL_SSLv3)
SSLContext(protocol=ssl.PROTOCOL_TLSv1)

SSL.Context(SSL.SSLv2_METHOD)
SSL.Context(SSL.SSLv3_METHOD)
SSL.Context(SSL.TLSv1_METHOD)

METHOD = SSL.SSLv2_METHOD
SSL.Context(METHOD)

# importing the protocol constant directly
from ssl import PROTOCOL_SSLv2
ssl.wrap_socket(ssl_version=PROTOCOL_SSLv2)
SSLContext(protocol=PROTOCOL_SSLv2)

# secure versions specified
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_TLSv1_2)
SSLContext(protocol=ssl.PROTOCOL_TLSv1_2)
SSL.Context(SSL.TLSv1_2_METHOD)

# insecure versions allowed by specified range
SSLContext(protocol=ssl.PROTOCOL_SSLv23)
SSLContext(protocol=ssl.PROTOCOL_TLS)
SSLContext(protocol=ssl.PROTOCOL_TLS_CLIENT)
SSLContext(protocol=ssl.PROTOCOL_TLS_SERVER)

SSL.Context(SSL.SSLv23_METHOD)
