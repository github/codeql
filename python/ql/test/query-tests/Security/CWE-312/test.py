import logging

def get_password():
    pass

def log_password():
    password = get_password()
    logging.info("Password '%s'", password)

def get_cert():
    pass

def log_cert():
    logging.debug("Cert=%s", get_cert())

