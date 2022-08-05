#!/usr/bin/env python
# -*- coding: UTF-8 -*-

"""
@Desc   ：preventing timing attack sensitive info
"""
import hmac
from flask import Flask
from flask import request

@app.route('/good')
def check_credentials(password):
    return hmac.compare_digest(password, "token")
  
if __name__ == '__main__':
    app.debug = True
    app.run() 
