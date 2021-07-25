from flask import Flask, request, make_response, Response


@app.route("/true")
def true():
    resp = make_response()
    resp.set_cookie("name", value="value", secure=True)
    return resp


@app.route("/flask_make_response")
def flask_make_response():
    resp = make_response("hello")
    resp.headers['Set-Cookie'] = "name=value; Secure;"
    return resp