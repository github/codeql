# These tests use a wsgi validator; so are split into a separate directory from the other tests since the models only check for the presence of a validator in the database. 

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

def main1():
    with make_server('', 8000, validator(test_app)) as httpd:
        print("Serving on port 8000...")
        httpd.serve_forever()