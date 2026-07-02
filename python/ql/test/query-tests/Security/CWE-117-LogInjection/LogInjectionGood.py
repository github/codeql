#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：Log Injection
"""
from flask import Flask
from flask import request
import logging

logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)

@app.route('/good1')
def good1():
    name = request.args.get('name')
    name = name.replace('\r\n','').replace('\n','')
    logging.info('User name: ' + name) # Good
    return 'good1'

@app.route('/good_repr1')
def good_repr1():
    name = request.args.get('name')
    logging.info('User name: ' + repr(name)) # Good - repr() escapes special characters
    return 'good_repr1'

@app.route('/good_repr2')
def good_repr2():
    name = request.args.get('name')
    logging.info('User name: %r', name) # Good - %r format specifier applies repr()
    return 'good_repr2'

if __name__ == '__main__':
    app.debug = True
    handler = logging.FileHandler('log')
    app.logger.addHandler(handler)
    app.run()
