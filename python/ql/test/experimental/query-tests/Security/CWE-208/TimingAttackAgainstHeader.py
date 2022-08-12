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
def bad1():
    if not request.headers.get('X-Auth-Token') == "key":
        raise Exception('bad token')
    return 'bad1'

@app.route('/good')
def good1(): 
    if not hmac.compare_digest(Secret, "token"):
        raise Exception('bad token')
    return 'good1'
 
if __name__ == '__main__':
    app.debug = True
    app.run() 
