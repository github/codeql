# use to compare alerts without import

import ssl

copy_secure_context = ssl.SSLContext(ssl.PROTOCOL_TLS)
copy_secure_context.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1

# this is just to allow us to see how un-altered exports work
copy_completely_insecure_context = ssl.SSLContext(ssl.PROTOCOL_TLS)

# and an insecure export that is refined
copy_also_insecure_context = ssl.SSLContext(ssl.PROTOCOL_TLS)
copy_also_insecure_context.options |= ssl.OP_NO_TLSv1



import socket
hostname = 'www.python.org'

with socket.create_connection((hostname, 443)) as sock:
        with copy_secure_context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

with socket.create_connection((hostname, 443)) as sock:
        with copy_completely_insecure_context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

with socket.create_connection((hostname, 443)) as sock:
        with copy_also_insecure_context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())
