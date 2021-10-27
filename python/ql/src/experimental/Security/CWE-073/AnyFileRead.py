#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：Any File Injection
"""
from flask import Flask, send_file, make_response
from flask import request
import os

filenames = ["/home/work/temp/a.png", "/home/work/temp/b.png"]

app = Flask(__name__)

@app.route('/bad1')
def bad1():
    filename = request.args.get('filename')
    context = send_file(filename, as_attachment=True) # Bad
    return context

@app.route('/bad2')
def bad2():
    filename = request.args.get('filename')
    context = open(filename, 'r') # Bad
    response = make_response(context)
    return response

@app.route('/good1')
def good1():
    filename = request.args.get('filename')
    if filename in filenames: # Good
        context = open(filename, 'r')
    else:
        context = "filename error"
    response = make_response(context)
    return response

if __name__ == '__main__':
    app.debug = True
    app.run()