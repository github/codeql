import urllib.request

#Unsafe requests

urllib.request.urlopen('https://semmle.com') # UNSAFE
urllib.request.urlopen('https://semmle.com', cafile=None) # UNSAFE

#Safe option

urllib.request.urlopen('https://semmle.com', cafile="/path/to/cert/")

#Wrapper to ensure safety

def make_safe_request(url, certpath):
    if certpath is None:
        raise Exception("Trying to make unsafe request")
    return urllib.request.urlopen(url, cafile=certpath)
