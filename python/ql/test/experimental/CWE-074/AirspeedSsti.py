import airspeed
from flask import Flask, request


app = Flask(__name__)


@app.route("/")


@route('/other')
def a():
    template = request.args.get('template')
    return airspeed.Template(template)
