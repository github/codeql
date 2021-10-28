#!/usr/bin/env python
# -*- coding: UTF-8 -*-
"""
@Desc   ：Any File Injection
"""
from flask import Flask, send_file, make_response
from flask import request
from flask.blueprints import Blueprint
import os

blueprint = Blueprint('routes_general',
                      __name__,
                      static_folder='../static',
                      template_folder='../templates')

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

@blueprint.route('/note_attachment/<filename>')
def bad3(filename):
    file_path = os.path.join(PATH_NOTE_ATTACHMENTS, filename)
    if file_path is not None:
        try:
            return send_file(file_path, as_attachment=True)
        except Exception:
            logger.exception("Send note attachment")

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