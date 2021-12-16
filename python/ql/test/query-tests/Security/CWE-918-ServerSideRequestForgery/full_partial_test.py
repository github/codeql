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


    # using .format
    url = "https://{}".format(user_input)
    requests.get(url) # NOT OK -- user has full control

    url = "https://{}/foo".format(user_input)
    requests.get(url) # NOT OK -- user has full control

    url = "https://{}/foo?key={}".format(user_input, query_val)
    requests.get(url) # NOT OK -- user has full control


    # using %-formatting
    url = "https://%s" % user_input
    requests.get(url) # NOT OK -- user has full control

    url = "https://%s/foo" % user_input
    requests.get(url) # NOT OK -- user has full control

    url = "https://%s/foo/key=%s" % (user_input, query_val)
    requests.get(url) # NOT OK -- user has full control


    # using f-strings
    url = f"https://{user_input}"
    requests.get(url) # NOT OK -- user has full control

    url = f"https://{user_input}/foo"
    requests.get(url) # NOT OK -- user has full control

    url = f"https://{user_input}/foo?key={query_val}"
    requests.get(url) # NOT OK -- user has full control


def partial_ssrf():
    user_input = request.args['untrusted_input']

    url = "https://example.com/foo?" + user_input
    requests.get(url) # NOT OK -- user controls query parameters

    url = "https://example.com/" + user_input
    requests.get(url) # NOT OK -- user controls path

    url = "https://example.com/" + user_input
    requests.get(url) # NOT OK -- user controls path

    url = "https://example.com/foo#{}".format(user_input)
    requests.get(url) # NOT OK -- user contollred fragment

    # this is probably the least interesting one, since it's only the fragment that is
    # controlled

    url = "https://example.com/foo#%s" % user_input
    requests.get(url) # NOT OK -- user contollred fragment

    url = f"https://example.com/foo#{user_input}"
    requests.get(url) # NOT OK -- user only controlled fragment
