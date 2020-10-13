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
    pickle.loads(payload)  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute()
    yaml.load(payload)  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute()
    yaml.load(payload, Loader=SafeLoader)  # $getAnInput=payload $getOutput=Attribute()
    marshal.loads(payload)  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute()

    import dill
    dill.loads(payload)  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute()
