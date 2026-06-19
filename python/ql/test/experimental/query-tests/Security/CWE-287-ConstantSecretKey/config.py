"""Flask App configuration."""
from os import environ
import os
import random

FLASK_DEBUG = True
aConstant = 'CHANGEME2' # $ Source


class Config:
    SECRET_KEY = environ.get("envKey")
    SECRET_KEY = aConstant # $ Alert
    SECRET_KEY = os.getenv('envKey')
    SECRET_KEY = os.environ.get('envKey')
    SECRET_KEY = os.environ.get('envKey', random.randint)
    SECRET_KEY = os.getenv('envKey', random.randint)
    SECRET_KEY = os.getenv('envKey', aConstant) # $ Alert
    SECRET_KEY = os.environ.get('envKey', aConstant) # $ Alert
    SECRET_KEY = os.environ['envKey']
