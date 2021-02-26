import ssl
from ssl import SSLContext

# secure versions
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_TLSv1_2)
SSLContext(protocol=ssl.PROTOCOL_TLSv1_2)

# possibly insecure default
ssl.wrap_socket()
context = SSLContext()
