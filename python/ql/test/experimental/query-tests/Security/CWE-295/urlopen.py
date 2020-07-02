import urllib.request

#Simple cases
urllib.request.urlopen('https://semmle.com', "/path/to/cert/") # BAD (does not assign cert path to "cafile")
urllib.request.urlopen('https://semmle.com', cafile="/path/to/cert/")
urllib.request.urlopen('https://semmle.com') # BAD
urllib.request.urlopen('https://semmle.com', cafile=None) # BAD

# Simple flow
urlopen = urllib.request.urlopen
urlopen('https://semmle.com', cafile="/path/to/cert/") # GOOD
urlopen('https://semmle.com', cafile=None) # BAD

#Other flow
openurl = urllib.request.urlopen

def req1(test=None):
    openurl('https://semmle.com', cafile=test) # BAD
    test = "/path/to/cert/"
    openurl('https://semmle.com', cafile=test) # GOOD

def req2(cafile):
    openurl('https://semmle.com', cafile=cafile) # BAD (from line 25)

req2(None) # BAD (at line 23)
req2("/path/to/cert/") # GOOD

