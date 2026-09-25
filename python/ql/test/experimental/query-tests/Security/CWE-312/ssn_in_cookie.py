from flask import Flask, make_response, request, Response

app = Flask("Leak social security number")

@app.route('/')
def index():
    socialsecurity = request.args.get("social security number")
    resp = make_response(render_template(...))
    resp.set_cookie("social security number", socialsecurity)
    return resp

@app.route('/')
def index2():
    socialsecurity = request.args.get("social security number")
    resp = Response(...)
    resp.set_cookie("social security number", socialsecurity)
    return resp
