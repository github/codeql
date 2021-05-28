from flask import Flask, request, make_response
app = Flask(__name__)

@app.route("/xss")
def xss():
    username = request.args.get("username")
    return make_response("Hello {}".format(username))
