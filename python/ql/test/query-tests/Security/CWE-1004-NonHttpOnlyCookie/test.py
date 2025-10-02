from flask import Flask, request, make_response

app = Flask(__name__)

@app.route("/test")
def test():
    resp = make_response()
    resp.set_cookie("oauth", "value1") # $Alert[py/client-exposed-cookie]
    resp.set_cookie("oauth", "value2", secure=True) # $Alert[py/client-exposed-cookie]
    resp.set_cookie("oauth", "value2", httponly=True) 
    resp.set_cookie("oauth", "value2", samesite="Strict") # $Alert[py/client-exposed-cookie]
    resp.set_cookie("oauth", "value2", httponly=True, samesite="None") 