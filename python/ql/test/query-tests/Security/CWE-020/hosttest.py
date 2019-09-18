from flask import Flask, request, redirect
import re

app = Flask(__name__)

UNSAFE_REGEX = re.compile("(www|beta).example.com/")
SAFE_REGEX = re.compile(r"(www|beta)\.example\.com/")

@app.route('/some/path/bad')
def unsafe(request):
    target = request.args.get('target', '')
    if UNSAFE_REGEX.match(target):
        return redirect(target)

@app.route('/some/path/good')
def safe(request):
    target = request.args.get('target', '')
    if SAFE_REGEX.match(target):
        return redirect(target)
