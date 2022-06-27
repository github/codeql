#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：timing attack
"""

from flask import Flask
from flask import request
import hmac

app = Flask(__name__)

key = "e179017a-62b0-4996-8a38-e91aa9f1"

@app.route('/bad1')
def bad1():
    Secret = request.headers.get('X-Auth-Token')
    if not Secret == "key":
        raise Exception('bad token')
    return 'bad1'

@app.route('/bad2')
def check_credentials(password):
    return password == "token"
    
def sign(pre_key, msg, alg):
    return hmac.new(pre_key, msg, alg).digest()

def verify(msg, sig):
    return sig == sign(key, msg, hashlib.sha256) #bad
           
if __name__ == '__main__':
    app.debug = True
    app.run() 
