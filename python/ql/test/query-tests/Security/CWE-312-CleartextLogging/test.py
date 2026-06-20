import logging
import sys

LOGGER = logging.getLogger("LOGGER")

def get_logger():
    return LOGGER


def get_password():
    return "<PASSWORD>"


def get_cert():
    return "<CERT>"


def log_password():
    password = get_password() # $ Source
    logging.info("logging.info Password '%s'", password) # $ Alert # NOT OK

    LOGGER.log(logging.INFO, "LOGGER.log Password '%s'", password) # $ Alert # NOT OK
    logging.root.info("logging.root.info Password '%s'", password) # $ Alert # NOT OK

    # name of logger variable should not matter
    foo = LOGGER
    foo.info("foo.info Password '%s'", password) # $ Alert # NOT OK

    # return value from function
    get_logger().info("get_logger().info Password '%s'", password) # $ Alert # NOT OK


def log_cert():
    logging.debug("Cert=%s", get_cert()) # OK

def print_password():
    print(get_password()) # $ Alert # NOT OK

    sys.stdout.write(get_password()) # $ Alert # NOT OK
    sys.stderr.write(get_password()) # $ Alert # NOT OK

    import getpass

    x = getpass.getpass() # $ Source
    print(x) # $ Alert # NOT OK

def log_private():
    def log1(social_security_number, ssn, className, passportNo): # $ Source
        print(social_security_number) # $ Alert # NOT OK
        print(ssn) # $ Alert # NOT OK
        print(className) # OK
        print(passportNo) # $ Alert # NOT OK

    def log2(post_code, zipCode, home_address): # $ Source
        print(post_code) # $ Alert # NOT OK
        print(zipCode) # $ Alert # NOT OK
        print(home_address) # $ Alert # NOT OK

    def log3(user_latitude, user_longitude): # $ Source
        print(user_latitude) # $ Alert # NOT OK
        print(user_longitude) # $ Alert # NOT OK

    def log4(mobile_number, phoneNo): # $ Source
        print(mobile_number) # $ Alert # NOT OK
        print(phoneNo) # $ Alert # NOT OK

    def log5(creditcard, debit_card, bank_number, bank_account, accountNo, ccn, user_ccn, succNode): # $ Source
        print(creditcard) # $ Alert # NOT OK
        print(debit_card) # $ Alert # NOT OK
        print(bank_number) # $ Alert # NOT OK
        print(bank_account) # $ MISSING: Alert # NOT OK, but NOT FOUND - "account" is treated as having the "id" classification and thus excluded.
        print(accountNo) # $ MISSING: Alert # NOT OK, but NOT FOUND - "account" is treated as having the "id" classification and thus excluded.
        print(ccn) # $ Alert # NOT OK
        print(user_ccn) # $ Alert # NOT OK
        print(succNode) # OK



def FPs(account, account_id):
    # we assume that any account parameter is sensitive (id/username)
    # https://github.com/github/codeql/issues/6363
    print(account) # OK

    # https://github.com/github/codeql/issues/6927
    arn = f"arn:aws:iam::{account_id}:role/cfripper-access"
    logging.info(f"Preparing to assume role: {arn}") # OK

    # Harmless UUIDs
    # https://github.com/github/codeql/issues/6726
    # https://github.com/github/codeql/issues/7497
    x = generate_uuid4()
    print(x) # OK

    # username not considered sensitive
    # https://github.com/github/codeql/issues/7116
    logging.error("Misc Exception. User %s: %s", request.user.username)

    # dictionary taint-flow cross-talk
    # https://github.com/github/codeql/issues/6380
    import settings
    config = {
        "sleep_timer": 5,
        "password": settings.password
    }
    print(config["sleep_timer"]) # OK


if __name__ == "__main__":
    logging.basicConfig(level=logging.DEBUG)
    log_password()
    log_cert()
    print_password()
