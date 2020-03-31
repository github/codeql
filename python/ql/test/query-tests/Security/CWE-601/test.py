from flask import Flask, request, redirect

app = Flask(__name__)

@app.route('/')
def hello():
    target = request.args.get('target', '')
    return redirect(target, code=302)


#Check for safe prefixes

@app.route('/ok')
def ok():
    untrusted = request.args.get('ok', '')
    safe = "safe"
    safe += untrusted
    return redirect(safe, code=302)
