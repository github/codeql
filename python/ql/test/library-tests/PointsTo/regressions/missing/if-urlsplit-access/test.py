# Only a problem in Python 3
from urllib.parse import urlsplit

foo = 42
check(foo)

def func(url):
    parts = urlsplit(url)

    foo = 1
    check(foo)

    if parts.path: # using `urlsplit(url).path` here is equivalent
        return # using `pass` here instead makes points-to work

    foo = 2
    check(foo) # Points-to was missing here. Fixed by https://github.com/Semmle/ql/pull/2922
