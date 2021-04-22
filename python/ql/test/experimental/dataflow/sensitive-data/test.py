
from not_found import get_passwd, account_id

def get_password():
    pass

def get_secret():
    pass

def fetch_certificate():
    pass

def encrypt_password(pwd):
    pass

get_password() # $ SensitiveDataSource=password
get_passwd() # $ SensitiveDataSource=password
get_secret() # $ SensitiveDataSource=secret
fetch_certificate() # $ SensitiveDataSource=certificate
account_id() # $ SensitiveDataSource=id
safe_to_store = encrypt_password(pwd)
