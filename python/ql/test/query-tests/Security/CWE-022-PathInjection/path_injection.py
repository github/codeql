import os

from flask import Flask, request
app = Flask(__name__)


STATIC_DIR = "/server/static/"


@app.route("/path1")
def path_injection():
    filename = request.args.get('filename', '')
    f = open(os.path.join(STATIC_DIR, filename)) # NOT OK


@app.route("/path2")
def path_injection():
    # Normalized, but not checked
    filename = request.args.get('filename', '')
    npath = os.path.normpath(os.path.join(STATIC_DIR, filename))
    f = open(npath)  # NOT OK


@app.route("/path3")
def safe_path():
    # Normalized, but `open()` is not guarded by `startswith` check
    filename = request.args.get('filename', '')
    npath = os.path.normpath(os.path.join(STATIC_DIR, filename))
    if npath.startswith(STATIC_DIR):
        pass
    f = open(npath)  # NOT OK


@app.route("/path4")
def safe_path():
    # Normalized, and checked properly
    filename = request.args.get('filename', '')
    npath = os.path.normpath(os.path.join(STATIC_DIR, filename))
    if npath.startswith(STATIC_DIR):
        f = open(npath)  # OK
