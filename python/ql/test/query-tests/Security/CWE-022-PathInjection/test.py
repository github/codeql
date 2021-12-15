import os.path

from flask import Flask, request

app = Flask(__name__)


def source():
    return request.args.get("path", "")


def normalize(x):
    return os.path.normpath(x)


@app.route("/path")
def simple():
    x = source()
    open(x)  # NOT OK


@app.route("/path")
def normalization():
    x = source()
    y = normalize(x)
    open(y)  # NOT OK


@app.route("/path")
def check():
    x = source()
    if x.startswith("subfolder/"):
        open(x)  # NOT OK


@app.route("/path")
def normalize_then_check():
    x = source()
    y = normalize(x)
    if y.startswith("subfolder/"):
        open(y)  # OK


@app.route("/path")
def check_then_normalize():
    x = source()
    if x.startswith("subfolder/"):
        y = normalize(x)
        open(y)  # NOT OK
