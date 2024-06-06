from flask import Flask, request, redirect
from urllib.parse import urlparse

app = Flask(__name__)

@app.route('/')
def hello():
    target = request.args.get('target', '')
    target = target.replace('\\', '')
    if not urlparse(target).netloc and not urlparse(target).scheme:
        # relative path, safe to redirect
        return redirect(target, code=302)
    # ignore the target and redirect to the home page
    return redirect('/', code=302)
