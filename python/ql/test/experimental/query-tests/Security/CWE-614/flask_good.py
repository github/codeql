from flask import Flask, request, make_response, Response

app = Flask(__name__)


@app.route("/true")
def true():
    resp = make_response()
    resp.set_cookie("name", value="value", secure=True)
    return resp


@app.route("/flask_Response")
def flask_Response():
    resp = Response()
    resp.headers['Set-Cookie'] = "name=value; Secure;"
    return resp


@app.route("/flask_make_response")
def flask_make_response():
    resp = make_response("hello")
    resp.headers['Set-Cookie'] = "name=value; Secure;"
    return resp


def indeterminate(secure):
    resp = make_response()
    resp.set_cookie("name", value="value", secure=secure)
    return resp


# if __name__ == "__main__":
#     app.run(debug=True)
