from flask import request, make_response


@app.route("/1")
def true():
    resp = make_response()
    resp.set_cookie(request.args["name"],
                    value=request.args["name"])
    return resp


@app.route("/2")
def flask_make_response():
    resp = make_response("hello")
    resp.headers['Set-Cookie'] = f"{request.args['name']}={request.args['name']};"
    return resp
