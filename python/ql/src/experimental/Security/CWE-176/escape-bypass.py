import unicodedata
from flask import Flask, request, escape, render_template

app = Flask(__name__)


@app.route("/unsafe1")
def unsafe1():
    user_input = escape(request.args.get("ui"))
    normalized_user_input = unicodedata.normalize("NFKC", user_input)
    return render_template("result.html", normalized_user_input=normalized_user_input)
