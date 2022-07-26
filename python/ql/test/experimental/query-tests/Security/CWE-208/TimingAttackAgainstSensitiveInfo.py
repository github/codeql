#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：timing attack against Secret
"""
from flask import Flask
from flask import request

app = Flask(__name__)

@app.route('/bad')
def check_credentials():
    if request.method == 'POST':
        password = request.form['pwd']
        return password == sec
    
@app.route('/good')
def check_credentials(sec):
    if request.method == 'POST':
        password = request.form['pwd']
        return constant_time_string_compare(password, sec)

def constant_time_string_compare(a, b):
    if len(a) != len(b):
        return False

    result = 0

    for x, y in zip(a, b):
        result |= ord(x) ^ ord(y)

    return result == 0
    
if __name__ == '__main__':
    app.debug = True
    app.run() 
