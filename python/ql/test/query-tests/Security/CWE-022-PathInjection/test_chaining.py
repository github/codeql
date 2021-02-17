import os.path

from flask import Flask, request

app = Flask(__name__)


def source():
    return request.args.get("path", "")


# Wrap normalization, so we can fool the chained configurations.
# (Call context is lost at cross-over nodes.)
def normalize(x):
    return os.path.normpath(x)


@app.route("/path")
def normalize_then_check():
    x = source()
    y = normalize(x)  # <--- this call...
    if y.startswith("subfolder/"):
        open(y)  # OK


@app.route("/path")
def normalize_check_normalize():
    x = source()
    y = normalize(x)  # (...or this call...)
    if y.startswith("subfolder/"):
        z = normalize(y)  # <--- ...can jump to here, resulting in FP
        open(z)  # OK


# The problem does not manifest if we simply define an alias
normpath = os.path.normpath


@app.route("/path")
def normalize_check_normalize_alias():
    x = source()
    y = normpath(x)
    if y.startswith("subfolder/"):
        z = normpath(y)
        open(z)  # OK
