from http.server import HTTPServer, SimpleHTTPRequestHandler
import ssl


httpd = HTTPServer(('localhost', 4443), SimpleHTTPRequestHandler)

httpd.socket = ssl.wrap_socket (httpd.socket, 
        keyfile="../key.pem", 
        certfile="../cert.pem", server_side=True)

httpd.serve_forever()
