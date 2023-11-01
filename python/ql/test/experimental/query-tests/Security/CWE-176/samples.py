import unicodedata
from flask import Flask, request, escape, render_template

app = Flask(__name__)


@app.route("/unsafe1")
def unsafe1():
    user_input = escape(request.args.get("ui"))
    normalized_user_input = unicodedata.normalize("NFKC", user_input)  # $result=BAD
    return render_template("result.html", normalized_user_input=normalized_user_input)


@app.route("/unsafe2")
def unsafe1bis():
    user_input = escape(request.args.get("ui"))
    if user_input.isascii():
        normalized_user_input = user_input
    else:
        normalized_user_input = unicodedata.normalize("NFC", user_input)  # $result=BAD
    return render_template("result.html", normalized_user_input=normalized_user_input)


@app.route("/safe1")
def safe1():
    normalized_user_input = unicodedata.normalize(
        "NFKC", request.args.get("ui")
    )  # $result=OK
    user_input = escape(normalized_user_input)
    return render_template("result.html", normalized_user_input=user_input)
