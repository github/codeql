#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：
"""
from fastapi import FastAPI, Request
from flask import Flask, request, send_file, make_response, helpers, jsonify, render_template,render_template_string, Response
from flask.json import jsonify
from pathlib import Path
from werkzeug.utils import secure_filename
import io
import os
import builtins

app = Flask(__name__)


@app.route('/fileRead1')
def fileRead1():
    filename = request.args.get('filename')
    context = io.open(filename)
    response = make_response(context)
    return response

@app.route('/fileRead2')
def fileRead2():
    filename = request.args.get('filename')
    context = open(filename, encoding="utf-8").read()
    return context

@app.route('/fileRead3')
def fileRead3():
    filename = request.args.get('filename')
    context = ""
    with builtins.open(filename, encoding="utf-8") as f:
        context = f.readlines()
    return context

@app.route('/fileRead4')
def fileRead4():
    filename = request.args.get('filename')
    response = send_file(path_or_file = "/home/work/" + filename)
    return response

@app.route('/fileRead5')
def fileRead5():
    filename = request.args.get('filename')
    context = helpers.send_file(filename)
    return context

@app.route('/fileRead6')
def fileRead6():
    filename = request.args.get('filename')
    context = os.listdir(filename)
    return render_template_string("filedelete.html", contents = context)

@app.route('/fileRead7')
def fileRead7():
    filename = request.args.get('filename')
    fd = os.open(filename, os.O_RDWR|os.O_CREAT)
    result = os.fdopen(fd).read()
    return jsonify(result)

@app.route('/fileRead8')
def fileRead8():
    filename = request.args.get('filename')
    result = ""
    for dir in os.scandir(filename):
        result += str(dir)
    return render_template_string(filename)

@app.route('/fileDelete1')
def fileDelete1():
    filename = request.args.get('filename')
    result = ""
    try:
        result = os.remove(filename)
    except Exception as e:
        result = "failed"
    response = make_response(result)
    return response

@app.route('/fileDelete2')
def fileDelete2():
    filename = request.args.get('filename')
    result = ""
    try:
        result = os.removedirs(filename)
    except Exception as e:
        result = "failed"
    return result, 200

@app.route('/fileDelete3')
def fileDelete3():
    filename = request.args.get('filename')
    result = ""
    try:
        result = os.unlink(filename)
    except Exception as e:
        result = "failed"
    return render_template(template_name_or_list = "filedelete.html", contents = filename)

@app.route('/good1')
def good1():
    filename = request.args.get('filename')
    sec_filename = secure_filename(filename)
    try:
        result = os.unlink(sec_filename)
    except Exception as e:
        result = "failed"

if __name__ == '__main__':
    app.debug = True
    app.run(host = '0.0.0.0')