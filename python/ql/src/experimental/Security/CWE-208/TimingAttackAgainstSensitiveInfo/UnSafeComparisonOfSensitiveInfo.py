#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：timing attack against sensitive info
"""

from flask import Flask
from flask import request

@app.route('/bad', methods = ['POST', 'GET'])
def bad():
    if request.method == 'POST':
        password = request.form['pwd']
        return password == "test"
    
if __name__ == '__main__':
    app.debug = True
    app.run() 
