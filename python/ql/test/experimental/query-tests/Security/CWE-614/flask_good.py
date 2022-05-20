from flask import Flask, request, make_response, Response

app = Flask(__name__)


@app.route("/1")
def true():
    resp = make_response()
    resp.set_cookie("name", value="value", secure=True,
                    httponly=True, samesite='Lax')
    return resp


@app.route("/2")
def flask_Response():
    resp = Response()
    resp.headers['Set-Cookie'] = "name=value; Secure; HttpOnly; SameSite=Lax;"
    return resp


def indeterminate(secure):
    resp = make_response()
    resp.set_cookie("name", value="value", secure=secure)
    return resp


# if __name__ == "__main__":
#     app.run(debug=True)
