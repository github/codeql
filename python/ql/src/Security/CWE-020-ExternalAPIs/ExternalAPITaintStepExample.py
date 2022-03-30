import base64
import pickle

from flask import Flask, request, make_response
app = Flask(__name__)

@app.route("/example")
def profile():
    raw_data = request.args.get("data").encode('utf-8')
    data = base64.decodebytes(raw_data)
    obj = pickle.loads(data)
    ...
