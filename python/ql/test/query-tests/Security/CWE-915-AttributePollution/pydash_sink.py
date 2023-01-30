from flask import Flask, request
import pydash


class User:
    def __init__(self):
        pass


app = Flask(__name__)


@app.route("/vuln")
def vuln_handler():
    not_accessible_variable = 'Hello'
    # '__class__.__init__.__globals__.not_accessible_variable'
    pydash.set_(User(), request.args['arg'], 'Polluted variable')
    return not_accessible_variable