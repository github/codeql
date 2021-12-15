import sys
import os
import cgi

if sys.version_info[0] == 2:
    from BaseHTTPServer import BaseHTTPRequestHandler
    from BaseHTTPServer import HTTPServer

if sys.version_info[0] == 3:
    from http.server import HTTPServer, BaseHTTPRequestHandler


class MyHandler(BaseHTTPRequestHandler):

    def taint_sources(self):

        ensure_tainted(
            self,

            self.requestline,

            self.path,

            self.headers,
            self.headers['Foo'],
            self.headers.get('Foo'),
            self.headers.get_all('Foo'),
            self.headers.keys(),
            self.headers.values(),
            self.headers.items(),
            self.headers.as_bytes(),
            self.headers.as_string(),
            str(self.headers),
            bytes(self.headers),

            self.rfile,
            self.rfile.read(),
        )

        form = cgi.FieldStorage(
            self.rfile,
            self.headers,
            environ={'REQUEST_METHOD': 'POST', 'CONTENT_TYPE': self.headers.get('content-type')},
        )

        ensure_tainted(
            form,

            form['key'],
            form['key'].value,
            form['key'].file,
            form['key'].filename,
            form['key'][0], # will be a list, if multiple fields named "key" are provided
            form['key'][0].value,
            form['key'][0].file,
            form['key'][0].filename,

            form.getvalue('key'),
            form.getvalue('key')[0], # will be a list, if multiple fields named "key" are provided

            form.getfirst('key'),

            form.getlist('key'),
            form.getlist('key')[0],
        )

    def do_GET(self):
        # send_response will log a line to stderr
        self.send_response(200)
        self.send_header("Content-type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(b"Hello BaseHTTPRequestHandler\n")
        self.wfile.writelines([b"1\n", b"2\n", b"3\n"])
        print(self.headers)


    def do_POST(self):
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
