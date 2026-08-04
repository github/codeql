#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：Log Injection
"""
from flask import Flask
from flask import request # $ Source
from django.utils.log import request_logger
import logging

logging.basicConfig(level=logging.DEBUG)

app = Flask(__name__)

@app.route('/bad1')
def bad1():
    name = request.args.get('name')
    app.logger.info('User name: ' + name) # $ Alert # Bad
    return 'bad1'

@app.route('/bad2')
def bad2():
    name = request.args.get('name')
    logging.info('User name: ' + name) # $ Alert # Bad
    return 'bad2'

@app.route('/bad3')
def bad3():
    name = request.args.get('name')
    request_logger.warn('User name: ' + name) # $ Alert # Bad
    return 'bad3'

@app.route('/bad4')
def bad4():
    name = request.args.get('name')
    logtest = logging.getLogger('test')
    logtest.debug('User name: ' + name) # $ Alert # Bad
    return 'bad4'

if __name__ == '__main__':
    app.debug = True
    handler = logging.FileHandler('log')
    app.logger.addHandler(handler)
    app.run()
