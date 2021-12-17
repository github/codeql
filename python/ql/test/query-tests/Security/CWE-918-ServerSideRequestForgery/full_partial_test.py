from flask import request

import requests


def full_ssrf():
    user_input = request.args['untrusted_input']
    query_val = request.args['query_val']

    requests.get(user_input) # NOT OK -- user has full control

    url = "https://" + user_input
    requests.get(url) # NOT OK -- user has full control

    # although the path `/foo` is added here, this can be circumvented such that the
    # final URL is `https://evil.com/#/foo" -- since the fragment (#) is not sent to the
    # server.
    url = "https://" + user_input + "/foo"
    requests.get(url) # NOT OK -- user has full control

    # this might seem like a dummy test, but it serves to check how our sanitizers work.
    url = "https://" + user_input + "/foo?key=" + query_val
    requests.get(url) # NOT OK -- user has full control

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
    requests.get(url) # NOT OK -- user has full control

    url = "https://{}/foo".format(user_input)
    requests.get(url) # NOT OK -- user has full control

    url = "https://{}/foo?key={}".format(user_input, query_val)
    requests.get(url) # NOT OK -- user has full control

    url = "https://{x}".format(x=user_input)
    requests.get(url) # NOT OK -- user has full control

    url = "https://{1}".format(0, user_input)
    requests.get(url) # NOT OK -- user has full control

def full_ssrf_percent_format():
    user_input = request.args['untrusted_input']
    query_val = request.args['query_val']

    # using %-formatting
    url = "https://%s" % user_input
    requests.get(url) # NOT OK -- user has full control

    url = "https://%s/foo" % user_input
    requests.get(url) # NOT OK -- user has full control

    url = "https://%s/foo/key=%s" % (user_input, query_val)
    requests.get(url) # NOT OK -- user has full control

def full_ssrf_f_strings():
    user_input = request.args['untrusted_input']
    query_val = request.args['query_val']

    # using f-strings
    url = f"https://{user_input}"
    requests.get(url) # NOT OK -- user has full control

    url = f"https://{user_input}/foo"
    requests.get(url) # NOT OK -- user has full control

    url = f"https://{user_input}/foo?key={query_val}"
    requests.get(url) # NOT OK -- user has full control


def partial_ssrf_1():
    user_input = request.args['untrusted_input']

    url = "https://example.com/foo?" + user_input
    requests.get(url) # NOT OK -- user controls query parameters

def partial_ssrf_2():
    user_input = request.args['untrusted_input']

    url = "https://example.com/" + user_input
    requests.get(url) # NOT OK -- user controls path

def partial_ssrf_3():
    user_input = request.args['untrusted_input']

    url = "https://example.com/" + user_input
    requests.get(url) # NOT OK -- user controls path

def partial_ssrf_4():
    user_input = request.args['untrusted_input']

    url = "https://example.com/foo#{}".format(user_input)
    requests.get(url) # NOT OK -- user contollred fragment

def partial_ssrf_5():
    user_input = request.args['untrusted_input']

    # this is probably the least interesting one, since it's only the fragment that is
    # controlled

    url = "https://example.com/foo#%s" % user_input
    requests.get(url) # NOT OK -- user contollred fragment

def partial_ssrf_6():
    user_input = request.args['untrusted_input']

    url = f"https://example.com/foo#{user_input}"
    requests.get(url) # NOT OK -- user only controlled fragment
