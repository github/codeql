#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：timing attack against Secret
"""
from flask import Flask
from flask import request

app = Flask(__name__)

@app.route('/bad', methods = ['POST', 'GET'])
def bad():
    if request.method == 'POST':
        password = request.form['pwd']
        return password == "1234"
    
@app.route('/good', methods = ['POST', 'GET'])
def good():
    if request.method == 'POST':
        password = request.form['pwd']
        return constant_time_string_compare(password, "1234")

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
