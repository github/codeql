
from not_found import get_passwd # $ SensitiveDataSource=password
from not_found import account_id # $ SensitiveDataSource=id

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

f = get_password
f() # $ SensitiveDataSource=password

# attributes
foo = ObjectFromDatabase()
foo.secret # $ SensitiveDataSource=secret
foo.username # $ SensitiveDataSource=id


# based on variable/parameter names
def my_func(password): # $ SensitiveDataSource=password
    print(password) # $ SensitiveUse=password

password = some_function() # $ SensitiveDataSource=password
print(password) # $ SensitiveUse=password

for password in some_function2(): # $ SensitiveDataSource=password
    print(password) # $ SensitiveUse=password

with some_function3() as password: # $ SensitiveDataSource=password
    print(password) # $ SensitiveUse=password


# Special handling of lookups of sensitive properties
request.args["password"], # $ SensitiveDataSource=password
request.args.get("password") # $ SensitiveDataSource=password

x = "password"
request.args.get(x) # $ SensitiveDataSource=password

# I don't think handling `getlist` is super important, just included it to show what we don't handle
request.args.getlist("password")[0] # $ MISSING: SensitiveDataSource=password

from not_found import password2 as foo # $ SensitiveDataSource=password
print(foo) # $ SensitiveUse=password
