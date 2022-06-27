#!/usr/bin/env python
# -*- coding: UTF-8 -*-

"""
@Desc   ：preventing timing attack
"""
import hmac
from flask import Flask
from flask import request
import hashlib

key = "e179017a-62b0-4996-8a38-e91aa9f1"

@app.route('/good1')
def good1():
    Secret = request.headers.get('X-Auth-Token')    
    if not hmac.compare_digest(Secret, "token"):
        raise Exception('bad token')
    return 'good1'

@app.route('/good2')
def check_credentials(password):
    return hmac.compare_digest(password, "token")

def sign(pre_key, msg, alg):
    return hmac.new(pre_key, msg, alg).digest()

def verify(msg, sig):
    return hmac.compare_digest(sig, sign(key, msg, hashlib.sha256)) #good
        
if __name__ == '__main__':
    app.debug = True
    app.run() 
