import requests
from flask import Flask, request

app = Flask(__name__)

@app.route("/full_ssrf")
def full_ssrf():
    target = request.args["target"]

    # BAD: user has full control of URL
    resp = request.get("https://" + target + ".example.com/data/")

    # GOOD: `subdomain` is controlled by the server.
    subdomain = "europe" if target == "EU" else "world"
    resp = request.get("https://" + subdomain + ".example.com/data/")
