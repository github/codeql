from bottle import Bottle, route, request, redirect, response # TODO: We're listing the import as a Source -- while it is techtically true, it is not useful.

app = Bottle()

@app.route('/test_taint/<name>/<number:int>')
def test_taint(name = "World!", number="0", foo="foo"):
    ensure_tainted(name, number)
    ensure_not_tainted(foo)

    # Manually inspected all fields of the Request object
    # https://bottlepy.org/docs/dev/api.html#the-request-object

    ensure_tainted(
        request.environ,
        request.environ.get('HTTP_AUTHORIZATION'),

        request.url_args,
        request.url_args['url_arg'],

        request.path,

        request.headers,
        request.headers['HEADER'],

        request.get_header('HEADER'),

        # FormsDict
        request.cookies,
        # FormsDict is a subtype of dict
        request.cookies['cookie_name'],
        request.cookies.get('cookie_name'),
        # But also adds its own helpers
        request.cookies.cookie_name,
        request.cookies.getunicode('cookie_name'),
        request.cookies.getall('cookie_name'),

        request.get_cookie('cookie_name'),

        # FormsDict
        request.query,
        request.query.name,

        # FormsDict
        request.forms,
        request.forms.form_field_name,

        # FormsDict
        request.params,
        request.params.query_or_form_field_name,

        # FormsDict
        request.files,
        request.files.filename,

        request.json,
        request.json['some_key'],

        request.body, # file-like object
        request.body.read(),
        request.body.readline(),
        request.body.readlines(),
        [line for line in request.body],
        # TODO: Should we handle `request.body.read1()`?
        # TODO: Should we handle `request.body.readinto()`?

        request.GET, # alias for request.query

        # FormsDict (combination of request.forms and request.files)
        request.POST,

        request.url,

        request.urlparts,

        request.fullpath,

        request.query_string,

        request.script_name,

        request.content_type,

        request.auth, # (user, password)
        request.auth[0],

        request.remote_route, # list of ips
        request.remote_route[0],

        request.remote_addr,

        request.copy().path,
    )
