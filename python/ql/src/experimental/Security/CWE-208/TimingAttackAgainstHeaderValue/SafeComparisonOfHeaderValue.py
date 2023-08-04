#!/usr/bin/env python
# -*- coding: UTF-8 -*-

"""
@Desc   ：preventing timing attack against header value
"""

from flask import Flask
from flask import request
import hmac

@app.route('/good')
def good():
    secret = request.headers.get('X-Auth-Token')    
    if not hmac.compare_digest(secret, "token"):
        raise Exception('bad token')
    return 'good'

if __name__ == '__main__':
    app.debug = True
    app.run() 
