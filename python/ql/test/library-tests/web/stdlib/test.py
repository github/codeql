import sys

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

    def do_GET(self):
        # send_response will log a line to stderr
        self.send_response(200)
        self.send_header("Content-type", "text/plain; charset=utf-8")
        self.end_headers()
        self.wfile.write(b"Hello BaseHTTPRequestHandler")
        print(self.headers)




if __name__ == "__main__":
    server = HTTPServer(("127.0.0.1", 8080), MyHandler)
    server.serve_forever()

    # Headers works case insensitvely, so self.headers['foo'] == self.headers['FOO']
    # curl localhost:8080 --header "Foo: 1" --header "foo: 2"
