import flask
import pickle
import yaml
import marshal

from flask import Flask, request
app = Flask(__name__)

@app.route("/")
def hello():
    payload = request.args.get('payload')
    pickle.loads(payload)  # $getData=payload
    yaml.load(payload)  # $getData=payload
    marshal.loads(payload)  # $getData=payload
    import dill
    dill.loads(payload)  # $getData=payload
