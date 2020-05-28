# taken from https://docs.python.org/3/library/ssl.html?highlight=ssl#ssl.SSLContext

import socket
import ssl

hostname = 'www.python.org'
context = ssl.create_default_context()
context.options |= ssl.OP_NO_TLSv1 # This added by me

with socket.create_connection((hostname, 443)) as sock:
    with context.wrap_socket(sock, server_hostname=hostname) as ssock:
        print(ssock.version())