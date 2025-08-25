# This test file demonstrates how to use an application with a wsgiref.simple_server
# see https://docs.python.org/3/library/wsgiref.html#wsgiref.simple_server.WSGIServer
import sys
import wsgiref.simple_server
import wsgiref.headers

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
    write = start_response("200 OK", [("Content-Type", "text/plain")]) # $ headerWriteBulk=List headerWriteBulkUnsanitized=name,value headerWriteNameUnsanitized="Content-Type" headerWriteValueUnsanitized="text/plain"
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
        start_response("200 OK", []) # $ headerWriteBulk=List headerWriteBulkUnsanitized=name,value
        return [b"my_method"] # $ HttpResponse responseBody=List

def func2(environ, start_response): # $ requestHandler
    headers = wsgiref.headers.Headers([("Content-Type", "text/plain")]) # $ headerWriteBulk=List headerWriteBulkUnsanitized=name,value headerWriteNameUnsanitized="Content-Type" headerWriteValueUnsanitized="text/plain"
    headers.add_header("X-MyHeader", "a") # $ headerWriteNameUnsanitized="X-MyHeader" headerWriteValueUnsanitized="a"
    headers.setdefault("X-MyHeader2", "b") # $ headerWriteNameUnsanitized="X-MyHeader2" headerWriteValueUnsanitized="b"
    headers.__setitem__("X-MyHeader3", "c") # $ headerWriteNameUnsanitized="X-MyHeader3" headerWriteValueUnsanitized="c"
    headers["X-MyHeader4"] = "d" # $ headerWriteNameUnsanitized="X-MyHeader4" headerWriteValueUnsanitized="d"
    start_response(status, headers) # $ headerWriteBulk=headers headerWriteBulkUnsanitized=name,value
    return [b"Hello"] # $ HttpResponse responseBody=List

case = sys.argv[1] # $ threatModelSource[commandargs]=sys.argv
if case == "1":
    server = wsgiref.simple_server.WSGIServer(ADDRESS, wsgiref.simple_server.WSGIRequestHandler)
    server.set_app(func)
elif case == "2":
    server = MyServer()
elif case == "3":
    server = MyServer()
    def func3(_env, start_response): # $ requestHandler
        start_response("200 OK", []) # $ headerWriteBulk=List headerWriteBulkUnsanitized=name,value
        return [b"foo"] # $ HttpResponse responseBody=List
    server.set_app(func3)
elif case == "4":
    server = wsgiref.simple_server.make_server(ADDRESS[0], ADDRESS[1], func2)
else:
    sys.exit("wrong case")


print(f"Running on http://{ADDRESS[0]}:{ADDRESS[1]}")

server.serve_forever()
