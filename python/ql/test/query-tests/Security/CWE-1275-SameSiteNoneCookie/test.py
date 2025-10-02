from flask import Flask, request, make_response

app = Flask(__name__)

@app.route("/test")
def test(oauth_cookie_name):
    resp = make_response()
    resp.set_cookie("password", "value1") 
    resp.set_cookie("authKey", "value2", samesite="Lax") 
    resp.set_cookie("session_id", "value2", samesite="None") # $Alert[py/samesite-none-cookie]
    resp.set_cookie("oauth", "value2", secure=True, samesite="Strict") 
    resp.set_cookie("oauth", "value2", httponly=True, samesite="Strict") 
    resp.set_cookie(oauth_cookie_name, "value2", secure=True, samesite="None") # $Alert[py/samesite-none-cookie]
    resp.set_cookie("not_sensitive", "value2", samesite="None")
    