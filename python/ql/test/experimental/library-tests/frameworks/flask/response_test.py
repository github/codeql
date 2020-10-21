import json

from flask import Flask, make_response, jsonify, Response

app = Flask(__name__)


@app.route("/html1")
def html1():
    return "<h1>hello</h1>"


@app.route("/html2")
def html2():
    # note that response saved in a variable intentionally -- we wan the annotations to
    # show that we recognize the response creation, and not the return (hopefully). (and
    # do the same in the following of the file)
    resp = make_response("<h1>hello</h1>")
    return resp


@app.route("/html3")
def html3():
    resp = app.make_response("<h1>hello</h1>")
    return resp


# TODO: Create test-cases for the many ways that `make_response` can be used
# https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.make_response


@app.route("/html4")
def html4():
    resp = Response("<h1>hello</h1>")
    return resp


@app.route("/html5")
def html5():
    # note: flask.Flask.response_class is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = Flask.response_class("<h1>hello</h1>")
    return resp


@app.route("/html6")
def html6():
    # note: app.response_class (flask.Flask.response_class) is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = app.response_class("<h1>hello</h1>")
    return resp


@app.route("/jsonify")
def jsonify_route():
    data = {"foo": "bar"}
    response = jsonify(data)
    return response


################################################################################
# Setting content-type manually
################################################################################


@app.route("/content-type/response-modification1")
def response_modification1():
    resp = make_response("<h1>hello</h1>")
    resp.content_type = "text/plain"
    return resp


@app.route("/content-type/response-modification2")
def response_modification2():
    resp = make_response("<h1>hello</h1>")
    resp.headers["content-type"] = "text/plain"
    return resp


# Exploration of mimetype/content_type/headers arguments to `app.response_class` -- things can get tricky
# see https://werkzeug.palletsprojects.com/en/1.0.x/wrappers/#werkzeug.wrappers.Response


@app.route("/content-type/Response1")
def Response1():
    resp = Response("<h1>hello</h1>", mimetype="text/plain")
    return resp


@app.route("/content-type/Response2")
def Response2():
    resp = Response("<h1>hello</h1>", content_type="text/plain; charset=utf-8")
    return resp


@app.route("/content-type/Response3")
def Response3():
    # content_type argument takes priority (and result is text/plain)
    resp = Response("<h1>hello</h1>", content_type="text/plain; charset=utf-8", mimetype="text/html")
    return resp


@app.route("/content-type/Response4")
def Response4():
    # note: capitalization of Content-Type does not matter
    resp = Response("<h1>hello</h1>", headers={"Content-TYPE": "text/plain"})
    return resp


@app.route("/content-type/Response5")
def Response5():
    # content_type argument takes priority (and result is text/plain)
    # note: capitalization of Content-Type does not matter
    resp = Response("<h1>hello</h1>", headers={"Content-TYPE": "text/html"}, content_type="text/plain; charset=utf-8")
    return resp


@app.route("/content-type/Flask-response-class")
def Flask_response_class():
    # note: flask.Flask.response_class is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = Flask.response_class("<h1>hello</h1>", mimetype="text/plain")
    return resp


@app.route("/content-type/app-response-class")
def app_response_class():
    # note: app.response_class (flask.Flask.response_class) is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = app.response_class("<h1>hello</h1>", mimetype="text/plain")
    return resp

# TODO: add tests for setting status code
# TODO: add test that manually creates a redirect by setting status code and suitable header.

################################################################################


if __name__ == "__main__":
    app.run(debug=True)
