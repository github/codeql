from flask import Flask, request
app = Flask(__name__)

@app.route("/test_taint/<name>/<int:number>")  # $routeSetup="/test_taint/<name>/<int:number>"
def test_taint(name = "World!", number="0", foo="foo"):  # $routeHandler $routedParameter=name $routedParameter=number
    ensure_tainted(name, number)
    ensure_not_tainted(foo)

    # Manually inspected all fields of the Request object
    # https://flask.palletsprojects.com/en/1.1.x/api/#flask.Request

    ensure_tainted(

        request.environ,
        request.environ.get('HTTP_AUTHORIZATION'),

        request.path,
        request.full_path,
        request.base_url,
        request.url,

        # These request.accept_* properties are instances of subclasses of werkzeug.datastructures.Accept
        request.accept_charsets.best,
        request.accept_charsets.best_match(["utf-8", "utf-16"]),
        request.accept_charsets[0],
        request.accept_encodings,
        request.accept_languages,
        request.accept_mimetypes,

        # werkzeug.datastructures.HeaderSet (subclass of collections_abc.MutableSet)
        request.access_control_request_headers,

        request.access_control_request_method,

        request.access_route,
        request.access_route[0],

        # By default werkzeug.datastructures.ImmutableMultiDict -- although can be changed :\
        request.args,
        request.args['key'],
        request.args.getlist('key'),

        # werkzeug.datastructures.Authorization (a dict, with some properties)
        request.authorization,
        request.authorization['username'],
        request.authorization.username,

        # werkzeug.datastructures.RequestCacheControl
        request.cache_control,
        # These should be `int`s, but can be strings... see debug method below
        request.cache_control.max_age,
        request.cache_control.max_stale,
        request.cache_control.min_fresh,

        request.content_encoding,

        request.content_md5,

        request.content_type,

        # werkzeug.datastructures.ImmutableTypeConversionDict (which is basically just a dict)
        request.cookies,
        request.cookies['key'],

        request.data,

        # a werkzeug.datastructures.MultiDict, mapping [str, werkzeug.datastructures.FileStorage]
        request.files,
        request.files['key'],
        request.files['key'].filename,
        request.files['key'].stream,
        request.files.getlist('key'),
        request.files.getlist('key')[0].filename,
        request.files.getlist('key')[0].stream,

        # By default werkzeug.datastructures.ImmutableMultiDict -- although can be changed :\
        request.form,
        request.form['key'],
        request.form.getlist('key'),

        request.get_data(),

        request.get_json(),
        request.get_json()['foo'],
        request.get_json()['foo']['bar'],

        # werkzeug.datastructures.EnvironHeaders,
        # which has same interface as werkzeug.datastructures.Headers
        request.headers,
        request.headers['key'],
        request.headers.get_all('key'),
        request.headers.getlist('key'),
        list(request.headers), # (k, v) list
        request.headers.to_wsgi_list(), # (k, v) list

        request.json,
        request.json['foo'],
        request.json['foo']['bar'],

        request.method,

        request.mimetype,

        request.mimetype_params,

        request.origin,

        # werkzeug.datastructures.HeaderSet (subclass of collections_abc.MutableSet)
        request.pragma,

        request.query_string,

        request.referrer,

        request.remote_addr,

        request.remote_user,

        # file-like object
        request.stream,
        request.input_stream,

        request.url,

        request.user_agent,

        # werkzeug.datastructures.CombinedMultiDict, which is basically just a werkzeug.datastructures.MultiDict
        request.values,
        request.values['key'],
        request.values.getlist('key'),

        # dict
        request.view_args,
        request.view_args['key'],
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
        request.args,
        a,
        b,

        request.args['key'],
        a['key'],
        b['key'],

        request.args.getlist('key'),
        a.getlist('key'),
        b.getlist('key'),
        gl('key'),
    )

    # aliasing tests
    req = request
    gd = request.get_data
    ensure_tainted(
        req.path,
        gd(),
    )




@app.route("/debug/<foo>/<bar>", methods=['GET']) # $routeSetup="/debug/<foo>/<bar>"
def debug(foo, bar):  # $routeHandler $routedParameter=foo $routedParameter=bar
    print("request.view_args", request.view_args)

    print("request.headers {!r}".format(request.headers))
    print("request.headers['accept'] {!r}".format(request.headers['accept']))

    print("request.pragma {!r}".format(request.pragma))

    return 'ok'

@app.route("/stream", methods=['POST'])  # $routeSetup="/stream"
def stream():  # $routeHandler
    print(request.path)
    s = request.stream
    print(s)
    # just works :)
    print(s.read())

    return 'ok'

@app.route("/input_stream", methods=['POST'])  # $routeSetup="/input_stream"
def input_stream():  # $routeHandler
    print(request.path)
    s = request.input_stream
    print(s)
    # hangs until client stops connection, since max number of bytes to read must
    # be handled manually
    print(s.read())

    return 'ok'

@app.route("/form", methods=['POST'])  # $routeSetup="/form"
def form():  # $routeHandler
    print(request.path)
    print("request.form", request.form)

    return 'ok'

@app.route("/cache_control", methods=['POST'])  # $routeSetup="/cache_control"
def cache_control():  # $routeHandler
    print(request.path)
    print("request.cache_control.max_age", request.cache_control.max_age, type(request.cache_control.max_age))
    print("request.cache_control.max_stale", request.cache_control.max_stale, type(request.cache_control.max_stale))
    print("request.cache_control.min_fresh", request.cache_control.min_fresh, type(request.cache_control.min_fresh))

    return 'ok'

@app.route("/file_upload", methods=['POST'])  # $routeSetup="/file_upload"
def file_upload():  # $routeHandler
    print(request.path)
    for k,v in request.files.items():
        print(k, v, v.name, v.filename, v.stream)

    return 'ok'

@app.route("/args", methods=['GET'])  # $routeSetup="/args"
def args():  # $routeHandler
    print(request.path)
    print("request.args", request.args)

    return 'ok'

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
