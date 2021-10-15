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
