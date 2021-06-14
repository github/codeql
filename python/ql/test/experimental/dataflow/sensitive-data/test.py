
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

# attributes
foo = ObjectFromDatabase()
foo.secret # $ SensitiveDataSource=secret
foo.username # $ SensitiveDataSource=id

# Special handling of lookups of sensitive properties
request.args["password"], # $ MISSING: SensitiveDataSource=password
request.args.get("password") # $ SensitiveDataSource=password

# I don't think handling `getlist` is super important, just included it to show what we don't handle
request.args.getlist("password")[0] # $ MISSING: SensitiveDataSource=password
