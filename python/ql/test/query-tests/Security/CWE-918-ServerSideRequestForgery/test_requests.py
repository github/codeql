from flask import request

import requests

def ssrf_test():
    user_input = request.args['untrusted_input']

    requests.get(user_input) # NOT OK -- user has full control

    # since `requests`` always uses complete URLs, it's not interesting to test more of
    # the framework directly. See `full_partial_test.py` for different ways to do SSRF.
