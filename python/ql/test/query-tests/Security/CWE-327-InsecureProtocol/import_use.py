# check that query works properly with imports

import socket
from import_def import secure_context, completely_insecure_context, also_insecure_context

hostname = 'www.python.org'

with socket.create_connection((hostname, 443)) as sock:
        with secure_context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

with socket.create_connection((hostname, 443)) as sock:
        with completely_insecure_context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())

with socket.create_connection((hostname, 443)) as sock:
        with also_insecure_context.wrap_socket(sock, server_hostname=hostname) as ssock:
            print(ssock.version())
