# This test file demonstrates how to use an application with a wsgiref.simple_server
# see https://docs.python.org/3/library/wsgiref.html#wsgiref.simple_server.WSGIServer
import sys
import wsgiref.simple_server

def ignore(*arg, **kwargs): pass
ensure_tainted = ensure_not_tainted = ignore

ADDRESS = ("localhost", 8000)


# I wanted to showcase that we handle both functions and bound-methods, so it's possible
# to run this test-file in 2 different ways.

def func(environ, start_response): # $ requestHandler
    ensure_tainted(
        environ, # $ tainted
        environ["PATH_INFO"], # $ tainted
    )
    write = start_response("200 OK", [("Content-Type", "text/plain")])
    write(b"hello") # $ HttpResponse responseBody=b"hello"
    write(data=b" ") # $ HttpResponse responseBody=b" "

    # function return value should be an iterable that will also be written to the
    # response.
    return [b"world", b"!"] # $ HttpResponse responseBody=List


class MyServer(wsgiref.simple_server.WSGIServer):
    def __init__(self):
        super().__init__(ADDRESS, wsgiref.simple_server.WSGIRequestHandler)
        self.set_app(self.my_method)

    def my_method(self, _env, start_response): # $ requestHandler
        start_response("200 OK", [])
        return [b"my_method"] # $ HttpResponse responseBody=List


case = sys.argv[1]
if case == "1":
    server = wsgiref.simple_server.WSGIServer(ADDRESS, wsgiref.simple_server.WSGIRequestHandler)
    server.set_app(func)
elif case == "2":
    server = MyServer()
elif case == "3":
    server = MyServer()
    def func3(_env, start_response): # $ requestHandler
        start_response("200 OK", [])
        return [b"foo"] # $ HttpResponse responseBody=List
    server.set_app(func3)
else:
    sys.exit("wrong case")


print(f"Running on http://{ADDRESS[0]}:{ADDRESS[1]}")

server.serve_forever()
