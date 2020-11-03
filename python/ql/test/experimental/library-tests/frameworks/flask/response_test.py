import json

from flask import Flask, make_response, jsonify, Response, request

app = Flask(__name__)


@app.route("/html1")  # $routeSetup="/html1"
def html1():  # $routeHandler
    return "<h1>hello</h1>"  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"


@app.route("/html2")  # $routeSetup="/html2"
def html2():  # $routeHandler
    # note that response saved in a variable intentionally -- we wan the annotations to
    # show that we recognize the response creation, and not the return (hopefully). (and
    # do the same in the following of the file)
    resp = make_response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/html3")  # $routeSetup="/html3"
def html3():  # $routeHandler
    resp = app.make_response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


# TODO: Create test-cases for the many ways that `make_response` can be used
# https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.make_response


@app.route("/html4")  # $routeSetup="/html4"
def html4():  # $routeHandler
    resp = Response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/html5")  # $routeSetup="/html5"
def html5():  # $routeHandler
    # note: flask.Flask.response_class is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = Flask.response_class("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/html6")  # $routeSetup="/html6"
def html6():  # $routeHandler
    # note: app.response_class (flask.Flask.response_class) is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = app.response_class("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/html7")  # $routeSetup="/html7"
def html7():  # $routeHandler
    resp = make_response()  # $HttpResponse mimetype=text/html
    resp.set_data("<h1>hello</h1>")  # $ MISSING: responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/jsonify")  # $routeSetup="/jsonify"
def jsonify_route():  # $routeHandler
    data = {"foo": "bar"}
    resp = jsonify(data)  # $ MISSING: HttpResponse mimetype=application/json responseBody=data
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp

################################################################################
# Tricky return handling
################################################################################

@app.route("/tricky-return1")  # $routeSetup="/tricky-return1"
def tricky_return1():  # $routeHandler
    if "raw" in request.args:
        resp = "<h1>hellu</h1>"
    else:
        resp = make_response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $HttpResponse mimetype=text/html responseBody=resp

def helper():
    if "raw" in request.args:
        return "<h1>hellu</h1>"
    else:
        return make_response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"

@app.route("/tricky-return2")  # $routeSetup="/tricky-return2"
def tricky_return2():  # $routeHandler
    resp = helper()
    return resp  # $HttpResponse mimetype=text/html responseBody=resp


################################################################################
# Setting content-type manually
################################################################################


@app.route("/content-type/response-modification1")  # $routeSetup="/content-type/response-modification1"
def response_modification1():  # $routeHandler
    resp = make_response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    resp.content_type = "text/plain"  # $ MISSING: HttpResponse mimetype=text/plain
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/response-modification2")  # $routeSetup="/content-type/response-modification2"
def response_modification2():  # $routeHandler
    resp = make_response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    resp.headers["content-type"] = "text/plain"  # $ MISSING: HttpResponse mimetype=text/plain
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


# Exploration of mimetype/content_type/headers arguments to `app.response_class` -- things can get tricky
# see https://werkzeug.palletsprojects.com/en/1.0.x/wrappers/#werkzeug.wrappers.Response


@app.route("/content-type/Response1")  # $routeSetup="/content-type/Response1"
def Response1():  # $routeHandler
    resp = Response("<h1>hello</h1>", mimetype="text/plain")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Response2")  # $routeSetup="/content-type/Response2"
def Response2():  # $routeHandler
    resp = Response("<h1>hello</h1>", content_type="text/plain; charset=utf-8")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Response3")  # $routeSetup="/content-type/Response3"
def Response3():  # $routeHandler
    # content_type argument takes priority (and result is text/plain)
    resp = Response("<h1>hello</h1>", content_type="text/plain; charset=utf-8", mimetype="text/html")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Response4")  # $routeSetup="/content-type/Response4"
def Response4():  # $routeHandler
    # note: capitalization of Content-Type does not matter
    resp = Response("<h1>hello</h1>", headers={"Content-TYPE": "text/plain"})  # $HttpResponse responseBody="<h1>hello</h1>" SPURIOUS: mimetype=text/html MISSING: mimetype=text/plain
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Response5")  # $routeSetup="/content-type/Response5"
def Response5():  # $routeHandler
    # content_type argument takes priority (and result is text/plain)
    # note: capitalization of Content-Type does not matter
    resp = Response("<h1>hello</h1>", headers={"Content-TYPE": "text/html"}, content_type="text/plain; charset=utf-8")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Response6")  # $routeSetup="/content-type/Response6"
def Response6():  # $routeHandler
    # mimetype argument takes priority over header (and result is text/plain)
    # note: capitalization of Content-Type does not matter
    resp = Response("<h1>hello</h1>", headers={"Content-TYPE": "text/html"}, mimetype="text/plain")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Flask-response-class")  # $routeSetup="/content-type/Flask-response-class"
def Flask_response_class():  # $routeHandler
    # note: flask.Flask.response_class is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = Flask.response_class("<h1>hello</h1>", mimetype="text/plain")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/app-response-class")  # $routeSetup="/content-type/app-response-class"
def app_response_class():  # $routeHandler
    # note: app.response_class (flask.Flask.response_class) is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = app.response_class("<h1>hello</h1>", mimetype="text/plain")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


# TODO: add tests for setting status code
# TODO: add test that manually creates a redirect by setting status code and suitable header.

################################################################################


if __name__ == "__main__":
    app.run(debug=True)
