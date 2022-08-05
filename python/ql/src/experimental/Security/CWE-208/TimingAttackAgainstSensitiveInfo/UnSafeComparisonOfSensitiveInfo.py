#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：timing attack against sensitive info
"""

from flask import Flask
from flask import request

@app.route('/bad')
def check_credentials(password):
    return password == "token"
    
if __name__ == '__main__':
    app.debug = True
    app.run() 
