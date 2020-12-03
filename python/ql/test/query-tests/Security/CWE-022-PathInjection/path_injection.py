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
def unsafe_path_normpath():
    # Normalized, but `open()` is not guarded by `startswith` check
    filename = request.args.get('filename', '')
    npath = os.path.normpath(os.path.join(STATIC_DIR, filename))
    if npath.startswith(STATIC_DIR):
        pass
    f = open(npath)  # NOT OK


@app.route("/path4")
def safe_path_normpath():
    # Normalized, and checked properly
    filename = request.args.get('filename', '')
    npath = os.path.normpath(os.path.join(STATIC_DIR, filename))
    if npath.startswith(STATIC_DIR):
        f = open(npath)  # OK


@app.route("/path5")
def unsafe_path_realpath():
    # Normalized (by `realpath` that also follows symlinks), but not checked properly
    filename = request.args.get('filename', '')
    npath = os.path.realpath(os.path.join(STATIC_DIR, filename))
    f = open(npath)  # NOT OK


@app.route("/path6")
def safe_path_realpath():
    # Normalized (by `realpath` that also follows symlinks), and checked properly
    filename = request.args.get('filename', '')
    npath = os.path.realpath(os.path.join(STATIC_DIR, filename))
    if npath.startswith(STATIC_DIR):
        f = open(npath)  # OK


@app.route("/path6")
def unsafe_path_abspath():
    # Normalized (by `abspath`), but not checked properly
    filename = request.args.get('filename', '')
    npath = os.path.abspath(os.path.join(STATIC_DIR, filename))
    f = open(npath)  # NOT OK


@app.route("/path7")
def safe_path_abspath():
    # Normalized (by `abspath`), and checked properly
    filename = request.args.get('filename', '')
    npath = os.path.abspath(os.path.join(STATIC_DIR, filename))
    if npath.startswith(STATIC_DIR):
        f = open(npath)  # OK
