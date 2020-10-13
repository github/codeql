import flask
import dill

from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def hello():
    payload = request.args.get("payload")
    dill.loads(payload)  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute() $UNSAFE_getFormat=ASCII
    dill.loads(payload, encoding='latin1')  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute() $UNSAFE_getFormat=latin1
