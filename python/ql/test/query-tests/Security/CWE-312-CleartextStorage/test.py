#Don't import logging; it transitively imports a lot of stuff

def get_password():
    pass

def get_cert():
    pass

def write_cert(filename):
    cert = get_cert()
    with open(filename, "w") as file:
        file.write(cert)
