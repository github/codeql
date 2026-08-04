from flask import Flask, make_response, request, Response

app = Flask("Leak password")

@app.route('/')
def index():
    password = request.args.get("password") # $ Source
    resp = make_response(render_template(...))
    resp.set_cookie("password", password) # $ Alert # NOT OK
    return resp

@app.route('/')
def index2():
    password = request.args.get("password") # $ Source
    resp = Response(...)
    resp.set_cookie("password", password) # $ Alert # NOT OK
    return resp
