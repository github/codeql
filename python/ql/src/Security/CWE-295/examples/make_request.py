import requests

#Unsafe requests

requests.get('https://semmle.com', verify=False) # UNSAFE
requests.get('https://semmle.com', verify=0) # UNSAFE

#Various safe options

requests.get('https://semmle.com', verify=True) # Explicitly safe
requests.get('https://semmle.com', verify="/path/to/cert/")
requests.get('https://semmle.com') # The default is to verify.

#Wrapper to ensure safety

def make_safe_request(url, verify_cert):
    if not verify_cert:
        raise Exception("Trying to make unsafe request")
    return requests.get(url, verify_cert)
