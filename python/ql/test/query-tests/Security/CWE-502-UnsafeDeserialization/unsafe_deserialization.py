import flask
import pickle
import yaml
import marshal

from yaml import SafeLoader

from flask import Flask, request
app = Flask(__name__)


@app.route("/")
def hello():
    payload = request.args.get("payload")
    pickle.loads(payload) # NOT OK
    yaml.load(payload) # NOT OK
    yaml.load(payload, Loader=SafeLoader) # OK
    marshal.loads(payload) # NOT OK

    import dill
    dill.loads(payload) # NOT OK

    import pandas
    pandas.read_pickle(payload) # NOT OK