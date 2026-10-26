import re
from flask import Flask, request
app = Flask(__name__)

@app.route("/poly-redos")
def code_execution():
    text = request.args.get("text")
    re.sub(r"^\s+|\s+$", "", text) # NOT OK
    re.match(r"^0\.\d+E?\d+$", text) # NOT OK
