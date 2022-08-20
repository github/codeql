from flask import Flask, request, make_response, Response


@app.route("/1")
def true():
    resp = make_response()
    resp.set_cookie("name", value="value", secure=True)
    return resp


@app.route("/2")
def flask_make_response():
    resp = make_response("hello")
    resp.headers['Set-Cookie'] = "name=value; Secure;"
    return resp
