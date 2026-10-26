import ssl
from OpenSSL import SSL
from ssl import SSLContext

# insecure versions specified
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_SSLv2) # $ Alert
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_SSLv3) # $ Alert
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_TLSv1) # $ Alert

SSLContext(protocol=ssl.PROTOCOL_SSLv2) # $ Alert
SSLContext(protocol=ssl.PROTOCOL_SSLv3) # $ Alert
SSLContext(protocol=ssl.PROTOCOL_TLSv1) # $ Alert

SSL.Context(SSL.SSLv2_METHOD) # $ Alert
SSL.Context(SSL.SSLv3_METHOD) # $ Alert
SSL.Context(SSL.TLSv1_METHOD) # $ Alert

METHOD = SSL.SSLv2_METHOD
SSL.Context(METHOD) # $ Alert

# importing the protocol constant directly
from ssl import PROTOCOL_SSLv2
ssl.wrap_socket(ssl_version=PROTOCOL_SSLv2) # $ Alert
SSLContext(protocol=PROTOCOL_SSLv2) # $ Alert

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
