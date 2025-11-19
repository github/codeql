from flask import Flask, request, make_response, Response


@app.route("/good1")
def good1():
    resp = make_response()
    resp.set_cookie("sessionid", value="value", secure=True, httponly=True, samesite='Strict') # GOOD: Attributes are securely set
    return resp


@app.route("/good2")
def good2():
    resp = make_response()
    resp.headers['Set-Cookie'] = "sessionid=value; Secure; HttpOnly; SameSite=Strict" # GOOD: Attributes are securely set 
    return resp

@app.route("/bad1")
def bad1():
    resp = make_response()
    resp.set_cookie("sessionid", value="value", samesite='None') # BAD: the SameSite attribute is set to 'None' and the 'Secure' and 'HttpOnly' attributes are set to False by default.
    return resp