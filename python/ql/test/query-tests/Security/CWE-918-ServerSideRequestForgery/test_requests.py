from flask import request # $ Source[py/full-ssrf]
from AntiSSRF import AntiSSRFPolicy

import requests

def ssrf_test1():
    user_input = request.args['untrusted_input']
    # NOT OK -- user has full control
    requests.get(user_input)  # $ Alert[py/full-ssrf]
    # since `requests`` always uses complete URLs, it's not interesting to test more of
    # the framework directly. See `full_partial_test.py` for different ways to do SSRF.

def ssrf_test2():
    user_input = request.args['untrusted_input']
    # NOT OK -- user has full control
    session = requests.Session()
    session.get(user_input)  # $ Alert[py/full-ssrf]

def ssrf_test3():
    user_input = request.args['untrusted_input']
    # NOT OK -- user has full control
    requests.request('<method>', user_input)  # $ Alert[py/full-ssrf]

def ssrf_test_with_policy1():
    user_input = request.args['untrusted_input']
    policy = AntiSSRFPolicy()
    session = policy.get_antissrf_session()
    # OK -- dangerous user input is filtered by AntiSSRFPolicy
    session.get(user_input)

def ssrf_test_with_policy2():
    user_input = request.args['untrusted_input']
    policy = AntiSSRFPolicy()
    session = policy.get_antissrf_session()
    # overwriting the HTTPAdapter to default requests adapter
    # this makes the session unsafe again
    session.mount("http://", requests.adapters.HTTPAdapter())
    # NOT OK -- dangerous user input is no longer filtered by AntiSSRFPolicy
    # TODO: not currently a scenario we detect. 
    session.get(user_input) # $ MISSING: Alert[py/full-ssrf]

def ssrf_test_with_policy3(adapter):
    user_input = request.args['untrusted_input']
    policy = AntiSSRFPolicy()
    session = policy.get_antissrf_session()
    # overwriting the HTTPAdapter to a custom requests adapter
    # this could make the session unsafe again
    session.mount("http://", adapter)
    # NOT OK -- dangerous user input is no longer filtered by AntiSSRFPolicy
    # TODO: not currently a scenario we detect. 
    session.get(user_input) # $ MISSING: Alert[py/full-ssrf]