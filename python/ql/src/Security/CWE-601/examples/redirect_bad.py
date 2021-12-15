from flask import Flask, request, redirect

app = Flask(__name__)

@app.route('/')
def hello():
    target = request.args.get('target', '')
    return redirect(target, code=302)
