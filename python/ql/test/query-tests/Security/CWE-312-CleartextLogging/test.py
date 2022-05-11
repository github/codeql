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
    logging.debug("Cert=%s", get_cert()) # NOT OK

def print_password():
    print(get_password()) # NOT OK

    sys.stdout.write(get_password()) # NOT OK
    sys.stderr.write(get_password()) # NOT OK


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
