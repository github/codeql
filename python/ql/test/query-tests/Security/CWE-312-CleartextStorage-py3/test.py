import pathlib


def get_cert():
    return "<CERT>"


def write_password(filename):
    cert = get_cert()

    path = pathlib.Path(filename)
    path.write_text(cert) # NOT OK
    path.write_bytes(cert.encode("utf-8")) # NOT OK

    path.open("w").write(cert) # NOT OK
