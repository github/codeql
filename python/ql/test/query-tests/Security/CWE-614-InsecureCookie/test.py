from flask import Flask, request, make_response

app = Flask(__name__)

@app.route("/test")
def test():
    resp = make_response()
    resp.set_cookie("key1", "value1") # $Alert[py/insecure-cookie]
    resp.set_cookie("key2", "value2", secure=True) 
    resp.set_cookie("key2", "value2", httponly=True) # $Alert[py/insecure-cookie]
    resp.set_cookie("key2", "value2", samesite="Strict") # $Alert[py/insecure-cookie]
    resp.set_cookie("key2", "value2", samesite="Lax") # $Alert[py/insecure-cookie]
    resp.set_cookie("key2", "value2", samesite="None") # $Alert[py/insecure-cookie]
    resp.set_cookie("key2", "value2", secure=True, samesite="Strict")
    resp.set_cookie("key2", "value2", httponly=True, samesite="Strict") # $Alert[py/insecure-cookie]
    resp.set_cookie("key2", "value2", secure=True, samesite="None")
    resp.set_cookie("key2", "value2", httponly=True, samesite="None") # $Alert[py/insecure-cookie]
    resp.set_cookie("key2", "value2", secure=True, httponly=True, samesite="Strict")