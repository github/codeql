from flask import Flask, request
app = Flask(__name__)

@app.route("/test_taint/<name>/<int:number>")  # $routeSetup="/test_taint/<name>/<int:number>"
def test_taint(name = "World!", number="0", foo="foo"):  # $requestHandler routedParameter=name routedParameter=number
    ensure_tainted(name, number) # $ tainted
    ensure_not_tainted(foo)

    # Manually inspected all fields of the Request object
    # https://flask.palletsprojects.com/en/1.1.x/api/#flask.Request

    ensure_tainted(

        request.environ, # $ tainted
        request.environ.get('HTTP_AUTHORIZATION'), # $ tainted

        request.path, # $ tainted
        request.full_path, # $ tainted
        request.base_url, # $ tainted
        request.url, # $ tainted

        # These request.accept_* properties are instances of subclasses of werkzeug.datastructures.Accept
        request.accept_charsets.best, # $ MISSING: tainted
        request.accept_charsets.best_match(["utf-8", "utf-16"]), # $ MISSING: tainted
        request.accept_charsets[0], # $ tainted
        request.accept_encodings, # $ tainted
        request.accept_languages, # $ tainted
        request.accept_mimetypes, # $ tainted

        # werkzeug.datastructures.HeaderSet (subclass of collections_abc.MutableSet)
        request.access_control_request_headers, # $ tainted

        request.access_control_request_method, # $ tainted

        request.access_route, # $ tainted
        request.access_route[0], # $ tainted

        # By default werkzeug.datastructures.ImmutableMultiDict -- although can be changed :\
        request.args, # $ tainted
        request.args['key'], # $ tainted
        request.args.get('key'), # $ tainted
        request.args.getlist('key'), # $ tainted

        # werkzeug.datastructures.Authorization (a dict, with some properties)
        request.authorization, # $ tainted
        request.authorization['username'], # $ tainted
        request.authorization.username, # $ tainted
        request.authorization.password, # $ tainted
        request.authorization.realm, # $ tainted
        request.authorization.nonce, # $ tainted
        request.authorization.uri, # $ tainted
        request.authorization.nc, # $ tainted
        request.authorization.cnonce, # $ tainted
        request.authorization.response, # $ tainted
        request.authorization.opaque, # $ tainted
        request.authorization.qop, # $ tainted

        # werkzeug.datastructures.RequestCacheControl
        request.cache_control, # $ tainted
        # These should be `int`s, but can be strings... see debug method below
        request.cache_control.max_age, # $ MISSING: tainted
        request.cache_control.max_stale, # $ MISSING: tainted
        request.cache_control.min_fresh, # $ MISSING: tainted

        request.content_encoding, # $ tainted

        request.content_md5, # $ tainted

        request.content_type, # $ tainted

        # werkzeug.datastructures.ImmutableTypeConversionDict (which is basically just a dict)
        request.cookies, # $ tainted
        request.cookies['key'], # $ tainted

        request.data, # $ tainted

        # a werkzeug.datastructures.MultiDict, mapping [str, werkzeug.datastructures.FileStorage]
        request.files, # $ tainted
        request.files['key'], # $ tainted
        request.files['key'].filename, # $ tainted
        request.files['key'].stream, # $ tainted
        request.files['key'].read(), # $ tainted
        request.files['key'].stream.read(), # $ tainted
        request.files.get('key'), # $ tainted
        request.files.get('key').filename, # $ tainted
        request.files.get('key').stream, # $ tainted
        request.files.getlist('key'), # $ tainted
        request.files.getlist('key')[0].filename, # $ tainted
        request.files.getlist('key')[0].stream, # $ tainted

        # By default werkzeug.datastructures.ImmutableMultiDict -- although can be changed :\
        request.form, # $ tainted
        request.form['key'], # $ tainted
        request.form.get('key'), # $ tainted
        request.form.getlist('key'), # $ tainted

        request.get_data(), # $ tainted

        request.get_json(), # $ tainted
        request.get_json()['foo'], # $ tainted
        request.get_json()['foo']['bar'], # $ tainted

        # werkzeug.datastructures.EnvironHeaders,
        # which has same interface as werkzeug.datastructures.Headers
        request.headers, # $ tainted
        request.headers['key'], # $ tainted
        request.headers.get('key'), # $ tainted
        request.headers.get_all('key'), # $ tainted
        request.headers.getlist('key'), # $ tainted
        # popitem returns `(key, value)`
        request.headers.popitem(), # $ tainted
        request.headers.popitem()[0], # $ tainted
        request.headers.popitem()[1], # $ tainted
        # two ways to get (k, v) lists
        list(request.headers), # $ tainted
        request.headers.to_wsgi_list(), # $ tainted

        request.json, # $ tainted
        request.json['foo'], # $ tainted
        request.json['foo']['bar'], # $ tainted

        request.method, # $ tainted

        request.mimetype, # $ tainted

        request.mimetype_params, # $ tainted

        request.origin, # $ tainted

        # werkzeug.datastructures.HeaderSet (subclass of collections_abc.MutableSet)
        request.pragma, # $ tainted

        request.query_string, # $ tainted

        request.referrer, # $ tainted

        request.remote_addr, # $ tainted

        request.remote_user, # $ tainted

        # file-like object
        request.stream, # $ tainted
        request.input_stream, # $ tainted

        request.url, # $ tainted

        request.user_agent, # $ tainted

        # werkzeug.datastructures.CombinedMultiDict, which is basically just a werkzeug.datastructures.MultiDict
        request.values, # $ tainted
        request.values['key'], # $ tainted
        request.values.get('key'), # $ tainted
        request.values.getlist('key'), # $ tainted

        # dict
        request.view_args, # $ tainted
        request.view_args['key'], # $ tainted
        request.view_args.get('key'), # $ tainted
    )

    ensure_not_tainted(
        request.script_root,
        request.url_root,

        # The expected charset for parsing request data / urls. Can not be changed by client.
        # https://github.com/pallets/werkzeug/blob/4dc8d6ab840d4b78cbd5789cef91b01e3bde01d5/src/werkzeug/wrappers/base_request.py#L71-L72
        request.charset,
        request.url_charset,

        # request.date is a parsed `datetime`
        # https://github.com/pallets/werkzeug/blob/4dc8d6ab840d4b78cbd5789cef91b01e3bde01d5/src/werkzeug/wrappers/common_descriptors.py#L76-L83
        request.date,

        # Assuming that endpoints are not created by user-input seems fair
        request.endpoint,

        # In some rare circumstances a client could spoof the host, but by default they
        # should not be able to. See
        # https://werkzeug.palletsprojects.com/en/1.0.x/wrappers/#werkzeug.wrappers.BaseRequest.trusted_hosts
        request.host,
        request.host_url,

        request.scheme,

        request.script_root,
    )

    # Testing some more tricky data-flow still works
    a = request.args
    b = a
    gl = b.getlist
    ensure_tainted(
        request.args, # $ tainted
        a, # $ tainted
        b, # $ tainted

        request.args['key'], # $ tainted
        a['key'], # $ tainted
        b['key'], # $ tainted

        request.args.getlist('key'), # $ tainted
        a.getlist('key'), # $ tainted
        b.getlist('key'), # $ tainted
        gl('key'), # $ tainted
    )

    # aliasing tests
    req = request
    gd = request.get_data
    ensure_tainted(
        req.path, # $ tainted
        gd(), # $ tainted
    )




@app.route("/debug/<foo>/<bar>", methods=['GET']) # $routeSetup="/debug/<foo>/<bar>"
def debug(foo, bar):  # $requestHandler routedParameter=foo routedParameter=bar
    print("request.view_args", request.view_args)

    print("request.headers {!r}".format(request.headers))
    print("request.headers['accept'] {!r}".format(request.headers['accept']))

    print("request.pragma {!r}".format(request.pragma))

    return 'ok'  # $HttpResponse

@app.route("/stream", methods=['POST'])  # $routeSetup="/stream"
def stream():  # $requestHandler
    print(request.path)
    s = request.stream
    print(s)
    # just works :)
    print(s.read())

    return 'ok'  # $HttpResponse

@app.route("/input_stream", methods=['POST'])  # $routeSetup="/input_stream"
def input_stream():  # $requestHandler
    print(request.path)
    s = request.input_stream
    print(s)
    # hangs until client stops connection, since max number of bytes to read must
    # be handled manually
    print(s.read())

    return 'ok'  # $HttpResponse

@app.route("/form", methods=['POST'])  # $routeSetup="/form"
def form():  # $requestHandler
    print(request.path)
    print("request.form", request.form)

    return 'ok'  # $HttpResponse

@app.route("/cache_control", methods=['POST'])  # $routeSetup="/cache_control"
def cache_control():  # $requestHandler
    print(request.path)
    print("request.cache_control.max_age", request.cache_control.max_age, type(request.cache_control.max_age))
    print("request.cache_control.max_stale", request.cache_control.max_stale, type(request.cache_control.max_stale))
    print("request.cache_control.min_fresh", request.cache_control.min_fresh, type(request.cache_control.min_fresh))

    return 'ok'  # $HttpResponse

@app.route("/file_upload", methods=['POST'])  # $routeSetup="/file_upload"
def file_upload():  # $requestHandler
    print(request.path)
    for k,v in request.files.items():
        print(k, v, v.name, v.filename, v.stream)

    return 'ok'  # $HttpResponse

@app.route("/args", methods=['GET'])  # $routeSetup="/args"
def args():  # $requestHandler
    print(request.path)
    print("request.args", request.args)

    return 'ok'  # $HttpResponse

# curl --header "My-Header: some-value" http://localhost:5000/debug/fooval/barval
# curl --header "Pragma: foo, bar" --header "Pragma: stuff, foo" http://localhost:5000/debug/fooval/barval

# curl -X POST --data 'wat' http://localhost:5000/stream
# curl -X POST --data 'wat' http://localhost:5000/input_stream

# curl --form foo=foo --form foo=123 http://localhost:5000/form

# curl --header "Cache-Control: max-age=foo, max-stale=bar, min-fresh=baz" http://localhost:5000/cache_control
# curl --header "Cache-Control: max-age=1, max-stale=2, min-fresh=3" http://localhost:5000/cache_control

# curl -F myfile=@<some-file> localhost:5000/file_upload

# curl http://localhost:5000/args?foo=42&bar=bar

if __name__ == "__main__":
    app.run(debug=True)
