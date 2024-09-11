from flask import Response, request, Flask, make_response
from werkzeug.datastructures import Headers

app = Flask(__name__)


@app.route('/werkzeug_headers')
def werkzeug_headers():
    rfs_header = request.args["rfs_header"]
    response = Response()
    headers = Headers()
    headers.add("HeaderName", rfs_header) # GOOD: Newlines are rejected from header value.
    headers.add(rfs_header, "HeaderValue") # BAD: User controls header name.
    response.headers = headers 
    return response

@app.route("/flask_make_response_header_arg2")
def flask_make_response_header_arg2():
    rfs_header = request.args["rfs_header"]
    resp = make_response("hello", {request.args["rfs_header"]: "HeaderValue"}) # BAD
    return resp

@app.route("/flask_escaped")
def flask_escaped():
    rfs_header = request.args["rfs_header"]
    resp = make_response("hello", {rfs_header.replace("\n", ""): "HeaderValue"}) # GOOD - Newlines are removed from the input.
    return resp

@app.route("/flask_extend")
def flask_extend():
    rfs_header = request.args["rfs_header"]
    response = Response()
    h1 = {rfs_header: "HeaderValue"}
    response.headers.extend(h1) # BAD
    h2 = [(rfs_header, "HeaderValue")]
    response.headers.extend(h2) # BAD
    return response

# if __name__ == "__main__":
#     app.run(debug=True)