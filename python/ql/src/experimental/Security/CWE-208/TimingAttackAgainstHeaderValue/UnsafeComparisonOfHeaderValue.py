#!/usr/bin/env python
# -*- coding: UTF-8 -*-

"""
@Desc   ：preventing timing attack against header value
"""

from flask import Flask
from flask import request

@app.route('/bad')
def bad():
    secret = request.headers.get('X-Auth-Token')    
    if secret == "token":
        raise Exception('bad token')
    return 'bad'

if __name__ == '__main__':
    app.debug = True
    app.run() 
