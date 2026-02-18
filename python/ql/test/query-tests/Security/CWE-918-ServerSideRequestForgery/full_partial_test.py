from flask import request # $ Source

import requests
import re

def full_ssrf():
    user_input = request.args['untrusted_input']
    query_val = request.args['query_val']

    # NOT OK -- user has full control
    requests.get(user_input) # $ Alert[py/full-ssrf]

    url = "https://" + user_input
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf] 

    # although the path `/foo` is added here, this can be circumvented such that the
    # final URL is `https://evil.com/#/foo" -- since the fragment (#) is not sent to the
    # server.
    url = "https://" + user_input + "/foo"
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf] 

    # this might seem like a dummy test, but it serves to check how our sanitizers work.
    url = "https://" + user_input + "/foo?key=" + query_val
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]

# taint-steps are added as `fromNode -> toNode`, but when adding a sanitizer it's
# currently only possible to so on either `fromNode` or `toNode` (either all edges in
# and out, or just the edges in or out). The sanitizers for full URL control is applied
# on the `fromNode`, since for `"https://{}/{}".format(user_input1, user_input2)` there
# is still a valid taint-step for `user_input1` -- if we made `toNode` a sanitizer that
# would also remove this flow that we actually want. When coupled with use-use flow,
# this means that later uses of a sanitized value will no longer be tainted, so
# `requests.get(user_input2)` would no longer give an alert. To overcome this problem,
# we split these tests into multiple functions, so we do not get this use-use flow, and
# therefore know we are able to see where the sanitizers are applied.

def full_ssrf_format():
    user_input = request.args['untrusted_input']
    query_val = request.args['query_val']

    # using .format
    url = "https://{}".format(user_input)
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]

    url = "https://{}/foo".format(user_input)
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]

    url = "https://{}/foo?key={}".format(user_input, query_val)
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]

    url = "https://{x}".format(x=user_input)
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]

    url = "https://{1}".format(0, user_input)
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]

def full_ssrf_percent_format():
    user_input = request.args['untrusted_input']
    query_val = request.args['query_val']

    # using %-formatting
    url = "https://%s" % user_input
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]

    url = "https://%s/foo" % user_input
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]

    url = "https://%s/foo/key=%s" % (user_input, query_val)
    # NOT OK -- user has full and partial control
    requests.get(url) # $ Alert[py/partial-ssrf] $ MISSING: Alert[py/full-ssrf] 

def full_ssrf_f_strings():
    user_input = request.args['untrusted_input']
    query_val = request.args['query_val']

    # using f-strings
    url = f"https://{user_input}"
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]

    url = f"https://{user_input}/foo"
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]

    url = f"https://{user_input}/foo?key={query_val}"
    # NOT OK -- user has full control
    requests.get(url) # $ Alert[py/full-ssrf]


def partial_ssrf_1():
    user_input = request.args['untrusted_input']

    url = "https://example.com/foo?" + user_input
    # NOT OK -- user controls query parameters
    requests.get(url) # $ Alert[py/partial-ssrf]

def partial_ssrf_2():
    user_input = request.args['untrusted_input']

    url = "https://example.com/" + user_input
    # NOT OK -- user controls path
    requests.get(url) # $ Alert[py/partial-ssrf]

def partial_ssrf_3():
    user_input = request.args['untrusted_input']

    url = "https://example.com/" + user_input
    # NOT OK -- user controls path
    requests.get(url) # $ Alert[py/partial-ssrf]

def partial_ssrf_4():
    user_input = request.args['untrusted_input']

    url = "https://example.com/foo#{}".format(user_input)
    # NOT OK -- user controlled fragment
    requests.get(url)  # $ Alert[py/partial-ssrf]

def partial_ssrf_5():
    user_input = request.args['untrusted_input']

    # this is probably the least interesting one, since it's only the fragment that is
    # controlled

    url = "https://example.com/foo#%s" % user_input
    # NOT OK -- user controlled fragment
    requests.get(url)  # $ Alert[py/partial-ssrf]

def partial_ssrf_6():
    user_input = request.args['untrusted_input']

    url = f"https://example.com/foo#{user_input}"
    # NOT OK -- user only controlled fragment
    requests.get(url) # $ Alert[py/partial-ssrf]

def partial_ssrf_7():
    user_input = request.args['untrusted_input']

    if user_input.isalnum():
        url = f"https://example.com/foo#{user_input}"
        requests.get(url)  # OK - user input can only contain alphanumerical characters 

    if user_input.isalpha():
        url = f"https://example.com/foo#{user_input}"
        requests.get(url) # OK - user input can only contain alphabetical characters 

    if user_input.isdecimal():
        url = f"https://example.com/foo#{user_input}"
        requests.get(url) # OK - user input can only contain decimal characters 

    if user_input.isdigit():
        url = f"https://example.com/foo#{user_input}"
        requests.get(url) # OK - user input can only contain digits

    if user_input.isnumeric():
        url = f"https://example.com/foo#{user_input}"
        requests.get(url) # OK - user input can only contain numeric characters

    if user_input.isspace():
        url = f"https://example.com/foo#{user_input}"
        requests.get(url) # OK - user input can only contain whitespace characters 

    if re.fullmatch(r'[a-zA-Z0-9]+', user_input):
        url = f"https://example.com/foo#{user_input}"
        requests.get(url) # OK - user input can only contain alphanumerical characters

    if re.fullmatch(r'.*[a-zA-Z0-9]+.*', user_input):
        url = f"https://example.com/foo#{user_input}"
        # NOT OK, but NOT FOUND - user input can contain arbitrary characters 
        requests.get(url) # $ MISSING: Alert[py/partial-ssrf] 

    
    if re.match(r'^[a-zA-Z0-9]+$', user_input):
        url = f"https://example.com/foo#{user_input}"
        requests.get(url) # OK - user input can only contain alphanumerical characters

    if re.match(r'[a-zA-Z0-9]+', user_input):
        url = f"https://example.com/foo#{user_input}"
        # NOT OK, but NOT FOUND - user input can contain arbitrary character as a suffix.
        requests.get(url) # $ MISSING: Alert[py/partial-ssrf] 

    reg = re.compile(r'^[a-zA-Z0-9]+$')

    if reg.match(user_input):
       url = f"https://example.com/foo#{user_input}"
       requests.get(url) # OK - user input can only contain alphanumerical characters

    if reg.fullmatch(user_input):
       url = f"https://example.com/foo#{user_input}"
       requests.get(url) # OK - user input can only contain alphanumerical characters 
