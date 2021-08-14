from flask import request, Flask
import re


@app.route("/direct")
def direct():
    unsafe_pattern = request.args['pattern']
    safe_pattern = re.escape(unsafe_pattern)
    re.search(safe_pattern, "")


@app.route("/compile")
def compile():
    unsafe_pattern = request.args['pattern']
    safe_pattern = re.escape(unsafe_pattern)
    compiled_pattern = re.compile(safe_pattern)
    compiled_pattern.search("")
