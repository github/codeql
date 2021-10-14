from flask import request, Flask
import re


@app.route("/direct")
def direct():
    unsafe_pattern = request.args["pattern"]
    re.search(unsafe_pattern, "")


@app.route("/compile")
def compile():
    unsafe_pattern = request.args["pattern"]
    compiled_pattern = re.compile(unsafe_pattern)
    compiled_pattern.search("")
