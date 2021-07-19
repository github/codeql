import ssl

# secure versions
ssl.wrap_socket(ssl_version=ssl.PROTOCOL_TLSv1_2)

# possibly insecure default
ssl.wrap_socket()
