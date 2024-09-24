import json

from flask import Flask, make_response, jsonify, Response, request, redirect
from werkzeug.datastructures import Headers

app = Flask(__name__)


@app.route("/html1")  # $routeSetup="/html1"
def html1():  # $requestHandler
    return "<h1>hello</h1>"  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"


@app.route("/html2")  # $routeSetup="/html2"
def html2():  # $requestHandler
    # note that response saved in a variable intentionally -- we wan the annotations to
    # show that we recognize the response creation, and not the return (hopefully). (and
    # do the same in the following of the file)
    resp = make_response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/html3")  # $routeSetup="/html3"
def html3():  # $requestHandler
    resp = app.make_response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


# TODO: Create test-cases for the many ways that `make_response` can be used
# https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask.make_response


@app.route("/html4")  # $routeSetup="/html4"
def html4():  # $requestHandler
    resp = Response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/html5")  # $routeSetup="/html5"
def html5():  # $requestHandler
    resp = Response(response="<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/html6")  # $routeSetup="/html6"
def html6():  # $requestHandler
    # note: flask.Flask.response_class is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = Flask.response_class("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/html7")  # $routeSetup="/html7"
def html7():  # $requestHandler
    # note: app.response_class (flask.Flask.response_class) is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = app.response_class("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/html8")  # $routeSetup="/html8"
def html8():  # $requestHandler
    resp = make_response()  # $HttpResponse mimetype=text/html
    resp.set_data("<h1>hello</h1>")  # $ MISSING: responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/jsonify")  # $routeSetup="/jsonify"
def jsonify_route():  # $requestHandler
    x = "x"; y = "y"; z = "z"
    if True:
        import flask.json
        resp = flask.json.jsonify(x, y, z=z)  # $HttpResponse mimetype=application/json responseBody=x responseBody=y responseBody=z
        assert resp.mimetype == "application/json"

        resp = app.json.response(x, y, z=z)  # $HttpResponse mimetype=application/json responseBody=x responseBody=y responseBody=z
        assert resp.mimetype == "application/json"

    resp = jsonify(x, y, z=z)  # $ HttpResponse mimetype=application/json responseBody=x responseBody=y responseBody=z
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp

################################################################################
# Tricky return handling
################################################################################

@app.route("/tricky-return1")  # $routeSetup="/tricky-return1"
def tricky_return1():  # $requestHandler
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
def tricky_return2():  # $requestHandler
    resp = helper()
    return resp  # $HttpResponse mimetype=text/html responseBody=resp


################################################################################
# Setting content-type manually
################################################################################


@app.route("/content-type/response-modification1")  # $routeSetup="/content-type/response-modification1"
def response_modification1():  # $requestHandler
    resp = make_response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    resp.content_type = "text/plain"  # $ MISSING: HttpResponse mimetype=text/plain
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/response-modification2")  # $routeSetup="/content-type/response-modification2"
def response_modification2():  # $requestHandler
    resp = make_response("<h1>hello</h1>")  # $HttpResponse mimetype=text/html responseBody="<h1>hello</h1>"
    resp.headers["content-type"] = "text/plain"  # $ headerWriteNameUnsanitized="content-type" headerWriteValue="text/plain" MISSING: HttpResponse mimetype=text/plain
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


# Exploration of mimetype/content_type/headers arguments to `app.response_class` -- things can get tricky
# see https://werkzeug.palletsprojects.com/en/1.0.x/wrappers/#werkzeug.wrappers.Response


@app.route("/content-type/Response1")  # $routeSetup="/content-type/Response1"
def Response1():  # $requestHandler
    resp = Response("<h1>hello</h1>", mimetype="text/plain")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Response2")  # $routeSetup="/content-type/Response2"
def Response2():  # $requestHandler
    resp = Response("<h1>hello</h1>", content_type="text/plain; charset=utf-8")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Response3")  # $routeSetup="/content-type/Response3"
def Response3():  # $requestHandler
    # content_type argument takes priority (and result is text/plain)
    resp = Response("<h1>hello</h1>", content_type="text/plain; charset=utf-8", mimetype="text/html")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Response4")  # $routeSetup="/content-type/Response4"
def Response4():  # $requestHandler
    # note: capitalization of Content-Type does not matter
    resp = Response("<h1>hello</h1>", headers={"Content-TYPE": "text/plain"})  # $ headerWriteBulk=Dict headerWriteBulkUnsanitized=name headerWriteNameUnsanitized="Content-TYPE" headerWriteValue="text/plain" HttpResponse responseBody="<h1>hello</h1>" SPURIOUS: mimetype=text/html MISSING: mimetype=text/plain
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Response5")  # $routeSetup="/content-type/Response5"
def Response5():  # $requestHandler
    # content_type argument takes priority (and result is text/plain)
    # note: capitalization of Content-Type does not matter
    resp = Response("<h1>hello</h1>", headers={"Content-TYPE": "text/html"}, content_type="text/plain; charset=utf-8")  # $ headerWriteBulk=Dict headerWriteBulkUnsanitized=name headerWriteNameUnsanitized="Content-TYPE" headerWriteValue="text/html" HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Response6")  # $routeSetup="/content-type/Response6"
def Response6():  # $requestHandler
    # mimetype argument takes priority over header (and result is text/plain)
    # note: capitalization of Content-Type does not matter
    resp = Response("<h1>hello</h1>", headers={"Content-TYPE": "text/html"}, mimetype="text/plain")  # $ headerWriteBulk=Dict headerWriteBulkUnsanitized=name headerWriteNameUnsanitized="Content-TYPE" headerWriteValue="text/html" HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/Flask-response-class")  # $routeSetup="/content-type/Flask-response-class"
def Flask_response_class():  # $requestHandler
    # note: flask.Flask.response_class is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = Flask.response_class("<h1>hello</h1>", mimetype="text/plain")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


@app.route("/content-type/app-response-class")  # $routeSetup="/content-type/app-response-class"
def app_response_class():  # $requestHandler
    # note: app.response_class (flask.Flask.response_class) is set to `flask.Response` by default.
    # it can be overridden, but we don't try to handle that right now.
    resp = app.response_class("<h1>hello</h1>", mimetype="text/plain")  # $HttpResponse mimetype=text/plain responseBody="<h1>hello</h1>"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


# TODO: add tests for setting status code
# TODO: add test that manually creates a redirect by setting status code and suitable header.

################################################################################
# Redirect
################################################################################


@app.route("/redirect-simple")  # $routeSetup="/redirect-simple"
def redirect_simple():  # $requestHandler
    next = request.args['next']
    resp = redirect(next) # $ HttpResponse mimetype=text/html HttpRedirectResponse redirectLocation=next
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp


################################################################################
# Cookies
################################################################################

def unk():
    return

@app.route("/setting_cookie")  # $routeSetup="/setting_cookie"
def setting_cookie():  # $requestHandler
    resp = make_response() # $ HttpResponse mimetype=text/html
    resp.set_cookie("key", "value") # $ CookieWrite CookieName="key" CookieValue="value" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
    resp.set_cookie(key="key", value="value") # $ CookieWrite CookieName="key" CookieValue="value" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
    resp.set_cookie(key="key", value="value", secure=True, httponly=True, samesite="Strict") # $ CookieWrite CookieName="key" CookieValue="value" CookieSecure=true CookieHttpOnly=true CookieSameSite=Strict
    resp.set_cookie(key="key", value="value", secure=unk(), httponly=unk(), samesite=unk()) # $ CookieWrite CookieName="key" CookieValue="value" 
    resp.headers.add("Set-Cookie", "key2=value2") # $ headerWriteNameUnsanitized="Set-Cookie" headerWriteValue="key2=value2" CookieWrite CookieRawHeader="key2=value2" CookieSecure=false CookieHttpOnly=false CookieSameSite=Lax
    resp.delete_cookie("key3") # $ CookieWrite CookieName="key3"
    resp.delete_cookie(key="key3") # $ CookieWrite CookieName="key3"
    return resp  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp

################################################################################
# Headers
################################################################################

@app.route("/headers") # $routeSetup="/headers"
def headers():  # $requestHandler
    resp1 = Response() # $ HttpResponse mimetype=text/html
    resp1.headers["X-MyHeader"] = "a" # $ headerWriteNameUnsanitized="X-MyHeader" headerWriteValue="a"
    resp2 = make_response() # $ HttpResponse mimetype=text/html
    resp2.headers["X-MyHeader"] = "aa" # $ headerWriteNameUnsanitized="X-MyHeader" headerWriteValue="aa"
    resp2.headers.extend({"X-MyHeader2": "b"}) # $ headerWriteBulk=Dict headerWriteBulkUnsanitized=name headerWriteNameUnsanitized="X-MyHeader2" headerWriteValue="b" 
    resp3 = make_response("hello", 200, {"X-MyHeader3": "c"}) # $ HttpResponse mimetype=text/html responseBody="hello" headerWriteBulk=Dict headerWriteBulkUnsanitized=name headerWriteNameUnsanitized="X-MyHeader3" headerWriteValue="c"
    resp4 = make_response("hello", {"X-MyHeader4": "d"}) # $ HttpResponse mimetype=text/html responseBody="hello" headerWriteBulk=Dict headerWriteBulkUnsanitized=name headerWriteNameUnsanitized="X-MyHeader4" headerWriteValue="d"
    resp5 = Response(headers={"X-MyHeader5":"e"}) # $ HttpResponse mimetype=text/html headerWriteBulk=Dict headerWriteBulkUnsanitized=name headerWriteBulkUnsanitized=name headerWriteNameUnsanitized="X-MyHeader5" headerWriteValue="e"
    return resp5  # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=resp5

@app.route("/werkzeug-headers") # $routeSetup="/werkzeug-headers"
def werkzeug_headers():  # $requestHandler
    response = Response() # $ HttpResponse mimetype=text/html
    headers = Headers()
    headers.add("X-MyHeader1", "a") # $ headerWriteNameUnsanitized="X-MyHeader1" headerWriteValue="a"
    headers.add_header("X-MyHeader2", "b") # $ headerWriteNameUnsanitized="X-MyHeader2" headerWriteValue="b"
    headers.set("X-MyHeader3", "c") # $ headerWriteNameUnsanitized="X-MyHeader3" headerWriteValue="c" 
    headers.setdefault("X-MyHeader4", "d") # $ headerWriteNameUnsanitized="X-MyHeader4" headerWriteValue="d" 
    headers.__setitem__("X-MyHeader5", "e") # $ headerWriteNameUnsanitized="X-MyHeader5" headerWriteValue="e" 
    headers["X-MyHeader6"] = "f" # $ headerWriteNameUnsanitized="X-MyHeader6" headerWriteValue="f" 
    h1 = {"X-MyHeader7": "g"} # $ headerWriteNameUnsanitized="X-MyHeader7" headerWriteValue="g"
    headers.extend(h1) # $ headerWriteBulk=h1 headerWriteBulkUnsanitized=name 
    h2 = [("X-MyHeader8", "h")] # $ headerWriteNameUnsanitized="X-MyHeader8" headerWriteValue="h"
    headers.extend(h2) # $ headerWriteBulk=h2 headerWriteBulkUnsanitized=name 
    response.headers = headers 
    return response # $ SPURIOUS: HttpResponse mimetype=text/html responseBody=response

################################################################################


if __name__ == "__main__":
    app.run(debug=True)
