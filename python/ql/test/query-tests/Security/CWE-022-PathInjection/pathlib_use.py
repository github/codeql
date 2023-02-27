import pathlib

from flask import Flask, request
app = Flask(__name__)


STATIC_DIR = pathlib.Path("/server/static/")


@app.route("/pathlib_use")
def path_injection():
    filename = request.args.get('filename', '')
    p = STATIC_DIR / filename
    p.open() # $ result=BAD

    p2 = pathlib.Path(STATIC_DIR, filename)
    p2.open() # $ result=BAD
