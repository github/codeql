from flask import Flask, request, redirect

VALID_REDIRECT = "http://cwe.mitre.org/data/definitions/601.html"

app = Flask(__name__)

@app.route('/')
def hello():
    target = request.args.get('target', '')
    if target == VALID_REDIRECT:
        return redirect(target, code=302)
    else:
        ... # Error
