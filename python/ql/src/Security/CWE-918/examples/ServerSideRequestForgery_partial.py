import requests
from flask import Flask, request

app = Flask(__name__)

@app.route("/partial_ssrf")
def partial_ssrf():
    user_id = request.args["user_id"]

    # BAD: user can fully control the path component of the URL
    resp = requests.get("https://api.example.com/user_info/" + user_id)

    if user_id.isalnum():
        # GOOD: user_id is restricted to be alpha-numeric, and cannot alter path component of URL
        resp = requests.get("https://api.example.com/user_info/" + user_id)
