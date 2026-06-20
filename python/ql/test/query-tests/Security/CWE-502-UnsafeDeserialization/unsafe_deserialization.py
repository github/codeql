import flask
import pickle
import yaml
import marshal

from yaml import SafeLoader

from flask import Flask, request # $ Source
app = Flask(__name__)


@app.route("/")
def hello():
    payload = request.args.get("payload")
    pickle.loads(payload) # $ Alert # NOT OK
    yaml.load(payload) # $ Alert # NOT OK
    yaml.load(payload, Loader=SafeLoader) # OK
    marshal.loads(payload) # $ Alert # NOT OK

    import dill
    dill.loads(payload) # $ Alert # NOT OK

    import pandas
    pandas.read_pickle(payload) # $ Alert # NOT OK
