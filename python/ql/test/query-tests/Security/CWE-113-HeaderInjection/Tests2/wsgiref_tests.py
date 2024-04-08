from wsgiref.simple_server import make_server 
from wsgiref.headers import Headers
from wsgiref.validate import validator

def test_app(environ, start_response):
    status = "200 OK"
    h_name = environ["source_n"]
    h_val = environ["source_v"]
    headers = [(h_name, "val"), ("name", h_val)]
    start_response(status, headers) # GOOD - the application is validated, so headers containing newlines will be rejected.
    return [b"Hello"]

def test_app2(environ, start_response):
    status = "200 OK"
    h_name = environ["source_n"]
    h_val = environ["source_v"]
    headers = Headers([(h_name, "val"), ("name", h_val)]) # GOOD
    headers.add_header(h_name, h_val) # GOOD
    headers.setdefault(h_name, h_val) # GOOD
    headers.__setitem__(h_name, h_val) # GOOD
    headers[h_name] = h_val # GOOD
    start_response(status, headers)
    return [b"Hello"]

def main1():
    with make_server('', 8000, validator(test_app)) as httpd:
        print("Serving on port 8000...")
        httpd.serve_forever()

def main2():
    with make_server('', 8000, validator(test_app2)) as httpd:
        print("Serving on port 8000...")
        httpd.serve_forever()