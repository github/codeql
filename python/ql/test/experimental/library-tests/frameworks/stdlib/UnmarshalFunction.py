import flask
import pickle
import marshal

from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def hello():
    payload = request.args.get("payload")
    pickle.loads(payload)  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute() $UNSAFE_getFormat=pickle
    pickle.loads(payload, encoding='latin1')  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute() $UNSAFE_getFormat=pickle
    marshal.loads(payload)  # $UNSAFE_getAnInput=payload $UNSAFE_getOutput=Attribute() $UNSAFE_getFormat=marshal
