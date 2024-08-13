import http.server
import sys
import os
import socket
import ssl
import random
from datetime import datetime, timedelta, timezone
from cryptography.hazmat.primitives import hashes, serialization
from cryptography import utils, x509
from cryptography.hazmat.primitives.asymmetric import rsa, dsa

import select


def generateCA(ca_cert_file, ca_key_file):
    ca_key = dsa.generate_private_key(4096)
    name = x509.Name([
        x509.NameAttribute(x509.NameOID.COUNTRY_NAME, "US"),
        x509.NameAttribute(x509.NameOID.ORGANIZATION_NAME, "GitHub"),
        x509.NameAttribute(x509.NameOID.COMMON_NAME, "GitHub CodeQL Proxy")])
    ca_cert = x509.CertificateBuilder().subject_name(name).issuer_name(name)
    ca_cert = ca_cert.public_key(ca_key.public_key())
    ca_cert = ca_cert.serial_number(random.randint(50000000, 100000000))
    ca_cert = ca_cert.not_valid_before(datetime.now(timezone.utc))
    ca_cert = ca_cert.not_valid_after(
        datetime.now(timezone.utc) + timedelta(days=3650))
    ca_cert = ca_cert.add_extension(x509.BasicConstraints(
        ca=True, path_length=None), critical=True)
    ca_cert = ca_cert.add_extension(
        x509.SubjectKeyIdentifier.from_public_key(ca_key.public_key()), critical=False)
    ca_cert = ca_cert.sign(ca_key, hashes.SHA256())
    with open(ca_cert_file, 'wb') as f:
        f.write(ca_cert.public_bytes(encoding=serialization.Encoding.PEM))
    with open(ca_key_file, 'wb') as f:
        f.write(ca_key.private_bytes(encoding=serialization.Encoding.PEM,
                format=serialization.PrivateFormat.PKCS8, encryption_algorithm=serialization.NoEncryption()))


def create_certificate(hostname):
    pkey = rsa.generate_private_key(public_exponent=65537, key_size=2048)
    subject = x509.Name(
        [x509.NameAttribute(x509.NameOID.COMMON_NAME, hostname)])

    cert = x509.CertificateBuilder()
    cert = cert.subject_name(subject).issuer_name(ca_certificate.subject)
    cert = cert.public_key(pkey.public_key())
    cert = cert.serial_number(random.randint(50000000, 100000000))
    cert = cert.not_valid_before(datetime.now(timezone.utc)).not_valid_after(
        datetime.now(timezone.utc) + timedelta(days=3650))
    cert = cert.add_extension(x509.BasicConstraints(
        ca=False, path_length=None), critical=True)
    cert = cert.add_extension(
        x509.SubjectAlternativeName([x509.DNSName(hostname), x509.DNSName(f"*.{hostname}")]), critical=False)

    cert = cert.sign(ca_key, hashes.SHA256())

    return (cert, pkey)


class Handler(http.server.SimpleHTTPRequestHandler):
    def check_auth(self):
        username = os.getenv('PROXY_USER')
        password = os.getenv('PROXY_PASSWORD')
        if username is None or password is None:
            return True

        authorization = self.headers.get(
            'Proxy-Authorization', self.headers.get('Authorization', ''))
        authorization = authorization.split()
        if len(authorization) == 2:
            import base64
            import binascii
            auth_type = authorization[0]
            if auth_type.lower() == "basic":
                try:
                    authorization = authorization[1].encode('ascii')
                    authorization = base64.decodebytes(
                        authorization).decode('ascii')
                except (binascii.Error, UnicodeError):
                    pass
                else:
                    authorization = authorization.split(':')
                    if len(authorization) == 2:
                        return username == authorization[0] and password == authorization[1]
        return False

    def do_CONNECT(self):
        if not self.check_auth():
            self.send_response(
                http.HTTPStatus.PROXY_AUTHENTICATION_REQUIRED)
            self.send_header('Proxy-Authenticate', 'Basic realm="Proxy"')
            self.end_headers()
            return
        # split self.path into host and port
        host, port = self.path.split(':')
        port = int(port)
        self.send_response(http.HTTPStatus.OK, 'Connection established')
        self.send_header('Connection', 'close')
        self.end_headers()
        self.mitm(host, port)

    # man in the middle SSL connection
    def mitm(self, host, port):
        ssl_client_context = ssl.create_default_context(
            purpose=ssl.Purpose.CLIENT_AUTH)
        if not os.path.exists("certs/" + host + '.pem'):
            cert, pkey = create_certificate(host)
            with open("certs/" + host + '.pem', 'wb') as f:
                f.write(pkey.private_bytes(encoding=serialization.Encoding.PEM,
                        format=serialization.PrivateFormat.TraditionalOpenSSL, encryption_algorithm=serialization.NoEncryption()))
                f.write(cert.public_bytes(encoding=serialization.Encoding.PEM))

        ssl_client_context.load_cert_chain("certs/" + host + '.pem')
        ssl_client_context.load_verify_locations(ca_certificate_path)
        # wrap self.connection in SSL
        client = ssl_client_context.wrap_socket(
            self.connection, server_side=True)

        # create socket to host:port
        remote = socket.create_connection(
            (host, port))
        # wrap socket in SSL
        ssl_server_context = ssl.create_default_context(
            purpose=ssl.Purpose.SERVER_AUTH)
        remote = ssl_server_context.wrap_socket(remote, server_hostname=host)

        try:
            while True:
                ready, _, _ = select.select(
                    [client, remote], [], [], 2.0)
                if not ready:
                    break
                for src in ready:
                    if src is client:
                        dst = remote
                    else:
                        dst = client
                    src.setblocking(False)
                    dst.setblocking(True)
                    pending = 8192
                    while pending:
                        try:
                            data = src.recv(pending)
                        except ssl.SSLWantReadError:
                            break
                        if not data:
                            return
                        pending = src.pending()
                        dst.sendall(data)
        finally:
            remote.close()
            client.close()

    def do_GET(self):
        raise NotImplementedError()


if __name__ == '__main__':
    port = int(sys.argv[1])
    ca_certificate = None
    ca_certificate_path = None
    ca_key = None
    if len(sys.argv) > 2:
        ca_certificate_path = sys.argv[2]
        with open(ca_certificate_path, 'rb') as f:
            ca_certificate = x509.load_pem_x509_certificate(f.read())
        with open(sys.argv[3], 'rb') as f:
            ca_key = serialization.load_pem_private_key(
                f.read(), password=None)

    server_address = ('localhost', port)
    httpd = http.server.HTTPServer(server_address, Handler)
    httpd.serve_forever()
