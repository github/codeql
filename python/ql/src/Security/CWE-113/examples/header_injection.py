@app.route("/example_bad")
def example_bad():
    rfs_header = request.args["rfs_header"]
    response = Response()
    custom_header = "X-MyHeader-" + rfs_header
    # BAD: User input is used as part of the header name.
    response.headers[custom_header] = "HeaderValue" 
    return response

@app.route("/example_good")
def example_bad():
    rfs_header = request.args["rfs_header"]
    response = Response()
    custom_header = "X-MyHeader-" + rfs_header.replace("\n", "").replace("\r","").replace(":","")
    # GOOD: Line break characters are removed from the input.
    response.headers[custom_header] = "HeaderValue" 
    return response