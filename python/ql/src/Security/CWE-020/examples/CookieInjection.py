from flask import request, make_response


@app.route("/1")
def set_cookie():
    resp = make_response()
    resp.set_cookie(request.args["name"], # BAD: User input is used to set the cookie's name and value
                    value=request.args["name"])
    return resp


@app.route("/2")
def set_cookie_header():
    resp = make_response()
    resp.headers['Set-Cookie'] = f"{request.args['name']}={request.args['name']};" # BAD: User input is used to set the raw cookie header.
    return resp
