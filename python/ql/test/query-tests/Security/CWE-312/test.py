#Don't import logging; it transitively imports a lot of stuff

def get_password():
    pass

def log_password():
    password = get_password()
    logging.info("Password '%s'", password)

def get_cert():
    pass

def log_cert():
    logging.debug("Cert=%s", get_cert())

def print_password():
    print(get_password())

def write_cert(filename):
    cert = get_cert()
    with open(filename, "w") as file:
        file.write(cert)
