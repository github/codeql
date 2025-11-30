from http.server import HTTPServer, BaseHTTPRequestHandler
import urllib.parse

class VulnerableHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urllib.parse.urlparse(self.path)
        params = urllib.parse.parse_qs(parsed_path.query)
        input_value = params.get("input", [""])[0]
        # Unsafe: Directly including user input in headers
        self.send_response(200)
        try:
            self.send_header("X-Info", input_value) # BAD
        except Exception as e:
            print(f"[!] Header injection failed: {e}")
        self.end_headers()
        self.wfile.write(b"Hello world!")


# if __name__ == "__main__":
#     print("Serving vulnerable app on http://127.0.0.1:8080")
#     httpd = HTTPServer(("127.0.0.1", 8080), VulnerableHandler)
#     httpd.serve_forever()
