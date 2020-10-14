import flask
import yaml
from yaml import SafeLoader

from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def hello():
    payload = request.args.get("payload")
    yaml.load(payload)  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute() $UNSAFE_getFormat=YAML
    yaml.load(payload, Loader=SafeLoader)  # $getAnInput=payload $getOutput=Attribute() $getFormat=YAML
