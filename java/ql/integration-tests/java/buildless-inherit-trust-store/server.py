from http.server import HTTPServer, SimpleHTTPRequestHandler
import ssl


httpd = HTTPServer(('localhost', 4443), SimpleHTTPRequestHandler)

sslctx = ssl.SSLContext(ssl.PROTOCOL_TLS_SERVER)
sslctx.options |= ssl.OP_NO_TLSv1 | ssl.OP_NO_TLSv1_1
sslctx.load_cert_chain(certfile="../cert.pem", keyfile="../key.pem")

httpd.socket = sslctx.wrap_socket (httpd.socket, server_side=True)

httpd.serve_forever()
