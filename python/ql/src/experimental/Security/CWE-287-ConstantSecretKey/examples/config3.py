"""Flask App configuration."""
import os

# General Config
FLASK_DEBUG = True
# if we are loading SECRET_KEY from config files then
# it is good to check default value always, maybe
# the user responsible for setup the application make a mistake
# and has not changed the default SECRET_KEY value
SECRET_KEY = os.getenv('envKey', "A_CONSTANT_SECRET")  # A_CONSTANT_SECRET
if SECRET_KEY == "A_CONSTANT_SECRET":
    raise "not possible"
