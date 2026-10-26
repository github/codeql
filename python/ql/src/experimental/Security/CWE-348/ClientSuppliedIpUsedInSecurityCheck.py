#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：ip address spoofing
"""
from flask import Flask
from flask import request

app = Flask(__name__)

@app.route('/bad1')
def bad1():
    client_ip = request.headers.get('x-forwarded-for')
    if not client_ip.startswith('192.168.'):
        raise Exception('ip illegal')
    return 'bad1'

@app.route('/bad2')
def bad2():
    client_ip = request.headers.get('x-forwarded-for')
    if not client_ip == '127.0.0.1':
        raise Exception('ip illegal')
    return 'bad2'

@app.route('/good1')
def good1():
    client_ip = request.headers.get('x-forwarded-for')
    client_ip = client_ip.split(',')[client_ip.split(',').length - 1]
    if not client_ip == '127.0.0.1':
        raise Exception('ip illegal')
    return 'good1'

if __name__ == '__main__':
    app.debug = True
    app.run()