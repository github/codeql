from flask import Flask, request, make_response, Response

app = Flask(__name__)


@app.route("/false")
def false():
    resp = make_response()
    resp.set_cookie("name", value="value", secure=False,
                    httponly=False, samesite='None')
    return resp


@app.route("/flask_Response")
def flask_Response():
    resp = Response()
    resp.headers['Set-Cookie'] = "name=value; SameSite=None;"
    return resp


@app.route("/false")
def false():
    resp = make_response()
    resp.set_cookie(request.args["name"], value=request.args["value"], secure=False,
                    httponly=False, samesite='None')
    return resp


@app.route("/flask_Response")
def flask_Response():
    resp = Response()
    resp.headers['Set-Cookie'] = f"{request.args['name']}={request.args['value']}; SameSite=None;"
    return resp


# if __name__ == "__main__":
#     app.run(debug=True)
