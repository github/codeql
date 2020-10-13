import flask

from flask import Flask, make_response
app = Flask(__name__)


SOME_ROUTE = "/some/route"
@app.route(SOME_ROUTE) # $routeSetup="/some/route"
def some_route():  # $routeHandler
    return make_response("some_route")


def index():  # $routeHandler
    return make_response("index")
app.add_url_rule('/index', 'index', index)  # $routeSetup="/index"


# We don't support this yet, and I think that's OK
def later_set():  # $f-:routeHandler
    return make_response("later_set")
app.add_url_rule('/later-set', 'later_set', view_func=None)  # $routeSetup="/later-set"
app.view_functions['later_set'] = later_set


@app.route(UNKNOWN_ROUTE) # $routeSetup
def unkown_route(foo, bar):  # $routeHandler $routedParameter=foo $routedParameter=bar
    return make_response("unkown_route")


if __name__ == "__main__":
    app.run(debug=True)
