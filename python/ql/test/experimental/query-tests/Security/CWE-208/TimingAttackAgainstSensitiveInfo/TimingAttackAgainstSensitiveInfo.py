#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：timing attack against Secret
"""
from flask import Flask
from flask import request
from django.utils.crypto import constant_time_compare

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
        return constant_time_compare(password, "1234")
    
if __name__ == '__main__':
    app.debug = True
    app.run() 
