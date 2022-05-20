import ssl
import socket

# Using the deprecated ssl.wrap_socket method
ssl.wrap_socket(socket.socket())

# Using SSLContext
context = ssl.SSLContext()
