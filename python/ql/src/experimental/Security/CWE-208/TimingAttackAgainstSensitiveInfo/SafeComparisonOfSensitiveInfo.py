#!/usr/bin/env python
# -*- coding: UTF-8 -*-

"""
@Desc   ：preventing timing attack sensitive info
"""
from flask import Flask
from flask import request
import hmac

app = Flask(__name__)

@app.route('/bad', methods = ['POST', 'GET'])
def bad():
    if request.method == 'POST':
        password = request.form['pwd']
        return hmac.compare_digest(password, "1234")
    
if __name__ == '__main__':
    app.debug = True
    app.run() 
