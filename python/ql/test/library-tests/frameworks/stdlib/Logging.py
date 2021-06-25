import logging

# this bit just included to make this file runable
logging.basicConfig(level=logging.DEBUG)

password = "<pass>"
msg = "foo %s"

LOGGER = logging.getLogger("LOGGER")

logging.info(msg, password) # $ loggingInput=msg loggingInput=password
logging.info(msg="hello") # $ loggingInput="hello"

logging.log(logging.INFO, msg, password) # $ loggingInput=msg loggingInput=password
LOGGER.log(logging.INFO, msg, password) # $ loggingInput=msg loggingInput=password

logging.root.info(msg, password) # $ loggingInput=msg loggingInput=password

# test of all levels

logging.critical(msg, password) # $ loggingInput=msg loggingInput=password
logging.fatal(msg, password) # $ loggingInput=msg loggingInput=password
logging.error(msg, password) # $ loggingInput=msg loggingInput=password
logging.warning(msg, password) # $ loggingInput=msg loggingInput=password
logging.warn(msg, password) # $ loggingInput=msg loggingInput=password
logging.info(msg, password) # $ loggingInput=msg loggingInput=password
logging.debug(msg, password) # $ loggingInput=msg loggingInput=password
logging.exception(msg, password) # $ loggingInput=msg loggingInput=password

LOGGER.critical(msg, password) # $ loggingInput=msg loggingInput=password
LOGGER.fatal(msg, password) # $ loggingInput=msg loggingInput=password
LOGGER.error(msg, password) # $ loggingInput=msg loggingInput=password
LOGGER.warning(msg, password) # $ loggingInput=msg loggingInput=password
LOGGER.warn(msg, password) # $ loggingInput=msg loggingInput=password
LOGGER.info(msg, password) # $ loggingInput=msg loggingInput=password
LOGGER.debug(msg, password) # $ loggingInput=msg loggingInput=password
LOGGER.exception(msg, password) # $ loggingInput=msg loggingInput=password

# not sure how to make these print anything, but just to show that it works
logging.Logger("foo").info("hello") # $ loggingInput="hello"

class MyLogger(logging.Logger):
    pass

MyLogger("bar").info("hello") # $ loggingInput="hello"
