"""Flask App configuration."""
from os import environ
import os
import random
import configparser

FLASK_DEBUG = True
aConstant = 'CHANGEME2'
config = configparser.ConfigParser()


class Config:
    SECRET_KEY = config["a"]["Secret"]
    SECRET_KEY = config.get("key", "value")
    SECRET_KEY = environ.get("envKey")
    SECRET_KEY = aConstant
    SECRET_KEY = os.getenv('envKey')
    SECRET_KEY = os.environ.get('envKey')
    SECRET_KEY = os.environ.get('envKey', random.randint)
    SECRET_KEY = os.getenv('envKey', random.randint)
    SECRET_KEY = os.getenv('envKey', aConstant)
    SECRET_KEY = os.environ.get('envKey', aConstant)
    SECRET_KEY = os.environ['envKey']
