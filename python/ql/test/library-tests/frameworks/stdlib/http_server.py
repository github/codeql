import sys
import os
import cgi

if sys.version_info[0] == 2:
    from BaseHTTPServer import BaseHTTPRequestHandler
    from BaseHTTPServer import HTTPServer
    from SimpleHTTPServer import SimpleHTTPRequestHandler
    from CGIHTTPServer import CGIHTTPRequestHandler

if sys.version_info[0] == 3:
    from http.server import HTTPServer, BaseHTTPRequestHandler, SimpleHTTPRequestHandler, CGIHTTPRequestHandler


def test_cgi_FieldStorage_taint():
    # When a python script is invoked through CGI, the default values used by
    # `cgi.FieldStorage` constructor makes it handle data from incoming request.
    # You _can_ also manually set the input-data, as is shown below in `MyHandler`.
    form = cgi.FieldStorage()

    ensure_tainted(
        form, # $ tainted

        # `form['key']` will be a list, if multiple fields named "key" are provided
        form['key'], # $ tainted
        form['key'].value, # $ tainted
        form['key'].file, # $ tainted
        form['key'].filename, # $ tainted
        form['key'][0], # $ tainted
        form['key'][0].value, # $ tainted
        form['key'][0].file, # $ tainted
        form['key'][0].filename, # $ tainted
        [field.value for field in form['key']], # $ tainted

        # `form.getvalue('key')` will be a list, if multiple fields named "key" are provided
        form.getvalue('key'), # $ tainted
        form.getvalue('key')[0], # $ tainted

        form.getfirst('key'), # $ tainted

        form.getlist('key'), # $ tainted
        form.getlist('key')[0], # $ tainted
        [field.value for field in form.getlist('key')], # $ tainted
    )


class MyHandler(BaseHTTPRequestHandler):

    def taint_sources(self):

        ensure_tainted(
            self, # $ tainted

            self.requestline, # $ tainted

            self.path, # $ tainted

            self.headers, # $ tainted
            self.headers['Foo'], # $ tainted
            self.headers.get('Foo'), # $ tainted
            self.headers.get_all('Foo'), # $ tainted
            self.headers.keys(), # $ tainted
            self.headers.values(), # $ tainted
            self.headers.items(), # $ tainted
            self.headers.as_bytes(), # $ tainted
            self.headers.as_string(), # $ tainted
            str(self.headers), # $ tainted
            bytes(self.headers), # $ tainted

            self.rfile, # $ tainted
            self.rfile.read(), # $ tainted
        )

        form = cgi.FieldStorage(
            self.rfile,
            self.headers,
            environ={'REQUEST_METHOD': 'POST', 'CONTENT_TYPE': self.headers.get('content-type')},
        )

        ensure_tainted(form) # $ tainted


    def do_GET(self): # $ requestHandler
        # send_response will log a line to stderr
        self.send_response(200)
        self.send_header("Content-type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(b"Hello BaseHTTPRequestHandler\n")
        self.wfile.writelines([b"1\n", b"2\n", b"3\n"])
        print(self.headers)


    def do_POST(self): # $ requestHandler
        form = cgi.FieldStorage(
            self.rfile,
            self.headers,
            environ={'REQUEST_METHOD': 'POST', 'CONTENT_TYPE': self.headers.get('content-type')},
        )

        if 'myfile' not in form:
            self.send_response(422)
            self.end_headers()
            return

        field = form['myfile']

        field.file.seek(0, os.SEEK_END)
        filesize = field.file.tell()

        print("Uploaded {!r} with {} bytes".format(field.filename, filesize))

        self.send_response(200)
        self.end_headers()


if __name__ == "__main__":
    server = HTTPServer(("127.0.0.1", 8080), MyHandler)
    server.serve_forever()

    # Headers works case insensitvely, so self.headers['foo'] == self.headers['FOO']
    # curl localhost:8080 --header "Foo: 1" --header "foo: 2"

    # To test file submission through forms, use
    # curl -F myfile=@<yourfile> localhost:8080
