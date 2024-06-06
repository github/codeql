"""Flask App configuration."""
import os
import random

FLASK_DEBUG = True
aConstant = 'CHANGEME2'


class Config:
    SECRET_KEY = aConstant
    SECRET_KEY = os.environ.get('envKey', random.randint)
    SECRET_KEY = os.getenv('envKey', random.randint)
    SECRET_KEY = os.getenv('envKey', aConstant)
    SECRET_KEY = os.environ.get('envKey', aConstant)
