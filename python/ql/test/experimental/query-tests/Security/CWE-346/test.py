from flask import Response, request, Flask

@app.route("/flask_Response")
def flask_Response():
    rfs_header = request.args["rfs_header"]
    response = Response()
    response.headers['Access-Control-Allow-Origin'] = rfs_header
    response.headers['Access-Control-Allow-Credentials'] = "true"
    return response
