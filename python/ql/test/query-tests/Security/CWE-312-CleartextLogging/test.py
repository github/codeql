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
    password = get_password()
    logging.info("logging.info Password '%s'", password) # NOT OK

    LOGGER.log(logging.INFO, "LOGGER.log Password '%s'", password) # NOT OK
    logging.root.info("logging.root.info Password '%s'", password) # NOT OK

    # name of logger variable should not matter
    foo = LOGGER
    foo.info("foo.info Password '%s'", password) # NOT OK

    # return value from function
    get_logger().info("get_logger().info Password '%s'", password) # NOT OK


def log_cert():
    logging.debug("Cert=%s", get_cert()) # OK

def print_password():
    print(get_password()) # NOT OK

    sys.stdout.write(get_password()) # NOT OK
    sys.stderr.write(get_password()) # NOT OK

    import getpass

    x = getpass.getpass()
    print(x) # NOT OK

def log_private():
    def log1(social_security_number, ssn, className, passportNo):
        print(social_security_number) # NOT OK
        print(ssn) # NOT OK
        print(className) # OK
        print(passportNo) # NOT OK

    def log2(post_code, zipCode, home_address):
        print(post_code) # NOT OK, but NOT FOUND - "code" is treated as encrypted and thus not sensitive
        print(zipCode) # NOT OK, but NOT FOUND - "code" is treated as encrypted and thus not sensitive
        print(home_address) # NOT OK

    def log3(user_latitude, user_longitude):
        print(user_latitude) # NOT OK
        print(user_longitude) # NOT OK

    def log4(mobile_number, phoneNo):
        print(mobile_number) # NOT OK
        print(phoneNo) # NOT OK

    def log5(creditcard, debit_card, bank_number, bank_account, accountNo, ccn, user_ccn, succNode):
        print(creditcard) # NOT OK
        print(debit_card) # NOT OK
        print(bank_number) # NOT OK
        print(bank_account) # NOT OK, but NOT FOUND - "account" is treated as having the "id" classification and thus excluded.
        print(accountNo) # NOT OK, but NOT FOUND - "account" is treated as having the "id" classification and thus excluded.
        print(ccn) # NOT OK
        print(user_ccn) # NOT OK
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
