from flask import Response, request, Flask, make_response
from werkzeug.datastructures import Headers

app = Flask(__name__)


@app.route('/werkzeug_headers')
def werkzeug_headers():
    rfs_header = request.args["rfs_header"]
    response = Response()
    headers = Headers()
    headers.add("HeaderName", rfs_header)
    response.headers = headers
    return response


@app.route("/flask_Response")
def flask_Response():
    rfs_header = request.args["rfs_header"]
    response = Response()
    response.headers['HeaderName'] = rfs_header
    return response


@app.route("/flask_make_response")
def flask_make_response():
    rfs_header = request.args["rfs_header"]
    resp = make_response("hello")
    resp.headers['HeaderName'] = rfs_header
    return resp


@app.route("/flask_make_response_extend")
def flask_make_response_extend():
    rfs_header = request.args["rfs_header"]
    resp = make_response("hello")
    resp.headers.extend(
        {'HeaderName': rfs_header})
    return resp


@app.route("/Response_arg")
def Response_arg():
    return Response(headers={'HeaderName': request.args["rfs_header"]})

# if __name__ == "__main__":
#     app.run(debug=True)
