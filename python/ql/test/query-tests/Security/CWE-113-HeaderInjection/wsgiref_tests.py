from wsgiref.simple_server import make_server 
from wsgiref.headers import Headers

def test_app(environ, start_response):
    status = "200 OK"
    h_name = environ["source_n"]
    h_val = environ["source_v"]
    headers = [(h_name, "val"), ("name", h_val)]
    start_response(status, headers) # BAD
    return [b"Hello"]

def test_app2(environ, start_response):
    status = "200 OK"
    h_name = environ["source_n"]
    h_val = environ["source_v"]
    headers = Headers([(h_name, "val"), ("name", h_val)]) # BAD
    headers.add_header(h_name, h_val) # BAD
    headers.setdefault(h_name, h_val) # BAD
    headers.__setitem__(h_name, h_val) # BAD
    headers[h_name] = h_val # BAD
    start_response(status, headers)
    return [b"Hello"]

def main1():
    with make_server('', 8000, test_app) as httpd:
        print("Serving on port 8000...")
        httpd.serve_forever()

def main2():
    with make_server('', 8000, test_app2) as httpd:
        print("Serving on port 8000...")
        httpd.serve_forever()