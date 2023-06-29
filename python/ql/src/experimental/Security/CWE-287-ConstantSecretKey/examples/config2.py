"""Flask App configuration."""
import environ

aConstant = 'CHANGEME2'

SECRET_KEY = aConstant


class Config:
    SECRET_KEY = aConstant
