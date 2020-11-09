
import os.path

from flask import Flask, request
app = Flask(__name__)

@app.route("/path1")
def path_injection():
    path = request.args.get('path', '')
    f = open(os.path.join(os.getcwd(), path))

@app.route("/path2")
def path_injection():
    # Normalized, but not checked
    path = request.args.get('path', '')
    npath = os.path.normpath(os.path.join(os.getcwd(), path))
    f = open(npath)  # Path not found

SAFE = "/tmp/scratch_area/"

@app.route("/path3")
def safe_path():
    # Normalized, but check doesn't reach open().
    path = request.args.get('path', '')
    npath = os.path.normpath(os.path.join(os.getcwd(), path))
    if npath.startswith(SAFE):
        pass
    f = open(npath)  # Path not found

@app.route("/path4")
def safe_path():
    # Normalized, and checked properly
    path = request.args.get('path', '')
    npath = os.path.normpath(os.path.join(os.getcwd(), path))
    if npath.startswith(SAFE):
        f = open(npath)
