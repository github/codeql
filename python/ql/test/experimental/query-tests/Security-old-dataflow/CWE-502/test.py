import flask
import pickle
import yaml
import marshal

from flask import Flask, request
app = Flask(__name__)

@app.route("/")
def hello():
    payload = request.args.get('payload')
    pickle.loads(payload)
    yaml.load(payload)
    marshal.loads(payload)
    import dill
    dill.loads(payload)


