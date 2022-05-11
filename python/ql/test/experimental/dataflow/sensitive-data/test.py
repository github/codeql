
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

# more tests of functions we don't have definition for
x = unkown_func_not_even_imported_get_password() # $ SensitiveDataSource=password
print(x) # $ SensitiveUse=password

f = get_passwd
x = f()
print(x) # $ SensitiveUse=password

import not_found
f = not_found.get_passwd # $ SensitiveDataSource=password
x = f()
print(x) # $ SensitiveUse=password

def my_func(non_sensitive_name):
    x = non_sensitive_name()
    print(x) # $ SensitiveUse=password
f = not_found.get_passwd # $ SensitiveDataSource=password
my_func(f)

# attributes
foo = ObjectFromDatabase()
foo.secret # $ SensitiveDataSource=secret
foo.username # $ SensitiveDataSource=id

getattr(foo, "password") # $ SensitiveDataSource=password
x = "password"
getattr(foo, x) # $ SensitiveDataSource=password

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

# ------------------------------------------------------------------------------
# cross-talk between different calls
# ------------------------------------------------------------------------------

# Case 1: providing name as argument

_configuration = {"sleep_timer": 5, "mysql_password": "1234"}

def get_config(key):
    # Treating this as a SensitiveDataSource is questionable, since that will result in
    # _all_ calls to `get_config` being treated as giving sensitive data
    return _configuration[key]

foo = get_config("mysql_password")
print(foo) # $ MISSING: SensitiveUse=password

bar = get_config("sleep_timer")
print(bar)

# Case 2: Providing function as argument

def call_wrapper(func):
    print("Will call", func)
    # Treating this as a SensitiveDataSource is questionable, since that will result in
    # _all_ calls to `call_wrapper` being treated as giving sensitive data
    return func() # $ SensitiveDataSource=password

foo = call_wrapper(get_password)
print(foo) # $ SensitiveUse=password

harmless = lambda: "bar"
bar = call_wrapper(harmless)
print(bar) # $ SPURIOUS: SensitiveUse=password

# ------------------------------------------------------------------------------
# cross-talk in dictionary.
# ------------------------------------------------------------------------------

from unknown_settings import password # $ SensitiveDataSource=password

print(password) # $ SensitiveUse=password
_config = {"sleep_timer": 5, "mysql_password": password}

# since we have taint-step from store of `password`, we will consider any item in the
# dictionary to be a password :(
print(_config["sleep_timer"]) # $ SPURIOUS: SensitiveUse=password
