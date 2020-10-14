import flask
import yaml
from yaml import SafeLoader

from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def hello():
    payload = request.args.get("payload")
    yaml.load(payload)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=YAML $decodeUnsafe=
    yaml.load(payload, Loader=SafeLoader)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=YAML
