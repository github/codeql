import socket
import ssl

hostname = 'www.python.org'
context = ssl.SSLContext(ssl.PROTOCOL_TLS)
context.options |= ssl.OP_NO_TLSv1
context.options |= ssl.OP_NO_TLSv1_1 # This added by me

with socket.create_connection((hostname, 443)) as sock:
    with context.wrap_socket(sock, server_hostname=hostname) as ssock:
        print(ssock.version())