import requests

#Simple cases
requests.get('https://semmle.com', verify=True) # GOOD
requests.get('https://semmle.com', verify=False) # BAD
requests.post('https://semmle.com', verify=True) # GOOD
requests.post('https://semmle.com', verify=False) # BAD

# Simple flow
put = requests.put
put('https://semmle.com', verify="/path/to/cert/") # GOOD
put('https://semmle.com', verify=False) # BAD

#Other flow
delete = requests.delete

def req1(verify=False):
    delete('https://semmle.com', verify) # BAD
    if verify:
        delete('https://semmle.com', verify) # GOOD
    if not verify:
        return
    delete('https://semmle.com', verify) # GOOD

patch = requests.patch

def req2(verify):
    patch('https://semmle.com', verify=verify) # BAD (from line 30)

req2(False) # BAD (at line 28)
req2("/path/to/cert/") # GOOD

#Falsey value
requests.post('https://semmle.com', verify=0) # BAD
