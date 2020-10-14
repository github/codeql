import flask
import pickle
import marshal

from flask import Flask, request

app = Flask(__name__)


@app.route("/")
def hello():
    payload = request.args.get("payload")
    pickle.loads(payload)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=pickle $decodeUnsafe=
    pickle.loads(payload, encoding='latin1')  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=pickle $decodeUnsafe=
    marshal.loads(payload)  # $decodeInput=payload $decodeOutput=Attribute() $decodeFormat=pickle $decodeUnsafe=
