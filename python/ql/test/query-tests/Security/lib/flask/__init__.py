from .globals import request
from .globals import current_app

class Flask(object):
    # Only some methods mocked, signature copied from
    # https://flask.palletsprojects.com/en/1.1.x/api/#flask.Flask
    def run(host=None, port=None, debug=None, load_dotenv=True, **options):
        pass

    def make_response(rv):
        pass

    def add_url_rule(rule, endpoint=None, view_func=None, provide_automatic_options=None, **options):
        pass

class Response(object):
    pass

def redirect(location, code=302, Response=None):
    pass

def make_response(rv):
    if not args:
        return current_app.response_class()
    if len(args) == 1:
        args = args[0]
    return current_app.make_response(args)

def escape(txt):
    return Markup.escape(txt)

def render_template_string(source, **context):
    pass