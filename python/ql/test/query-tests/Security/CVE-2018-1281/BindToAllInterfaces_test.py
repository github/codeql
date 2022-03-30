import socket

# binds to all interfaces, insecure
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('0.0.0.0', 31137))

# binds to all interfaces, insecure
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('', 4040))

# binds only to a dedicated interface, secure
s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(('84.68.10.12', 8080))

# binds to all interfaces, insecure
ALL_LOCALS = "0.0.0.0"
s.bind((ALL_LOCALS, 9090))

# binds to all interfaces, insecure
tup = (ALL_LOCALS, 8080)
s.bind(tup)


# IPv6
s = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
s.bind(("::", 8080)) # NOT OK
