#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：Timing Attack Against Header
"""
from flask import Flask
from flask import request
import hmac

app = Flask(__name__)

@app.route('/bad')
def bad():
    if not request.headers.get('X-Auth-Token') == "token": # $ Alert
        raise Exception('bad token')
    return 'bad'

@app.route('/good')
def good(): 
    tok = request.headers.get('X-Auth-Token')
    if not hmac.compare_digest(tok, "token"):
        raise Exception('bad token')
    return 'good'
 
if __name__ == '__main__':
    app.debug = True
    app.run() 
