def get_cert():
    return "<CERT>"


def write_cert(filename):
    cert = get_cert()
    with open(filename, "w") as file:
        file.write(cert) # NOT OK
        lines = [cert + "\n"]
        file.writelines(lines) # NOT OK
