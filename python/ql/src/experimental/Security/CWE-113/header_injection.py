from flask import Response, request, Flask, make_response


@app.route("/flask_Response")
def flask_Response():
    rfs_header = request.args["rfs_header"]
    response = Response()
    response.headers['HeaderName'] = rfs_header
    return response
