import json
from flask import Flask, request, make_response, escape

app = Flask(__name__)


@app.route("/unsafe")
def unsafe():
    first_name = request.args.get("name", "")
    return make_response("Your name is " + first_name)  # NOT OK


@app.route("/safe")
def safe():
    first_name = request.args.get("name", "")
    return make_response("Your name is " + escape(first_name))  # OK


@app.route("/unsafe/json")
def unsafe_json():
    data = json.loads(request.data)
    return make_response(json.dumps(data))  # NOT OK


@app.route("/safe/json")
def safe_json():
    data = json.loads(request.data)
    return make_response(json.dumps(data), 200, {'Content-Type': 'application/json'})  # OK, FP
