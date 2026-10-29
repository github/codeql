from flask import Flask, make_response, request

app = Flask("Leak password")

@app.route('/')
def index():
    password = request.args.get("password")
    resp = make_response(render_template(...))
    resp.set_cookie("password", password)
    return resp
