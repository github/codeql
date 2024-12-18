from wsgiref.simple_server import make_server 
from wsgiref.headers import Headers

def test_app(environ, start_response):
    status = "200 OK"
    h_name = environ["source_n"]
    h_val = environ["source_v"]
    headers = [(h_name, "val"), ("name", h_val)]
    start_response(status, headers) # BAD
    return [b"Hello"]

def main1():
    with make_server('', 8000, test_app) as httpd:
        print("Serving on port 8000...")
        httpd.serve_forever()