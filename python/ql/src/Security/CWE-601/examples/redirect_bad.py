from flask import Flask, request, redirect

app = Flask(__name__)

@app.route('/')
def hello():
    target = files = request.args.get('target', '')
    return redirect(target, code=302)
