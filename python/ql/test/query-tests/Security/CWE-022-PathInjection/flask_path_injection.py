from flask import Flask, request, send_from_directory
import os

app = Flask(__name__)


STATIC_DIR = "/server/static/"


# see https://flask.palletsprojects.com/en/1.1.x/api/#flask.send_from_directory
@app.route("/provide-filename")
def download_file():
    filename = request.args.get('filename', '')
    # ok since `send_from_directory` ensure this stays within `STATIC_DIR`
    return send_from_directory(STATIC_DIR, filename) # OK


# see https://flask.palletsprojects.com/en/1.1.x/api/#flask.send_from_directory
@app.route("/also-provide-dirname")
def download_file():
    dirname = request.args.get('dirname', '')
    filename = request.args.get('filename', '')
    return send_from_directory(dirname, filename) # NOT OK


# see https://flask.palletsprojects.com/en/1.1.x/api/#flask.send_from_directory
@app.route("/join-filename")
def download_file():
    filename = request.args.get('filename', '')
    f = os.path.join("soemthing",filename)
    return send_from_directory(STATIC_DIR, f) #  OK

# see https://flask.palletsprojects.com/en/1.1.x/api/#flask.send_from_directory
@app.route("/join-dirname")
def download_file():
    dirname = request.args.get('dirname', '')
    filename = request.args.get('filename', '')
    d = os.path.join(STATIC_DIR,dirname)
    return send_from_directory(d, filename) # NOT OK