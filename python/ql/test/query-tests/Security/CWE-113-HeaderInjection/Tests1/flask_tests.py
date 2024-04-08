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


@app.route("/flask_Response")
def flask_Response():
    rfs_header = request.args["rfs_header"]
    response = Response()
    response.headers['HeaderName'] = rfs_header # GOOD
    response.headers[rfs_header] = "HeaderValue" # BAD
    return response


@app.route("/flask_make_response")
def flask_make_response():
    rfs_header = request.args["rfs_header"]
    response = make_response("hello")
    response.headers['HeaderName'] = rfs_header # GOOD
    response.headers[rfs_header] = "HeaderValue" # BAD
    return response


@app.route("/flask_make_response_extend")
def flask_make_response_extend():
    rfs_header = request.args["rfs_header"]
    resp = make_response("hello")
    resp.headers.extend(
        {'HeaderName': rfs_header}) # GOOD
    resp.headers.extend(
        {rfs_header: "HeaderValue"}) # BAD
    return resp


@app.route("/Response_arg")
def Response_arg():
    return Response(headers={'HeaderName': request.args["rfs_header"], request.args["rfs_header"]: "HeaderValue"}) # BAD

@app.route("/flask_make_response_header_arg3")
def flask_make_response_header_arg3():
    rfs_header = request.args["rfs_header"]
    resp = make_response("hello", 200, {request.args["rfs_header"]: "HeaderValue"}) # BAD
    return resp

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

@app.route("/werkzeug_methods")
def werkzeug_methods():
    rfs_header = request.args["rfs_header"]
    response = Response()
    headers = Headers()
    headers.add(rfs_header, "HeaderValue") # BAD
    headers.add_header(rfs_header, "HeaderValue") # BAD
    headers.set(rfs_header, "HeaderValue") # BAD
    headers.setdefault(rfs_header, "HeaderValue") # BAD
    headers.__setitem__(rfs_header, "HeaderValue") # BAD
    headers[rfs_header] = "HeaderValue" # BAD
    h1 = {rfs_header: "HeaderValue"}
    headers.extend(h1) # BAD
    h2 = [(rfs_header, "HeaderValue")]
    headers.extend(h2) # BAD
    response.headers = headers 
    h3 = {rfs_header: "HeaderValue"}
    h4 = [(rfs_header, "HeaderValue")]
    resp2 = make_response("hi", h3) # BAD
    resp3 = make_response("hi", h4) # BAD
    return response

# if __name__ == "__main__":
#     app.run(debug=True)