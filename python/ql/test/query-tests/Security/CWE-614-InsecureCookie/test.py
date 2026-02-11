from flask import Flask, request, make_response

app = Flask(__name__)

@app.route("/test")
def test():
    resp = make_response()
    resp.set_cookie("authKey", "value1") # $Alert[py/insecure-cookie]
    resp.set_cookie("authKey", "value2", secure=True) 
    resp.set_cookie("sessionID", "value2", httponly=True) # $Alert[py/insecure-cookie]
    resp.set_cookie("password", "value2", samesite="Strict") # $Alert[py/insecure-cookie]
    resp.set_cookie("notSensitive", "value3") 
